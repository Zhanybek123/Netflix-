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
}
