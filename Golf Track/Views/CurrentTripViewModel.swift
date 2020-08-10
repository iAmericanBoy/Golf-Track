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
    @Published private var currentSpeed: Measurement<UnitSpeed> = Measurement(value: 0, unit: .metersPerSecond)
    @Published private var currentDistance: Measurement<UnitLength> = Measurement(value: 0, unit: .meters)
    @Published private var currentAltitude: Measurement<UnitLength> = Measurement(value: 0, unit: .meters)

    var altitude: String {
        return format(currentAltitude)
    }

    var time: String {
        return format(secondsElapsed)
    }

    var speed: String {
        return format(currentSpeed)
    }

    var distance: String {
        return format(currentDistance)
    }

    // MARK: Members

    private let tripManager: TripManagerProtocol
    private var locationSubscriber: AnyCancellable?
    private var distanceSubscriber: AnyCancellable?
    private var speedSubscriber: AnyCancellable?
    private var timer: Timer = Timer()

    // MARK: Init

    init(tripManager: TripManagerProtocol = TripManager()) {
        self.tripManager = tripManager
    }

    // MARK: Intents

    func startTrip() {
        secondsElapsed = 0
        locationSubscriber = tripManager.locationPipline.sink { _ in
//            locations.append("Lat: \(newLocation.coordinate.latitude.description)")
//            locations.append("Long: \(newLocation.coordinate.longitude.description)")
        }
        distanceSubscriber = tripManager.distancePipline.sink { [self] newDistance in
            currentDistance = newDistance
        }
        speedSubscriber = tripManager.speedPipline.sink { [self] newSpeed in
            currentSpeed = newSpeed
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

    private func format(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale.current
        formatter.unitStyle = .medium
        return formatter.string(from: distance)
    }

    private func format(_ speed: Measurement<UnitSpeed>) -> String {
        let formatter = MeasurementFormatter()
        formatter.locale = Locale.current
        formatter.unitStyle = .medium
        return formatter.string(from: speed)
    }
}
