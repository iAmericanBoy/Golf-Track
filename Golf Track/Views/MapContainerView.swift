//
//  MapContainerView.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 8/10/20.
//

import MapKit
import SwiftUI

struct MapContainerView: UIViewRepresentable {
    @Binding var overlays: [MKOverlay]

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if view.overlays.count != overlays.count {
            view.addOverlays(overlays)
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapContainerView

        init(_ parent: MapContainerView) {
            self.parent = parent
        }

        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer(overlay: overlay)
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 3
            return renderer
        }
    }
}

struct MapContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MapContainerView()
    }
}

extension MKPointAnnotation {
    static var example: MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.title = "London"
        annotation.subtitle = "Home to the 2012 Summer Olympics."
        annotation.coordinate = CLLocationCoordinate2D(latitude: 51.5, longitude: -0.13)
        return annotation
    }
}
