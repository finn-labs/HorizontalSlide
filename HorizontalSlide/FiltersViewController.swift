import UIKit

class FiltersViewController: UIViewController {
    lazy var gestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(interactiveTransitionRecognizerAction(_:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addGestureRecognizer(gestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    @objc func interactiveTransitionRecognizerAction(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if let transitionDelegate = transitioningDelegate as? HorizontalSlideTransitionDelegate {
                transitionDelegate.gestureRecognizer = sender
                dismiss(animated: true, completion: nil)
            }
        }
    }

}
