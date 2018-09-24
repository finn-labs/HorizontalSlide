import UIKit

class SwipeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var targetEdge: UIRectEdge
    
    init(targetEdge: UIRectEdge) {
        self.targetEdge = targetEdge
        super.init()
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from) else { return }
        guard let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) else { return }

        guard let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from) else { return }
        guard let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }

        let isPresenting = (toViewController.presentingViewController === fromViewController)
        let fromFrame = transitionContext.initialFrame(for: fromViewController)
        let toFrame = transitionContext.finalFrame(for: toViewController)

        let offset: CGVector
        if self.targetEdge == .top {
            offset = CGVector(dx: 0.0, dy: 1.0)
        } else if self.targetEdge == .bottom {
            offset = CGVector(dx: 0.0, dy: -1.0)
        } else if self.targetEdge == .left {
            offset = CGVector(dx: 1.0, dy: 0.0)
        } else if self.targetEdge == .right {
            offset = CGVector(dx: -1.0, dy: 0.0)
        } else {
            fatalError("targetEdge must be one of UIRectEdgeTop, UIRectEdgeBottom, UIRectEdgeLeft, or UIRectEdgeRight.")
        }
        
        if isPresenting {
            fromView.frame = fromFrame
            toView.frame = toFrame.offsetBy(dx: toFrame.size.width * offset.dx * -1, dy: toFrame.size.height * offset.dy * -1)
        } else {
            fromView.frame = fromFrame
            toView.frame = toFrame
        }
        
        let containerView = transitionContext.containerView
        if isPresenting {
            containerView.addSubview(toView)
        } else {
            containerView.insertSubview(toView, belowSubview: fromView)
        }
        
        let transitionDuration = self.transitionDuration(using: transitionContext)
        
        UIView.animate(withDuration: transitionDuration, animations: {
            if isPresenting {
                toView.frame = toFrame
            } else {
                // For a dismissal, the fromView slides off the screen.
                fromView.frame = fromFrame.offsetBy(dx: fromFrame.size.width * offset.dx,
                    dy: fromFrame.size.height * offset.dy)
            }
            
            }, completion: {finished in
                let wasCancelled = transitionContext.transitionWasCancelled
                
                // Due to a bug with unwind segues targeting a view controller inside
                // of a navigation controller, we must remove the toView in cases where
                // an interactive dismissal was cancelled.  This bug manifests as a
                // soft UI lockup after canceling the first interactive modal
                // dismissal; further invocations of the unwind segue have no effect.
                //
                // The navigation controller's implementation of
                // -segueForUnwindingToViewController:fromViewController:identifier:
                // returns a segue which only dismisses the currently presented
                // view controller if it determines that the navigation controller's
                // view is not in the view hierarchy at the time the segue is invoked.
                // The system does not remove toView when we invoke -completeTransition:
                // with a value of NO if this is a dismissal transition.
                //
                // Note that it is not necessary to check for further conditions
                // specific to this bug (e.g. isPresenting==NO &&
                // [toViewController isKindOfClass:UINavigationController.class])
                // because removing toView is a harmless operation in all scenarios
                // except for a successfully completed presentation transition, where
                // it would result in a blank screen.
                if wasCancelled {
                    toView.removeFromSuperview()
                }
                
                // When we complete, tell the transition context
                // passing along the BOOL that indicates whether the transition
                // finished or not.
                transitionContext.completeTransition(!wasCancelled)
        })
    }
    
}
