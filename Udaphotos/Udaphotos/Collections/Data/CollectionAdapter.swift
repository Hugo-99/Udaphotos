//
//  CollectionAdapter.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 11/08/2024.
//

import Foundation
import CoreData

enum CollectionAdapter {
    static func toPhotoCollections(_ collections: [Collection], context: NSManagedObjectContext) -> [PhotosCollection] {
        var photosCollections: [PhotosCollection] = []

        for collection in collections {
            let photosCollection = PhotosCollection(context: context)
            photosCollection.id = collection.id
            photosCollection.title = collection.title
            photosCollection.details = collection.details
            photosCollection.published_at = collection.published_at
            photosCollection.updated_at = collection.updated_at
            photosCollection.total_photos = Int64(collection.total_photos)

            if let cover = collection.cover_photo {
                let coverPhoto = CollectionCoverPhoto(context: context)

                let urls = PhotoUrls(context: context)
                urls.raw = cover.urls.raw
                urls.full = cover.urls.full
                urls.regular = cover.urls.regular
                urls.small = cover.urls.small
                urls.thumb = cover.urls.thumb

                coverPhoto.urls = urls
                photosCollection.cover_photo = coverPhoto
            }

            photosCollections.append(photosCollection)
        }

        try? context.save()

        return photosCollections
    }

}


