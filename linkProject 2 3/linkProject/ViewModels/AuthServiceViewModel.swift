//
//  AuthService.swift
//  linkProject
//
//  Created by Hibah Abdullah Alatawi on 19/02/1445 AH.
//

import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class AuthServiceViewModel: ObservableObject {
    @Published var currentUser: User?
    @Published var queryDataModel: [queryModel] = []
    @Published var saved = false
    @Published var savedFireStore = true
    let db = Firestore.firestore()
    @Published  var isLoggedIn = false
    @Environment(\.locale) var locale
    @Published  var baseURL = "https://www.ipqualityscore.com/api/json/url/s2SngC1JooF7OaKmABK2wwB9YI32Rk4D/"
    @Published  var urlString: String = ""
    
    
    func registerAnonymously() {
        Auth.auth().signInAnonymously { (authResult, error) in
            if let error = error {
                print("Error registering anonymously: \(error.localizedDescription)")
                
            } else {
                
                print("User is logged in anonymously with UID: \(authResult?.user.uid ?? "Unknown")")
                self.isLoggedIn = true
                
                self.saveURL("https://lxxxxab.sa", suspicious: true )
            }
        }
    }
    
    func saveURL(_ url: String, suspicious: Bool){
        let urlinfo : [String: Any] = [
            "url": url,
            "suspicious": suspicious
        ]
        db.collection("userUrls").addDocument(data: urlinfo){ error in
            if let error = error{
                print("error \(error)")
            }
            else{
                print("successfully")
            }
        }
    }

    func verifyURL(_ url: String, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: baseURL + (url.urlEncoded ?? "") ) else {
            
            return
        }
        
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let data = data {
                let decoder = JSONDecoder()
                
                do {
                    let apiResponse = try decoder.decode(APIResponse.self, from: data)
                    completion(.success((apiResponse.suspicious ?? false)))
                } catch {
                    print(error)
                    
                }
            }
            
            
            if let error = error {
                completion(.failure(error))
            }
        }.resume()
    }
    func openReportingURL() {
        
        let url = URL(string: "https://www.my.gov.sa/wps/portal/snp/servicesDirectory/servicedetails/6166/!ut/p/z1/jZBNb4MwDIZ_yw4ci50CGduNdlK1aIxWqC3LZYIqBCSaoDQbWn99o-2E-jXfbD2P_NrAoQCuyu9WlrbVquxc_8HpJ1vGIUmQZDEhFFfzp_jlnbAAFwjbMZAF0cwB6WOW5BuCGAH_j49XKsF7PrsHuAumJp2nEnhf2mbSqlpDQQmlbjcf29mChc4m62nENohhdAacn_cL3MjvAspOV3-_TFQVxC6JEbUwwvhfxo0ba_vDs4ceDsPgS61lJ_yd3nt4SWn0wUIxJiEXCvr9uji-1fnrhFc_wfBwAhue_0A!/dz/d5/L0lHSkovd0RNQURrQUVnQSEhLzROVkUvYXI!/")!
        
        if  UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    
    func isValidURL(URL: String) -> Bool {
        return URL.contains("www") || URL.contains("https")
        || URL.contains("http")
    }
    
    func getURLsFromDB(_ url: String) {
        db.collection("userUrls")
            .whereField("url", isEqualTo: url)
            .getDocuments() { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    
                    self?.getURLsFromDBFallback(url)
                } else {
                    guard let self = self else { return }
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        print("data", data)
                        let suspicious = data["suspicious"] as? Bool ?? false
                        let url = data["url"] as? String ?? ""
                        let urlData = queryModel(url: url, suspicious: suspicious)
                        self.queryDataModel.append(urlData)
                        self.savedFireStore = false
                        print("Gg\(urlData)")
                    }
                }
        }
    }

    func getURLsFromDBFallback(_ url: String) {
        // Second function logic goes here
        db.collection("otherCollection")
            .whereField("url", isEqualTo: url)
            .getDocuments() { [weak self] (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    // Handle the case where both functions fail
                } else {
                    guard let self = self else { return }
                    for document in querySnapshot!.documents {
                        print("\(document.documentID) => \(document.data())")
                        let data = document.data()
                        print("data", data)
                        let suspicious = data["suspicious"] as? Bool ?? false
                        let url = data["url"] as? String ?? ""
                        let urlData = queryModel(url: url, suspicious: suspicious)
                        self.queryDataModel.append(urlData)
                        self.savedFireStore = false
                        print("Gg\(urlData)")
                    }
                }
        }
    }
}



extension String {
    var urlEncoded: String? {
        let allowedCharacterSet = CharacterSet.alphanumerics.union(CharacterSet(charactersIn: "~-_."))
        return self.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet)
    }
}

