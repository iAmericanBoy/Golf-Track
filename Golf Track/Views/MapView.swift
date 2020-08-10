//
//  MapView.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 8/10/20.
//

import MapKit
import SwiftUI

struct MapView: UIViewRepresentable {
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ uiView: MKMapView, context: Context) {}
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
