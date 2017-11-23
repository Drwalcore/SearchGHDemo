import SnapKit
import UIKit

class CellView: UIView {

    init() {
        super.init(frame: .zero)

        addSubviews()
        configureSubviews()
        configureAutolayout()
    }

    private func addSubviews() {

    }

    private func configureSubviews() {

    }

    private func configureAutolayout() {

    }

    // MARK: - Properties

    let tableView: UITableView = UITableView()

    // MARK: - Required initializer

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
