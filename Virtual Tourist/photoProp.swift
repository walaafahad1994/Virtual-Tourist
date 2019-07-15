//
//  photoProp.swift
//  Virtual Tourist
//
//  Created by walaa fahad  on 7/1/19.
//  Copyright © 2019 Walaa Fahad. All rights reserved.
//

import Foundation
import UIKit
let imagesCache = NSCache<NSString, AnyObject>()

class photoProp:UIImageView{
    
    
    var imageURL: URL!
    
    func setPhoto(_ newPhoto: Photo) {
        if photo != nil {
            return
        }
        photo = newPhoto
    }
    
    private var photo: Photo! {
        didSet {
            if let image = photo.getImage() {
                self.image = image
                return
            }
            
            guard let url = photo.imageUrl else {
                return
            }
            
            loadImageUsingCache(with: url)
        }
    }
    
    func loadImageUsingCache(with url: URL) {
        imageURL = url
        image = nil
    
        
        if let cachedImage = imagesCache.object(forKey: url.absoluteString as NSString) as? UIImage {
            self.image = cachedImage
   
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let DownloadedImage = UIImage(data: data!) else { return }
            imagesCache.setObject(DownloadedImage, forKey:  url.absoluteString as NSString)
            DispatchQueue.main.async {
                self.image = DownloadedImage
                self.photo.setImage(image: DownloadedImage)
                ((try? self.photo.managedObjectContext?.save()) as ()??)
            }
            
            }.resume()
    }
    lazy var actvInd: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .whiteLarge)
        self.addSubview(activityIndicatorView)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        activityIndicatorView.hidesWhenStopped = true
        return activityIndicatorView
    }()
    
    func showActivityIndicatorView() {
        DispatchQueue.main.async {
            self.actvInd.startAnimating()
        }
    }
    
    func hideActivityIndicatorView() {
        DispatchQueue.main.async {
            self.actvInd.stopAnimating()
        }
    }
    
    
    
}
