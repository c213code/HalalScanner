import Foundation
import UIKit
import Roboflow

class ModelManager {
    static let shared = ModelManager()

    var rfModel: RFModel?
    var isReady = false
    private var isLoading = false

    private let rf = RoboflowMobile(apiKey: Secrets.roboflowKey)

    func preload(completion: (() -> Void)? = nil) {
        guard !isReady, !isLoading else {
            completion?()
            return
        }

        isLoading = true

        rf.load(model: "food-ksjo4", modelVersion: 3) { model, error, _, _ in
            if let error = error {
                print("MODEL LOAD ERROR:", error.localizedDescription)
                self.isLoading = false
                completion?()
                return
            }

            self.rfModel = model
            model?.configure(threshold: 0.4, overlap: 0.3, maxObjects: 3)

            let size = CGSize(width: 50, height: 50)
            UIGraphicsBeginImageContextWithOptions(size, true, 1.0)
            UIColor.black.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            let dummyImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            guard let image = dummyImage else {
                self.isLoading = false
                completion?()
                return
            }

            model?.detect(image: image) { _, _ in
                self.isReady = true
                self.isLoading = false
                print("MODEL PRELOADED AND WARMED UP")
                completion?()
            }
        }
    }
}
