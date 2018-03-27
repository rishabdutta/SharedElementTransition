//
//  ViewController.swift
//  ListToDetail
//
//  Created by Rishab Dutta on 13/03/18.
//  Copyright © 2018 Rishab Dutta. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let TableViewCellId = "CustomTableViewCell"
    private let AnimationId = "animation"
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            let nib = UINib(nibName: TableViewCellId, bundle: nil)
            tableView.register(nib, forCellReuseIdentifier: TableViewCellId)
        }
    }
    
    private let transition = CustomTransition()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func cellFrame(for indexPath: IndexPath) -> CGRect {
        let cell = tableView.cellForRow(at: indexPath)
        return tableView.convert((cell?.frame)!, to: view)
    }

}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCellId, for: indexPath) as! CustomTableViewCell
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        transition.frame = cellFrame(for: indexPath)
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
        vc.transitioningDelegate = transition
        vc.modalPresentationStyle = .custom
        present(vc, animated: true, completion: nil)

    }
    
}


















