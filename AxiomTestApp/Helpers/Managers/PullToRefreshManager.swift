//
//  PullToRefreshManager.swift
//  AxiomTestApp
//
//  Created by Mhd Baher on 23/06/2023.
//

import Foundation
import UIKit

class PullToRefreshManager {
    private let tableView: UITableView
    private let refreshControl = UIRefreshControl()
    private var loadDataHandler: (() -> Void)?

    init(tableView: UITableView) {
        self.tableView = tableView
        setupRefreshControl()
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    func setLoadDataHandler(_ handler: @escaping () -> Void) {
        loadDataHandler = handler
    }

    @objc private func refreshData() {
        loadDataHandler?()
    }

    func endRefreshing() {
        refreshControl.endRefreshing()
    }
}
