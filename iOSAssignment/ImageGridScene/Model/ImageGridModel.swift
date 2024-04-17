//
//  ImageGridModel.swift
//  iOSAssignment
//
//  Created by Bhagyadhar Sahoo on 14/04/24.
//

import Foundation

struct ImageGridModel {
    struct Image: Codable, Hashable {
        var id, title: String?
        var language: Language?
        var thumbnail: Thumbnail?
        var mediaType: Int?
        var coverageURL: String?
        var publishedAt, publishedBy: String?
        var backupDetails: BackupDetails?
    }
    
    // MARK: - BackupDetails
    struct BackupDetails: Codable, Hashable {
        var pdfLink: String?
        var screenshotURL: String?
    }
    
    enum Language: String, Codable {
        case english = "english"
        case hindi = "hindi"
    }
    
    // MARK: - Thumbnail
    struct Thumbnail: Codable, Hashable {
        var id: String?
        var version: Int?
        var domain: String?
        var basePath: String?
        var key: String?
        var qualities: [Int]?
        var aspectRatio: Double?
    }
}
