//
//  HomeController.swift
//  SlideOutMenu
//
//  Created by James Rochabrun on 10/14/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import UIKit

class HomeController: UITableViewController {

    // MARK:- UI
    let menuController = MenuController()
    let darkCoverView: UIView = {
        let frame: CGRect = UIApplication.shared.keyWindow?.frame ?? .zero
        let v = UIView(frame: frame)
        v.alpha = 0
        v.isUserInteractionEnabled = false
        v.backgroundColor = UIColor.init(white: 0, alpha: 0.8)
        return v
    }()
    
    // MARK:- Private properties
    private let menuWidth: CGFloat = 300.0
    private var isMenuOpened = false
    private let velocityOpenThreshold: CGFloat = 500.0

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        setUpMenuController()
        setUpGestures()
        setUpDarkCoverView()
    }
    
    // MARK:- Set up
    private func setUpNavBar() {
        
        navigationItem.title = "Home"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Open", style: .done, target: self, action: #selector(handleOpen))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Hide", style: .done, target: self, action: #selector(handleHide))
    }
    
    private func setUpMenuController() {
        
        menuController.view.frame = CGRect(x: -menuWidth, y: 0, width: menuWidth, height: self.view.frame.height)
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(menuController.view)
        addChild(menuController)
    }
    
    private func setUpGestures() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        self.view.addGestureRecognizer(panGesture)
    }
    
    private func setUpDarkCoverView() {
        guard let window = UIApplication.shared.keyWindow else { return }
        window.addSubview(darkCoverView)
    }
    
    // MARK:- Animation
    private func performAnimation(transform: CGAffineTransform) {
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.setViewsTransform(transform)
        })
    }
    
    // MARK:- Handlers
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed: self.handlePanChanged(gesture)
        case .ended: self.handlePanEnded(gesture)
        default:
            break
        }
    }
    
    private func handlePanChanged(_ gesture: UIPanGestureRecognizer ) {
        
        let translation = gesture.translation(in: view)
        var x = translation.x
        if isMenuOpened {
            x += menuWidth
        }
        x = min(menuWidth, x) // left
        x = max(0, x) // right
        
        let transform = CGAffineTransform(translationX: x, y: 0)
        self.setViewsTransform(transform)
        /// divide the  translation x by the width of the presented view
        let alpha =  x / menuWidth
        
        print("alpha = \(alpha) x = \(x)")
        darkCoverView.alpha = alpha
    }
    
    private func setViewsTransform(_ transform: CGAffineTransform) {
        
        menuController.view.transform = transform
        navigationController?.view.transform = transform
        darkCoverView.transform = transform
        darkCoverView.alpha = transform.isIdentity ? 0 : 1
    }
    
    private func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if isMenuOpened {
            if abs(velocity.x) > velocityOpenThreshold {
                handleHide()
                return
            }
            abs(translation.x) < menuWidth / 2 ? handleOpen() : handleHide()
        } else {
            if velocity.x > velocityOpenThreshold {
                handleOpen()
                return
            }
            translation.x < menuWidth / 2 ? handleHide() : handleOpen()
        }
    }
    
    @objc func handleOpen() {
        isMenuOpened = true
        self.performAnimation(transform: CGAffineTransform(translationX: self.menuWidth, y: 0))
    }
    
    @objc func handleHide() {
        isMenuOpened = false
        self.performAnimation(transform: .identity)
    }
}

// MARK:- DataSource
extension HomeController {
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
}
