import UIKit

class SwipeTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    weak var transitionContext: UIViewControllerContextTransitioning?
    let gestureRecognizer: UIPanGestureRecognizer
    let edge: UIRectEdge

    init(gestureRecognizer: UIPanGestureRecognizer, edgeForDragging edge: UIRectEdge) {
        self.gestureRecognizer = gestureRecognizer
        self.edge = edge
        super.init()

        gestureRecognizer.addTarget(self, action: #selector(self.gestureRecognizeDidUpdate(_:)))
    }

    deinit {
        self.gestureRecognizer.removeTarget(self, action: #selector(self.gestureRecognizeDidUpdate(_:)))
    }


    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }

    private func percentForGesture(_ gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        let transitionContainerView = self.transitionContext?.containerView
        let locationInSourceView = gesture.location(in: transitionContainerView)
        let width = (transitionContainerView?.bounds ?? CGRect()).width
        let height = (transitionContainerView?.bounds ?? CGRect()).height
        if self.edge == .right {
            return (width - locationInSourceView.x) / width
        } else if self.edge == .left {
            return locationInSourceView.x / width
        } else if self.edge == .bottom {
            return (height - locationInSourceView.y) / height
        } else if self.edge == .top {
            return locationInSourceView.y / height
        } else {
            return 0.0
        }
    }

    @objc func gestureRecognizeDidUpdate(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            break
        case .changed:
            self.update(self.percentForGesture(gestureRecognizer))
            break
        case .ended:
            if self.percentForGesture(gestureRecognizer) >= 0.5 {
                self.finish()
            } else {
                self.cancel()
            }
        default:
            self.cancel()
        }
    }
}
