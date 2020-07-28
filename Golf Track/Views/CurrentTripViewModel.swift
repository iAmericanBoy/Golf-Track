//
//  CurrentTripViewModel.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import Combine

class CurrentTripViewModel: ObservableObject {
    @Published var locations: String = "Hello"

    private let tripManager: TripManager
    private var locationSubscriber: AnyCancellable?

    init(tripManager: TripManager = TripManager()) {
        self.tripManager = tripManager
    }

    func startTrip() {
        tripManager.startTrip()
        locations = ""
        locationSubscriber = tripManager.locationPipline.sink { [self] newLocation in
            locations.append("Lat: \(newLocation.coordinate.latitude.description)")
            locations.append("Long: \(newLocation.coordinate.longitude.description)")
        }
    }

    func endTrip() {
        tripManager.endTrip()
    }
}
