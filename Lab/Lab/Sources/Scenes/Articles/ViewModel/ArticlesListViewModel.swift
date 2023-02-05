import Foundation
import UIKit

final class ArticlesListViewModel {
	var articleViewModels: [ArticleCellViewModel] = []

	var didUpdateData: (() -> Void)?
	var didReceiveError: (() -> Void)?

	weak var delegate: ArticlesListViewModelDelegate?

	private var pageNum = 1
	private let dependencies: AppDependency
	private var articles: [Article] = []

	init(dependencies: AppDependency) {
		self.dependencies = dependencies
	}

	func start() {
		getArticleFromDb()
		getArticles(needRefresh: true)
	}

	func loadMoreArticles() {
		getArticles()
	}

	func refresh() {
		getArticles(needRefresh: true)
	}

	func didSelectRow(at indexPath: IndexPath) {
		guard indexPath.row < articles.count else { return }
		articles[indexPath.row].viewCount += 1
		articleViewModels[indexPath.row].update(with: articles[indexPath.row])
		delegate?.showArticleDetails(with: articles[indexPath.row])
	}

	func saveArticles() {
		dependencies.coreDaraService.addArticles(articles: articles)
	}

	private func getArticleFromDb() {
		articles = dependencies.coreDaraService.getArticles()
		articleViewModels = articles.map { convertToViewModel(article: $0) }
		didUpdateData?()
	}

	private func getArticles(needRefresh: Bool = false) {
		if needRefresh {
			articles = []
			articleViewModels = []
			pageNum = 1
		}

		dependencies.networkManager.getNews(pageNum: pageNum) { [weak self] result in
			guard let self = self else { return }

			switch result {
			case .success(let articles):
				self.handleSuccess(with: articles)
			case .failure:
				self.handleError()
			}
		}
	}

	private func handleSuccess(with articles: [Article]) {
		self.articles += articles
		articleViewModels += articles.map { convertToViewModel(article: $0) }
		didUpdateData?()
		loadImages(stringURLs: articles.map { $0.urlToImage })
	}

	private func handleError() {
		didReceiveError?()
	}

	private func convertToViewModel(article: Article) -> ArticleCellViewModel {
		let cellViewModel = ArticleCellViewModel(article: article)
		return cellViewModel
	}

	private func loadImages(stringURLs: [String?]) {
		dependencies.networkManager.images(forURLs: stringURLs) { [weak self] imagesData in
			guard let self = self else { return }

			for (index, imageData) in imagesData.enumerated() {
				let indexWithOffset = (self.pageNum - 1) * 20 + index
				self.articles[indexWithOffset].imageData = imageData
				self.articleViewModels[indexWithOffset].update(with: self.articles[indexWithOffset])
			}

			self.pageNum += 1
		}
	}
}
