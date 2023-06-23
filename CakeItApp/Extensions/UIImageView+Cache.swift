//
//  UIImageView+Cache.swift
//  CakeItApp
//
//  Created by Karekar, Mangesh on 23/06/2023.
//

import UIKit

class ImageStore: NSObject {
    static let imageCache = NSCache<NSString, UIImage>()
    
}

extension UIImageView {
    func setImage(for urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        let urlToString = url.absoluteString as NSString
        if let cachedImage = ImageStore.imageCache.object(forKey: urlToString) {
            self.image = cachedImage
            
        } else {
            
            DispatchQueue.global(qos: .background).async { [weak self] in
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        ImageStore.imageCache.setObject(image, forKey: urlToString)
                        self?.image = image
                    }
                } else {
                    DispatchQueue.main.async {
                        self?.image = nil
                    }
                }
            }
        }
    }
    
}
