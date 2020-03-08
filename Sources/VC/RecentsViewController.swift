import UIKit

class RecentsViewController: UITableViewController, UISearchResultsUpdating {

    var recents: [Photo] = []
    var searchResults: [Photo] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.title = "以往"
        refreshControl?.addTarget(self, action: #selector(onRefresh), for: .valueChanged)
        onRefresh()
    }

    @objc func onRefresh() -> Void {
        recents.removeAll()

        // ...
    }

    func updateSearchResults(for searchController: UISearchController) {
        searchResults.removeAll()

        // ...
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if navigationItem.searchController?.isActive ?? false {
            return searchResults.count
        } else {
            return recents.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = tableView.dequeueReusableCell(withIdentifier: "PhotoCard", for: indexPath) as! PhotoCard
        let index = indexPath.row

        if navigationItem.searchController?.isActive ?? false {
            item.load(data: searchResults[index])
        } else {
            item.load(data: recents[index])
        }

        return item
    }
}
