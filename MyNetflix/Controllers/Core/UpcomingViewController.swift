//
//  UpcomingViewController.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/19/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var movies = [Movie]()
    
    private let upcomingTableVeiw: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .white
        table.register(TItleTableViewCell.self, forCellReuseIdentifier: TItleTableViewCell.identifier)
        return table
    }()
    
    let appearance = UINavigationBarAppearance()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(upcomingTableVeiw)
        upcomingTableVeiw.delegate = self
        upcomingTableVeiw.dataSource = self
        fetchData()
        
        title = "Upcoming Movies"
        configureNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTableVeiw.frame = view.bounds
    }
    
    func fetchData() {
        APICaller.shared.getTrendingMovies { result in
            switch result {
            case.success(let results):
                self.movies = results
                DispatchQueue.main.async {
                    self.upcomingTableVeiw.reloadData()
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
}


extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TItleTableViewCell.identifier, for: indexPath) as? TItleTableViewCell else { return UITableViewCell() }
        let moviePath = movies[indexPath.item]
        cell.configureCell(with: UpcomingModel(moviePicturePath: moviePath.poster_path ?? "", title: (moviePath.original_name ?? moviePath.original_title) ?? "Unavailable"))
        cell.backgroundColor = .black
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
