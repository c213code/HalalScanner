import Foundation
import UIKit
import Roboflow

class ModelManager {
    static let shared = ModelManager()

    // Словарь для хранения загруженных моделей
    var models: [String: RFModel] = [:]
    var isReady = false
    private var isLoading = false

    // Ваш API Key из Roboflow
    private let rf = RoboflowMobile(apiKey: Secrets.roboflowKey)

    // Обновленные ID проектов и их версии из ваших писем
    private let projectConfigs = [
        "food": (id: "food-ksjo4", version: 3),
        "dairy": (id: "-tv4zs", version: 4)
    ]

    func preload(completion: (() -> Void)? = nil) {
        guard !isReady, !isLoading else {
            completion?()
            return
        }

        isLoading = true
        let group = DispatchGroup()

        for (name, config) in projectConfigs {
            group.enter()
            
            rf.load(model: config.id, modelVersion: config.version) { model, error, _, _ in
                if let error = error {
                    print("Ошибка загрузки модели \(name):", error.localizedDescription)
                } else if let model = model {
                    self.models[name] = model
                    // Настройка параметров детекции
                    model.configure(threshold: 0.4, overlap: 0.3, maxObjects: 3)
                    print("Модель \(name) успешно загружена")
                }
                group.leave()
            }
        }

        group.notify(queue: .main) {
            self.isReady = true
            self.isLoading = false
            print("Все модели готовы к работе: \(self.models.keys)")
            completion?()
        }
    }
    
    // Метод для получения конкретной модели по имени ("food" или "dairy")
    func getModel(named name: String) -> RFModel? {
        return models[name]
    }
}
