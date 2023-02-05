import UIKit

extension UIViewController {
	func showAlert(text: String?) {
		let alert = UIAlertController(title: text, message: nil, preferredStyle: .alert)
		alert.setValue(NSAttributedString(string: text ?? "", attributes: [
			.font : UIFont.systemFont(ofSize: 16)
		]), forKey: "attributedTitle")
		let okAction = UIAlertAction(title: "Ок", style: .default, handler: nil)
		alert.view.tintColor = .black
		alert.addAction(okAction)
		present(alert, animated: true, completion: nil)
	}

	func showError(_ error: Error) {
		showAlert(text: error.localizedDescription)
	}
}
