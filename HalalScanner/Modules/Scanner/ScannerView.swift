//
//  ScannerView.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 30.03.2026.
//

import UIKit

class ScannerView : UIView {
    let captureButton = UIButton()
    let scanFrame = UIView()
    
    let productStack = UIStackView()
    let statusLabel = PaddingLabel()
    let nameLabel = PaddingLabel()
    let halalLabel = PaddingLabel()
    let caloriesLabel = PaddingLabel()
    let overlayView = UIView()
    
    let flashView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupUI() {
        
        captureButton.translatesAutoresizingMaskIntoConstraints = false
        captureButton.backgroundColor = .white
        captureButton.layer.cornerRadius = 35
        
        addSubview(captureButton)
        NSLayoutConstraint.activate([
            
            captureButton.widthAnchor.constraint(equalToConstant: 70),
            captureButton.heightAnchor.constraint(equalToConstant: 70),
            
            captureButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            captureButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -40)
            
        ])
        
        
        
        
        scanFrame.translatesAutoresizingMaskIntoConstraints = false
        scanFrame.layer.borderColor = UIColor.white.cgColor
        //        scanFrame.layer.borderWidth = 2
        scanFrame.layer.cornerRadius = 12
        
        addSubview(scanFrame)
        
        NSLayoutConstraint.activate([
            scanFrame.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.7),
            scanFrame.heightAnchor.constraint(equalTo: scanFrame.widthAnchor),
            
            scanFrame.centerXAnchor.constraint(equalTo: centerXAnchor),
            scanFrame.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.text = "No Food Detected ❌"
        statusLabel.padding = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        statusLabel.backgroundColor = .appScannerStatus
        
        statusLabel.layer.cornerRadius = 10
        
        statusLabel.layer.masksToBounds = true
        
        statusLabel.textAlignment = .center
        statusLabel.clipsToBounds = true
        
        statusLabel.textColor = .white
        statusLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        addSubview(statusLabel)
        
        NSLayoutConstraint.activate([
            statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            statusLabel.topAnchor.constraint(equalTo: scanFrame.topAnchor, constant: -100)
        ])
        
        flashView.backgroundColor = .white
        flashView.alpha = 0
        flashView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flashView)
        bringSubviewToFront(flashView)
        NSLayoutConstraint.activate([
            flashView.topAnchor.constraint(equalTo: topAnchor),
            flashView.bottomAnchor.constraint(equalTo: bottomAnchor),
            flashView.leadingAnchor.constraint(equalTo: leadingAnchor),
            flashView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])

        
        
        setupScannerCorners()
        setupProductInfo()
        
        
        
        setupOverlay()
        
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
        
        addSubview(productStack)
        
        NSLayoutConstraint.activate([
            productStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            productStack.bottomAnchor.constraint(equalTo: captureButton.topAnchor, constant: -20)
        ])
        
        [nameLabel, halalLabel].forEach {
            $0.textColor = .white
            $0.backgroundColor = .appOverlayLabel
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
    func setupOverlay() {
        insertSubview(overlayView, belowSubview: scanFrame)

        bringSubviewToFront(scanFrame)
        bringSubviewToFront(statusLabel)
        bringSubviewToFront(captureButton)
        
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        
        
    }
    func applyOverlayMask() {
            let scanRect = convert(scanFrame.frame, from: scanFrame.superview)
            
            let path = UIBezierPath(rect: overlayView.bounds)
            
            let pathScanner  = UIBezierPath(roundedRect: scanRect, cornerRadius: 5)
            
            path.append(pathScanner)
            path.usesEvenOddFillRule = true
            
            overlayView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
            
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            maskLayer.fillRule = .evenOdd
            maskLayer.fillColor = UIColor.appOverlayMask.cgColor
            
            overlayView.layer.addSublayer(maskLayer)
        }
    
    func animateCapture() {
        flashView.alpha = 1
        UIView.animate(withDuration: 0.35, delay: 0, options: .curveEaseOut) {
            self.flashView.alpha = 0
        }
        UIView.animate(withDuration: 0.1, animations: {
            self.captureButton.transform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        }) { _ in
            UIView.animate(withDuration: 0.15) {
                self.captureButton.transform = .identity
            }
        }
        statusLabel.text = "Анализдалуда... ⏳"
        statusLabel.backgroundColor = .appScannerActive
        UIView.animate(withDuration: 0.6, delay: 0, options: [.repeat, .autoreverse, .allowUserInteraction]) {
            self.statusLabel.alpha = 0.4
        }
    }
    
    func stopStatusPulse() {
        statusLabel.layer.removeAllAnimations()
        UIView.animate(withDuration: 0.2) {
            self.statusLabel.alpha = 1
        }
        statusLabel.backgroundColor = .appScannerStatus

    }
    
    
}
