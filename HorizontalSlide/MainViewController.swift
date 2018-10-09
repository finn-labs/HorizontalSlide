import UIKit

class MainViewController: UIViewController {
    lazy var customTransitionDelegate: HorizontalSlideTransitionDelegate = {
        let delegate = HorizontalSlideTransitionDelegate()
        return delegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Endre søk", style: .done, target: self, action: #selector(changeSearchTapped(sender:)))

        let interactiveTransitionRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(interactiveTransitionRecognizerAction(_:)))
        interactiveTransitionRecognizer.edges = .right
        view.addGestureRecognizer(interactiveTransitionRecognizer)
    }

    @objc func interactiveTransitionRecognizerAction(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            changeSearchTapped(sender: sender)
        }
    }

    @objc func changeSearchTapped(sender: Any?) {
        let secondViewController = FiltersViewController()
        secondViewController.transitioningDelegate = customTransitionDelegate
        customTransitionDelegate.gestureRecognizer = sender as? UIScreenEdgePanGestureRecognizer
        secondViewController.modalPresentationStyle = .custom
        present(secondViewController, animated: true, completion: nil)
    }
}
