final class URLFactory {
	private static let baseURL = "https://newsapi.org/v2/everything"
	private static let apiKey = "efdb2f2ab5bb423cb77d98bd99fe1379"
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
