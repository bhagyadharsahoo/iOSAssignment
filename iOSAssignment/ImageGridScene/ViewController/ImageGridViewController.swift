//
//  ImageGridViewController.swift
//  iOSAssignment
//
//  Created by Bhagyadhar Sahoo on 14/04/24.
//

import UIKit
import Combine

class ImageGridViewController: UIViewController {
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    //MARK: Properties:-
    private lazy var dataSource = createDataSource()
    private let viewModel: ImageGridViewModel
    private var cancellable: Set<AnyCancellable> = []
    
    init(_ viewModel: ImageGridViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) { fatalError() }

}

//MARK: View LifeCycles:-
extension ImageGridViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        bind(to: viewModel)
        viewModel.viewDidLoad()
        theCellRegistration()
        configCompositionalLayout()
        collectionView.dataSource = dataSource
    }
    
    private func bind(to viewModel: ImageGridViewModel) {
        viewModel.$images.receive(on: DispatchQueue.main)
            .sink { images in
                self.applySnapShot(images)
            }.store(in: &cancellable)
    }
}

typealias DataSource = UICollectionViewDiffableDataSource<ImageGridViewController.Section, ImageData>

extension ImageGridViewController {
    private func theCellRegistration() {
        collectionView.register(ImageGridCollectionCell.nib, forCellWithReuseIdentifier: ImageGridCollectionCell.identifier)
    }
    
    private func createDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { collectionView, indexPath, image in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageGridCollectionCell.identifier, for: indexPath) as! ImageGridCollectionCell
            cell.configure(cell: image)
            return cell
        }
    }
    
    private func applySnapShot(_ forImageData: [ImageData]) {
        var snapShot = NSDiffableDataSourceSnapshot<Section, ImageData>()
        snapShot.appendSections([.main])
        snapShot.appendItems(forImageData, toSection: .main)
        dataSource.apply(snapShot, animatingDifferences: true)
    }
    
    @frozen enum Section {
        case main
    }
}

//MARK: Compositional Layout:-
extension ImageGridViewController {
    
    private func configCompositionalLayout() {
        let layout = UICollectionViewCompositionalLayout { section, env in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1/3), heightDimension: .fractionalHeight(1))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalWidth(1/3))
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            let section = NSCollectionLayoutSection(group: group)
            return section
        }
        collectionView.setCollectionViewLayout(layout, animated: true)
    }
}
