//
//  DBService.swift
//  Binet
//
//  Created by Вячеслав Вовк on 12.01.2024.
//

import Foundation
import Alamofire
import UIKit




class DBService {
    
    private let url = "https://vkus-sovet.ru"
    
    func getMenu(complition: @escaping (Result<Menu, Error>) -> ()) {
        
        let menuUrl = url + "/api/getMenu.php"
    
        
        let concurent = DispatchQueue.global(qos: .background)
        
        concurent.async {
            AF.request(menuUrl)
                .validate()
                .response { response in
                    
                    guard let data = response.data else {
                        
                        if let error = response.error {
                            complition(.failure(error))
                        }
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    guard let plantPreparation = try? decoder.decode(Menu.self, from: data) else {
                        print("false")
                        return
                    }
                    complition(.success(plantPreparation))
                }
                
        }
        
    }
    
    func getSubMenu(menuList: Menu.MenuList, complition: @escaping (Result<SubMenu, Error>) -> ()) {
        
        let menuUrl = url + "/api/getSubMenu.php?menuID=" + menuList.menuID
        print(menuUrl)
        
        let concurent = DispatchQueue.global(qos: .background)
        
        concurent.async {
            AF.request(menuUrl)
                .validate()
                .response { response in
                    
                    guard let data = response.data else {
                        
                        if let error = response.error {
                            complition(.failure(error))
                        }
                        return
                    }
                    
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    
                    guard let plantPreparation = try? decoder.decode(SubMenu.self, from: data) else {
                        print("false")
                        return
                    }
                    complition(.success(plantPreparation))
                }
                
        }
        
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func downloadImage(from url: String, imageView: UIImageView) {
        print("Download Started")
        let imageUrl = URL(string: self.url + url.description)!
        getData(from: imageUrl) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? imageUrl.lastPathComponent)
            print("Download Finished")
            // always update the UI from the main thread
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
            
            
        }
    }
}
