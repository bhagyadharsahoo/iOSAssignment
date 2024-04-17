//
//  ImageLoader.swift
//  iOSAssignment
//
//  Created by Bhagyadhar Sahoo on 17/04/24.
//

import UIKit

final class LazyImageLoader {
    
    static let shared = LazyImageLoader()
    
    private init() {}
    
    private let cache = NSCache<NSString, UIImage>()
    
    func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        
        
        
        if let image = cache.object(forKey: url.absoluteString as NSString) {
            completion(image)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                completion(nil)
                return
            }
            
            self.cache.setObject(image, forKey: url.absoluteString as NSString)
            completion(image)
        }.resume()
    }
}
