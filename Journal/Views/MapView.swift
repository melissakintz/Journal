//
//  MapView.swift
//  Journal
//
//  Created by Mélissa Kintz on 13/07/2023.
//

import SwiftUI
import MapKit

struct MapView: View {
    @Binding var position: MapCameraPosition
    var coordinate: CLLocationCoordinate2D

    var body: some View {
        Map(position: $position){
            Annotation("", coordinate: coordinate){
                ZStack {
                    Image(systemName: "circle.inset.filled")
                        .symbolEffect(.pulse.byLayer, isActive: true)
                        .foregroundColor(.blue)
                }
            }
        }
            .ignoresSafeArea(edges: .top)

    }


}


#Preview {
    MapView(position: .constant(.automatic), coordinate: CLLocationCoordinate2D())
        .modelContainer(for: Entry.self, inMemory: true)

}
