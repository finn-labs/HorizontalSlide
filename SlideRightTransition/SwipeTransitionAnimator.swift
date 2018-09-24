import UIKit

class SwipeTransitionAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    var targetEdge: UIRectEdge
    
    //| ----------------------------------------------------------------------------
    init(targetEdge: UIRectEdge) {
        self.targetEdge = targetEdge
        super.init()
    }
    
    
    //| ----------------------------------------------------------------------------
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.35
    }
    
    //| ----------------------------------------------------------------------------
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        
        let containerView = transitionContext.containerView
        
        // For a Presentation:
        //      fromView = The presenting view.
        //      toView   = The presented view.
        // For a Dismissal:
        //      fromView = The presented view.
        //      toView   = The presenting view.
        let fromView: UIView
        let toView: UIView
        
        // In iOS 8, the viewForKey: method was introduced to get views that the
        // animator manipulates.  This method should be preferred over accessing
        // the view of the fromViewController/toViewController directly.
        // It may return nil whenever the animator should not touch the view
        // (based on the presentation style of the incoming view controller).
        // It may also return a different view for the animator to animate.
        //
        // Imagine that you are implementing a presentation similar to form sheet.
        // In this case you would want to add some shadow or decoration around the
        // presented view controller's view. The animator will animate that
        // decoration instead and the presented view controller's view will be a
        // child of the decoration.
        if #available(iOS 8.0, *) {
            fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
            toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        } else {
            fromView = fromViewController.view
            toView = toViewController.view
        }
        
        // If this is a presentation, toViewController corresponds to the presented
        // view controller and its presentingViewController will be
        // fromViewController.  Otherwise, this is a dismissal.
        let isPresenting = (toViewController.presentingViewController === fromViewController)
        
        let fromFrame = transitionContext.initialFrame(for: fromViewController)
        let toFrame = transitionContext.finalFrame(for: toViewController)
        
        // Based on our configured targetEdge, derive a normalized vector that will
        // be used to offset the frame of the presented view controller.
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
            // For a presentation, the toView starts off-screen and slides in.
            fromView.frame = fromFrame
            toView.frame = toFrame.offsetBy(dx: toFrame.size.width * offset.dx * -1,
                dy: toFrame.size.height * offset.dy * -1)
        } else {
            fromView.frame = fromFrame
            toView.frame = toFrame
        }
        
        // We are responsible for adding the incoming view to the containerView
        // for the presentation.
        if isPresenting {
            containerView.addSubview(toView)
        } else {
            // -addSubview places its argument at the front of the subview stack.
            // For a dismissal animation we want the fromView to slide away,
            // revealing the toView.  Thus we must place toView under the fromView.
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
