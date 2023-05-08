//
//  HeroHeaderUIView.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 10/19/22.
//

import UIKit
import SDWebImage

protocol PlayButtonPressedDelegate: AnyObject {
    func didPressPlayButton(movie: Movie)
}

class HeroHeaderUIView: UIView {
    
    weak var playButtonDelegate: PlayButtonPressedDelegate?
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let heroImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "movie")
        return imageView
    }()
    
    private var movieName: Movie?
    
    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
        playButton.addTarget(self, action: #selector(didPressPlayButton), for: .touchUpInside)
    }
    
    @objc func didPressPlayButton() {
        print("Did tapped")
        guard let movie = movieName else { return }
        playButtonDelegate?.didPressPlayButton(movie: movie)
    }
    
    func configure(with movie: Movie) {
        guard let picturePath = URL(string: "https://image.tmdb.org/t/p/w500\(movie.poster_path ?? "")") else {return}
        
        heroImageView.sd_setImage(with: picturePath)
        movieName = movie
    }
    
    private func applyConstraints() {
        NSLayoutConstraint.activate([
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            playButton.widthAnchor.constraint(equalToConstant: 110),
            
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -80),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -40),
            downloadButton.widthAnchor.constraint(equalToConstant: 110)
        ])
    }
    
    override func layoutSubviews() {
        heroImageView.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
