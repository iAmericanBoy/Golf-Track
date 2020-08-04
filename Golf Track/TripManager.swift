//
//  TripManager.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import Combine
import CoreLocation

protocol TripManagerProtocol {
    var locationPipline: PassthroughSubject<CLLocation, Never> { get }
    var distancePipline: PassthroughSubject<Measurement<UnitLength>, Never> { get }
    var speedPipline: PassthroughSubject<Measurement<UnitSpeed>, Never> { get }
    func startTrip()
    func endTrip()
}

class TripManager: TripManagerProtocol {
    // MARK: Trip Information
    
    private var startDate: Date?
    
    private var locationList: [CLLocation] = [] {
        didSet {
            calculateDistance(locationList.last)
        }
    }
    
    /// Variable to store the last collected Location. Used for distance calculation
    private var lastLocation: CLLocation?
    private var distance: Measurement<UnitLength> = Measurement(value: 0, unit: UnitLength.meters)
    private var speed: Measurement<UnitSpeed> = Measurement(value: 0, unit: UnitSpeed.metersPerSecond)
    
    // MARK: Memebers
    
    private var locationManager: LocationManager
    private var cancelableLocationPublisher: AnyCancellable?
    
    // MARK: Piplines
    
    let locationPipline = PassthroughSubject<CLLocation, Never>()
    let distancePipline = PassthroughSubject<Measurement<UnitLength>, Never>()
    let speedPipline = PassthroughSubject<Measurement<UnitSpeed>, Never>()
    
    // MARK: init
    
    init(locationManager: LocationManager = LocationManager.shared) {
        self.locationManager = locationManager
    }
    
    // MARK: Public
    
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
    
    // MARK: Private
    
    private func start() {
        locationManager.startLocationUpdates()
        startDate = Date()
        distance = Measurement(value: 0, unit: UnitLength.meters)
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
            self.speedPipline.send(Measurement(value: location.speed, unit: UnitSpeed.metersPerSecond))
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
    
    private func calculateDistance(_ newlocation: CLLocation?) {
        if let newLocation = newlocation {
            let delta = lastLocation?.distance(from: newLocation) ?? 0
            distance = distance + Measurement(value: delta, unit: UnitLength.meters)
            distancePipline.send(distance)
        }
        lastLocation = locationList.last
    }
}

struct MockTripManager: TripManagerProtocol {
    var distancePipline = PassthroughSubject<Measurement<UnitLength>, Never>()
    var speedPipline = PassthroughSubject<Measurement<UnitSpeed>, Never>()
    var locationPipline = PassthroughSubject<CLLocation, Never>()
    
    func startTrip() {}
    
    func endTrip() {}
}
