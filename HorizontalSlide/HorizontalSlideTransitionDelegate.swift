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

    public func interactionControllerForPresentation(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let gestureRecognizer = self.gestureRecognizer {
            return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: .right)
        } else {
            return nil
        }
    }

    public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        if let gestureRecognizer = self.gestureRecognizer {
            return SwipeTransitionInteractionController(gestureRecognizer: gestureRecognizer, edgeForDragging: .left)
        } else {
            return nil
        }
    }
}
