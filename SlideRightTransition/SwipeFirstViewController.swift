import UIKit

class SwipeFirstViewController: UIViewController {
    
    private var _customTransitionDelegate: SwipeTransitionDelegate?
    
    
    //| ----------------------------------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // This gesture recognizer could be defined in the storyboard but is
        // instead created in code for clarity.
        let interactiveTransitionRecognizer = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(self.interactiveTransitionRecognizerAction(_:)))
        interactiveTransitionRecognizer.edges = .right
        self.view.addGestureRecognizer(interactiveTransitionRecognizer)
    }
    
    
    //| ----------------------------------------------------------------------------
    //! Action method for the interactiveTransitionRecognizer.
    //
    @IBAction func interactiveTransitionRecognizerAction(_ sender: UIScreenEdgePanGestureRecognizer) {
        if sender.state == .began {
            self.performSegue(withIdentifier: "CustomTransition", sender: sender)
        }
        
        // Remaining cases are handled by the
        // SwipeTransitionInteractionController.
    }
    
    
    //| ----------------------------------------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CustomTransition" {
            let destinationViewController = segue.destination
            
            // Unlike in the Cross Dissolve demo, we use a separate object as the
            // transition delegate rather then (our)self.  This promotes
            // 'separation of concerns' as SwipeTransitionDelegate will
            // handle pairing the correct animation controller and interaction
            // controller for the presentation.
            let transitionDelegate = self.customTransitionDelegate
            
            // If this will be an interactive presentation, pass the gesture
            // recognizer along to our SwipeTransitionDelegate instance
            // so it can return the necessary
            // <UIViewControllerInteractiveTransitioning> for the presentation.
            if let sender = sender as? UIGestureRecognizer {
                transitionDelegate.gestureRecognizer = (sender as! UIScreenEdgePanGestureRecognizer)
            } else {
                transitionDelegate.gestureRecognizer = nil
            }
            
            // Set the edge of the screen to present the incoming view controller
            // from.  This will match the edge we configured the
            // UIScreenEdgePanGestureRecognizer with previously.
            //
            // NOTE: We can not retrieve the value of our gesture recognizer's
            //       configured edges because prior to iOS 8.3
            //       UIScreenEdgePanGestureRecognizer would always return
            //       UIRectEdgeNone when querying its edges property.
            transitionDelegate.targetEdge = .right
            
            // Note that the view controller does not hold a strong reference to
            // its transitioningDelegate.  If you instantiate a separate object
            // to be the transitioningDelegate, ensure that you hold a strong
            // reference to that object.
            destinationViewController.transitioningDelegate = transitionDelegate
            
            // Setting the modalPresentationStyle to FullScreen enables the
            // <ContextTransitioning> to provide more accurate initial and final
            // frames of the participating view controllers.
            destinationViewController.modalPresentationStyle = .fullScreen
        }
    }
    
    
    //| ----------------------------------------------------------------------------
    //  Custom implementation of the getter for the customTransitionDelegate
    //  property.  Lazily creates an instance of SwipeTransitionDelegate.
    //
    var customTransitionDelegate: SwipeTransitionDelegate {
        get {
            if _customTransitionDelegate == nil {
                _customTransitionDelegate = SwipeTransitionDelegate()
            }
            
            return _customTransitionDelegate!
        }
        set {
            _customTransitionDelegate = newValue
        }
    }
    //
    //MARK: -
    //MARK: Unwind Actions
    
    //| ----------------------------------------------------------------------------
    //! Action for unwinding from SwipeSecondViewController.
    //
    @IBAction func unwindToSwipeFirstViewController(_ sender: UIStoryboardSegue) {
    }
    
}
