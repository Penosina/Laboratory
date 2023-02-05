struct ArticleDTO: Decodable {
	let source: SourceDTO
	let author: String?
	let title: String
	let description: String?
	let url: String
	let urlToImage: String?
	let publishedAt: String
	let content: String
}

extension Article {
	init(from dto: ArticleDTO) {
		self.sourceName = dto.source.name
		self.title = dto.title
		self.description = dto.description
		self.urlToImage = dto.urlToImage
		self.url = dto.url
		self.publishedAt = dto.publishedAt
		self.viewCount = 0
	}
}
