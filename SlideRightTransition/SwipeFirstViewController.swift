import UIKit

class SwipeFirstViewController: UIViewController {
    lazy var customTransitionDelegate: SwipeTransitionDelegate = {
        return SwipeTransitionDelegate()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Endre søk", style: .done, target: self, action: #selector(changeSearchTapped(sender:)))
    }

    @objc func changeSearchTapped(sender: Any?) {
        let secondViewController = SwipeSecondViewController()
        let transitionDelegate = self.customTransitionDelegate
        transitionDelegate.targetEdge = .right
        secondViewController.transitioningDelegate = transitionDelegate
        secondViewController.modalPresentationStyle = .fullScreen
        present(secondViewController, animated: true, completion: nil)
    }
}
