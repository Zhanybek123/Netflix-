//
//  TItleTableViewCellCellTableViewCell.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 11/14/22.
//

import UIKit
import SDWebImage

class TItleTableViewCell: UITableViewCell {
    
    static let identifier = "TItleTableViewCell"
    
    private var moviePicture: UIImageView = {
       let image = UIImageView()
//        image.clipsToBounds = true
        image.contentMode = UIView.ContentMode.scaleAspectFit
        image.layer.cornerRadius = 5
        return image
    }()
    
    private var label: UILabel = {
       let label = UILabel()
        return label
    }()
    
    private let playIcon: UIImageView = {
       let image = UIImageView()
        image.contentMode = .scaleToFill
//        image.layer.masksToBounds
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProperties() {
        [moviePicture, label, playIcon] .forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false }
            NSLayoutConstraint.activate([
                moviePicture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                moviePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                moviePicture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                moviePicture.widthAnchor.constraint(equalToConstant: 100),
                
                label.leadingAnchor.constraint(equalTo: moviePicture.trailingAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                playIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                playIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    
    func configureCell(with model: UpcomingModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.moviePicturePath)") else { return }
        moviePicture.sd_setImage(with: url)
        self.label.text = model.title
    }
}
