//
//  LocationManager.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import Combine
import CoreLocation

enum LocationError: Error {
    case notAllowed
    case unknown
    case error(Error)
}

protocol LocationManagerable {
    var completion: ((Result<Void, LocationError>) -> Void)? { get set }
    var publisher: AnyPublisher <CLLocation, LocationError> { get }
    func requestPermission()
    func startLocationUpdates()
    func endLocationUpdates()
}

class LocationManager: NSObject, LocationManagerable {
    private static var manager = CLLocationManager()

    static let shared = LocationManager()

    var completion: ((Result<Void, LocationError>) -> Void)?

    private let locationPublisher: PassthroughSubject<CLLocation, LocationError>
    var publisher: AnyPublisher<CLLocation, LocationError>

    override private init() {
        locationPublisher = PassthroughSubject<CLLocation, LocationError>()
        publisher = locationPublisher.eraseToAnyPublisher()

        super.init()

        LocationManager.manager.delegate = self
    }

    func requestPermission() {
        switch LocationManager.manager.authorizationStatus() {
        case .notDetermined:
            LocationManager.manager.requestAlwaysAuthorization()
        case .restricted, .denied:
            completion?(.failure(.notAllowed))
        case .authorizedAlways:
            completion?(.success(()))
        case .authorizedWhenInUse:
            completion?(.success(()))
            @unknown default:
            completion?(.failure(.unknown))
            assertionFailure()
        }
    }

    func startLocationUpdates() {
        LocationManager.manager.activityType = .fitness
        LocationManager.manager.distanceFilter = 10
        LocationManager.manager.startUpdatingLocation()
    }

    func endLocationUpdates() {
        LocationManager.manager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            requestPermission()
        case .restricted, .denied, .authorizedWhenInUse:
            completion?(.failure(.notAllowed))
        case .authorizedAlways:
            completion?(.success(()))
        @unknown default:
            completion?(.failure(.unknown))
            assertionFailure()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        for newLocation in locations {
            let howRecent = newLocation.timestamp.timeIntervalSinceNow
            guard newLocation.horizontalAccuracy < 20, abs(howRecent) < 10 else { continue }
            locationPublisher.send(newLocation)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationPublisher.send(completion: Subscribers.Completion.failure(LocationError.error(error)))
    }
}
