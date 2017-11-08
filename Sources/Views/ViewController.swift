import UIKit
import AFNetworking
import MBProgressHUD

// swiftlint:disable force_cast

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    public var dataProvider: MockDataProviderProtocol?

    enum CellType: String {

        case repository
        case user
    }

    var searchBar: UISearchBar!
    var searchPreRequisities = GitHubAPIConditions()
    var searchUsersParameters = GitHubAPIUsers()
    var cellsData: [[CellType: AnyObject]] = []
    private var requestOperations: [AFHTTPRequestOperation] = []
    var objectForDetail: [CellType: AnyObject]?

    override func viewDidLoad() {
        super.viewDidLoad()

        searchBarSetUp()
        tableViewPreSetup()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

// MARK: TableView Set Up and Options

    func tableViewPreSetup() {

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let reusableCell = self.tableView.dequeueReusableCell(withIdentifier: "CustomGITCell", for: indexPath) as! CustomGITCell

        let cellData = cellsData[indexPath.row]
        switch cellData.keys.first! {
        case .repository:
            let repo = cellData.values.first as! GitHubAPI
            reusableCell.nameLabel?.text = repo.name
            reusableCell.descriptionLabel?.text = repo.description
        case .user:
            let user = cellData.values.first as! User
            reusableCell.nameLabel?.text = user.login
            reusableCell.descriptionLabel?.text = user.repoURL
        }
        reusableCell.cellTypeLabel.text = cellData.keys.first!.rawValue

        return reusableCell

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cellsData.count
    }

    public func startSearch(withText text: String) {
        MBProgressHUD.hide(for: self.view, animated: true)
        for operation in requestOperations {
            operation.cancel()
        }
        searchPreRequisities.searchString = text
        searchUsersParameters.searchString = text
        cellsData = []
        searchInit()
        searchUsers()
        dataProvider?.startSearch()
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        objectForDetail = cellsData[indexPath.row]
        performSegue(withIdentifier: "DetailSegue", sender: nil)

    }

// MARK: Search Bar Setup and Options

    func searchBarSetUp() {

        searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.placeholder = "Type to search GitHub repositories!"

        searchBar.autocorrectionType = .no
        searchBar.autocapitalizationType = .none
        searchBar.spellCheckingType = .no

        searchBar.sizeToFit()
        navigationItem.titleView = searchBar
    }

    internal func searchInit() {

        MBProgressHUD.showAdded(to: self.view, animated: true)

        let operation = GitHubAPI.startRepoFetch(settings: searchPreRequisities, successCallback: { repositories -> Void in

            for repository in repositories {
                self.cellsData.append([CellType.repository: repository])
                print("[Name: \(repository.name!)]" +
                    "\n\t[Description: \(repository.description)]" +
                    "\n\t[Stars: \(repository.stars!)]" +
                    "\n\t[Owner: \(repository.ownerLogin!)]" +
                    "\n\t[Avatar: \(repository.ownerAvatarURL!)]")

            }
            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            self.tableView.reloadData()

        }, error: { error -> Void in

            DispatchQueue.main.async {
                MBProgressHUD.hide(for: self.view, animated: true)
            }
            print(error!)

        })
        requestOperations.append(operation)
    }

    func searchUsers() {
        let operation = GitHubAPI.startUsersFetch(settings: searchUsersParameters, successCallback: { users in
            for user in users {
                self.cellsData.append([CellType.user: user])
                print("login: \(user.login)")
                print("url: \(user.repoURL)")
            }
            self.tableView.reloadData()
        }) { error in
            print(error)
        }
        requestOperations.append(operation)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! DetailViewController
        if let object = objectForDetail {
            switch object.keys.first! as CellType {
            case .repository:
                vc.update(withRepository: object.values.first! as! GitHubAPI)
            case .user:
                vc.update(withUser: object.values.first! as! User)
            }
        }
    }
}

extension ViewController: UISearchBarDelegate {

    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        return true
    }

    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {

        searchBar.setShowsCancelButton(false, animated: true)
        return true
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {

        searchBar.text = ""
        searchBar.resignFirstResponder()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        startSearch(withText: searchBar.text ?? "")
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        startSearch(withText: searchText)

    }

}
