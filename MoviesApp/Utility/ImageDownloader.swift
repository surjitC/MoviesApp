//
//  ImageDownloader.swift
//  MoviesApp
//
//  Created by Surjit on 13/03/21.
//

import UIKit

class ImageDownloader {
    
    var imageCache = NSCache<AnyObject, UIImage>()
    var urlResquest: URLSession?
    
    func loadImage(from urlString: String?, completionHandler: @escaping (UIImage) -> Void)  {
        guard let urlString = urlString, let url = URL(string: urlString) else {
            completionHandler(#imageLiteral(resourceName: "imagePlaceholder"))
            return
        }
        return self.loadImage(from: url, completionHandler: completionHandler)
    }
    
    func loadImage(from imageURL: URL, completionHandler: @escaping (UIImage) -> Void) {
        if let cahedImage = self.imageCache.object(forKey: imageURL as AnyObject) {
            DispatchQueue.main.async {
                completionHandler(cahedImage)
            }
            return
        }
        DispatchQueue.main.async {
            completionHandler(#imageLiteral(resourceName: "imagePlaceholder"))
        }
        DispatchQueue.global().async { [weak self] in
            self?.urlResquest = URLSession.shared
            self?.urlResquest?.dataTask(with: imageURL, completionHandler: { (data, response, error) in
                if let data = try? Data(contentsOf: imageURL), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.imageCache.setObject(image, forKey: imageURL as AnyObject)
                        completionHandler(image)
                    }
                }
            }).resume()
            
        }
    }
}
