import Foundation
import UIKit

final class ArticleDetailsViewModel {

	var title: String {
		model.title
	}

	var description: String? {
		model.description
	}

	var publishedAt: String {
		model.publishedAt
	}

	var sourceName: String {
		model.sourceName
	}

	lazy var image: UIImage? = {
		guard let imageData = model.imageData else { return nil }
		return UIImage(data: imageData, scale: 0.05)
	}()

	weak var delegate: ArticleDetailsViewModelDelegate?

	var didUpdateData: (() -> Void)?
	var didReceiveError: (() -> Void)?

	private let dependencies: AppDependency
	private let model: Article

	init(dependencies: AppDependency, model: Article) {
		self.dependencies = dependencies
		self.model = model
	}

	func start() {
		didUpdateData?()
	}

	func showWebPage() {
		delegate?.showWebPage(urlString: model.url)
	}

	func finish() {
		delegate?.finish()
	}
}
