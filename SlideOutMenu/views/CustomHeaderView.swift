//
//  CustomHeaderView.swift
//  SlideOutMenu
//
//  Created by James Rochabrun on 10/15/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class CustomHeaderView: UIView {
    
    // MARK:- UI
    let nameLabel: UILabel = {
        let l = UILabel()
        l.text = "James Rochabrun"
        l.font = UIFont.systemFont(ofSize: 20, weight: .heavy)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let userNameLabel: UILabel = {
        let l = UILabel()
        l.text = "JRochabrun"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let statsLabel: UILabel = {
        let l = UILabel()
        l.text = "42 Following 135 Followers"
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let profileImageView: ProfileImageView = {
        let iV = ProfileImageView()
        iV.translatesAutoresizingMaskIntoConstraints = false
        iV.contentMode = .scaleAspectFit // aspect ratio
        iV.image = #imageLiteral(resourceName: "pz.jpg")
        iV.backgroundColor = .blue
        iV.clipsToBounds = true
        iV.layer.cornerRadius = 24
        return iV
    }()
    
    lazy var stackView: UIStackView = {
        let sV = UIStackView(arrangedSubviews: self.arrangedSubViews())
        sV.axis = .vertical
        sV.spacing = 8
        sV.isLayoutMarginsRelativeArrangement = true
        sV.layoutMargins = UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
        sV.translatesAutoresizingMaskIntoConstraints = false
        return sV
    }()
    
    // MARK:- Initialization
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setUpUI()
        setUpConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK:- UI Config
    private func arrangedSubViews() -> [UIView] {
        return [
            /// Profile image
            UIView(),
            UIStackView(arrangedSubviews: [profileImageView, UIView()]),
            nameLabel,
            userNameLabel,
            SpacerView(space: 16),
            statsLabel
        ]
    }
    
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
