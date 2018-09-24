import UIKit

class SwipeSecondViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let interactiveTransitionRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(interactiveTransitionRecognizerAction(sender:)))
        interactiveTransitionRecognizer.edges = .left
        self.view.addGestureRecognizer(interactiveTransitionRecognizer)
    }
    
    
    @IBAction func interactiveTransitionRecognizerAction(sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            if let transitionDelegate = self.transitioningDelegate as? SwipeTransitionDelegate {
                transitionDelegate.gestureRecognizer = sender
                transitionDelegate.targetEdge = .left
                dismiss(animated: true, completion: nil)
        }
    }
    }
}
