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
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    // MARK: Properties
    var menu = [Menu](){
        didSet{
            self.tableView.reloadData()
        }
    }
    var defaultOffSet: CGPoint?
    var defaultTableHeight = CGFloat()
    
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
        calculateTableInset()
        animate()
    }
    
    // MARK: Methods
    // configuration: to configure any protocols
    private func configuration(){
        let nib = UINib(nibName: SlideUpMenuCell.identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: SlideUpMenuCell.identifier)
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func setupData(){
        menu = Menu.initData()
    }
    
    func initAnimation(){
        self.view.backgroundColor = .clear
        bottomConstraint.constant = -tableView.frame.height
        self.view.layoutIfNeeded()
    }
    
    func animate(){
        bottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = .init(red: 0, green: 0, blue: 0, alpha: 0.8)
            self.view.layoutIfNeeded()
        })
    }
    
    func calculateTableInset(){
        let top = self.tableView.frame.height - tableView.contentSize.height
        tableView.contentInset = UIEdgeInsets(top: top, left: 0, bottom: 0, right: 0)
        defaultOffSet = tableView.contentOffset
        defaultTableHeight = tableView.frame.height
    }
    
    private func dismissMenu(){
        bottomConstraint.constant = -tableView.frame.height
        UIView.animate(withDuration: 0.3, animations: {
            self.view.backgroundColor = .clear
            self.view.layoutIfNeeded()
        }) { (finished) in
            if finished{
                self.dismiss(animated: false, completion: nil)
            }
        }
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
        handleHeight()
    }
    
    
    func handleHeight(){
        guard let startOffset = self.defaultOffSet else { return }
        let offset = tableView.contentOffset
        guard offset.y < startOffset.y else { return }
        
        // Scrolling down
        // check if your table view height is less than normal height, do your logic.
        let deltaY = abs((startOffset.y - offset.y))
        heightConstraint.constant = heightConstraint.constant - deltaY
        self.view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let yPosition = scrollView.panGestureRecognizer.translation(in: scrollView).y
        if yPosition > (tableView.contentSize.height/2){
            // dismiss view.
            dismissMenu()
        }else{
            // animate to the normal
            heightConstraint.constant = 0
            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
                self.tableView.reloadData()
            })
        }
    }
}
