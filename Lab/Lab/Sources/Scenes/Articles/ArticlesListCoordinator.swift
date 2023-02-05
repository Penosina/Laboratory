import UIKit

protocol ArticlesListViewModelDelegate: AnyObject {
	func showArticleDetails(with article: Article)
}

protocol ArticleDetailsCoordinatorDelegate: AnyObject {
	func finish(coordinator: ArticleDetailsCoordinator)
}

final class ArticlesListCoordinator: Coordinator {
	var childCoordinators: [Coordinator]

	var rootNavigationController: UINavigationController

	private let dependencies: AppDependency

	init(dependencies: AppDependency, rootNavigationController: UINavigationController) {
		self.rootNavigationController = rootNavigationController
		self.dependencies = dependencies

		childCoordinators = []
	}

	func start() {
		let viewModel = ArticlesListViewModel(dependencies: dependencies)
		viewModel.delegate = self
		let vc = ArticlesListViewController(viewModel: viewModel)
		rootNavigationController.setViewControllers([vc], animated: true)
	}
}

extension ArticlesListCoordinator: ArticlesListViewModelDelegate {
	func showArticleDetails(with article: Article) {
		let articleDetailsCoordinator = ArticleDetailsCoordinator(dependencies: dependencies,
																  rootNavigationController: rootNavigationController,
																  article: article)
		articleDetailsCoordinator.delegate = self
		childCoordinators.append(articleDetailsCoordinator)
		articleDetailsCoordinator.start()
	}
}

extension ArticlesListCoordinator: ArticleDetailsCoordinatorDelegate {
	func finish(coordinator: ArticleDetailsCoordinator) {
		removeAllChildCoordinatorsWithType(type(of: coordinator))
	}
}
