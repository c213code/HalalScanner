//
//  ModelManager.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 22.03.2026.
//

import Foundation
import Roboflow

class ModelManager {
    static let shared = ModelManager()
    
    var rfModel: RFModel?
    var isReady = false
    
    private let rf = RoboflowMobile(apiKey: Secrets.roboflowKey)
    
    func preload() {
        rf.load(model: "food-ksjo4", modelVersion: 3) { model, error, _, _ in
            self.rfModel = model
            model?.configure(threshold: 0.4, overlap: 0.3, maxObjects: 3)
            
            // warm up
            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
            UIColor.black.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            let dummyImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let image = dummyImage {
                model?.detect(image: image) { _, _ in
                    self.isReady = true
                    print("MODEL PRELOADED AND WARMED UP")
                }
            }
        }
    }}
