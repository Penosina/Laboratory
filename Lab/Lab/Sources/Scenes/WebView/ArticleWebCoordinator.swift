import Foundation
import UIKit

protocol ArticleWebViewModelDelegate: AnyObject {
	func finish()
}

final class ArticleWebCoordinator: Coordinator {

	weak var delegate: ArticleWebCoordinatorDelegate?

	var childCoordinators: [Coordinator]
	var rootNavigationController: UINavigationController
	private let dependencies: AppDependency
	private let url: String

	init(dependencies: AppDependency,
		 rootNavigationController: UINavigationController,
		 url: String) {
		self.dependencies = dependencies
		self.rootNavigationController = rootNavigationController
		self.childCoordinators = []
		self.url = url
	}

	func start() {
		let viewModel = ArticleWebViewModel(url: url)
		viewModel.delegate = self
		let vc = ArticleWebViewController(viewModel: viewModel)
		rootNavigationController.pushViewController(vc, animated: true)
	}
}

extension ArticleWebCoordinator: ArticleWebViewModelDelegate {
	func finish() {
		delegate?.finish(coordinator: self)
	}
}
