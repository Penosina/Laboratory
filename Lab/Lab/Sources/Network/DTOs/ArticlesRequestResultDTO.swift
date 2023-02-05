struct ArticlesRequestResultDTO: Decodable {
	let status: String
	let totalResults: Int
	let articles: [ArticleDTO]
}
