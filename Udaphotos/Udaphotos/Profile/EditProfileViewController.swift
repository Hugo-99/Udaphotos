//
//  EditProfileViewController.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation

import Foundation
import UIKit

class EditProfileViewController: UIViewController {

    var user: User!

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        updateScreenView()
    }

    override func viewDidAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }

    var updateTask: Task<Void, Never>?

    var isBottomTextFieldEditing: Bool {
        bioTextField.isEditing || locationTextField.isEditing
    }

    deinit {
        updateTask?.cancel()
    }

    func updateScreenView() {
        usernameTextField.placeholder = "Username"
        firstNameTextField.placeholder = "First name"
        lastNameTextField.placeholder = "Last name"
        bioTextField.placeholder = "Your bio"
        locationTextField.placeholder = "Your location"
        emailTextField.placeholder = "Email"

        usernameTextField.text = user.username
        firstNameTextField.text = user.firstName
        lastNameTextField.text = user.lastName
        bioTextField.text = user.bio
        locationTextField.text = user.location
        emailTextField.text = user.email
    }

    @IBAction func updateProfile(_ sender: UIButton) {
        showCustomAlert(
            title: "Confirmation",
            message: "Are you sure you want to update your profile with these details?",
            handlerName: "Confirm",
            handler: updateUserProfile
        )
    }

    @IBAction func cancelUpdate(_ sender: UIButton) {
        dismissAll()
    }

    func dismissAll() {
        dismiss(animated: true) { [weak presentingViewController] in
            presentingViewController?.dismiss(animated: true, completion: nil)
        }
    }

}

extension EditProfileViewController {
    func updateUserProfile() {
        updateTask?.cancel()
        updateTask = Task { @MainActor in
            do {
                let request = updateProfileRequest()
                let user = try await ProfileClient.shared.updateUserProfile(request: request)
                dismissAll()
            } catch {
                showCustomAlert(title: "Something went wrong", message: "Try again later.")
            }
        }
    }

    func updateProfileRequest() -> UpdateProfileRequest {
        UpdateProfileRequest(
           username: usernameTextField.text,
           first_name: firstNameTextField.text,
           last_name: lastNameTextField.text,
           email: emailTextField.text,
           location: locationTextField.text,
           bio: bioTextField.text
       )
    }
}

private extension EditProfileViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if isBottomTextFieldEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if isBottomTextFieldEditing {
            view.frame.origin.y = 0
        }
    }
}
