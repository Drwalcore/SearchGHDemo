import Foundation

class CustomGITCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var cellTypeLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        nameLabel.preferredMaxLayoutWidth = nameLabel.frame.size.width
        descriptionLabel.preferredMaxLayoutWidth = descriptionLabel.frame.size.width
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
