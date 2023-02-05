import Foundation
import UIKit

final class ArticlesListViewController: UIViewController {

	@IBOutlet weak var tableView: UITableView!

	private let refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
		return refreshControl
	}()

	private let viewModel: ArticlesListViewModel
	private let reuseIdentifier = "ArticleCellView"

	@objc
	private func refresh(sender: UIRefreshControl) {
		sender.endRefreshing()
		viewModel.refresh()
	}

	init(viewModel: ArticlesListViewModel) {
		self.viewModel = viewModel
		super.init(nibName: "ArticlesListViewController", bundle: nil)
	}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.title = "Новости"
		setupTableView()
		bindToViewModel()
		viewModel.start()
	}

	override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		viewModel.saveArticles()
	}

	private func setupTableView() {
		tableView.register(UINib(nibName: "ArticleCellView", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
		tableView.delegate = self
		tableView.dataSource = self
		tableView.refreshControl = refreshControl
	}

	private func bindToViewModel() {
		viewModel.didUpdateData = { [weak self] in
			self?.tableView.reloadData()
		}

		viewModel.didReceiveError = { [weak self] in
			self?.showAlert(text: "Упс... Ошибка!")
		}
	}

	required init?(coder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
}

extension ArticlesListViewController: UITableViewDelegate, UITableViewDataSource {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		viewModel.articleViewModels.count
	}

	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		guard
			let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? ArticleCellView,
			indexPath.row < viewModel.articleViewModels.count
		else {
			return UITableViewCell()
		}

		let cellViewModel = viewModel.articleViewModels[indexPath.row]
		cell.configure(with: cellViewModel)

		return cell
	}

	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		viewModel.didSelectRow(at: indexPath)
	}
}
