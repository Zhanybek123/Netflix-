//
//  HomeViewController.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/19/22.
//

import UIKit

enum Sections: Int {
    case trendingMovies, trendingTv, popular, upcoming, topRated
}

class HomeViewController: UIViewController {
    
    private var movies = [Movie]()
    private var tvShows = [Movie]()
    private var popular = [Movie]()
    private var upcoming = [Movie]()
    private var topRated = [Movie]()
    
    let sectionTitles: [String] = ["Trending Movie", "Trending TV", "Popular",  "Upcomming Movies", "Top Rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(homeFeedTable)
        
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        homeFeedTable.tableHeaderView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        
        configureNavBar()
        
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case.success(let results):
                self.movies = results
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
                self.tvShows = results
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
        var image = UIImage(named: "netflix_PNG15")
        image = image?.withRenderingMode(.alwaysOriginal).resizeTo(size: CGSize(width: 25, height: 40))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)]
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

extension UIImage {
    func resizeTo(size: CGSize) -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: size)
        let image = renderer.image { i in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
        return image.withRenderingMode(self.renderingMode)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        switch indexPath.section{
        case Sections.trendingMovies.rawValue:
            cell.configureMovies(with: movies)
        case Sections.trendingTv.rawValue:
            cell.configureMovies(with: tvShows)
        case Sections.popular.rawValue:
            cell.configureMovies(with: popular)
        case Sections.upcoming.rawValue:
            cell.configureMovies(with: upcoming)
        case Sections.topRated.rawValue:
            cell.configureMovies(with: topRated)
        default:
            return UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        nil
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.bottom
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: .minimum(0, -offset))
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        tableView.backgroundColor = .black
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        header.textLabel?.frame = CGRect(x: view.bounds.origin.x + 120, y: view.frame.origin.y/4, width: 100, height: view.frame.height)
        header.frame = CGRect(x: 20, y: 20, width: 100, height: 100)
        header.textLabel?.textColor = .white
        header.textLabel?.text? = header.textLabel?.text?.capitalizeFirstLetter() ?? ""
    }
    
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        tableView.backgroundColor = .blue
    }
}

