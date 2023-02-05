final class URLFactory {
	private static let baseURL = "https://newsapi.org/v2/everything"
	private static let apiKey = "a9eb31242fa9495ca92bf35a68f5e7f7"
	private static let pageSize = 20

	static func makeGetNewsURLString(pageNum: Int) -> String {

		let urlString = baseURL
						+ "?apiKey=\(apiKey)"
						+ "&q=tesla"
						+ "&sortBy=publishedAt"
						+ "&pageSize=\(pageSize)"
						+ "&page=\(pageNum)"
		return urlString
	}
}
