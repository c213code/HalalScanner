import Foundation
import UIKit
import Roboflow

class ModelManager {
    static let shared = ModelManager()

    private(set) var model: RFModel?
    var isReady = false
    private var isLoading = false

    private let rf = RoboflowMobile(apiKey: Secrets.roboflowKey)

    // Dairy products model (-tv4zs, version 8)
    private let projectID = "-tv4zs"
    private let projectVersion = 8

    func preload(completion: (() -> Void)? = nil) {
        guard !isReady, !isLoading else {
            completion?()
            return
        }
        isLoading = true

        rf.load(model: projectID, modelVersion: projectVersion) { [weak self] rfModel, error, _, _ in
            guard let self else { return }
            if let error = error {
                print("Ошибка загрузки модели:", error.localizedDescription)
            } else if let rfModel {
                self.model = rfModel
                rfModel.configure(threshold: 0.4, overlap: 0.3, maxObjects: 3)
                print("Модель готова:", self.projectID)
            }
            self.isReady = self.model != nil
            self.isLoading = false
            completion?()
        }
    }
}
