import Foundation
import CoreData

final class CoreDataService {
	// MARK: - Properties
	var viewContext: NSManagedObjectContext {
		persistentContainer.viewContext
	}

	private var persistentContainer: NSPersistentContainer

	// MARK: - Init
	init() {
		persistentContainer = NSPersistentContainer(name: "Model")
		persistentContainer.loadPersistentStores { description, error in
			if let error = error {
				fatalError("Failed to load CoreData stack: \(error)")
			}
		}
	}

	// MARK: - Public Methods
	func addArticles(articles: [Article]) {
		for article in articles {
			addOrUpdateArticle(article: article)
		}
	}

	func getArticles() -> [Article] {
		var articles: [Article] = []

		let request: NSFetchRequest = ArticleDataModel.fetchRequest()
		let dataBaseArticles = (try? viewContext.fetch(request)) ?? []

		dataBaseArticles.forEach { article in
			try? articles.append(article.transient())
		}

		return articles
	}

	func deleteAllData() {
		let storeContainer = persistentContainer.persistentStoreCoordinator

		for store in storeContainer.persistentStores {
			try? storeContainer.destroyPersistentStore(
				at: store.url!,
				ofType: store.type,
				options: nil
			)
		}

		persistentContainer = NSPersistentContainer(name: "Model")
		persistentContainer.loadPersistentStores { _, error in
			print(String(describing: error))
		}
	}

	private func addOrUpdateArticle(article: Article) {
		ArticleDataModel.from(transient: article, inContext: viewContext)
		try? viewContext.save()
	}
}
