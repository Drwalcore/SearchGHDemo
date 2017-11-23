import SnapKit
import UIKit

class MainView: UIView {

    init() {
        super.init(frame: .zero)

        addSubviews()
        configureSubviews()
        configureAutolayout()
    }

    private func addSubviews() {
        addSubview(tableView)
    }

    private func configureSubviews() {

    }

    private func configureAutolayout() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    // MARK: - Properties

    let tableView: UITableView = UITableView()

    // MARK: - Required initializer

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
