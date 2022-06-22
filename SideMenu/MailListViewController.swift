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
            self.containerView.isHidden = self.isSlideInMenuPresented ? true : false
            
        } completion: { (finished) in
            print("Animation finished: \(finished)")
            self.isSlideInMenuPresented.toggle()
        }
        
    }
    
    @objc
    func slipOut(gestureRecognizer: UIPanGestureRecognizer) {
        let t = gestureRecognizer.translation(in: self.menuView)
        guard (t.x < 0 || self.menuView.frame.origin.x > 0 ) else { return }
        switch gestureRecognizer.state {
        case .changed,.began:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                self.menuView.transform = CGAffineTransform(translationX: t.x, y: 0)
            })
        case .ended:
            if -t.x < self.menuView.frame.width/2 {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
                    self.menuView.transform = .identity
                })
            } else {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: .curveEaseInOut) { [self] in
                    self.menuView.frame.origin.x = self.isSlideInMenuPresented ? -(view.frame.width - slideInMenuPadding) : 0
                    self.containerView.isHidden = self.isSlideInMenuPresented ? true : false
                    
                } completion: { (finished) in
                    print("Animation finished: \(finished)")
                    self.isSlideInMenuPresented.toggle()
                }
            }
        default:
            guard (t.x < 0 || self.menuView.frame.origin.x > 0 ) else { return }
        }
    }
    
    lazy var menuView: UIView = {
        let view = UIView()
        var viewTranslation = CGPoint(x: 0, y: 0)
        view.backgroundColor = .green
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(self.slipOut))
        view.addGestureRecognizer(gesture)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.2)
        view.isOpaque = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.menuBarButtomItemTapped))
        view.addGestureRecognizer(tap)
        view.isUserInteractionEnabled = true
        return view
    }()
    
    lazy var tableView: UITableView = {
        let view = UITableView()
        view.frame = self.view.frame
        view.backgroundColor = .yellow
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = .yellow
        title = "Side menu"
        navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        view.addSubview(tableView)
        containerView.edgeTo(view)
        containerView.isHidden = true
        menuView.pinMenuTo(view, with: (view.frame.width - slideInMenuPadding))
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
        widthAnchor.constraint(equalToConstant: constant).isActive = true
        trailingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}

