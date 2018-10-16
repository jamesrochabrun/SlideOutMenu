//
//  SpacerView.swift
//  SlideOutMenu
//
//  Created by James Rochabrun on 10/15/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class SpacerView: UIView {
    
    let space: CGFloat
    
    override var intrinsicContentSize: CGSize {
        return .init(width: space, height: space)
    }
    
    init(space: CGFloat) {
        self.space = space
        super.init(frame: .zero)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.space = 0
        super.init(coder: aDecoder)
    }
}
