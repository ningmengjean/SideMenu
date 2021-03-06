//
//  ViewController.swift
//  SideMenu
//
//  Created by 朱晓瑾 on 2022/6/21.
//

import UIKit
import Foundation

class MailListViewController: UIViewController {

    var isSlideInMenuPresented = false

    var slideInMenuPadding: CGFloat {
        if UIDevice.current.userInterfaceIdiom == .pad {
            return self.view.frame.width * 0.60
        }
        return self.view.frame.width * 0.20
    }
    
    lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuBarButtomItemTapped))

    @objc
    func menuBarButtomItemTapped() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) { [self] in
            self.menuView.frame.origin.x = self.isSlideInMenuPresented ? -(view.frame.width - slideInMenuPadding) : 0
            self.maskView.isHidden = self.isSlideInMenuPresented ? true : false
            
        } completion: { (finished) in
            print("Animation finished: \(finished)")
            self.isSlideInMenuPresented.toggle()
        }
        
    }
    
    @objc
    func swipeLeft() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) { [self] in
            self.menuView.frame.origin.x = self.isSlideInMenuPresented ? -(view.frame.width - slideInMenuPadding) : 0
            self.maskView.isHidden = self.isSlideInMenuPresented ? true : false
            
        } completion: { (finished) in
            print("Animation finished: \(finished)")
            self.isSlideInMenuPresented.toggle()
        }
    }
    
    lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .green
        if UIDevice.current.userInterfaceIdiom == .phone {
            let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeLeft))
            swipeLeft.direction = .left
            self.view.addGestureRecognizer(swipeLeft)
            view.isUserInteractionEnabled = true
        }
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    lazy var maskView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.isOpaque = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.menuBarButtomItemTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        title = "Side menu"
        if UIDevice.current.userInterfaceIdiom == .phone {
            navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
            containerView.edgeTo(view)
            maskView.edgeTo(view)
            maskView.isHidden = true
            menuView.pinMenuTo(view, with: (view.frame.width - slideInMenuPadding))
        } else {
            containerView.ipadContainerEdgeTo(view, with: slideInMenuPadding)
            menuView.ipadPinMenuTo(view, with: (view.frame.width - slideInMenuPadding))
        }
    }
}

extension UIView {
    
    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: -constant).isActive = true
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func ipadContainerEdgeTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func ipadPinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

