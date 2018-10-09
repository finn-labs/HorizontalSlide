import UIKit

class SwipeTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    weak var transitionContext: UIViewControllerContextTransitioning?
    let gestureRecognizer: UIPanGestureRecognizer
    let isDismissal: Bool

    init(gestureRecognizer: UIPanGestureRecognizer, isDismissal: Bool) {
        self.gestureRecognizer = gestureRecognizer
        self.isDismissal = isDismissal
        super.init()

        gestureRecognizer.addTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
    }

    deinit {
        gestureRecognizer.removeTarget(self, action: #selector(gestureRecognizeDidUpdate(_:)))
    }


    override func startInteractiveTransition(_ transitionContext: UIViewControllerContextTransitioning) {
        self.transitionContext = transitionContext
        super.startInteractiveTransition(transitionContext)
    }

    private func percentForGesture(_ gesture: UIScreenEdgePanGestureRecognizer) -> CGFloat {
        let transitionContainerView = transitionContext?.containerView
        let locationInSourceView = gesture.location(in: transitionContainerView)
        let width = transitionContainerView?.bounds.width ?? 0
        guard width > 0 else { return 0 }

        if isDismissal {
            return locationInSourceView.x / width
        } else {
            return (width - locationInSourceView.x) / width
        }
    }

    @objc func gestureRecognizeDidUpdate(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            break
        case .changed:
            update(percentForGesture(gestureRecognizer))
            break
        case .ended:
            if percentForGesture(gestureRecognizer) >= 0.5 {
                finish()
            } else {
                cancel()
            }
        default:
            cancel()
        }
    }
}
