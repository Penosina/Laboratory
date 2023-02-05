//
//  ArticleCellView.swift
//  Lab
//
//  Created by Abrosimov Ilya on 04.02.2023.
//

import UIKit

class ArticleCellView: UITableViewCell {

	@IBOutlet weak var articleImageView: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var counterLabel: UILabel!

	private var viewModel: ArticleCellViewModel?

	func configure(with viewModel: ArticleCellViewModel?) {
		self.viewModel = viewModel

		viewModel?.didUpdateData = { [weak self] in
			self?.titleLabel.text = viewModel?.title
			self?.counterLabel.text = "Количество просмотров: \(viewModel?.viewedTimes ?? 0)"
			if let image = viewModel?.image {
				self?.articleImageView.image = image
			}
		}

		viewModel?.start()
	}
}
