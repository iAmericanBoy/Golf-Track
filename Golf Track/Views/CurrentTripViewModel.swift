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
    @Published private var secondsElapsed: Decimal = 0.0
    var seconds: String {
        return secondsElapsed.description
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
        locationSubscriber = tripManager.locationPipline.sink { [self] newLocation in
            locations.append("Lat: \(newLocation.coordinate.latitude.description)")
            locations.append("Long: \(newLocation.coordinate.longitude.description)")
        }
        timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
            self.secondsElapsed += 0.1
        }
        tripManager.startTrip()
    }

    func endTrip() {
        timer.invalidate()
        tripManager.endTrip()
    }
}
