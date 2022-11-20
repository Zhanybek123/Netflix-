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
        image.clipsToBounds = true
        image.contentMode = UIView.ContentMode.scaleAspectFit
        return image
    }()
    
    private var label: UILabel = {
       let label = UILabel()
        label.textColor = .white
        return label
    }()
    
    private let playIcon: UIButton = {
       let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 30))
        button.setImage(image, for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .white
        return button
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureProperties()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureProperties() {
        [moviePicture, label, playIcon] .forEach { property in
            contentView.addSubview(property)
            property.translatesAutoresizingMaskIntoConstraints = false }
            NSLayoutConstraint.activate([
                moviePicture.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                moviePicture.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                moviePicture.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
                moviePicture.widthAnchor.constraint(equalToConstant: 100),
                
                label.leadingAnchor.constraint(equalTo: moviePicture.trailingAnchor, constant: 10),
                label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                
                playIcon.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
//                playIcon.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
                playIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
            ])
        }
    
    func configureCell(with model: UpcomingModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model.moviePicturePath)") else { return }
        moviePicture.sd_setImage(with: url)
        self.label.text = model.title
    }
}
