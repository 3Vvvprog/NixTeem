//
//  MenuItemCell.swift
//  NixTeem
//
//  Created by Вячеслав Вовк on 16.01.2024.
//

import UIKit
import SnapKit

class MenuItemCell: UICollectionViewCell {
    private var dbService = DBService()
    
    static var identifier = "MenuItemCell"
    
    var mainView = UIView()
    private var imageView = UIImageView()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 20)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var subMenuCountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Medium", size: 14)
        label.numberOfLines = 0
        label.textColor = .lightGray
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: Menu.MenuList) {
        dbService.downloadImage(from: data.image, imageView: self.imageView)
        nameLabel.text = data.name
        var product = " товаров"
        if data.subMenuCount >= 11 && data.subMenuCount <= 20 {
            product = " товаров"
        }else if data.subMenuCount % 10 >= 2 && data.subMenuCount % 10 <= 4 {
            product = " товара"
        }else if data.subMenuCount % 10 == 1 {
            product = " товар"
        }else {
            product = " товаров"
        }
        subMenuCountLabel.text = String(data.subMenuCount) + product
    }
    
    func configureBackground(background: UIColor) {
        self.mainView.backgroundColor = background
        
    }
}

private extension MenuItemCell {
    func initialize() {
        addSubview(mainView)
        mainView.backgroundColor = UIColor(red: 66/255.0, green: 67/255.0, blue: 68/255.0, alpha: 1.000)
        mainView.layer.cornerRadius = 8
        
        mainView.addSubview(imageView)
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        imageView.clipsToBounds = true
        
        mainView.addSubview(nameLabel)
        
        mainView.addSubview(subMenuCountLabel)
    }
    
    func makeConstraints() {
        mainView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
            make.height.equalTo(180)
            make.width.equalTo(150)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.bottom.equalTo(mainView.snp.centerY)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom).offset(10)
        }
        
        subMenuCountLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-10)
        }
    }
}
