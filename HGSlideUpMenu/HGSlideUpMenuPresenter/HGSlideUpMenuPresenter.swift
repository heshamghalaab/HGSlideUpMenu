//
//  HGSlideUpMenuPresenter.swift
//  HGSlideUpMenu
//
//  Created by hesham ghalaab on 5/27/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//


import UIKit

class HGSlideUpMenuPresenter{
    
    // Here we define a set of supported destinations using an
    // enum, and we can also use associated values to add support
    // for passing arguments from one screen to another.
    enum Destination {
        case HGSlideUpMenu(withMenu: [Menu])
    }
    
    // In most cases it's totally safe to make this a strong
    // reference, but in some situations it could end up
    // causing a retain cycle, so better be safe than sorry :)
    private weak var viewController: UIViewController?
    
    // MARK: - Initializer
    init(vc: UIViewController?) {
        guard let vc = vc else { return }
        self.viewController = vc
    }
    
    // MARK: - Navigator
    func present(_ destination: Destination) {
        presentViewController(for: destination)
    }
    
    // MARK: - Private
    private func presentViewController(for destination: Destination) {
        switch destination {
        case .HGSlideUpMenu(let menu):
            presentDefaultPopUpVC(menu: menu)
        }
    }
    
    private func presentDefaultPopUpVC(menu: [Menu]){
        let slideUpMenuVC = HGSlideUpMenuVC(nibName: "HGSlideUpMenuVC", bundle: nil)
        slideUpMenuVC.menu = menu
        slideUpMenuVC.slideUpMenuProtocol = viewController as? HGSlideUpMenuProtocol
        slideUpMenuVC.modalPresentationStyle = .overFullScreen
        DispatchQueue.main.async {
            self.viewController?.present(slideUpMenuVC, animated: false, completion: nil)
        }
    }
}


