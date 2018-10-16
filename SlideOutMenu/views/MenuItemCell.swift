//
//  MenuItemCell.swift
//  SlideOutMenu
//
//  Created by James Rochabrun on 10/15/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class IconImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 44, height: 44)
    }
}


class MenuItemCell: UITableViewCell {
    
    // MARK:- UI
    let menuTitleLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.systemFont(ofSize: 20, weight: .regular)
        l.text = "Profile"
        return l
    }()
    
    let iconImageView: IconImageView = {
        let iV = IconImageView()
        iV.image = #imageLiteral(resourceName: "pz.jpg")
        iV.contentMode = .scaleAspectFit
        return iV
    }()
    
    lazy var stackView: UIStackView = {
        let sV = UIStackView(arrangedSubviews: [iconImageView, menuTitleLabel, UIView()])
        sV.spacing = 8
        sV.isLayoutMarginsRelativeArrangement = true
        sV.layoutMargins = UIEdgeInsets(top: 30, left: 12, bottom: 30, right: 12)
        sV.translatesAutoresizingMaskIntoConstraints = false
        return sV
    }()
    
    // MARK:- Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .orange
        setUpUI()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK:- UI Config
    private func setUpUI() {
        addSubview(stackView)
    }
    
    private func setUpConstraints() {
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
    }
}
