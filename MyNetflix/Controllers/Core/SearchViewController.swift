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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchTableView)
        searchTableView.delegate = self
        searchTableView.dataSource = self
        fetchData()
        
        title = "Discover"
        configureNavBar()
        navigationItem.searchController = searchcontroller
        searchcontroller.searchResultsUpdater = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchTableView.frame = view.bounds
    }
    
    func fetchData() {
        APICaller.shared.getDiscoverMovie { [weak self] result in
            switch result{
            case.success(let movies):
                self?.movies = movies
                DispatchQueue.main.async {
                    self?.searchTableView.reloadData()
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let movieElement = movies[indexPath.item]
        guard let movieTitle = movieElement.original_name ?? movieElement.original_title else {return}
        guard let movieDescription = movieElement.overview else { return }
       
        APICaller.shared.getMovieFromYoutube(with: movieTitle) { [weak self] result in
            switch result {
            case.success(let movieResult):
                DispatchQueue.main.async {
                    let vc = TitlePreviewDetailViewController()
                    vc.configureProperties(with: TitleDitailModel(labelText: movieTitle, descritionLabel: movieDescription, webView: movieResult))
                    vc.modalPresentationStyle = .automatic
                    vc.modalTransitionStyle = .flipHorizontal
//                    self?.present(vc, animated: true)
                    self?.navigationController?.present(vc, animated: true)
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
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
    
    func movieSelected(with movie: Movie) {
        guard let title = movie.original_title ?? movie.original_name else {return}
            APICaller.shared.getMovieFromYoutube(with: title) { [weak self] result in
                switch result {
                case .success(let result):
                        guard let overView = movie.overview else { return }
                        let model = TitleDitailModel(labelText: title, descritionLabel: overView, webView: result)
                    DispatchQueue.main.async { [weak self] in
                        let vc = TitlePreviewDetailViewController()
                        vc.configureProperties(with: model)
                        vc.modalPresentationStyle = .formSheet
                        vc.modalTransitionStyle = .flipHorizontal
                        self?.navigationController?.present(vc, animated: true)
                    }
                case.failure(let error):
                    print(error)
            }
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty, query.trimmingCharacters(in: .whitespaces).count >= 3,
                let resultsController = searchController.searchResultsController as? SearchResultViewController else {return}
        APICaller.shared.search(withQuery: query) { result in
            DispatchQueue.main.async {
                switch result {
                case.success(let titles):
                    resultsController.searchResults = titles
                    resultsController.delegate = self
                    resultsController.movieCollectionView.reloadData()
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}

extension SearchViewController: SearchViewSelectDelegate {
    func didSelect(with movie: Movie) {
        movieSelected(with: movie)
    }
}
