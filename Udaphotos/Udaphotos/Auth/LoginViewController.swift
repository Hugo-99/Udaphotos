//
//  LoginViewController.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 07/07/2024.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    let authClient = AuthClient()
    var authTask: Task<Void, Never>?

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    deinit {
        authTask?.cancel()
    }

    @IBAction func login(_ sender: UIButton) {
        setLoggingIn(true)
        loginHandler()
    }

    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        loginButton.isEnabled = !loggingIn
    }
}

extension LoginViewController {
    func loginHandler() {
        authTask?.cancel()
        authTask = Task { @MainActor in
            defer { setLoggingIn(false) }
            do {
                let code = try await authClient.authorize()
                let _ = try await authClient.token(code: code)
                performSegue(withIdentifier: "completeLogin", sender: nil)
            } catch {
                showCustomAlert(title: "Something went wrong", message: "Double check your email and password and try again.")
            }
        }
    }
}
