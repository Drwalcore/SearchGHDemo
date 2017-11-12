import SnapKit
import UIKit

class CustomCell: UITableViewCell {

    let cellView: CellView = CellView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = UIColor.clear
        addSubview(cellView)

        cellView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Required initializer

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
