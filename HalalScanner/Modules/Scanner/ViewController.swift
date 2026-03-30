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
import FirebaseFirestore
import FirebaseAuth

class ViewController: UIViewController {

    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
  
    let photoOutput = AVCapturePhotoOutput()

    var isModelReady = false
    var isDetecting = false
    
    weak var coordinator: AppCoordinator?
    
    let scannerView = ScannerView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scannerView.captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)

        scannerView.captureButton.isEnabled = false
        scannerView.statusLabel.text = "Preparing scanner..."

        if ModelManager.shared.isReady {
            isModelReady = true
            scannerView.captureButton.isEnabled = true
            scannerView.statusLabel.text = "Ready to scan ✅"
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                ModelManager.shared.preload { [weak self] in
                    DispatchQueue.main.async {
                        self?.isModelReady = ModelManager.shared.isReady
                        self?.scannerView.captureButton.isEnabled = ModelManager.shared.isReady
                        self?.scannerView.statusLabel.text = ModelManager.shared.isReady ? "Ready to scan ✅" : "Model load failed"
                    }
                }
            }
        }
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
    
    override func loadView(){
        view = scannerView
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scannerView.applyOverlayMask()
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
        guard isModelReady else {
            scannerView.statusLabel.text = "Please wait..."
              return
          }

          guard !isDetecting else { return }

          isDetecting = true
        scannerView.captureButton.isEnabled = false

          let settings = AVCapturePhotoSettings()
          photoOutput.capturePhoto(with: settings, delegate: self)
        
 


    }
    
    func showProductInfo(product: Product, confidence: Int) {
        coordinator?.showProductSheet(from: self, product: product, confidence: confidence)
        
    }


    
    func detectWithRoboflow(image: UIImage) {
        let foodModel = ModelManager.shared.getModel(named: "food")
        let dairyModel = ModelManager.shared.getModel(named: "dairy")
        
        guard foodModel != nil || dairyModel != nil else {
            scannerView.statusLabel.text = "Model not loaded"
            isDetecting = false
            scannerView.captureButton.isEnabled = true
            return
        }
        
        scannerView.statusLabel.text = "Searching..."
        scannerView.productStack.isHidden = true
        
        var bestLabel: String?
        var bestConfidence: Int = 0
        let group = DispatchGroup()
        
        for model in [foodModel, dairyModel].compactMap({ $0 }) {
            group.enter()
            model.detect(image: image) { predictions, error in
                if let first = predictions?.first {
                    let values = first.getValues()
                    let label = (values["class"] as? String ?? "").lowercased()
                    let confidence = Int(((values["confidence"] as? NSNumber)?.doubleValue ?? 0) * 100)
                    if confidence > bestConfidence {
                        bestConfidence = confidence
                        bestLabel = label
                    }
                }
                group.leave()
            }
        }
        
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            if let label = bestLabel, let product = ProductCatalog.products[label] {
                self.scannerView.statusLabel.text = "Detected: \(product.emoji) \(product.name) (\(bestConfidence)%)"
                self.autoSave(product: product, confidence: bestConfidence)
                self.showProductInfo(product: product, confidence: bestConfidence)
            } else {
                self.scannerView.statusLabel.text = "No Food Detected ❌"
                self.scannerView.productStack.isHidden = true
            }
            self.isDetecting = false
            self.scannerView.captureButton.isEnabled = true
        }
    }
    
  
    
    func autoSave(product: Product, confidence: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "name": product.name,
            "emoji": product.emoji,
            "isHalal": product.halalStatus == .halal,
            "confidence": confidence,
            "category": product.category,
            "calories": product.calories,
            "date": Date()
        ]
        
        db.collection("scans").document(userId).collection("items")
            .addDocument(data: data) { error in
                if error == nil { print("АВТОСОХРАНЕНО!") }
            }
    }
}




extension ViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?){
        
        
        print("PHOTO CAPTURED")
        guard let data = photo.fileDataRepresentation() else {
            print("NO PHOTO DATA")

            return }
        
        guard let image = UIImage(data: data) else {
            print("CANNOT CREATE UIIMAGE")

            return }
        
        detectWithRoboflow(image: image)

    }
}
