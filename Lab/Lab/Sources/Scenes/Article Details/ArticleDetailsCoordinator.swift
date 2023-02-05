import UIKit

protocol ArticleDetailsViewModelDelegate: AnyObject {
	func showWebPage(urlString: String)
	func finish()
}

protocol ArticleWebCoordinatorDelegate: AnyObject {
	func finish(coordinator: ArticleWebCoordinator)
}

final class ArticleDetailsCoordinator: Coordinator {
	var childCoordinators: [Coordinator]
	var rootNavigationController: UINavigationController

	weak var delegate: ArticleDetailsCoordinatorDelegate?

	private let dependencies: AppDependency
	private let article: Article

	init(dependencies: AppDependency,
		 rootNavigationController: UINavigationController,
		 article: Article) {
		self.dependencies = dependencies
		self.childCoordinators = []
		self.rootNavigationController = rootNavigationController
		self.article = article
	}

	func start() {
		let viewModel = ArticleDetailsViewModel(dependencies: dependencies, model: article)
		viewModel.delegate = self
		let vc = ArticleDetailsViewController(viewModel: viewModel)
		rootNavigationController.pushViewController(vc, animated: true)
	}
}

extension ArticleDetailsCoordinator: ArticleDetailsViewModelDelegate {
	func showWebPage(urlString: String) {
		let coordinator = ArticleWebCoordinator(dependencies: dependencies,
												rootNavigationController: rootNavigationController,
												url: urlString)
		coordinator.delegate = self
		childCoordinators.append(coordinator)
		coordinator.start()
	}

	func finish() {
		delegate?.finish(coordinator: self)
	}
}

extension ArticleDetailsCoordinator: ArticleWebCoordinatorDelegate {
	func finish(coordinator: ArticleWebCoordinator) {
		removeAllChildCoordinatorsWithType(type(of: coordinator))
	}
}
