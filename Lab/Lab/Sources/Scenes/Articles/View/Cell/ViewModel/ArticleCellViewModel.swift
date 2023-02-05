import UIKit

final class ArticleCellViewModel {

	var title: String {
		article.title
	}

	var viewedTimes: Int {
		article.viewCount
	}

	var image: UIImage? {
		if let imageData = article.imageData, let image = UIImage(data: imageData, scale: 0.05) {
			return image
		}
		return nil
	}

	var didUpdateData: (() -> Void)?

	private var article: Article

	init(article: Article) {
		self.article = article
	}

	func start() {
		didUpdateData?()
	}

	func update(with article: Article) {
		self.article = article
		didUpdateData?()
	}
}
