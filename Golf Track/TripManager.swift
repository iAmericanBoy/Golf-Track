//
//  TripManager.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import CoreLocation

class TripManager {
    private var startDate: Date?
    private var distance: Measurement<UnitLength>?
    private var locationList: [CLLocation] = []
    
    private var locationManager: LocationManager
    
    init(locationManager: LocationManager = LocationManager.shared) {
        self.locationManager = locationManager
    }
    
    /// Checks if Location permission has benn given and Starts Trip after permission was givven
    func startTrip() {
        locationManager.completion = { [self] permissionResult in
            switch permissionResult {
            case .success():
                start()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    /// ends a Trip
    func endTrip() {
        end()
    }
    
    private func start() {
        locationManager.startLocationUpdates()
        startDate = Date()
    }
    
    private func end() {
        locationManager.endLocationUpdates()
        // calculate Time
        // calculate Distance
    }
}
