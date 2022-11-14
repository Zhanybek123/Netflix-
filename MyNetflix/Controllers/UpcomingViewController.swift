//
//  UpcomingViewController.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/19/22.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    static let idendifier = "UpcomingViewController"

    private var movies = [Movie]()
    
    private let upcomingTableVeiw: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.backgroundColor = .white
        table.register(TItleTableViewCell.self, forCellReuseIdentifier: TItleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.addSubview(upcomingTableVeiw)
        upcomingTableVeiw.delegate = self
        upcomingTableVeiw.dataSource = self
        fetchData()
        
        title = "Upcoming Movies"
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
}


extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TItleTableViewCell.identifier, for: indexPath) as? TItleTableViewCell else { return UITableViewCell() }
        let moviePath = movies[indexPath.item]
        cell.configureCell(with: UpcomingModel(moviePicturePath: moviePath.poster_path ?? "", title: (moviePath.original_name ?? moviePath.original_title) ?? "Unavailable"))
        return cell
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    
    
}
