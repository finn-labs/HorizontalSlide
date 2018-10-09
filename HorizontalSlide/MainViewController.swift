import UIKit

class MainViewController: UIViewController {
    lazy var customTransitionDelegate: HorizontalSlideTransitionDelegate = {
        let delegate = HorizontalSlideTransitionDelegate()
        return delegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Endre søk", style: .done, target: self, action: #selector(changeSearchTapped))

        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizerAction))
        swipeGestureRecognizer.direction = .left
        view.addGestureRecognizer(swipeGestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    @objc func swipeGestureRecognizerAction() {
        changeSearchTapped()
    }

    @objc func changeSearchTapped() {
        let secondViewController = FiltersViewController()
        secondViewController.transitioningDelegate = customTransitionDelegate
        secondViewController.modalPresentationStyle = .custom
        present(secondViewController, animated: true, completion: nil)
    }
}
