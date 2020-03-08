import SwiftyMarkdown
import UIKit

class DetailsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!

    var data: Photo? = nil

    override func viewDidLoad() {
        super.viewDidLoad()
        let md = SwiftyMarkdown(string: data!.content)
        titleLabel.text = data!.title
        contentLabel.attributedText = md.attributedString()
    }
}
