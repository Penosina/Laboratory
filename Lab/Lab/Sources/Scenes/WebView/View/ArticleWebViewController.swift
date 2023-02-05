import UIKit
import WebKit

class ArticleWebViewController: UIViewController {

	@IBOutlet weak var webView: WKWebView!

	private let viewModel: ArticleWebViewModel

	init(viewModel: ArticleWebViewModel) {
		self.viewModel = viewModel
		super.init(nibName: "ArticleWebViewController", bundle: nil)
	}

	override func viewDidLoad() {
        super.viewDidLoad()
		bindToViewModel()
		viewModel.start()
    }

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		viewModel.finish()
	}

	private func bindToViewModel() {
		viewModel.didUpdateData = { [weak self] in
			guard let urlRequest = self?.viewModel.urlRequest else { return }
			self?.webView.load(urlRequest)
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
