//
//  Model.swift
//  NixTeem
//
//  Created by Вячеслав Вовк on 16.01.2024.
//


import Foundation


struct Menu: Decodable {
    
    
    let status: Bool
    let menuList: [MenuList]
    
    // MARK: - Categories
    struct MenuList: Decodable {
        let menuID: String
        let image: String
        let name: String
        let subMenuCount: Int
    }
    
}

struct SubMenu: Decodable {
    
    
    let status: Bool
    let menuList: [SubMenuList]
    
    // MARK: - Categories
    struct SubMenuList: Decodable {
        let id: String
        let image: String
        let name: String
        let content: String
        let price: String
        let weight: String?
        let spicy: String?
    }
    
}

//
//struct Preparats {
//    var preparats: [Preparat]
//}
//
//extension Preparats: SectionModelType {
//    typealias Item = Preparat
//
//    var items: [Preparat] { return preparats }
//
//    init(original: Preparats, items: [Preparat]) {
//        self = original
//        preparats = items
//    }
//}



