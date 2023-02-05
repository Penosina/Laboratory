import Foundation

final class ArticleWebViewModel {

	weak var delegate: ArticleWebViewModelDelegate?

	var didUpdateData: (() -> Void)?

	var urlRequest: URLRequest? {
		guard let url = URL(string: url) else { return nil }
		return URLRequest(url: url)
	}

	private let url: String

	init(url: String) {
		self.url = url
	}

	func start() {
		didUpdateData?()
	}

	func finish() {
		delegate?.finish()
	}
}
