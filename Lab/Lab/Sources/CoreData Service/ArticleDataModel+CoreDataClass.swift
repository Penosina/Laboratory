import Foundation
import CoreData

enum CoreDataError: Error {
	case failedToDecodeData
}

@objc(ArticleDataModel)
public class ArticleDataModel: NSManagedObject {

	func transient() throws -> Article {
		guard
			let sourseName = sourceName,
			let title = title,
			let url = url,
			let publishedAt = publishedAt
		else {
			throw CoreDataError.failedToDecodeData
		}

		return Article(sourceName: sourseName,
					   title: title,
					   description: myDescription,
					   urlToImage: nil,
					   url: url,
					   publishedAt: publishedAt,
					   viewCount: Int(viewCount),
					   imageData: imageData)
	}

	@discardableResult
	static func from(transient: Article, inContext context: NSManagedObjectContext) -> ArticleDataModel {
		var article: ArticleDataModel

		let request: NSFetchRequest = ArticleDataModel.fetchRequest()
		let dataBaseArticles = (try? context.fetch(request)) ?? []

		if let dbArticle = dataBaseArticles.first(where: {
			$0.sourceName == transient.sourceName
			&& $0.title == transient.title
			&& $0.url == transient.url
		}) {
			article = dbArticle
			article.viewCount = Int16(transient.viewCount)
		} else {
			article = ArticleDataModel(context: context)
			article.sourceName = transient.sourceName
			article.title = transient.title
			article.myDescription = transient.description
			article.url = transient.url
			article.publishedAt = transient.publishedAt
			article.viewCount = Int16(transient.viewCount)
			article.imageData = transient.imageData
		}

		return article
	}
}
