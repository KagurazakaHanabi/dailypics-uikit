import Alamofire
import RxSwift
import SwiftyJSON
import SwiftyMarkdown
import UIKit

class TodayViewController: UITableViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    let disposeBag = DisposeBag()
    var today: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        onRefresh()
        self.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    @objc func onRefresh() {
        today.removeAll()

        let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
        let now = Date()
        let calendar = Calendar.current
        let comps = calendar.dateComponents(in: .current, from: now)
        dateLabel.text = "\(comps.month!) 月 \(comps.day!) 日 星期\(weekdays[comps.weekday! - 1])"

        Observable.zip(
            TujianApiProvider.rx.request(.text).mapString().asObservable(),
            TujianApiProvider.rx.request(.today).asObservable()
        ).subscribe(
            onNext: { text, todayRes in
                self.textLabel.text = text

                let todayArr = try! JSON(data: todayRes.data)
                for (_, element): (String, JSON) in todayArr {
                    self.today.append(Photo.fromJson(source: element))
                }
        }, onError: { error in
            self.textLabel.text = "不要扯我的呆毛，那是我的萌点所在..."
        }, onCompleted: {
            self.refreshControl?.endRefreshing()
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return today.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCell(withIdentifier: "PhotoCard", for: indexPath) as! PhotoCard
        let data = today[indexPath.row]

        var textColor: UIColor
        if data.color.isDark() {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }

        item.titleLabel.text = data.title
        item.titleLabel.textColor = textColor

        let md = SwiftyMarkdown(string: data.content)
        let plain = md.attributedString().string
        item.subtitleLabel.text = plain.components(separatedBy: "\n")[0]
        item.subtitleLabel.textColor = textColor.withAlphaComponent(179 / 255)

        Alamofire.request(data.cdnUrl).responseData(completionHandler: { result in
            let image = UIImage(data: result.data!)
            item.thumbnail.image = image
        })
        return item
    }

    func isDarkColor(color: UIColor) -> Bool {
        return false
    }
}
