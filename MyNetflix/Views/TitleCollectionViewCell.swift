
import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private var posterImageView: UIImageView = {
        let image = UIImageView()
        image.layer.masksToBounds = true
        image.layer.cornerRadius = 5
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(posterImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("OHH yo YULYA")
    }
    
    override func layoutSubviews() {
        posterImageView.frame = contentView.bounds
    }
    
    func configure(with model: String?) {
        guard let model = model else {return}
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(model)") else { return }
        posterImageView.sd_setImage(with: url, completed: nil)
        print(url)
    }
}
