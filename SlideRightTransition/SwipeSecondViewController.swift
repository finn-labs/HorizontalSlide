import UIKit

class SwipeSecondViewController: UIViewController {
    
    
    //| ----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This gesture recognizer could be defined in the storyboard but is
        // instead created in code for clarity.
        let interactiveTransitionRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.interactiveTransitionRecognizerAction(_:)))
        interactiveTransitionRecognizer.edges = .left
        self.view.addGestureRecognizer(interactiveTransitionRecognizer)
    }
    
    
    //| ----------------------------------------------------------------------------
    //! Action method for the interactiveTransitionRecognizer.
    //
    @IBAction func interactiveTransitionRecognizerAction(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            // "BackToFirstViewController" is the identifier of the unwind segue
            // back to SwipeFirstViewController.  Triggering it will dismiss
            // this view controller.
            self.performSegue(withIdentifier: "BackToFirstViewController", sender: sender)
        }
    }

    //| ----------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "BackToFirstViewController" {
            // Check if we were presented with our custom transition delegate.
            // If we were, update the configuration of the
            // SwipeTransitionDelegate with the gesture recognizer and
            // targetEdge for this view controller.
            if let transitionDelegate = self.transitioningDelegate as? SwipeTransitionDelegate {
                
                // If this will be an interactive presentation, pass the gesture
                // recognizer along to our SwipeTransitionDelegate instance
                // so it can return the necessary
                // <UIViewControllerInteractiveTransitioning> for the presentation.
                if let gestureRecognizer = sender as? UIScreenEdgePanGestureRecognizer {
                    transitionDelegate.gestureRecognizer = gestureRecognizer
                } else {
                    transitionDelegate.gestureRecognizer = nil
                }
                
                // Set the edge of the screen to dismiss this view controller
                // from.  This will match the edge we configured the
                // UIScreenEdgePanGestureRecognizer with previously.
                //
                // NOTE: We can not retrieve the value of our gesture recognizer's
                //       configured edges because prior to iOS 8.3
                //       UIScreenEdgePanGestureRecognizer would always return
                //       UIRectEdgeNone when querying its edges property.
                transitionDelegate.targetEdge = .left
            }
        }
    }
    
}
