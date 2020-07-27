//
//  LocationManager.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import CoreLocation

enum LocationManagerError: Error {
    case notAllowed
    case unknown
}

class LocationManager: NSObject {
    private static var manager = CLLocationManager()

    static let shared = LocationManager()

    var completion: ((Result<Void, LocationManagerError>) -> Void)?

    override private init() {
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
}
