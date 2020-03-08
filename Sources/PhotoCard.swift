import AlamofireImage
import SwiftyMarkdown
import UIKit

class PhotoCard: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var thumbnail: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func load(data: Photo) -> Void {
        let textColor: UIColor = data.color.isDark() ? UIColor.white : UIColor.black

        titleLabel.text = data.title
        titleLabel.textColor = textColor

        let md = SwiftyMarkdown(string: data.content)
        let plain = md.attributedString().string
        subtitleLabel.text = plain.components(separatedBy: "\n")[0]
        subtitleLabel.textColor = textColor.withAlphaComponent(179 / 255)
        thumbnail.af.setImage(
            withURL: URL.init(string: data.cdnUrl)!,
            placeholderImage: UIImage(named: "Placeholder"),
            filter: AspectScaledToFillSizeWithRoundedCornersFilter(
                size: thumbnail.frame.size,
                radius: 16
            ),
            imageTransition: .crossDissolve(0.2)
        )
    }
}
