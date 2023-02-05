import UIKit

struct Article {
	let sourceName: String
	let title: String
	let description: String?
	let urlToImage: String?
	let url: String
	let publishedAt: String

	var viewCount: Int
	var imageData: Data?
}
