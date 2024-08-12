//
//  ProfileViewController.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 21/07/2024.
//

import Foundation
import UIKit

class ProfileViewController: UIViewController {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var editProfileButton: UIButton!
    @IBOutlet weak var signOutButton: UIButton!

    @IBOutlet weak var collectionLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var photosLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!

    var user: User?
    var loadTask: Task<Void, Never>?

    deinit {
        loadTask?.cancel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        authCheck()
    }

    func authCheck() {
        guard AuthClient.shared.credential != nil else {
            performSegue(withIdentifier: "showSignInFlow", sender: nil)
            return
        }
        loadUserProfile()
    }

    @IBAction func editProfile() {
        showEditProfileScreen()
    }

    @IBAction func signOut() {
        showCustomAlert(title: "Sign out confirmation", message: "", handlerName: "Sign out", handler: signOutHandler)
    }
}

extension ProfileViewController {
    func loadUserProfile() {
        loadTask?.cancel()
        loadTask = Task { @MainActor in
            do {
                let user = try await ProfileClient.shared.getUserProfile()
                self.user = user
                setupProfile(user: user)
            } catch {
                showCustomAlert(title: "Something went wrong", message: "Try again later.")
            }
        }
    }

    func setupProfile(user: User) {
        userNameLabel.text = user.username
        emailLabel.text = user.email
        bioLabel.text = user.bio

        guard let likesCount = user.totalLikes,
              let photosCount = user.totalPhotos,
              let collectionsCount = user.totalCollections else { return }

        likesLabel.text = "Total likes: \(likesCount)"
        photosLabel.text = "Total photos: \(photosCount)"
        collectionLabel.text = "Total collections: \(collectionsCount)"
    }

    func showEditProfileScreen() {
        let editProfileVC = storyboard?.instantiateViewController(withIdentifier: "EditProfileViewController") as! EditProfileViewController
        editProfileVC.user = user
        editProfileVC.modalPresentationStyle = .overCurrentContext
        self.present(editProfileVC, animated: true) { [weak self] in
            self?.loadUserProfile()
        }
    }

    func signOutHandler() {
        AuthClient.shared.credential = nil
        performSegue(withIdentifier: "showSignInFlow", sender: nil)
    }
}
