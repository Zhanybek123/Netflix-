//
//  HomeViewController.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/19/22.
//

import UIKit

enum Sections: Int, CaseIterable {
    case trendingMovies, trendingTv, popular, upcoming, topRated
    
    var sectionTitle: String {
        switch self {
        case.trendingMovies:
            return "popular"
        case .trendingTv:
            return "trending Movies"
        case .popular:
            return "trending Tv Show"
        case .upcoming:
            return "upcoming"
        case .topRated:
            return "top Rated"
        }
    }
}

class HomeViewController: UIViewController {
    
    private var trendingMovies = [Movie]()
    private var trendingTvShows = [Movie]()
    private var popular = [Movie]()
    private var upcoming = [Movie]()
    private var topRated = [Movie]()
    
    private var randomHeaderImage: Movie?
    private var headerView: HeroHeaderUIView?
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    let navigationBarAppearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        headerView?.playButtonDelegate = self
        homeFeedTable.tableHeaderView = headerView
        
        configureNavBar()
        getHeaderImage()
        
        func getHeaderImage() {
            APICaller.shared.getTrendingMovies { [weak self] result in
                switch result {
                case .success(let movies):
                    guard let randomElement = movies.randomElement() else { return }
                    self?.headerView?.configure(with: randomElement)
                case.failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
        
        APICaller.shared.getTrendingMovies { [weak self]  results in
            switch results {
            case.success(let results):
                self?.trendingMovies = results
                DispatchQueue.main.async {
                    self?.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getTrendingTVs { [weak self] results in
            switch results {
            case.success(let results):
                self?.trendingTvShows = results
                DispatchQueue.main.async {
                    self?.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getPopularMovies { [weak self] results in
            switch results {
            case.success(let results):
                self?.popular = results
                DispatchQueue.main.async {
                    self?.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case.success(let results):
                self?.upcoming = results
                DispatchQueue.main.async {
                    self?.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getTopRatedMovies { [weak self] results in
            switch results {
            case.success(let results):
                self?.topRated = results
                DispatchQueue.main.async {
                    self?.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func openDetailViewController() {
        let vc = UIViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func configureNavBar() {
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = .black
        navigationController?.navigationBar.standardAppearance = navigationBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationBarAppearance
        navigationController?.navigationBar.tintColor = .white
        
        var image = UIImage(named: "netflix_PNG15")
        image = image?.withRenderingMode(.alwaysOriginal).resizeTo(size: CGSize(width: 25, height: 40))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)]
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
    
    func movieSelected(with movie: Movie) {
        guard let title = movie.original_title ?? movie.original_name else {return}
        guard let overView = movie.overview else { return }
        getMovieFromYoutube(withTitle: title, description: overView)
    }
    
    func getMovieFromYoutube(withTitle: String, description: String) {
        APICaller.shared.getMovieFromYoutube(with: withTitle) { [weak self] result in
            switch result {
            case .success(let result):
                DispatchQueue.main.async { [weak self] in
                    self?.openDetailViewController(withText: withTitle , descritionLabel: description, webView: result)
                    //                print(result)
                }
            case.failure(let error):
                print("\(error)  some shit happend")
            }
        }
    }
    
    func openDetailViewController(withText: String, descritionLabel: String, webView: VideoElement) {
        let model = TitleDitailModel(labelText: withText, descritionLabel: descritionLabel, webView: webView)
        let vc = TitlePreviewDetailViewController()
        vc.configureProperties(with: model)
        vc.modalPresentationStyle = .formSheet
        vc.modalTransitionStyle = .flipHorizontal
        self.navigationController?.present(vc, animated: true)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Sections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        switch Sections.allCases[indexPath.section] {
        case .trendingMovies:
            cell.collectionDelegate.data = trendingMovies
        case .trendingTv:
            cell.collectionDelegate.data = trendingTvShows
        case .popular:
            cell.collectionDelegate.data = popular
        case .upcoming:
            cell.collectionDelegate.data = upcoming
        case .topRated:
            cell.collectionDelegate.data = topRated
        }
        cell.collectionDelegate.selectDelegate = self
        cell.collectionView.reloadData()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    // disapearing navigationBar while scrolling down
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.bottom
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: .minimum(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Sections.allCases[section].sectionTitle
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        tableView.backgroundColor = .black
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.textColor = .white
        header.textLabel?.text? = header.textLabel?.text?.capitalizeFirstLetter() ?? ""
    }
}

extension HomeViewController: CollectionViewSelectDelegate {
    func didSelect(with movie: Movie) {
        movieSelected(with: movie)
    }
}

extension HomeViewController: PlayButtonPressedDelegate {
    func didPressPlayButton(movie: Movie) {
        movieSelected(with: movie)
    }
}
