//
//  CollectionPhotosViewController.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 23/07/2024.
//

import Foundation
import UIKit

class CollectionAlbumViewController: UIViewController {

    var collection: PhotosCollection!


    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var coverPhoto: UIImageView!
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var titleItem: UINavigationItem!
    @IBOutlet weak var albumView: UICollectionView!

    var photos: [Photo] = []
    var loadTask: Task<Void, Never>?

    deinit {
        loadTask?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupFlowLayout()
        setupCollectionView()
        loadCollectionPhotos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        albumView.reloadData()
    }

    func setupView() {
        titleItem.title = collection.title
        descriptionTextView.text = collection.details ?? "No desciption"
        descriptionTextView.isEditable = false
        descriptionTextView.isUserInteractionEnabled = false
        loadCoverPhoto()
    }

    func setupCollectionView() {
        albumView.delegate = self
        albumView.dataSource = self
    }

    func setupFlowLayout() {
        let space: CGFloat = 2.0
        let dimensionWidth = (albumView.frame.size.width - (2 * space)) / 3.0
        let dimensionHeight = (coverPhoto.frame.size.height - (2 * space)) / 2.0

        flowLayout.minimumInteritemSpacing = space
        flowLayout.minimumLineSpacing = space
        flowLayout.itemSize = CGSize(width: dimensionWidth, height: dimensionHeight)
    }
}

extension CollectionAlbumViewController {
    func loadCoverPhoto() {
        Task { @MainActor in
            do {
                let image = try await NetworkManager.shared.downloadPhoto(collection.cover_photo?.urls?.full)
                coverPhoto.image = image
            } catch {
                guard let placeholderImage = UIImage(named: "photo") else { return }
                coverPhoto.image = placeholderImage
            }
        }
    }

    func loadCollectionPhotos() {
        loadTask?.cancel()
        loadTask = Task { @MainActor in
            do {
                let result = try await PhotoClient.shared.searchPhotos(query: collection.title ?? "", page: 1, collections: [collection.id ?? "1"])
                self.photos = result
                self.albumView.reloadData()
            } catch {
                showCustomAlert(title: "Something went wrong", message: "Try again later.")
            }
        }
    }
}

extension CollectionAlbumViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
