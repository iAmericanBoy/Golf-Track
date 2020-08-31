//
//  MapContainerViewModel.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 8/31/20.
//

import Combine
import MapKit

class MapContainerViewModel: ObservableObject {
    // MARK: Publishers

    @Published var overlays: [MKOverlay] = []

    // MARK: Members

    private let tripManager: TripManagerProtocol
    private var locationSubscriber: AnyCancellable?

    // MARK: Init

    init(tripManager: TripManagerProtocol) {
        self.tripManager = tripManager

        locationSubscriber = tripManager.locationPipline.sink { _ in
        }
    }
}
