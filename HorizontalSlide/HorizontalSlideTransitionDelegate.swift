import UIKit

public class HorizontalSlideTransitionDelegate: NSObject, UIViewControllerTransitioningDelegate {
    var gestureRecognizer: UIPanGestureRecognizer?

    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        let presentationController = HorizontalSlideController(presentedViewController: presented, presenting: presenting)
        return presentationController
    }

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideTransitionAnimator()
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return HorizontalSlideTransitionAnimator()
    }
//    //| ----------------------------------------------------------------------------
//    //  If a <UIViewControllerAnimatedTransitioning> was returned from
//    //  -animationControllerForPresentedController:presentingController:sourceController:,
//    //  the system calls this method to retrieve the interaction controller for the
//    //  presentation transition.  Your implementation is expected to return an
//    //  object that conforms to the UIViewControllerInteractiveTransitioning
//    //  protocol, or nil if the transition should not be interactive.
//    //
//    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        // You must not return an interaction controller from this method unless
//        // the transition will be interactive.
//        if let gestureRecognizer = self.gestureRecognizer {
//            return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: .left)
//        } else {
//            return nil
//        }
//    }
//
//
//    //| ----------------------------------------------------------------------------
//    //  If a <UIViewControllerAnimatedTransitioning> was returned from
//    //  -animationControllerForDismissedController:,
//    //  the system calls this method to retrieve the interaction controller for the
//    //  dismissal transition.  Your implementation is expected to return an
//    //  object that conforms to the UIViewControllerInteractiveTransitioning
//    //  protocol, or nil if the transition should not be interactive.
//    //
//    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
//        // You must not return an interaction controller from this method unless
//        // the transition will be interactive.
//        if let gestureRecognizer = self.gestureRecognizer {
//            return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: .left)
//        } else {
//            return nil
//        }
//    }
}
