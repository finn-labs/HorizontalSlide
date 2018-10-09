import UIKit

class FiltersViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let swipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(swipeGestureRecognizerAction))
        swipeGestureRecognizer.direction = .right
        view.addGestureRecognizer(swipeGestureRecognizer)
        view.isUserInteractionEnabled = true
    }

    @objc func swipeGestureRecognizerAction() {
        dismiss(animated: true, completion: nil)
    }
}
