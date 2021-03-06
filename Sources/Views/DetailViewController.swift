import UIKit

// swiftlint:disable identifier_name

class DetailViewController: UIViewController {

    @IBOutlet weak var Avatar: UIImageView!
    @IBOutlet weak var OwnerName: UILabel!
    @IBOutlet weak var StarsNumber: UILabel!
    @IBOutlet weak var StarImage: UIImageView!
    @IBOutlet weak var RepoName: UILabel!
    @IBOutlet weak var RepoDescription: UILabel!
    @IBOutlet weak var linkButton: UIButton!

    private var user: User?
    private var repo: GitHubAPI?

    func update(withUser user: User) {
        self.user = user
    }

    func update(withRepository repo: GitHubAPI) {
        self.repo = repo
    }

    func downloadImage(link: String?) {
        guard let linkVal = link else {
            return
        }
        let url = URL(string: linkVal)
        Avatar.setImageWith(url!)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        updateLayout()

            if user != nil {
                setUserInfo()
            } else {
                setRepoInfo()
        }
    }

    private func setUserInfo() {
        guard let userVal = user else {
            return
        }

        RepoDescription.isHidden = true
        RepoName.isHidden = true
        StarImage.isHidden = true
        StarsNumber.isHidden = true
        OwnerName.text = userVal.login
        linkButton.setTitle(userVal.repoURL ?? "", for: .normal)
        downloadImage(link: userVal.avatarURL)
    }

    private func setRepoInfo() {

        guard let repoVal = repo else {
            return
        }

        linkButton.isHidden = true
        RepoDescription.text = repoVal.description
        StarsNumber.text = "\(repoVal.stars ?? 0)"+" x"
        RepoName.text = "Repository name: " + (repoVal.name)!
        OwnerName.text = repoVal.ownerLogin
        downloadImage(link: repoVal.ownerAvatarURL)
    }

    private func updateLayout() {
        RepoDescription.adjustsFontSizeToFitWidth = true
        RepoName.adjustsFontSizeToFitWidth = true
        OwnerName.adjustsFontSizeToFitWidth = true

    }

    @IBAction func linkButtonPressed(_ sender: AnyObject) {

        let link = URL(string: user!.repoURL!)
        UIApplication.shared.open(link!,
                                  options: [:],
                                  completionHandler: nil)
    }

}
