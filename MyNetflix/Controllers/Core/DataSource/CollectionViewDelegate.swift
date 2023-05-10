//
//  CollectionViewDelegate.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 4/15/23.
//

import Foundation
import UIKit

protocol CollectionViewSelectDelegate: AnyObject {
    func didSelect(with movie: Movie)
}

class CollectionViewDelegate: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var data: [Movie] = []
    weak var selectDelegate: CollectionViewSelectDelegate?
    
    func downloadTitleAt(indexPaths: [IndexPath]) {
        
//        TitleItemName.shared.downloadTitleWith(model: data[indexPaths.count]) { result in
//            switch result {
//            case .success():
//                print("Downloaded into database")
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell
        else {
            print("CollectionView didn't load")
            return UICollectionViewCell()
        }
        cell.configure(with: data[indexPath.item].poster_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDelegate?.didSelect(with: data[indexPath.item])
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil) { _ in
                let downloadAction = UIAction(title: "Download", subtitle: "Please press to download", image: UIImage(systemName: "square.and.arrow.down"), identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
                    self.downloadTitleAt(indexPaths: indexPaths)
                }
                return UIMenu(title: "Options", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
            }
        return config
    }
}
