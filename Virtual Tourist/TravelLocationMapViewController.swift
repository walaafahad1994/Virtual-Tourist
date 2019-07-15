//
//  TravelLocationMapViewController.swift
//  Virtual Tourist
//
//  Created by walaa fahad  on 6/24/19.
//  Copyright © 2019 Walaa Fahad. All rights reserved.
//

import UIKit
import MapKit
import CoreData
class TravelLocationMapViewController: UIViewController  ,UIGestureRecognizerDelegate , NSFetchedResultsControllerDelegate , MKMapViewDelegate{

    
    @IBOutlet weak var mapView: MKMapView!
   // var pinSaved = [Pin]()
    var dataController:DataController!
  //  var fetshResultController:NSFetchedResultsController<Pin>!
    var fetchedResultsController: NSFetchedResultsController<Pin>!
  
    var context: NSManagedObjectContext {
        return DataController.shared.viewContext
    }
    
    
    fileprivate func pinFetshedController() {
        let fetchRequest:NSFetchRequest<Pin> = Pin.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultsController.delegate = self
        do{
            try  fetchedResultsController.performFetch()
            updateMap()
        }catch
        {
            fatalError("The fetch can not Be performed ")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        pinFetshedController()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pinFetshedController()
    }
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let defaults = UserDefaults.standard
defaults.set(mapView.centerCoordinate.latitude, forKey: "lat")
        defaults.set(mapView.centerCoordinate.longitude, forKey: "long")
        defaults.set(mapView.region.span.latitudeDelta, forKey: "latDelta")
  defaults.set(mapView.region.span.longitudeDelta, forKey: "longDelta")

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        let defaults = UserDefaults.standard
        let locationData = ["lat":mapView.centerCoordinate.latitude
            , "long":mapView.centerCoordinate.longitude
            , "latDelta":mapView.region.span.latitudeDelta
            , "longDelta":mapView.region.span.longitudeDelta]
        defaults.set(locationData, forKey: "location")
        fetchedResultsController = nil
    }

  
    
   
    @IBAction func addPin(_ sender: UILongPressGestureRecognizer) {

    print ("pin has been touched")
        if sender.state != .began { return }
        let touchLocation = sender.location(in: mapView)
        
        let pin = Pin(context: context)
        pin.coord = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        try? context.save()// run correctly
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photoSeg" {
            let imageController = segue.destination as! imageColletionViewController
            imageController.pin = sender as? Pin
        }
    }
    
    // MARK: MKMapViewDelegate
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let pin = fetchedResultsController.fetchedObjects?.filter {
            $0.isEqual(to: view.annotation!.coordinate)
            }.first! // try to delete this
        performSegue(withIdentifier: "photoSeg", sender: pin)
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        updateMap()
    }
    func updateMap() {
        guard let pins = fetchedResultsController.fetchedObjects else { return } // try to delete
        
        for pin in pins {
            if mapView.annotations.contains(where: { pin.isEqual(to: $0.coordinate) }) { continue }
            let annotation = MKPointAnnotation()
            annotation.coordinate = pin.coord
            mapView.addAnnotation(annotation)
        }
    }
}
