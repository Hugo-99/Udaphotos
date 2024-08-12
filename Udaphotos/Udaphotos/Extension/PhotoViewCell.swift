//
//  PhotoViewCell.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 23/07/2024.
//

import UIKit

class PhotoViewCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!

    func setupView(photo: Photo) {
        Task { @MainActor in
            do {
//                let image = try await NetworkManager.shared.downloadPhoto(photo.urls[.regular])
                let image = try await NetworkManager.shared.downloadPhoto(photo.urls.regular)
                if let image {
                    updateImageView(with: image)
                }
            } catch {
                guard let placeholderImage = UIImage(named: "photo") else { return }
                updateImageView(with: placeholderImage)
            }
        }
    }

    func updateImageView(with image: UIImage) {
        UIView.transition(with: self.imageView, duration: 0.25, options: [.transitionCrossDissolve], animations: {
            self.imageView.image = image
        }, completion: nil)
    }
}

