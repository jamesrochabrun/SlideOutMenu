//
//  BaseSlidingController.swift
//  SlideOutMenu
//
//  Created by James Rochabrun on 10/14/18.
//  Copyright © 2018 James Rochabrun. All rights reserved.
//

import Foundation
import UIKit

class RightContainerView: UIView {}
class MenuContainerView: UIView {}
class DarkContainerView: UIView {}


class BaseSlidingController: UIViewController {
    
    let redView: RightContainerView = {
        let v = RightContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        return v
    }()
    
    let blueView: MenuContainerView = {
        let v = MenuContainerView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .blue
        return v
    }()
    
    let darkCoverView: DarkContainerView = {
        let v = DarkContainerView()
        v.backgroundColor = UIColor(white: 0, alpha: 0.7)
        v.alpha = 0
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    var rightController: UIViewController = UINavigationController(rootViewController: HomeController())

    
    var redViewLeadingConstraint: NSLayoutConstraint!
    private let menuWidth: CGFloat = 300
    private let velocityThreshold: CGFloat = 500
    private var isMenuOpened = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .orange
        setUpGestures()
        setUpViews()
        setUpViewControllers()
    }
    
    private func setUpGestures() {
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        view.addGestureRecognizer(panGesture)
    }
    
    private func setUpViews() {
        
        view.addSubview(redView)
        view.addSubview(blueView)
        
        NSLayoutConstraint.activate([
            redView.topAnchor.constraint(equalTo: view.topAnchor),
            redView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            redView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            blueView.topAnchor.constraint(equalTo: view.topAnchor),
            blueView.trailingAnchor.constraint(equalTo: redView.safeAreaLayoutGuide.leadingAnchor),
            blueView.widthAnchor.constraint(equalToConstant: menuWidth),
            blueView.bottomAnchor.constraint(equalTo: redView.bottomAnchor)
            ])
        
        self.redViewLeadingConstraint = redView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0)
        redViewLeadingConstraint.isActive = true
        
        setUpViewControllers()
    }
    
    private func setUpViewControllers() {
        
        let menuController = MenuController()
        
        let homeView = rightController.view!
        let menuView = menuController.view!
        
        homeView.translatesAutoresizingMaskIntoConstraints = false
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        redView.addSubview(homeView)
        redView.addSubview(darkCoverView)
        blueView.addSubview(menuView)
        
        NSLayoutConstraint.activate([
            // top, leading, bottom, trailing anchors
            homeView.topAnchor.constraint(equalTo: redView.topAnchor),
            homeView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            homeView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            homeView.trailingAnchor.constraint(equalTo: redView.trailingAnchor),
            
            menuView.topAnchor.constraint(equalTo: blueView.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: blueView.leadingAnchor),
            menuView.bottomAnchor.constraint(equalTo: blueView.bottomAnchor),
            menuView.trailingAnchor.constraint(equalTo: blueView.trailingAnchor),
            
            darkCoverView.topAnchor.constraint(equalTo: redView.topAnchor),
            darkCoverView.leadingAnchor.constraint(equalTo: redView.leadingAnchor),
            darkCoverView.bottomAnchor.constraint(equalTo: redView.bottomAnchor),
            darkCoverView.trailingAnchor.constraint(equalTo: redView.trailingAnchor),
            ])
        
        addChild(rightController)
        addChild(menuController)
    }
    
    @objc func handlePan(_ gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translation(in: view)
        var x = translation.x
        
        x = isMenuOpened ? x + menuWidth : x
        x = min(menuWidth, x)
        x = max(0, x)
        
        redViewLeadingConstraint.constant = x
        darkCoverView.alpha = x / menuWidth
        
        if gesture.state == .ended {
            handlePanEnded(gesture)
        }
    }
    
    private func handlePanEnded(_ gesture: UIPanGestureRecognizer) {
       
        let translation = gesture.translation(in: view)
        let velocity = gesture.velocity(in: view)
        
        if isMenuOpened {
            if abs(velocity.x) > velocityThreshold {
                closeMenu()
                return
            }
            if abs(translation.x) < menuWidth / 2 {
                openMenu()
            } else {
                closeMenu()
            }
        } else {
            if abs(velocity.x) > velocityThreshold {
                openMenu()
                return
            }
            
            if translation.x < menuWidth / 2 {
                closeMenu()
            } else {
                openMenu()
            }
        }
    }
    
    func openMenu() {
        
        isMenuOpened = true
        redViewLeadingConstraint.constant = menuWidth
        performAnimations()
    }
    
    func closeMenu() {
        
        redViewLeadingConstraint.constant = 0
        isMenuOpened = false
        performAnimations()
    }
    
    func didSelectItem(at indexPath: IndexPath) {
        
        performRightViewCleanUp()
        closeMenu()

        switch indexPath.row {
        case 0:
            /// home controller is the first onw we see on app launching
            let vc  = UINavigationController(rootViewController: HomeController())
            redView.addSubview(vc.view)
            addChild(vc)
            rightController = vc
        case 1:
            let firstController = UINavigationController(rootViewController: ListController())
            redView.addSubview(firstController.view)
            addChild(firstController)
            rightController = firstController
        case 2:
            let secondController = BookMarkTableViewController()
            redView.addSubview(secondController.view)
            // dont forget to add it as a child
            addChild(secondController)
            rightController = secondController
        default: break
        }
        
        redView.bringSubviewToFront(darkCoverView)
    }
    
    private func performRightViewCleanUp() {
        
        rightController.view.removeFromSuperview()
        rightController.removeFromParent()
    }
    
    fileprivate func performAnimations() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.darkCoverView.alpha = self.isMenuOpened ? 1 : 0
        })
    }
}
