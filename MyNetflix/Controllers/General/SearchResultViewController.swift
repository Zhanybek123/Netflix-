//
//  SearchResultViewController.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 11/20/22.
//

import UIKit

class SearchResultViewController: UIViewController {
    
    var searchResults: [Movie] = []
    
    private let movieTableView: UITableView = {
        let table = UITableView(frame: .zero, style: .insetGrouped)
        table.register(TItleTableViewCell.self, forCellReuseIdentifier: TItleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(movieTableView)
        movieTableView.dataSource = self
        movieTableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        movieTableView.frame = view.bounds
        
    }
}

extension SearchResultViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        searchResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TItleTableViewCell.identifier, for: indexPath) as? TItleTableViewCell else { return UITableViewCell() }
        let picturePath = searchResults[indexPath.row]
        cell.configureCell(with: UpcomingModel(moviePicturePath: picturePath.poster_path ?? "", title: picturePath.original_name ?? picturePath.original_title ?? ""))
//        cell.textLabel?.text = "something"
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        50
    }
}
