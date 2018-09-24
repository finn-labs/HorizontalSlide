import UIKit

class SwipeFirstViewController: UIViewController {
    lazy var customTransitionDelegate: SwipeTransitionDelegate = {
        return SwipeTransitionDelegate()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Endre søk", style: .done, target: self, action: #selector(changeSearchTapped(sender:)))
    }

    @objc func changeSearchTapped(sender: Any?) {
        let storyboard = UIStoryboard(name: "Swipe", bundle: nil)
        let secondViewController = storyboard.instantiateViewController(withIdentifier: "SecondViewController") as! SwipeSecondViewController
        let transitionDelegate = self.customTransitionDelegate
        if let sender = sender as? UIGestureRecognizer {
            transitionDelegate.gestureRecognizer = (sender as! UIScreenEdgePanGestureRecognizer)
        } else {
            transitionDelegate.gestureRecognizer = nil
        }
        transitionDelegate.targetEdge = .right
        secondViewController.transitioningDelegate = transitionDelegate
        secondViewController.modalPresentationStyle = .fullScreen
        present(secondViewController, animated: true, completion: nil)
    }
}
