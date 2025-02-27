//
//  ViewController.swift
//  BaseNetWork
//
//  Created by Nguyen Son on 27/2/25.
//

import UIKit
import Combine

struct UserModel: Codable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
}

struct Address: Codable {
    let street: String
    let city: String
    let zipcode: String
}

class ViewController: BaseViewController {

    @IBOutlet weak var labelUserName: UILabel!
    private var viewModel = UserViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchUserData()
        bindViewModel()
    }
    
    private func fetchUserData() {
        showLoading() // Hiện loading khi bắt đầu fetch dữ liệu
        viewModel.fetchUser()
    }
    
    private func bindViewModel() {
    
//        viewModel.$user
//            .compactMap({ $0?.username })
//            .receive(on: DispatchQueue.main)
//            .assign(to: \.text, on: labelUserName)
//            .store(in: &cancellables)
        
        viewModel.$user
            .receive(on: DispatchQueue.main)
            .sink { [weak self] user in
                self?.labelUserName.text = user?.username
                self?.hideLoading()
            }
            .store(in: &cancellables)
    }
}

class UserViewModel: ObservableObject {
    @Published var user: UserModel?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()

    func fetchUser() {
        NetworkService.shared.request(endpoint: .getUser)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = "❌ API Error: \(error.localizedDescription)"
                case .finished:
                    break
                }
            } receiveValue: { user in
                self.user = user
            }
            .store(in: &cancellables)
    }
}
