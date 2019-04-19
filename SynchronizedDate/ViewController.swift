//
//  ViewController.swift
//  SynchronizedDate
//
//  Created by Juan Carlos Ospina Gonzalez on 19/04/2019.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var labelSynchronized: UILabel!
    @IBOutlet weak var labelDeviceTime: UILabel!
    private let synchronizedDateService: SynchronizedDateProvider = AppConfiguration.synchronizedDateProvider
    private let sourceOfTruthRemoteDateProvider: SourceOfTruthRemoteDateProvider = AppConfiguration.sourceOfTruthRemoteDateProvider
    override func viewDidLoad() {
        super.viewDidLoad()
        addEventListeners()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchSourceOftruthDate()
        reloadLocalTime()
    }
    private func addEventListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(onAppForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    @objc private func onAppForeground() {
        fetchSourceOftruthDate()
        reloadLocalTime()
    }
    private func reloadLocalTime() {
        display(date: Date(), inLabel: labelDeviceTime)
    }
    private func fetchSourceOftruthDate() {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        labelSynchronized.text = "Loading..."
        sourceOfTruthRemoteDateProvider.fetchSourceOfTruthDate(completion: {[weak self] date in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let self = self else {
                return
            }
            if let date = date {
                self.synchronizedDateService.setSourceOfTruth(date: date)
                self.display(date:self.synchronizedDateService.synchronizedDate, inLabel: self.labelSynchronized)
            } else {
                self.labelSynchronized.text = "Error fetching date"
            }
        })
    }
    private func display(date: Date, inLabel label: UILabel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        label.text = dateFormatter.string(from: date)
    }
}

