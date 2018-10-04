import UIKit

class FiltersViewController: UIViewController {
    lazy var gestureRecognizer: UIPanGestureRecognizer = {
        return UIPanGestureRecognizer(target: self, action: #selector(self.interactiveTransitionRecognizerAction(_:)))
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .yellow

        view.addGestureRecognizer(gestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    @objc func interactiveTransitionRecognizerAction(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            if let transitionDelegate = self.transitioningDelegate as? HorizontalSlideTransitionDelegate {
                transitionDelegate.gestureRecognizer = sender
            }
        }
    }

}
