//
//  CurrentTripView.swift
//  Golf Track
//
//  Created by Dominic Lanzillotta on 7/26/20.
//

import SwiftUI

struct CurrentTripView: View {
    var body: some View {
        Button("Start", action: startTrip)
    }
    
    
    private func startTrip() {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentTripView()
    }
}
