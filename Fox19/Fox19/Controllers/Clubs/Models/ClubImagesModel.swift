//
//  ClubImagesModel.swift
//  Fox19
//
//  Created by Mykhailo Romanovskyi on 03.11.2020.
//
struct ClubImagesModel:Codable {
    
    let results: [DataForImage]?
    
    struct DataForImage:Codable {
        let image: String?
    }
}

