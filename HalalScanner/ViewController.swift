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
    
    
   
    
    let overlayView = UIView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        captureButton.isEnabled = false
        statusLabel.text = "Preparing scanner..."

        if ModelManager.shared.isReady {
            isModelReady = true
            captureButton.isEnabled = true
            statusLabel.text = "Ready to scan ✅"
        } else {
            DispatchQueue.global(qos: .userInitiated).async {
                ModelManager.shared.preload { [weak self] in
                    DispatchQueue.main.async {
                        self?.isModelReady = ModelManager.shared.isReady
                        self?.captureButton.isEnabled = ModelManager.shared.isReady
                        self?.statusLabel.text = ModelManager.shared.isReady ? "Ready to scan ✅" : "Model load failed"
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        applyOverlayMask()
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

    

   
    
    func detectWithRoboflow(image: UIImage) {
        let foodModel = ModelManager.shared.getModel(named: "food")
        let dairyModel = ModelManager.shared.getModel(named: "dairy")
        
        guard foodModel != nil || dairyModel != nil else {
            statusLabel.text = "Model not loaded"
            isDetecting = false
            captureButton.isEnabled = true
            return
        }
        
        statusLabel.text = "Searching..."
        productStack.isHidden = true
        
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
                self.statusLabel.text = "Detected: \(product.emoji) \(product.name) (\(bestConfidence)%)"
                self.autoSave(product: product, confidence: bestConfidence)
                self.showProductInfo(product: product, confidence: bestConfidence)
            } else {
                self.statusLabel.text = "No Food Detected ❌"
                self.productStack.isHidden = true
            }
            self.isDetecting = false
            self.captureButton.isEnabled = true
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
    func autoSave(product: Product, confidence: Int) {
        guard let userId = Auth.auth().currentUser?.uid else { return }
        
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "name": product.name,
            "emoji": product.emoji,
            "isHalal": product.isHalal,
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
