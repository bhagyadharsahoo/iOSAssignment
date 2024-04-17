//
//  NetworkManager.swift
//  iOSAssignment
//
//  Created by Bhagyadhar Sahoo on 14/04/24.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case invalidData
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchImageData(completion: @escaping (Result<[ImageData], Error>) -> Void) {
        let context = CoreDataManager.shared.context
        guard let url = URL(string: "https://acharyaprashant.org/api/v2/content/misc/media-coverages?limit=200") else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else { return }
            var imageD: [ImageData] = []
            context.perform {
                do {
                    var imageData = try JSONDecoder().decode([ImageGridModel.Image].self, from: data)
                    imageData.forEach { data in
                        let thumbnail = data.thumbnail
                        guard let domain = thumbnail?.domain, let base = thumbnail?.basePath,
                              let key = thumbnail?.key else { return }
                        let imageUrl = domain + "/" + base + "/0/" + key
                        imageD.append(ImageData(context: context, data: (thumbnail?.id, imageUrl)))
                    }
                    try context.save()
                    completion(.success(imageD))
                    
                } catch {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
