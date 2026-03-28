//
//  AuthViewModel.swift
//  HalalScanner
//
//  Created by Yerasyl Toleubek on 26.03.2026.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore


class AuthViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var isLoading = false
    @Published var errorMessage = ""
    
    var cancellables = Set<AnyCancellable>()
    
    var isFormValid: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest($email, $password)
            .map{ email, password in
                email.contains("@") && password.count >= 6
            }
            .eraseToAnyPublisher()
    }
    
    func login(completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] _, error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    func register(completion: @escaping (Result<Void, Error>) -> Void) {
        isLoading = true
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            self?.isLoading = false
            if let error = error {
                self?.errorMessage = error.localizedDescription
                completion(.failure(error))
            } else {
                self?.saveUserToFirestore(userId: result?.user.uid ?? "", email: self?.email ?? "", completion: completion)
            }
        }
    }
    func saveUserToFirestore(userId: String, email: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        let role = email == "admin@halal.com" ? "admin" : "user"
        
        db.collection("users").document(userId).setData([
            "email": email,
            "name": "Пайдаланушы",
            "role": role
        ]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
            }
    }
    
    
    
}
