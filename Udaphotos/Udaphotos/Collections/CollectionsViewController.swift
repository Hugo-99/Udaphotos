//
//  CollectionsViewController.swift
//  Udaphotos
//
//  Created by Li Hang Koh on 22/07/2024.
//

import Foundation
import UIKit
import CoreData

class CollectionsViewController: UIViewController, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!

    var selectedIndex = 0
    var collections: [PhotosCollection] = []
    var loadTask: Task<Void, Never>?
    var fetchedResultController: NSFetchedResultsController<PhotosCollection>!

    fileprivate func setupFetchedResultController() {
        let fetchRequest: NSFetchRequest<PhotosCollection> = PhotosCollection.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        let predicate = NSPredicate(format: "title != nil")
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.predicate = predicate

        fetchedResultController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: DataController.shared.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        fetchedResultController.delegate = self

        do {
            try fetchedResultController.performFetch()
        } catch {
            fatalError("The fetch could not be performed: \(error.localizedDescription)")
        }
    }

    deinit {
        loadTask?.cancel()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupFetchedResultController()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupCollection()
    }

    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "CollectionTableViewCell")
    }

    func setupCollection() {
        guard let storedCollections = fetchedResultController.fetchedObjects, !storedCollections.isEmpty else {
            loadCollections()
            return
        }
        collections = storedCollections
        tableView.reloadData()
    }

    func loadCollections() {
        loadTask?.cancel()
        loadTask = Task { @MainActor in
            do {
                let result = try await CollectionClient.shared.listCollections()
                let collections = CollectionAdapter.toPhotoCollections(result, context: DataController.shared.viewContext)
                self.collections = collections
                self.tableView.reloadData()
            } catch {
                showCustomAlert(title: "Something went wrong", message: "Try again later.")
            }
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "collectionAlbumSegue", let albumVC = segue.destination as? CollectionAlbumViewController {
            albumVC.collection = collections[selectedIndex]
        }
    }
}

extension CollectionsViewController: UITableViewDataSource, UITableViewDelegate  {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return collections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionTableViewCell", for: indexPath)

        let collection = collections[indexPath.row]

        cell.textLabel?.text = collection.title
        cell.imageView?.image = UIImage(named: "photo") // Placeholder image, update as necessary

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        performSegue(withIdentifier: "collectionAlbumSegue", sender: nil)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
