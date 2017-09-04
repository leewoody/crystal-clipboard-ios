//
//  ClipsViewController.swift
//  CrystalClipboard
//
//  Created by Justin Mazzocchi on 8/29/17.
//  Copyright © 2017 Justin Mazzocchi. All rights reserved.
//

import UIKit
import CoreData
import ReactiveSwift
import ReactiveCocoa
import PKHUD

class ClipsViewController: UIViewController, PersistentContainerSettable, ProviderSettable {
    var persistentContainer: NSPersistentContainer!
    var provider: APIProvider!
    
    private lazy var viewModel: ClipsViewModel! = ClipsViewModel(provider: self.provider, persistentContainer: self.persistentContainer)
    @IBOutlet private weak var tableView: UITableView!
    private let loadingFooterView = LoadingFooterView.fromNib()!
    private static let copiedHUDFlashDelay: TimeInterval = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // View model inputs
        
        let willEnterForeground = NotificationCenter.default.reactive.notifications(forName: .UIApplicationWillEnterForeground).take(during: reactive.lifetime).map { _ in Void() }
        let viewWillAppear = reactive.trigger(for: #selector(UIViewController.viewWillAppear(_:)))
        viewModel.viewAppearing <~ SignalProducer(values: willEnterForeground, viewWillAppear).flatten(.merge)
        viewModel.setFetchedResultsControllerDelegate(tableView)
        
        // View model outputs
        
        tableView.dataSource = viewModel.dataSource
        viewModel.textToCopy.observe(on: UIScheduler()).observeValues {
            UIPasteboard.general.string = $0
            UINotificationFeedbackGenerator().notificationOccurred(.success)
            HUD.flash(.labeledSuccess(title: "clips.copied".localized, subtitle: $0), delay: ClipsViewController.copiedHUDFlashDelay)
        }
        viewModel.clipsPresent.producer.startWithValues { [unowned self] in
            switch $0 {
            case .all: self.tableView.tableFooterView = nil
            case .some: self.tableView.tableFooterView = self.loadingFooterView
            case .none: self.tableView.tableFooterView = nil
            }
        }
        
        // Other setup
        
        tableView.tableFooterView = loadingFooterView
    }
}
