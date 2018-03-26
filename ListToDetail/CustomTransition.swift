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

extension CustomTransition: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        switch operation {
        case .none:
            return nil
        case .push:
            return CustomPushAnimation(frame: frame)
        case .pop:
            return nil
        }
    }
}

extension CustomTransition: UIViewControllerTransitioningDelegate {
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return CustomPushAnimation(frame: frame)
    }
}

private class CustomPushAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    let frame: CGRect
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(1)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        toView?.layoutIfNeeded()
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
        let containerView = transitionContext.containerView
        
        containerView.addSubview(toView!)
        toView?.frame = frame
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            toView!.frame = toViewFinalFrame
        }) { (finished) in
            transitionContext.completeTransition(true)
        }
    }
    
    
}

private class CustomPopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(2)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    
}
