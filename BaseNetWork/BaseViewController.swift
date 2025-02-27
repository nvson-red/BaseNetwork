//
//  BaseViewController.swift
//  BaseNetWork
//
//  Created by Nguyen Son on 27/2/25.
//

import Foundation
import Combine
import UIKit

class BaseViewController: UIViewController {
    private var loadingView: UIActivityIndicatorView?
    var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupLoadingView()
    }

    private func setupLoadingView() {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)
        loadingView = activityIndicator
    }

    func showLoading() {
        DispatchQueue.main.async {
            self.loadingView?.startAnimating()
            self.loadingView?.isHidden = false
        }
    }

    func hideLoading() {
        DispatchQueue.main.async {
            self.loadingView?.stopAnimating()
            self.loadingView?.isHidden = true
        }
    }
}
