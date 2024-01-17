//
//  ViewController.swift
//  NixTeem
//
//  Created by Вячеслав Вовк on 16.01.2024.
//

import UIKit
import SnapKit


class ViewController: UIViewController {
    private var dbService = DBService()
    private var menuList: [Menu.MenuList] = []
    private var subMenuList: [SubMenu.SubMenuList] = []
    private var selectedItem = 0
    
    
    
    private var logoView = UIImageView()
    private var logoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 35)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.text = "VKUSSOVET"
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var phoneImageView = UIImageView()
    
    lazy var menuListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 16
        
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .horizontal
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
    
        let collectionView = UICollectionView(frame:  .zero, collectionViewLayout: layout)
        collectionView.register(MenuItemCell.self, forCellWithReuseIdentifier: MenuItemCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 35)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var subMenuListCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 30
        layout.minimumLineSpacing = 30
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        
    
        let collectionView = UICollectionView(frame:  .zero, collectionViewLayout: layout)
        collectionView.register(SubMenuItemCell.self, forCellWithReuseIdentifier: SubMenuItemCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        
        return collectionView
    }()
    
    override func loadView() {
        super.loadView()
        dbService.getMenu { [ weak self ] result in
            switch result {
            case .success(let menu):
                print(menu)
//                self?.dbService.downloadImage(from: menu.menuList[0].image, imageView: self!.imageView)
                self?.menuList = menu.menuList
                self?.menuListCollectionView.reloadData()
                
                self?.dbService.getSubMenu(menuList: self!.menuList[0]) { result in
                    switch result {
                    case .success(let result):
                        self?.subMenuList = result.menuList
                        self?.nameLabel.text = self!.menuList[0].name
                        self?.subMenuListCollectionView.reloadData()
                        
                    case .failure(_):
                        break
                    }
                }
            case .failure(_):
                print("error")
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor(red: 36/255.0, green: 36/255.0, blue: 36/255.0, alpha: 1.000)
        initialize()
        makeConstraints()
    
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.tabBarController?.tabBar.tintColor = .blue
//    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        MainConstants.ScreenWidth = view.bounds.width
    }
    
    private enum Constants {
        static let selectedItemColor = UIColor(red: 70/255.0, green: 99/255.0, blue: 255/255.0, alpha: 1.000)
        static let notSelectedItemColor = UIColor(red: 66/255.0, green: 67/255.0, blue: 68/255.0, alpha: 1.000)
    }
    
    


}

private extension ViewController {
    func initialize() {
        
        view.addSubview(logoView)
        view.addSubview(logoLabel)
        
        logoView.clipsToBounds = true
        logoView.layer.cornerRadius = 30
        logoView.image = UIImage(named: "logo")
        
        view.addSubview(phoneImageView)
        phoneImageView.image = UIImage(systemName: "phone")
        phoneImageView.tintColor = .white
        
        view.addSubview(menuListCollectionView)
        menuListCollectionView.dataSource = self
        menuListCollectionView.delegate = self
        
        view.addSubview(nameLabel)
        
        view.addSubview(subMenuListCollectionView)
        subMenuListCollectionView.dataSource = self
        subMenuListCollectionView.delegate = self
    }
    
    func makeConstraints() {
        logoView.snp.makeConstraints { make in
            make.leading.top.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.height.width.equalTo(60)
        }
        
        logoLabel.snp.makeConstraints { make in
            make.centerY.equalTo(logoView.snp.centerY)
            make.leading.equalTo(logoView.snp.trailing).offset(10)
        }
        
        phoneImageView.snp.makeConstraints { make in
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(16)
            make.centerY.equalTo(logoView.snp.centerY)
            make.height.width.equalTo(30)
        }
        
        
        menuListCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(logoView.snp.bottom).offset(20)
            make.height.equalTo(180)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(menuListCollectionView.snp.bottom).offset(20)
        }
        
        subMenuListCollectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
        }
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == menuListCollectionView {
            return menuList.count
        }else {
            print(subMenuList.count)
            return subMenuList.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == menuListCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MenuItemCell.identifier, for: indexPath) as! MenuItemCell
            cell.configure(data: menuList[indexPath.item])
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SubMenuItemCell.identifier, for: indexPath) as! SubMenuItemCell
            cell.configure(data: subMenuList[indexPath.item])
            return cell
        }
    }
    
}

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if collectionView == menuListCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! MenuItemCell
            
            cell.configureBackground(background: Constants.selectedItemColor)
            let pastCell = collectionView.cellForItem(at: [0, selectedItem]) as? MenuItemCell
            
            pastCell?.configureBackground(background: Constants.notSelectedItemColor)
            selectedItem = indexPath[1]
            
            dbService.getSubMenu(menuList: menuList[indexPath.item]) { result in
                switch result {
                case .success(let result):
                    self.subMenuList = result.menuList
                    self.nameLabel.text = self.menuList[indexPath.item].name
                    self.subMenuListCollectionView.reloadData()
                    
                case .failure(_):
                    break
                }
            }
        }
            
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == menuListCollectionView {
            if let cell = collectionView.cellForItem(at: indexPath) as? MenuItemCell {
                cell.configureBackground(background: Constants.notSelectedItemColor)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == menuListCollectionView {
            let cell = cell as! MenuItemCell
            if indexPath[1] == selectedItem {
                cell.configureBackground(background: Constants.selectedItemColor)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if collectionView == menuListCollectionView {
            let cell = cell as! MenuItemCell
            cell.configureBackground(background: Constants.notSelectedItemColor)
        }
    }
}


