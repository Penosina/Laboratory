import Foundation
import UIKit

enum NetworkError: Error {
	case failedToDecodeData
}

final class NetworkManager {

	private var getNewsTask: URLSessionDataTask?

	private var isLoading = false

	func getNews(pageNum: Int = 1, completion: @escaping (Result<[Article], Error>) -> Void) {

		guard let url = URL(string: URLFactory.makeGetNewsURLString(pageNum: pageNum)) else { return }

		self.isLoading = true

		URLSession.shared.dataTask(with: url) { data, _, error in
			self.isLoading = false

			if let error = error {
				DispatchQueue.main.async {
					completion(.failure(error))
				}
			}

			guard
				let data = data,
				let articlesResult = try? JSONDecoder().decode(ArticlesRequestResultDTO.self, from: data)
			else {
				DispatchQueue.main.async {
					completion(.failure(NetworkError.failedToDecodeData))
				}
				return
			}

			DispatchQueue.main.async {
				completion(.success(articlesResult.articles.map { Article(from: $0) }))
			}
		}.resume()
	}

	func images(forURLs urls: [String?], completion: @escaping ([Data?]) -> Void) {

		guard isLoading == false else { return }

		isLoading = true

		let group = DispatchGroup()
		var imagesData: [Data?] = .init(repeating: nil, count: urls.count)

		for (index, urlString) in urls.enumerated() {
			group.enter()
			DispatchQueue.global().async {
				if let url = URL(string: urlString ?? "") {
					if let data = try? Data(contentsOf: url) {
						imagesData[index] = data
					}
				}
				group.leave()
			}
		}

		group.notify(queue: .main) {
			completion(imagesData)
		}

		isLoading = false
	}
}
