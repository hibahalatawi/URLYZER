//
//  Models.swift
//  linkProject
//
//  Created by Hibah Abdullah Alatawi on 21/02/1445 AH.
//

import Foundation

struct OnBordingStep {
    let image: String
    let title: String
    let description: String
}


struct APIResponse: Codable {
    let url: Bool?
    let suspicious:Bool?
    let saved:Bool?
}


struct queryModel : Identifiable {
    var id = UUID()
    var url:String
    var suspicious:Bool
}

enum APIErrors: String {
    case connectionError
    case canNotDecodeData
}

struct ImageModel: Identifiable{
    var id = UUID()
    var Image : String
}

