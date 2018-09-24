import UIKit

@objc(SwipeTransitionDelegate)
class SwipeTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    //! If this transition will be interactive, this property is set to the
    //! gesture recognizer which will drive the interactivity.
    var gestureRecognizer: UIScreenEdgePanGestureRecognizer?
    
    var targetEdge: UIRectEdge = []
    
    //| ----------------------------------------------------------------------------
    //  The system calls this method on the presented view controller's
    //  transitioningDelegate to retrieve the animator object used for animating
    //  the presentation of the incoming view controller.  Your implementation is
    //  expected to return an object that conforms to the
    //  UIViewControllerAnimatedTransitioning protocol, or nil if the default
    //  presentation animation should be used.
    //
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator(targetEdge: self.targetEdge)
    }
    
    
    //| ----------------------------------------------------------------------------
    //  The system calls this method on the presented view controller's
    //  transitioningDelegate to retrieve the animator object used for animating
    //  the dismissal of the presented view controller.  Your implementation is
    //  expected to return an object that conforms to the
    //  UIViewControllerAnimatedTransitioning protocol, or nil if the default
    //  dismissal animation should be used.
    //
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SwipeTransitionAnimator(targetEdge: self.targetEdge)
    }
    
    
    //| ----------------------------------------------------------------------------
    //  If a <UIViewControllerAnimatedTransitioning> was returned from
    //  -animationControllerForPresentedController:presentingController:sourceController:,
    //  the system calls this method to retrieve the interaction controller for the
    //  presentation transition.  Your implementation is expected to return an
    //  object that conforms to the UIViewControllerInteractiveTransitioning
    //  protocol, or nil if the transition should not be interactive.
    //
    func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // You must not return an interaction controller from this method unless
        // the transition will be interactive.
        if let gestureRecognizer = self.gestureRecognizer {
            return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: self.targetEdge)
        } else {
            return nil
        }
    }
    
    
    //| ----------------------------------------------------------------------------
    //  If a <UIViewControllerAnimatedTransitioning> was returned from
    //  -animationControllerForDismissedController:,
    //  the system calls this method to retrieve the interaction controller for the
    //  dismissal transition.  Your implementation is expected to return an
    //  object that conforms to the UIViewControllerInteractiveTransitioning
    //  protocol, or nil if the transition should not be interactive.
    //
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        // You must not return an interaction controller from this method unless
        // the transition will be interactive.
        if let gestureRecognizer = self.gestureRecognizer {
            return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: self.targetEdge)
        } else {
            return nil
        }
    }
    
}
