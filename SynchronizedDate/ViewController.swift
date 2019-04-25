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
    /// Creates event listeners to keep the date synchronized
    private func addEventListeners() {
        NotificationCenter.default.addObserver(self, selector: #selector(syncDate), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(syncDate), name: Notification.Name.NSSystemClockDidChange, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(syncDate), name: UIApplication.significantTimeChangeNotification, object: nil)
    }
    /// Attemps to resynchronize both remote and local `Date`
    @objc private func syncDate() {
        fetchSourceOftruthDate()
        reloadLocalTime()
    }
    /// Calls `fetchSourceOfTruthDate(completion:)`
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
    /// Outputs the local "unsynchronized" Date to the `labelDeviceTime`
    private func reloadLocalTime() {
        display(date: Date(), inLabel: labelDeviceTime)
    }
    /// A convenience method to display a formatted date in a `UILabel`
    private func display(date: Date, inLabel label: UILabel) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        label.text = dateFormatter.string(from: date)
    }
}

