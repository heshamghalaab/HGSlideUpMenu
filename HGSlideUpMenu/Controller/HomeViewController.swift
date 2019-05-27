//
//  HomeViewController.swift
//  HGSlideUpMenu
//
//  Created by hesham ghalaab on 5/24/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: Override Functions
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: Actions
    @IBAction func onTapMore(_ sender: UIBarButtonItem) {
        let presenter = HGSlideUpMenuPresenter(vc: self)
        presenter.present(.HGSlideUpMenu(withMenu: Menu.initData()))
    }
}

extension HomeViewController: HGSlideUpMenuProtocol{
    func didSelectHGSlideUpMenuRow(with row: Int) {
        print("selected row is: \(row)")
    }
}
