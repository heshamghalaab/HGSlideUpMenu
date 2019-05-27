//
//  HGSlideUpMenuVC.swift
//  HGSlideUpMenu
//
//  Created by hesham ghalaab on 5/24/19.
//  Copyright © 2019 hesham ghalaab. All rights reserved.
//

import UIKit

class HGSlideUpMenuVC: UIViewController {
    
    // MARK: Outlets
    @IBOutlet weak var tableView: HGSlideUpTableView!
    @IBOutlet weak var scrollBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var cancelBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var scrollView: UIScrollView!
    
    // MARK: Properties
    var lastContentOffset: CGFloat = 0
    var menu = [Menu](){
        didSet{ self.tableView.reloadData() }
    }
    
    // MARK: Override Functions
    // viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration()
        setupData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        lastContentOffset = scrollView.contentOffset.y
        animate()
    }
    
    // MARK: Methods
    // configuration: to configure any protocols
    private func configuration(){
        let nib = UINib(nibName: SlideUpMenuCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SlideUpMenuCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
        scrollView.delegate = self
    }
    
    private func setupData(){
        menu = Menu.initData()
    }
    
    func initAnimation(){
        self.view.backgroundColor = .clear
        scrollBottomConstraint.constant = -tableView.frame.height
        self.view.layoutIfNeeded()
    }
    
    func animate(){
        scrollBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.8)
            self.view.layoutIfNeeded()
        })
    }
    
    private func dismissMenu(){
        scrollBottomConstraint.constant = -scrollView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.4)
            self.view.layoutIfNeeded()
        }) { (finished) in
        }
        
        self.cancelBottomConstraint.constant = -50
        UIView.animate(withDuration: 0.3, delay: 0.25, options: [.curveEaseInOut], animations: {
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        }) { (finished) in
            if finished{
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func cancelTapped(_ sender: UIButton){
        dismissMenu()
    }
}



// MARK: UITableViewDelegate, UITableViewDataSource
extension HGSlideUpMenuVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SlideUpMenuCell.identifier, for: indexPath) as! SlideUpMenuCell
        cell.menuImageView.image = UIImage(named: menu[indexPath.row].imageName)
        cell.menuTitleLabel.text = menu[indexPath.row].title
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let state = scrollView.panGestureRecognizer.state
        
        if state == .changed{
            if lastContentOffset < scrollView.contentOffset.y{
                print("moving up: scrollViewContentOffset \(scrollView.contentOffset.y), bottomConstraint: \(scrollBottomConstraint.constant)")
                
                guard scrollBottomConstraint.constant < 0 else { return }
                let bottomConstant = scrollBottomConstraint.constant + abs(scrollView.contentOffset.y)
                scrollBottomConstraint.constant = (bottomConstant > 0) ? 0:bottomConstant
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.layoutIfNeeded()
                })
            }else if lastContentOffset >= scrollView.contentOffset.y{
                print("moving down: scrollViewContentOffset \(scrollView.contentOffset.y), bottomConstraint: \(scrollBottomConstraint.constant)")
                
                scrollBottomConstraint.constant = scrollBottomConstraint.constant - abs(scrollView.contentOffset.y)
                scrollView.contentOffset.y = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let yPosition = scrollView.panGestureRecognizer.translation(in: scrollView).y
        guard yPosition < (tableView.contentSize.height/2) else {
            dismissMenu()
            return
        }
        
        scrollBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
        
        if scrollView.contentOffset.y <= 0 {
            // if we wanna make any thing here
            // in case the animation is from down to up
            print("animate to normal")
        }else{
            // in case the animation is from up to down
            print("animate normally.")
        }
    }
}
