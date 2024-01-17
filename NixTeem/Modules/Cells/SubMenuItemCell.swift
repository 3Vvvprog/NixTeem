//
//  SubMenuItemCell.swift
//  NixTeem
//
//  Created by Вячеслав Вовк on 16.01.2024.
//

import UIKit
import SnapKit

class SubMenuItemCell: UICollectionViewCell {
    private var dbService = DBService()
    
    static var identifier = "SubMenuItemCell"
    
    var cellView = UIView()
    var mainView = UIView()
    private var imageView = UIImageView()
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 18)
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .center
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private var priceWeightLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFProDisplay-Semibold", size: 13)
       
        label.textColor = .lightGray
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private var addItemToBusket: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 70/255.0, green: 99/255.0, blue: 255/255.0, alpha: 1.000)
        button.setTitle("В корзину", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont(name: "SFProDisplay-Semibold", size: 18)
        button.layer.cornerRadius = 8
        return button
    }()

    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
        makeConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(data: SubMenu.SubMenuList) {
        nameLabel.text = data.name
        dbService.downloadImage(from: data.image, imageView: self.imageView)
        
        
        let boldText = data.price.components(separatedBy: ".")[0] + " ₽"
        let boldAttrs = [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Semibold", size: 18)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:boldAttrs as [NSAttributedString.Key : Any])
        var normalText = "/ 100"
        if let text = data.weight {
            normalText = " / \(text)"
        }else {
            normalText = ""
        }
        var normalAttrs = [NSAttributedString.Key.font : UIFont(name: "SFProDisplay-Medium", size: 14), NSAttributedString.Key.foregroundColor : UIColor.lightGray]
        
        let normalString = NSMutableAttributedString(string:normalText, attributes:normalAttrs as [NSAttributedString.Key : Any])
        attributedString.append(normalString)
        
        priceWeightLabel.attributedText = attributedString
        
        contentLabel.text = data.content
    }
    
}

private extension SubMenuItemCell {
    func initialize() {
        addSubview(cellView)
        cellView.addSubview(mainView)
        mainView.layer.cornerRadius = 8
        mainView.backgroundColor = .black
        
        mainView.addSubview(nameLabel)
        mainView.addSubview(imageView)
        
        imageView.layer.cornerRadius = 8
        imageView.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        imageView.clipsToBounds = true
        
        mainView.addSubview(priceWeightLabel)
        
        mainView.addSubview(contentLabel)
        cellView.addSubview(addItemToBusket)
        
        addItemToBusket.addTarget(self, action: #selector(didTap), for: .touchUpInside)
    }
    
    func makeConstraints() {
        cellView.snp.makeConstraints { make in
            make.directionalEdges.equalToSuperview()
            make.width.equalTo((MainConstants.ScreenWidth - 64) / 2)
            make.height.equalTo(250)
        }
        
        mainView.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
            make.height.equalTo(220)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalToSuperview().offset(10)
        }
        
        imageView.snp.makeConstraints { make in
            make.leading.bottom.trailing.equalToSuperview()
            make.top.equalTo(mainView.snp.centerY)
        }
        
        priceWeightLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.bottom.equalTo(imageView.snp.top).inset(-10)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.bottom.lessThanOrEqualTo(priceWeightLabel.snp.top).inset(-8)
        }
        
        addItemToBusket.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(20)
            make.centerY.equalTo(mainView.snp.bottom)
            make.height.equalTo(50)
            
        }
    }
    
    @objc func didTap() {
        print("tap")
    }
}
