import UIKit

final class AppCoordinator: Coordinator {
	// MARK: - Properties
	var childCoordinators: [Coordinator]
	var rootNavigationController: UINavigationController

	private let window: UIWindow?
	private let dependencies: AppDependency

	// MARK: - Init
	init(window: UIWindow?) {
		self.window = window
		childCoordinators = []
		rootNavigationController = UINavigationController()
		dependencies = AppDependency(networkManager: NetworkManager(),
									 coreDaraService: CoreDataService())
		rootNavigationController.navigationBar.tintColor = .systemIndigo
	}

	// MARK: - Public Methods
	func start() {
		guard let window = window else { return }

		window.rootViewController = rootNavigationController
		window.makeKeyAndVisible()

		let startCoordinator = ArticlesListCoordinator(dependencies: dependencies,
												   rootNavigationController: rootNavigationController)
		childCoordinators.append(startCoordinator)
		startCoordinator.start()
	}
}
