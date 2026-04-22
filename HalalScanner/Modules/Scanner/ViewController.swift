//
//  ViewController.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 07.03.2026.
//

import UIKit
import AVFoundation
//import Vision
//import CoreML
import Roboflow
import Combine

class ViewController: UIViewController {

    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    let photoOutput = AVCapturePhotoOutput()

    
    weak var coordinator: AppCoordinator?
    
    let scannerView = ScannerView()
    let viewModel = ScannerViewModel()
    var cancellables = Set<AnyCancellable>()
    
    override func loadView(){
        view = scannerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        scannerView.captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        scannerView.captureButton.isEnabled = false
        viewModel.preloadIfNeeded()
        bindViewModel()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if captureSession.inputs.isEmpty {
            DispatchQueue.global(qos: .userInitiated).async {
                self.setupCamera()
                self.captureSession.startRunning()
            }
        }
    }
    
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scannerView.applyOverlayMask()
    }
    
    func bindViewModel() {
        viewModel.$statusText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] text in
                self?.scannerView.statusLabel.text = text
            }
            .store(in: &cancellables)
        
        viewModel.$isReady
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isReady in
                self?.scannerView.captureButton.isEnabled = isReady
            }
            .store(in: &cancellables)
        viewModel.$isDetecting
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isDetecting in
                guard let self = self else { return }
                self.scannerView.captureButton.isEnabled = self.viewModel.isReady && !isDetecting
                if !isDetecting {
                    self.scannerView.stopStatusPulse()  
                }
            }
            .store(in: &cancellables)
        viewModel.$detectedProduct
               .receive(on: DispatchQueue.main)
               .compactMap { $0 }
               .sink { [weak self] product, confidence in
                   guard let self = self else { return }
                   self.coordinator?.showProductSheet(from: self, product: product, confidence: confidence)
                   self.scannerView.captureButton.isEnabled = true
               }
               .store(in: &cancellables)
    }
    
    
    func setupCamera() {
        captureSession.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            if captureSession.canAddInput(input) { captureSession.addInput(input) }
            if captureSession.canAddOutput(photoOutput) { captureSession.addOutput(photoOutput) }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            
            DispatchQueue.main.async {
                self.previewLayer.frame = self.view.bounds
                self.view.layer.insertSublayer(self.previewLayer, at: 0)
            }
            
        } catch { print("Camera error") }
    }

    @objc func capturePhoto() {
        guard viewModel.isReady else {
            scannerView.statusLabel.text = "Күте тұрыңыз..."
              return
          }

        guard !viewModel.isDetecting else { return }

        scannerView.captureButton.isEnabled = false
        scannerView.animateCapture()

          let settings = AVCapturePhotoSettings()
          photoOutput.capturePhoto(with: settings, delegate: self)
        
 


    }
    
    func showProductInfo(product: Product, confidence: Int) {
        coordinator?.showProductSheet(from: self, product: product, confidence: confidence)
        
    }
}
extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        print("PHOTO CAPTURED")
        guard let data = photo.fileDataRepresentation(),
              let image = UIImage(data: data) else {
            print("NO PHOTO DATA")
            return
        }
        runDetection(image: image)
    }

    
    func runDetection(image: UIImage) {
        guard !viewModel.isDetecting else { return }
        guard let model = ModelManager.shared.model else {
            viewModel.handleResult(label: nil, confidence: 0)
            return
        }

        viewModel.beginDetection()

        model.detect(image: image) { [weak self] predictions, _ in
            let label      = (predictions?.first?.getValues()["class"] as? String)?.lowercased()
            let confidence = Int(((predictions?.first?.getValues()["confidence"] as? NSNumber)?.doubleValue ?? 0) * 100)
            DispatchQueue.main.async {
                self?.viewModel.handleResult(label: label, confidence: confidence)
            }
        }
    }
}
