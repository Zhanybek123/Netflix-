//
//  SearchViewController.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/19/22.
//

import UIKit

class SearchViewController: UIViewController {
    
    private var movies = [Movie]()
    
    private let searchTableView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 120, height: 200)
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collection
    }()
    
    private let appearance = UINavigationBarAppearance()
    
    private let searchcontroller: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultViewController())
        controller.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "Search", attributes: [NSAttributedString.Key.foregroundColor: UIColor.black])
        controller.searchBar.searchBarStyle = .prominent
        return controller
    }()
    
    //    private let seachBar: UISearchBar = {
    //        let searchBar = UISearchBar()
    //        searchBar.tintColor = .red
    //        searchBar.barTintColor = .red
    //        return searchBar
    //    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        fetchData()
        
        title = "Search"
        configureNavBar()
        navigationItem.searchController = searchcontroller
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    
    func fetchData() {
        APICaller.shared.getDiscoverMovie { result in
            switch result{
            case.success(let movies):
                self.movies = movies
                DispatchQueue.main.async {
                    self.searchTableView.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barTintColor = UIColor.black
        //        navigationController?.navigationItem.largeTitleDisplayMode = .always
        appearance.titleTextAttributes = [.foregroundColor:UIColor.white]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .black
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        searchcontroller.searchBar.searchTextField.textColor = .black
        searchcontroller.searchBar.tintColor = .white
        searchcontroller.searchBar.searchTextField.backgroundColor = .white
    }
}


extension SearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        collectionView.backgroundColor = .black
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(with: movies[indexPath.item].poster_path ?? "")
        return cell
    }
    
    
}
