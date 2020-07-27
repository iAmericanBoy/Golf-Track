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
    
    private func start() {
        self.locationManager.startLocationUpdates()
        self.startDate = Date()
    }
}
