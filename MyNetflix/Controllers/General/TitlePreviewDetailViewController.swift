//
//  TitlePreviewDetailViewController.swift
//  MyNetflix
//
//  Created by zhanybek salgarin on 4/14/23.
//

import UIKit
import WebKit

class TitlePreviewDetailViewController: UIViewController {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Something for now"
        label.font = .systemFont(ofSize: 22)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.text = "Here is going to be a description"
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .red
        button.clipsToBounds = true
        button.layer.cornerRadius = 8
        return button
    }()
    
    private let webView: WKWebView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        
    }
    
    func configure() {
        [webView, titleLabel, descriptionLabel, downloadButton].forEach { property in
            view.addSubview(property)
            property.translatesAutoresizingMaskIntoConstraints = false
        }
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: view.bounds.height/3),
            
            titleLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            descriptionLabel.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            
            downloadButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            downloadButton.centerXAnchor.constraint(equalTo: webView.centerXAnchor),
            downloadButton.widthAnchor.constraint(equalToConstant: view.bounds.width/3)
        ])
    }
    func configureProperties(with model: TitleDitailModel) {
        titleLabel.text = model.labelText
        descriptionLabel.text = model.descritionLabel
        
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.webView.id.videoId)") else {return}
        
        webView.load(URLRequest(url: url))
    }
}
