import UIKit

class SwipeTransitionInteractionController: UIPercentDrivenInteractiveTransition {
    weak var transitionContext: UIViewControllerContextTransitioning?
    let gestureRecognizer: UIPanGestureRecognizer

    init(gestureRecognizer: UIPanGestureRecognizer) {
        self.gestureRecognizer = gestureRecognizer
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
        guard let fromViewController = transitionContext?.viewController(forKey: .from) else { return 0 }
        guard let toViewController = transitionContext?.viewController(forKey: .to) else { return  0 }
        let isPresenting = toViewController.presentingViewController === fromViewController

        let transitionContainerView: UIView?
        if isPresenting {
            transitionContainerView = transitionContext?.containerView
        } else {
            transitionContainerView = transitionContext?.viewController(forKey: .to)?.view
        }

        let locationInSourceView = gesture.location(in: transitionContainerView)
        let width = transitionContainerView?.bounds.width ?? 0
        guard width > 0 else { return 0 }
        let percentage: CGFloat
        if isPresenting {
            percentage = (width - locationInSourceView.x) / width
        } else {
            percentage = locationInSourceView.x / width
        }

        return percentage
    }

    @objc func gestureRecognizeDidUpdate(_ gestureRecognizer: UIScreenEdgePanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            break
        case .changed:
            update(percentForGesture(gestureRecognizer))
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
