import UIKit

class MainViewController: UIViewController {
    lazy var customTransitionDelegate: HorizontalSlideTransitionDelegate = {
        let delegate = HorizontalSlideTransitionDelegate()
        return delegate
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Endre søk", style: .done, target: self, action: #selector(changeSearchTapped(sender:)))
    }

    @objc func changeSearchTapped(sender: Any?) {
        let secondViewController = FiltersViewController()
        secondViewController.transitioningDelegate = self.customTransitionDelegate
        self.customTransitionDelegate.gestureRecognizer = secondViewController.gestureRecognizer
        secondViewController.modalPresentationStyle = .custom
        present(secondViewController, animated: true, completion: nil)
    }
}
