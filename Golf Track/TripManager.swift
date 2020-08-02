//
//  TripManager.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import Combine
import CoreLocation

class TripManager {
    private var startDate: Date?
    private var distance: Measurement<UnitLength>?
    private var locationList: [CLLocation] = []
    private var locationManager: LocationManagerable
    private var cancelableLocationPublisher: AnyCancellable?
    
    let locationPipline = PassthroughSubject<CLLocation, Never>()
    
    init(locationManager: LocationManagerable = LocationManager.shared) {
        self.locationManager = locationManager
    }
    
    /// Checks if Location permission has been given and Starts Trip after permission was givven
    func startTrip() {
        locationManager.completion = { [self] permissionResult in
            switch permissionResult {
            case .success():
                start()
            case .failure(let error):
                print(error)
            }
        }
        
        locationManager.requestPermission()
    }
    
    /// ends a Trip
    func endTrip() {
        end()
    }
    
    private func start() {
        locationManager.startLocationUpdates()
        startDate = Date()
        subscibeToLocationUpdates()
    }
    
    private func end() {
        locationManager.endLocationUpdates()
        // calculate Time
        // calculate Distance
        // after saving this trip
        locationList.removeAll()
    }
    
    private func subscibeToLocationUpdates() {
        cancelableLocationPublisher = locationManager.publisher.sink(receiveCompletion: onLocationPublisherCompletion) { location in
            self.locationList.append(location)
            self.locationPipline.send(location)
        }
    }
    
    private let onLocationPublisherCompletion: ((Subscribers.Completion<LocationError>) -> Void) = { completion in
        switch completion {
        case .finished:
            print("finished")
        case .failure(let error):
            print(error)
            // handle better
        }
    }
}
