//
//  CustomDismissAnimation.swift
//  ListToDetail
//
//  Created by Rishab Dutta on 27/03/18.
//  Copyright © 2018 Rishab Dutta. All rights reserved.
//

import Foundation
import UIKit

/*
 1. Take snapshot of the presenting view controller's view
 and divide it into two parts (viz. first and last)
 2. Use the VC to be presented as the middle view.
 3. Change frame of all the three views
 */

class CustomDismissAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private let frame: CGRect
    private var middleView: UIView!
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(0.8)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        let containerView = transitionContext.containerView
        
        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }
        //1.
        guard let firstSnap = firstSnapshot(toView: toVC.view, frame: frame) else { return }
        containerView.addSubview(firstSnap)
        //2.
        guard let middleSnap = middleSnapshot(fromView: fromView) else { return }
        containerView.addSubview(middleSnap)
        //1.
        guard let lastSnap = lastSnapshot(toView: toVC.view, frame: frame) else { return }
        containerView.addSubview(lastSnap)
        
        let yPos = frame.origin.y + frame.height
        let lastScreenHeight = ScreenHeight - yPos
        
        //3.
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            firstSnap.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: self.frame.origin.y)
            _ = {
                var frame = self.middleView.frame
                frame.origin.y = -StatusBarHeight
                self.middleView.frame = frame
            }()
            middleSnap.frame = CGRect(x: 0, y: self.frame.origin.y, width: ScreenWidth, height: self.frame.height)
            lastSnap.frame = CGRect(x: 0, y: yPos, width: ScreenWidth, height: lastScreenHeight)
        }) { (finished) in
            firstSnap.removeFromSuperview()
            middleSnap.removeFromSuperview()
            lastSnap.removeFromSuperview()
            transitionContext.completeTransition(true)
        }
    }
}

private extension CustomDismissAnimation {
    //1.
    func firstSnapshot(toView: UIView, frame: CGRect) -> UIView? {
        let nFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: frame.origin.y)
        guard let view = toView.resizableSnapshotView(from: nFrame, afterScreenUpdates: true, withCapInsets: .zero) else { return nil }
        
        var vFrame = view.frame
        vFrame.origin.y = -vFrame.height
        view.frame = vFrame
        return view
    }
    
    //2.
    func middleSnapshot(fromView: UIView) -> UIView? {
        middleView = fromView.snapshotView(afterScreenUpdates: false)
        middleView?.frame = fromView.frame
        
        let view = UIView(frame: fromView.frame)
        view.backgroundColor = .white
        view.clipsToBounds = true
        view.addSubview(middleView!)
        
        return view
    }
    
    //1.
    func lastSnapshot(toView: UIView, frame: CGRect) -> UIView? {
        let frameHeight = toView.frame.height - (frame.origin.y + frame.height)
        let nFrame = CGRect(x: 0, y: frame.origin.y + frame.height, width: ScreenWidth, height: frameHeight)
        guard let view = toView.resizableSnapshotView(from: nFrame, afterScreenUpdates: true, withCapInsets: .zero) else { return nil }
        
        let height = ScreenHeight - (frame.origin.y + frame.height)
        view.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: height)
        return view
    }
}
