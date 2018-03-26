//
//  CustomTransition.swift
//  ListToDetail
//
//  Created by Rishab Dutta on 23/03/18.
//  Copyright © 2018 Rishab Dutta. All rights reserved.
//

import Foundation
import UIKit

let ScreenWidth = UIScreen.main.bounds.width
let StatusBarHeight = UIApplication.shared.statusBarFrame.height

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
    
    var middleView: UIView!
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(1)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
        let containerView = transitionContext.containerView
        
        guard let firstSnap = firstSnapshot(fromView: fromVC!.view, frame: frame) else { return }
        containerView.addSubview(firstSnap)
        
        guard let middleSnap = middleSnapshot(toView: toView!, frame: frame) else { return }
        containerView.addSubview(middleSnap)
        
        guard let lastSnap = lastSnapshot(fromView: fromVC!.view, frame: middleSnap.frame) else { return }
        containerView.addSubview(lastSnap)
        
        containerView.addSubview(toView!)
        toView?.isHidden = true

        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            firstSnap.frame = CGRect(x: 0, y: -firstSnap.frame.height, width: ScreenWidth, height: firstSnap.frame.height)
            
            let middleViewFrameChange: () -> () = {
                var frame = self.middleView.frame
                frame.origin.y = 0
                self.middleView.frame = frame
            }
            middleViewFrameChange()
            middleSnap.frame = toViewFinalFrame
            lastSnap.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: ScreenWidth, height: self.frame.height)
            toView?.frame = toViewFinalFrame
        }) { (finished) in
            firstSnap.removeFromSuperview()
            middleSnap.removeFromSuperview()
            lastSnap.removeFromSuperview()
            toView?.isHidden = false
            transitionContext.completeTransition(true)
        }
    }
}

extension CustomPushAnimation {
    
    func firstSnapshot(fromView: UIView, frame: CGRect) -> UIView? {
        let nFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: frame.origin.y)
        let view = fromView.resizableSnapshotView(from: nFrame, afterScreenUpdates: false, withCapInsets: .zero)
        return view
    }
    
    func middleSnapshot(toView: UIView, frame: CGRect) -> UIView? {
        middleView = toView.snapshotView(afterScreenUpdates: true)
        middleView?.frame = toView.frame
        
        let view = UIView(frame: CGRect(x: 0, y: frame.origin.y, width: ScreenWidth, height: frame.height))
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        view.addSubview(middleView!)
        var frame = middleView?.frame
        frame?.origin.y = -StatusBarHeight
        middleView?.frame = frame!

        return view
    }
    
    func lastSnapshot(fromView: UIView, frame: CGRect) -> UIView? {
        let frameHeight = fromView.frame.height - (frame.origin.y + frame.height)
        let nFrame = CGRect(x: 0, y: frame.origin.y + frame.height, width: ScreenWidth, height: frameHeight)
        let view = fromView.resizableSnapshotView(from: nFrame, afterScreenUpdates: false, withCapInsets: .zero)
        view?.frame = nFrame
        return view
    }
}

private class CustomPopAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(2)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
    }
    
    
}
