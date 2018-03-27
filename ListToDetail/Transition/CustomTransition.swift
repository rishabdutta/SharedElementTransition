//
//  CustomTransition.swift
//  ListToDetail
//
//  Created by Rishab Dutta on 23/03/18.
//  Copyright © 2018 Rishab Dutta. All rights reserved.
//

import Foundation
import UIKit

class CustomTransition: NSObject {
    var frame: CGRect!
}

extension CustomTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPresentAnimation(frame: frame)
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomDismissAnimation(frame: frame)
    }
}





















