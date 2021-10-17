//
//  PexelNetworkCalls.swift
//  PexelPhoto
//
//  Created by Jeremy Lee on 10/17/21.
//

import Foundation
import UIKit

class PexelNetworkCalls {
    
    func pexelSearch(title: String) {
        NSLog("Calling Pexels API...")
        PexelSearchViewController.pexelImages.removeAll()
        PexelSearchViewController.pexelList.removeAll()
        let search = "query=\(title)"
        let urlItem = URL(string: "https://api.pexels.com/v1/search?per_page=30&\(search)")!
        let semaphore = DispatchSemaphore (value: 0)
        var request = URLRequest(url: urlItem, timeoutInterval: 30)
        request.addValue("\(keysForApi.apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            NSLog("Pexels returned Values")
            guard let data = data else {
                print(String(describing: error))
                semaphore.signal()
                return
            }
            do {
                let responseJSON = try JSONDecoder().decode(PexelPhotos.self, from: data)
                self.decodePexelAPIValues(imageList: responseJSON)
                semaphore.signal()
            } catch let error as NSError {
                NSLog("Error parsing JSON: \(error)")
                semaphore.signal()
            }
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    private func decodePexelAPIValues(imageList: PexelPhotos) {
        NSLog("Sorting Pexel Images")
        let photos = imageList.photos!
        for p in photos {
            PexelSearchViewController.pexelList.append(p)
        }
        createImageArray()
    }
    
    private func createImageArray() {
        let imagesRetrieved = PexelSearchViewController.pexelList
        for i in imagesRetrieved {
            let image = i.src?.medium
            let imagePortrait = i.src?.portrait
            let imageLandscape = i.src?.landscape
            let title = i.photographer
            let imageUrl = URL(string: image!)
            let data = (try? Data(contentsOf: imageUrl!))!
            let imageFound = UIImage(data: data)
            let item = PexelImages(image: imageFound, portrait: imagePortrait, landscape: imageLandscape, owner: title)
            PexelSearchViewController.pexelImages.append(item)
        }
        NotificationCenter.default.post(name: .picturesLoaded, object: self)
    }
    
}
