//
//  MapContainerView.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 8/10/20.
//

import MapKit
import SwiftUI

struct MapContainerView: UIViewRepresentable {
    @ObservedObject var viewModel: MapContainerViewModel

    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        return mapView
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        if view.overlays.count != viewModel.overlays.count {
            view.addOverlays(viewModel.overlays)
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
        MapContainerView(viewModel: MapContainerViewModel(tripManager: MockTripManager()))
    }
}

private extension MapContainerView_Previews {
    struct TestingVariations {
        static var simpleLine: [MKPolyline] {
            let start = CLLocationCoordinate2D(latitude: CLLocationDegrees(39.976273), longitude: CLLocationDegrees(-83.005588))
            let end = CLLocationCoordinate2D(latitude: CLLocationDegrees(39.976310), longitude: CLLocationDegrees(-83.005443))
            return [MKPolyline(coordinates: [start, end], count: 2)]
        }
    }
}
