//
//  CurrentTripViewModel.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import Combine

class CurrentTripViewModel: ObservableObject {
    private let tripManager: TripManager

    init(tripManager: TripManager = TripManager()) {
        self.tripManager = tripManager
    }

    func startTrip() {
        tripManager.startTrip()
    }

    func endTrip() {
        tripManager.endTrip()
    }
}
