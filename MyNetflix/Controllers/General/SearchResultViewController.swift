//
//  SearchResultViewController.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 11/20/22.
//

import UIKit

protocol SearchViewSelectDelegate: AnyObject {
    func didSelect(with movie: Movie)
}

class SearchResultViewController: UIViewController {
    
    var searchResults: [Movie] = []
    weak var delegate: SearchViewSelectDelegate?
    
    let movieCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        let table = UICollectionView(frame: .zero, collectionViewLayout: layout)
        table.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(movieCollectionView)
        movieCollectionView.dataSource = self
        movieCollectionView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieCollectionView.frame = view.bounds
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        let title = searchResults[indexPath.item]
        cell.configure(with: title.poster_path)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        delegate?.didSelect(with: searchResults[indexPath.item])
    }
}
