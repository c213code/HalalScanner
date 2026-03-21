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

class ViewController: UIViewController {

    
    
    let captureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    let captureButton = UIButton()
    let photoOutput = AVCapturePhotoOutput()
    let scanFrame = UIView()
    
    var isModelReady = false
    var isDetecting = false
    
    let productStack = UIStackView()
    let statusLabel = PaddingLabel()
    let nameLabel = PaddingLabel()
    let halalLabel = PaddingLabel()
    let caloriesLabel = PaddingLabel()
    
    
    let rf = RoboflowMobile(apiKey: Secrets.roboflowKey)
    var rfModel: RFModel?
    
    let overlayView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCamera()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyOverlayMask()
    }
    
    func setupCamera() {
        captureSession.sessionPreset = .photo
        
        guard let device = AVCaptureDevice.default(for: .video) else { return }
        
        do {
            let input = try AVCaptureDeviceInput(device: device)
            
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
            }
            if captureSession.canAddOutput(photoOutput) {
                captureSession.addOutput(photoOutput)
            }
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.frame = view.bounds
            previewLayer.videoGravity = .resizeAspectFill
            
            view.layer.addSublayer(previewLayer)
            
            DispatchQueue.global(qos: .userInitiated).async {
                self.captureSession.startRunning()
            }
        }
        catch{
            print("Camera error")
        }
        
    }
    func setupUI() {
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 35
        
        view.addSubview(captureButton)
        NSLayoutConstraint.activate([

                    captureButton.widthAnchor.constraint(equalToConstant: 70),
                    captureButton.heightAnchor.constraint(equalToConstant: 70),

                    captureButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                    captureButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40)

                ])
        
        captureButton.addTarget(self, action: #selector(capturePhoto), for: .touchUpInside)
        
        
        scanFrame.translatesAutoresizingMaskIntoConstraints = false
        scanFrame.layer.borderColor = UIColor.white.cgColor
//        scanFrame.layer.borderWidth = 2
        scanFrame.layer.cornerRadius = 12
        
        view.addSubview(scanFrame)
        
        NSLayoutConstraint.activate([
            scanFrame.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.7),
            scanFrame.heightAnchor.constraint(equalTo: scanFrame.widthAnchor),
            
            scanFrame.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            scanFrame.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "No Food Detected ❌"
        statusLabel.padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        statusLabel.backgroundColor = UIColor.gray.withAlphaComponent(0.7)

        statusLabel.layer.cornerRadius = 10
        
        statusLabel.layer.masksToBounds = true
        
        statusLabel.textAlignment = .center
        statusLabel.clipsToBounds = true
        
        statusLabel.textColor = .white
        statusLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        view.addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: scanFrame.topAnchor, constant: -100)
        ])
        
        setupScannerCorners()
        setupProductInfo()
        
        loadRoboflowModel()
        
        setupOverlay()
       
        
    }
    @objc func capturePhoto() {
        guard isModelReady else {
              statusLabel.text = "Please wait..."
              return
          }

          guard !isDetecting else { return }

          isDetecting = true
          captureButton.isEnabled = false

          let settings = AVCapturePhotoSettings()
          photoOutput.capturePhoto(with: settings, delegate: self)
        
 


    }
    
    func createCornerLine() -> UIView {
        let line = UIView()
        line.backgroundColor = .white
        line.translatesAutoresizingMaskIntoConstraints = false
        line.layer.cornerRadius = 5
        line.clipsToBounds = true
        
        return line
        
    }
    func setupScannerCorners() {
        
        let topLeftHorizontal = createCornerLine()
        let topLeftVertical = createCornerLine()

        let topRightHorizontal = createCornerLine()
        let topRightVertical = createCornerLine()

        let bottomLeftHorizontal = createCornerLine()
        let bottomLeftVertical = createCornerLine()

        let bottomRightHorizontal = createCornerLine()
        let bottomRightVertical = createCornerLine()
        
        
        scanFrame.addSubview(topLeftHorizontal)
        scanFrame.addSubview(topLeftVertical)

        scanFrame.addSubview(topRightHorizontal)
        scanFrame.addSubview(topRightVertical)

        scanFrame.addSubview(bottomLeftHorizontal)
        scanFrame.addSubview(bottomLeftVertical)

        scanFrame.addSubview(bottomRightHorizontal)
        scanFrame.addSubview(bottomRightVertical)
        
        
        NSLayoutConstraint.activate([
            
            // sizes
            topLeftHorizontal.widthAnchor.constraint(equalToConstant: 40),
            topLeftHorizontal.heightAnchor.constraint(equalToConstant: 4),
            
            topLeftVertical.widthAnchor.constraint(equalToConstant: 4),
            topLeftVertical.heightAnchor.constraint(equalToConstant: 40),
            
            
            topRightHorizontal.widthAnchor.constraint(equalToConstant: 40),
            topRightHorizontal.heightAnchor.constraint(equalToConstant: 4),
            
            topRightVertical.widthAnchor.constraint(equalToConstant: 4),
            topRightVertical.heightAnchor.constraint(equalToConstant: 40),
            
            
            bottomLeftHorizontal.widthAnchor.constraint(equalToConstant: 40),
            bottomLeftHorizontal.heightAnchor.constraint(equalToConstant: 4),
            
            bottomLeftVertical.widthAnchor.constraint(equalToConstant: 4),
            bottomLeftVertical.heightAnchor.constraint(equalToConstant: 40),
            
            
            bottomRightHorizontal.widthAnchor.constraint(equalToConstant: 40),
            bottomRightHorizontal.heightAnchor.constraint(equalToConstant: 4),
            
            bottomRightVertical.widthAnchor.constraint(equalToConstant: 4),
            bottomRightVertical.heightAnchor.constraint(equalToConstant: 40),
            
            
            // top left position
            topLeftHorizontal.topAnchor.constraint(equalTo: scanFrame.topAnchor),
            topLeftHorizontal.leftAnchor.constraint(equalTo: scanFrame.leftAnchor),
            
            topLeftVertical.topAnchor.constraint(equalTo: scanFrame.topAnchor),
            topLeftVertical.leftAnchor.constraint(equalTo: scanFrame.leftAnchor),
            
            
            // top right
            topRightHorizontal.topAnchor.constraint(equalTo: scanFrame.topAnchor),
            topRightHorizontal.rightAnchor.constraint(equalTo: scanFrame.rightAnchor),
            
            topRightVertical.topAnchor.constraint(equalTo: scanFrame.topAnchor),
            topRightVertical.rightAnchor.constraint(equalTo: scanFrame.rightAnchor),
            
            
            // bottom left
            bottomLeftHorizontal.bottomAnchor.constraint(equalTo: scanFrame.bottomAnchor),
            bottomLeftHorizontal.leftAnchor.constraint(equalTo: scanFrame.leftAnchor),
            
            bottomLeftVertical.bottomAnchor.constraint(equalTo: scanFrame.bottomAnchor),
            bottomLeftVertical.leftAnchor.constraint(equalTo: scanFrame.leftAnchor),
            
            
            // bottom right
            bottomRightHorizontal.bottomAnchor.constraint(equalTo: scanFrame.bottomAnchor),
            bottomRightHorizontal.rightAnchor.constraint(equalTo: scanFrame.rightAnchor),
            
            bottomRightVertical.bottomAnchor.constraint(equalTo: scanFrame.bottomAnchor),
            bottomRightVertical.rightAnchor.constraint(equalTo: scanFrame.rightAnchor),
            
        ])
    }
    
    func setupProductInfo() {
        productStack.axis = .vertical
        productStack.spacing = 8
        productStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(productStack)
        
        NSLayoutConstraint.activate([
            productStack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            productStack.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -20)
        ])
        
        [nameLabel, halalLabel].forEach {
            $0.textColor = .white
            $0.backgroundColor = UIColor.black.withAlphaComponent(0.7)
            $0.layer.cornerRadius = 14
            $0.layer.masksToBounds = true
            $0.textAlignment = .center
            $0.padding = UIEdgeInsets(top: 10, left: 16, bottom: 10, right: 16)
        }
        
        nameLabel.font = .systemFont(ofSize: 20, weight: .bold)
        halalLabel.font = .systemFont(ofSize: 16, weight: .medium)
        
        productStack.addArrangedSubview(nameLabel)
        productStack.addArrangedSubview(halalLabel)
        
        productStack.isHidden = true
    }
    func showProductInfo(product: Product, confidence: Int) {
        let vc = ProductSheetVC(product:  product, confidence: confidence)
        vc.modalPresentationStyle = .pageSheet
        
        if let sheet = vc.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = false
            sheet.preferredCornerRadius = 32
        }
        
        present(vc, animated: true)
        
    }

    
    func loadRoboflowModel() {
        statusLabel.text = "Preparing scanner..."
        captureButton.isEnabled = false

        rf.load(model: "food-ksjo4", modelVersion: 3) { [weak self] model, error, _, _ in
            guard let self = self else { return }

            if let error = error {
                print("ROBOFLOW LOAD ERROR:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.statusLabel.text = "Model load error"
                }
                return
            }

            model?.configure(threshold: 0.4, overlap: 0.3, maxObjects: 3)
            self.rfModel = model

            self.warmUpModel()
        }
    }
    func warmUpModel() {
        guard let rfModel = rfModel else { return }

        let size = CGSize(width: 50, height: 50)
        UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
        UIColor.black.setFill()
        UIRectFill(CGRect(origin: .zero, size: size))
        let dummyImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        guard let image = dummyImage else { return }

        rfModel.detect(image: image) { [weak self] _, _ in
            guard let self = self else { return }

            print("MODEL WARMED UP")

            DispatchQueue.main.async {
                self.isModelReady = true
                self.captureButton.isEnabled = true
                self.statusLabel.text = "Ready to scan ✅"
            }
        }
    }
    
    func detectWithRoboflow(image: UIImage) {
        guard let rfModel = rfModel else {
            statusLabel.text = "Model not loaded"
            productStack.isHidden = true
            isDetecting = false
            captureButton.isEnabled = true
            return
        }

        statusLabel.text = "Searching..."
        productStack.isHidden = true

        rfModel.detect(image: image) { [weak self] predictions, error in
            guard let self = self else { return }

            if error != nil {
                DispatchQueue.main.async {
                    self.statusLabel.text = "Detection error"
                    self.productStack.isHidden = true
                    self.isDetecting = false
                    self.captureButton.isEnabled = true
                }
                return
            }

            guard let first = predictions?.first else {
                DispatchQueue.main.async {
                    self.statusLabel.text = "No Food Detected ❌"
                    self.productStack.isHidden = true
                    self.isDetecting = false
                    self.captureButton.isEnabled = true
                }
                return
            }

            let values = first.getValues()
            let label = (values["class"] as? String ?? "Unknown").lowercased()
            let confidence = Int(((values["confidence"] as? NSNumber)?.doubleValue ?? 0) * 100)

            DispatchQueue.main.async {
                if let product = ProductCatalog.products[label] {
                    self.statusLabel.text = "Detected: \(product.emoji) \(product.name) (\(confidence)%)"
                    self.showProductInfo(product: product, confidence: confidence)
                } else {
                    self.statusLabel.text = "Detected: \(label.capitalized) (\(confidence)%)"
                    self.productStack.isHidden = true
                }

                self.isDetecting = false
                self.captureButton.isEnabled = true
            }
        }
    }
    
    func setupOverlay() {
        view.insertSubview(overlayView, belowSubview: scanFrame)

        view.bringSubviewToFront(scanFrame)
        view.bringSubviewToFront(statusLabel)
        view.bringSubviewToFront(captureButton)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        
        
    }
    
    func applyOverlayMask() {
        let scanRect = view.convert(scanFrame.frame, from: scanFrame.superview)
        
        let path = UIBezierPath(rect: overlayView.bounds)
        
        let pathScanner  = UIBezierPath(roundedRect: scanRect, cornerRadius: 5)
        
        path.append(pathScanner)
        path.usesEvenOddFillRule = true
        
        overlayView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        maskLayer.fillRule = .evenOdd
        maskLayer.fillColor = UIColor.black.withAlphaComponent(0.55).cgColor
        
        overlayView.layer.addSublayer(maskLayer)
    }
}

class PaddingLabel: UILabel {
    var padding = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    
    override func drawText(in rect: CGRect) {
        let insetRect = rect.inset(by: padding)
        super.drawText(in: insetRect)
          
    }
    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize

        return CGSize(width: size.width + padding.left + padding.right, height: size.height + padding.top + padding.bottom)
                      
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
