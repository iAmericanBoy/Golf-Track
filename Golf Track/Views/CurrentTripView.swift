//
//  CurrentTripView.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import SwiftUI

struct CurrentTripView: View {
    @ObservedObject var viewModel = CurrentTripViewModel()

    var body: some View {
        VStack {
            ZStack {
                MapContainerView()
                VStack {
                    Text(viewModel.time)
                    Text(viewModel.locations)
                    Text(viewModel.distance)
                    Text(viewModel.speed)
                    Text(viewModel.altitude)
                    Spacer()
                }
            }
            HStack {
                Button("Start", action: startTrip)
                Spacer()
                Button("End", action: endTrip)
            }
            .padding()
        }
    }

    private func startTrip() {
        viewModel.startTrip()
    }

    private func endTrip() {
        viewModel.endTrip()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTripView(viewModel: CurrentTripViewModel(tripManager: MockTripManager()))
    }
}
