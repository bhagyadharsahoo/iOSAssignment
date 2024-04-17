//
//  ImageGridViewModel.swift
//  iOSAssignment
//
//  Created by Bhagyadhar Sahoo on 14/04/24.
//

import Foundation
import Combine


final class ImageGridViewModel {
    
    @Published var images: [ImageData] = []
    
    private var networkManager: NetworkManager
    
    init(_ networkManager: NetworkManager = NetworkManager.shared) {
        self.networkManager = networkManager
    }
}

extension ImageGridViewModel {
    
    func viewDidLoad() {
        
        networkManager.fetchImageData { [weak self] result in guard let self else { return }
            switch result {
            case .success(let imageData):
                images = imageData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
}
