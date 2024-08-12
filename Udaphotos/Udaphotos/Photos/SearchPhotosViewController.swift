//
//  ViewController.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 07/07/2024.
//

import UIKit

enum SelectionType: Int {
    case single
    case multiple
}

class SearchPhotosViewController: UIViewController {

    // MARK: - Properties
    
    @IBOutlet weak var loadMoreButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var bottomSheet: UIView!
    @IBOutlet weak var searchQueryTextField: UITextField!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 20.0, left: 20.0, bottom: 20.0, right: 20.0)
    private var currentPage: Int = 1

    var photos: [Photo] = []

    var loadTask: Task<Void, Never>?
    var searchTask: Task<Void, Never>?
    var currentQuery: String = ""
    var caneLoadMorePhotos: Bool  = false

    deinit {
        loadTask?.cancel()
        searchTask?.cancel()
    }

    var isTextFieldEditing: Bool {
        searchQueryTextField.isEditing
    }

    override func viewDidAppear(_ animated: Bool) {
        subscribeToKeyboardNotifications()
    }

    override func viewDidDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupFlowLayout()
        setupButton()
        collectionView.dataSource = self
        collectionView.delegate = self
        hideKeyboardWhenTappedAround()
    }

    func setupFlowLayout() {
        let space: CGFloat = 2.0
        let dimensionWidth = (view.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (200 - (2 * space)) / 2.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }

    func setupButton() {
        searchQueryTextField.delegate = self
        loadMoreButton.isEnabled = false
    }

    // MARK: - Action
    @IBAction func searchPhotos() {
        if let query = searchQueryTextField.text, !query.isEmpty {
            currentQuery = query
            searchPhotos(query: query, isLoadMore: false)
        } else {
            showCustomAlert(title: "Warning", message: "Please enter your serach query before starting the search")
        }

    }

    @IBAction func loadMore() {
        searchPhotos(query: currentQuery, isLoadMore: true)
    }

    func searchPhotos(query: String, isLoadMore: Bool) {
        searchTask?.cancel()
        searchTask = Task { @MainActor in
            do {
                let result = try await PhotoClient.shared.searchPhotos(query: query, page: currentPage)
                photos = isLoadMore ? photos + result : result
                currentPage += 1
                loadMoreButton.isEnabled = true
                collectionView.reloadData()
            } catch {
                showCustomAlert(title: "Something went wrong", message: "Try again later.")
            }
        }
    }

}

// MARK: - UITableViewDataSource
extension SearchPhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoViewCell", for: indexPath)

        if let photoCell = cell as? PhotoViewCell {
            photoCell.setupView(photo: photos[indexPath.row])
        }

        return cell
    }
}

// MARK: - UITextFieldDelegate
extension SearchPhotosViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

private extension SearchPhotosViewController {
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if isTextFieldEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        if isTextFieldEditing {
            view.frame.origin.y = 0
        }
    }
}
