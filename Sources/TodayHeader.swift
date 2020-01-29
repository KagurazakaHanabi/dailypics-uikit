import UIKit

class TodayHeader: UIView {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!

    override func layoutSubviews() {
        super.layoutSubviews()
        let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
        let now = Date()
        let calendar = Calendar.current
        let comps = calendar.dateComponents(in: .current, from: now)
        dateLabel.text = "\(comps.month!) 月 \(comps.day!) 日 星期\(weekdays[comps.weekday! - 1])"
    }
}
