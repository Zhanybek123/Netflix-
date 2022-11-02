
import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private var posterView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        return image
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)

    }
    
    required init?(coder: NSCoder) {
        fatalError("OHH yo YULYA")
    }
    
    override func layoutSubviews() {
        posterView.frame = contentView.bounds
    }
    
    func configure(with model: String) {
        guard let url = URL(string: model) else { return }
        posterView.sd_setImage(with: url, completed: nil)
    }
}
