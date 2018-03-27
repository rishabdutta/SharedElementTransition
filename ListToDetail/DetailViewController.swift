//
//  DetailViewController.swift
//  ListToDetail
//
//  Created by Rishab Dutta on 13/03/18.
//  Copyright © 2018 Rishab Dutta. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
        
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(animated)
//        transitionCompletion()
//    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: true, completion: nil)
    }
}
