//
//  CurrentTripViewModel.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import Combine
import SwiftUI

class CurrentTripViewModel: ObservableObject {
    // MARK: Publishers

    @Published var locations: String = ""
    @Published private var secondsElapsed = 0.0
    var seconds: String {
        return format(secondsElapsed)
    }

    // MARK: Members

    private let tripManager: TripManagerProtocol
    private var locationSubscriber: AnyCancellable?
    private var timer: Timer = Timer()

    // MARK: Init

    init(tripManager: TripManagerProtocol = TripManager()) {
        self.tripManager = tripManager
    }

    // MARK: Intents

    func startTrip() {
        secondsElapsed = 55
        locationSubscriber = tripManager.locationPipline.sink { [self] newLocation in
            locations.append("Lat: \(newLocation.coordinate.latitude.description)")
            locations.append("Long: \(newLocation.coordinate.longitude.description)")
        }
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.secondsElapsed += 1
        }
        tripManager.startTrip()
    }

    func endTrip() {
        timer.invalidate()
        tripManager.endTrip()
    }

    private func format(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.zeroFormattingBehavior = [.dropLeading]
        return formatter.string(from: duration) ?? "0"
    }
}
