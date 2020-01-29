import RxSwift
import UIKit

class TodayViewController: UITableViewController {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        onRefresh()
        self.refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
    }

    @objc func onRefresh() {
        let weekdays = ["日", "一", "二", "三", "四", "五", "六"]
        let now = Date()
        let calendar = Calendar.current
        let comps = calendar.dateComponents(in: .current, from: now)
        dateLabel.text = "\(comps.month!) 月 \(comps.day!) 日 星期\(weekdays[comps.weekday! - 1])"
        
        TujianApiProvider.rx.request(.text).mapString().asObservable().subscribe(
            onNext: { result in
                self.textLabel.text = result
        }, onError: { error in
            self.textLabel.text = "不要扯我的呆毛，那是我的萌点所在..."
        }, onCompleted: {
            self.refreshControl?.endRefreshing()
        }).disposed(by: disposeBag)
    }

    // MARK: - Table view data source

    /*override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            return tableView.dequeueReusableCell(withIdentifier: "TodayHeader")!
        }
        return tableView.dequeueReusableCell(withIdentifier: "PhotoCard", for: indexPath)
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}
