//
//  imageColletionViewController.swift
//  Virtual Tourist
//
//  Created by walaa fahad  on 6/26/19.
//  Copyright © 2019 Walaa Fahad. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class imageColletionViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate{


    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var actvInd: UIActivityIndicatorView!
    
    @IBOutlet weak var newCollectionButton: UIBarButtonItem!
    
    @IBOutlet weak var messlabale: UILabel!
    var fetchedResultsController: NSFetchedResultsController<Photo>!
    var pin: Pin!
    var pageNumber = 1
    var isDeletingEverything = false
    var context: NSManagedObjectContext {
        return DataController.shared.viewContext
    }

    var isThereAnyPhoto: Bool {
    return (fetchedResultsController.fetchedObjects?.count ?? 0) != 0    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pinFetshedController()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        fetchedResultsController = nil
    }
    func updateInterface(processing: Bool) {
        collectionView.isUserInteractionEnabled = !processing
        if processing {
            actvInd.startAnimating()
            
        } else {
            actvInd.stopAnimating()
            actvInd.hidesWhenStopped = true
        }
    }
    
     fileprivate func pinFetshedController() {
        let fetchRequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(key: "creationDate", ascending: true)
        ]
        fetchRequest.predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do {
            try fetchedResultsController.performFetch()
            if isThereAnyPhoto {
              updateInterface(processing: false)
            } else {
                newCollectionTapped(self)
            }
            
            
        } catch {
            fatalError("The fetch could not be performd: \(error.localizedDescription)")
        }
        
    }
 
    @IBAction func newCollectionTapped(_ sender: Any) {
   
        
        updateInterface(processing: true)
        
        if isThereAnyPhoto {
            isDeletingEverything = true
            for photo in fetchedResultsController.fetchedObjects! {
                context.delete(photo)
            }
            try? context.save()
            isDeletingEverything = false
        }
        
        ApiCallss.getImagesURL(location: pin.coord, pageNum: pageNumber) { (urls, error, Message) in
            DispatchQueue.main.async {
                self.updateInterface(processing: false)
                
                guard (error == nil) && (Message == nil) else {
                    self.showNotify(title: "Error",
                                         message: error?.localizedDescription ?? Message)
                    return
                }
                
                guard let urls = urls, !urls.isEmpty else {
                    self.messlabale.isHidden = false
                    return
                }
                
                for url in urls {
                    let photo = Photo(context: self.context)
                    photo.imageUrl = url
                    photo.pin = self.pin
                }
                
                try? self.context.save()
            }
        }
        pageNumber += 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchedResultsController.fetchedObjects?.count ?? 0
    }
  
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellPhoto", for: indexPath) as! cellPhoto
        let photo = fetchedResultsController.object(at: indexPath)
        cell.imageView.setPhoto(photo)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let photo = fetchedResultsController.object(at: indexPath)
        context.delete(photo)
        try? context.save()
    }
    

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        if let indexPath = indexPath, type == .delete && !isDeletingEverything {
            collectionView.deleteItems(at: [indexPath])
            return
        }
        
        if let indexPath = indexPath, type == .insert {
            collectionView.insertItems(at: [indexPath])
            return
        }
        
        if let newIndexPath = newIndexPath, let oldIndexPath = indexPath, type == .move {
            collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
            return
        }
        
        if type != .update {
            collectionView.reloadData()
        }
    }
}
