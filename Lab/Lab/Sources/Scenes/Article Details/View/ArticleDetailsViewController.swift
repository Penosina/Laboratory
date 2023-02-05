import UIKit

class ArticleDetailsViewController: UIViewController {

	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var articleImageView: UIImageView!
	@IBOutlet weak var descriptionLabel: UILabel!
	@IBOutlet weak var dateLabel: UILabel!
	@IBOutlet weak var sourceLabel: UILabel!

	private let viewModel: ArticleDetailsViewModel

	@IBAction func didTapShowArticleFullDetailsButton(_ sender: Any) {
		viewModel.showWebPage()
	}

	init(viewModel: ArticleDetailsViewModel) {
		self.viewModel = viewModel
		super.init(nibName: "ArticleDetailsViewController", bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		title = "Новость"
		bindToViewModel()
		viewModel.start()
	}

	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		viewModel.finish()
	}

	private func bindToViewModel() {
		viewModel.didUpdateData = { [weak self] in
			guard let self = self else { return }

			self.titleLabel.text = self.viewModel.title
			self.descriptionLabel.text = self.viewModel.description
			self.dateLabel.text = "Дата публикации: \(self.viewModel.publishedAt)"
			self.sourceLabel.text = "Источник: \(self.viewModel.sourceName)"
			if let image = self.viewModel.image {
				self.articleImageView.image = image
			}
		}

		viewModel.didReceiveError = { [weak self] in
			self?.showAlert(text: "Упс... Ошибка!")
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}
