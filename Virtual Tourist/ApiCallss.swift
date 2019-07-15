//
//  ApiCallss.swift
//  Virtual Tourist
//
//  Created by walaa fahad  on 6/28/19.
//  Copyright © 2019 Walaa Fahad. All rights reserved.
//
import MapKit
import UIKit
import Foundation
class ApiCallss
{
    static func getImagesURL(location:CLLocationCoordinate2D ,pageNum:Int, completion : @escaping ([URL]?,Error?,String?)->())
    {
     //   \( pageNumber)
        let stringTourl = URL(string: "https://api.flickr.com/services/rest?api_key=60a9687053fb2e5bd33899bc4fffb9dc&extras=url_m&page=\(pageNum)&method=flickr.photos.search&lat=\(location.latitude)&lon=\(location.longitude)&accuracy=11&safe_search=1&format=json&per_page=6&nojsoncallback=1")!
       
    // add page pramters into URL
        
        
        let request = URLRequest(url: stringTourl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            guard (error == nil) else {
                completion(nil, error, nil)
                return
            }
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode >= 200 && statusCode <= 299 else {
                completion(nil, nil,"Check Your Internet Connection")
             //  showNotifcation("Error","Check Your Internet Connection")
                return
            }
            
            guard let data = data else {
                completion(nil, nil, "No data founded")
                return
            }
            
                      print(String(data: data, encoding: .utf8)!)
            
            guard let result = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {
                completion(nil, nil, "error parising")
                return
            }
            
     
            
            guard let photosDictionary = result["photos"] as? [String:Any] else {
                completion(nil, nil, "Cannot find key 'photos' in \(result)")
                return
            }
            
            guard let photosArray = photosDictionary["photo"] as? [[String:Any]] else {
                completion(nil, nil, "Cannot find key 'photo' in \(photosDictionary)")
                return
            }
            
      
            
                        var photosURLs = [URL]()
                        for photoDictionary in photosArray {
                            guard let urlString = photoDictionary["url_m"] as? String else {
                                continue
                            }
                            let url = URL(string: urlString)
                            photosURLs.append(url!)
                        }
            
            completion(photosURLs, nil, nil)
        }
        
        task.resume()
    }
    

    
    
     
}

    

    


