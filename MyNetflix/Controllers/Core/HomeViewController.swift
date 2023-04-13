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
        case.popular:
            return "popular"
        case .trendingMovies:
            return "trending Movies"
        case .trendingTv:
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
        homeFeedTable.tableHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        
        configureNavBar()
        APICaller.shared.getMovie(with: "harry potter") { results in
            print(results)
        }
        
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case.success(let results):
                self.trendingMovies = results
                DispatchQueue.main.async {
                    self.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getTrendingTVs { results in
            switch results {
            case.success(let results):
                self.trendingTvShows = results
                DispatchQueue.main.async {
                    self.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getPopularMovies { results in
            switch results {
            case.success(let results):
                self.popular = results
                DispatchQueue.main.async {
                    self.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getUpcomingMovies { results in
            switch results {
            case.success(let results):
                self.upcoming = results
                DispatchQueue.main.async {
                    self.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
        
        APICaller.shared.getTopRatedMovies { results in
            switch results {
            case.success(let results):
                self.topRated = results
                DispatchQueue.main.async {
                    self.homeFeedTable.reloadData()
                }
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
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
        
        cell.collectionView.dataSource = self
        cell.collectionView.delegate = self
        cell.collectionView.tag = indexPath.section
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

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell
        else {
            print("CollectionView didn't load")
            return UICollectionViewCell()
        }
        switch collectionView.tag {
        case Sections.popular.rawValue:
            cell.configure(with: popular[indexPath.item].poster_path)
        case Sections.trendingMovies.rawValue:
            cell.configure(with: trendingMovies[indexPath.item].poster_path)
        case Sections.trendingTv.rawValue:
            cell.configure(with: trendingTvShows[indexPath.item].poster_path)
        case Sections.upcoming.rawValue:
            cell.configure(with: upcoming[indexPath.item].poster_path)
        case Sections.topRated.rawValue:
            cell.configure(with: topRated[indexPath.item].poster_path)
        default:
            return UICollectionViewCell()
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch collectionView.tag {
        case Sections.popular.rawValue:
            return popular.count
        case Sections.trendingMovies.rawValue:
            return trendingMovies.count
        case Sections.trendingTv.rawValue:
            return trendingTvShows.count
        case Sections.upcoming.rawValue:
            return upcoming.count
        case Sections.topRated.rawValue:
            return topRated.count
        default:
            return 0
        }
    }
}
