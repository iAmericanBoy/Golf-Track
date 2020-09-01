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
    @Binding var center: CLLocationCoordinate2D
    @Binding var mapType: MKMapType

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        mapView.mapType = mapType
        mapView.region = MKCoordinateRegion(center: center, latitudinalMeters: 500, longitudinalMeters: 500)
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if view.overlays.count != overlays.count {
            view.addOverlays(overlays)
        }
        if view.region.center.latitude.magnitude != center.latitude.magnitude {
            let region = MKCoordinateRegion(center: center, latitudinalMeters: 250, longitudinalMeters: 250)
            view.setRegion(region, animated: true)
        }
        if view.mapType != mapType {
            view.mapType = mapType
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
            renderer.strokeColor = .white
            renderer.lineWidth = 3
            return renderer
        }
    }
}

struct MapContainerView_Previews: PreviewProvider {
    static var previews: some View {
        MapContainerView(overlays: .constant(TestingVariations.simpleLine), center: .constant(TestingVariations.center), mapType: .constant(.satellite))
    }
}

private extension MapContainerView_Previews {
    struct TestingVariations {
        static var simpleLine: [MKPolyline] {
            let start = CLLocationCoordinate2D(latitude: CLLocationDegrees(39.976273), longitude: CLLocationDegrees(-83.005588))
            let end = CLLocationCoordinate2D(latitude: CLLocationDegrees(39.976310), longitude: CLLocationDegrees(-83.005443))
            return [MKPolyline(coordinates: [start, end], count: 2)]
        }

        static var center: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: CLLocationDegrees(39.976273), longitude: CLLocationDegrees(-83.005588))
        }
    }
}
