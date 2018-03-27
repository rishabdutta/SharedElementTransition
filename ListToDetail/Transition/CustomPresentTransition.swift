//
//  CustomPresentTransition.swift
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
class CustomPresentAnimation: NSObject, UIViewControllerAnimatedTransitioning {
    private let frame: CGRect
    
    private var middleView: UIView!
    
    init(frame: CGRect) {
        self.frame = frame
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(0.8)
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)
        let toViewFinalFrame = transitionContext.finalFrame(for: toVC!)
        let containerView = transitionContext.containerView
        //1.
        guard let firstSnap = firstSnapshot(fromView: fromVC!.view, frame: frame) else { return }
        containerView.addSubview(firstSnap)
        //2.
        guard let middleSnap = middleSnapshot(toView: toView!, frame: frame) else { return }
        containerView.addSubview(middleSnap)
        //1.
        guard let lastSnap = lastSnapshot(fromView: fromVC!.view, frame: middleSnap.frame) else { return }
        containerView.addSubview(lastSnap)
        
        containerView.addSubview(toView!)
        toView?.isHidden = true
        
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0.0, options: .curveEaseIn, animations: {
            //3.
            firstSnap.frame = CGRect(x: 0, y: -firstSnap.frame.height, width: ScreenWidth, height: firstSnap.frame.height)
            
            _ = {
                // y position of middleView is changed because of padding issues
                var frame = self.middleView.frame
                frame.origin.y = 0
                self.middleView.frame = frame
            }()
            middleSnap.frame = toViewFinalFrame
            lastSnap.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: ScreenWidth, height: lastSnap.frame.height)
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

private extension CustomPresentAnimation {
    //1.
    func firstSnapshot(fromView: UIView, frame: CGRect) -> UIView? {
        let nFrame = CGRect(x: 0, y: 0, width: ScreenWidth, height: frame.origin.y)
        let view = fromView.resizableSnapshotView(from: nFrame, afterScreenUpdates: false, withCapInsets: .zero)
        return view
    }
    
    //2.
    func middleSnapshot(toView: UIView, frame: CGRect) -> UIView? {
        middleView = toView.snapshotView(afterScreenUpdates: true)
        
        let view = UIView(frame: CGRect(x: 0, y: frame.origin.y, width: ScreenWidth, height: frame.height))
        view.backgroundColor = .white
        view.clipsToBounds = true
        
        // y position of middleView is changed because of padding issues
        view.addSubview(middleView!)
        var frame = toView.frame
        frame.origin.y = -StatusBarHeight
        middleView?.frame = frame
        
        return view
    }
    
    //1.
    func lastSnapshot(fromView: UIView, frame: CGRect) -> UIView? {
        let frameHeight = fromView.frame.height - (frame.origin.y + frame.height)
        let nFrame = CGRect(x: 0, y: frame.origin.y + frame.height, width: ScreenWidth, height: frameHeight)
        let view = fromView.resizableSnapshotView(from: nFrame, afterScreenUpdates: false, withCapInsets: .zero)
        view?.frame = nFrame
        return view
    }
}
