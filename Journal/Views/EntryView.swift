//
//  EntryView.swift
//  Journal
//
//  Created by Mélissa Kintz on 13/07/2023.
//

import SwiftUI
import CoreLocation
import MapKit

struct EntryView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject private var speechRecognizer = SpeechRecognizer()

    @State var placemark: CLPlacemark?
    @State private var position: MapCameraPosition = .automatic
    @State private var content : String = ""
    @State private var isEditable = false
    
    var entry : Entry
    
    var body: some View {
        VStack(alignment: .leading) {
            if let coordinate = placemark?.location?.coordinate {
                MapView(position: $position, coordinate: coordinate)
                    .overlay {
                        HStack {
                            VStack(alignment: .leading) {
                                Spacer()
                                if let placemark {
                                    Text(placemark.locality ?? "no locality")
                                }
                                Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                                    .bold()
                            }
                            .padding(.bottom)
                            Spacer()
                        }
                        .padding()
                        .ignoresSafeArea(edges: .top)
                        .background(LinearGradient(colors: [.lightGray.opacity(0.9), .lightGray.opacity(0.9), .lightGray.opacity(0.9), .lightGray.opacity(0)],
                                                   startPoint: .leading,
                                                   endPoint: .center))
                    }
                    .frame(height: 100)
                    .padding(.bottom)
                VStack {
                    if isEditable {
                        Text(speechRecognizer.recognizedText)
                        Divider()
                        
                        TextEditor(text: $content)
                    }else {
                        Text(content)
                    }
                        
                    Spacer()
                }
                .padding()
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    if(isEditable){
                        if(speechRecognizer.isRecording) {
                            speechRecognizer.stopTranscribe()
                            content = content + " " + speechRecognizer.recognizedText
                        }else {
                            speechRecognizer.startTranscribe()
                        }
                    }
                }label: {
                    Image(systemName: speechRecognizer.isRecording ?  "waveform.circle.fill" : "waveform.circle" )
                }
            }
        }
        .onAppear {
            if (Date().formatted(date: .complete, time: .omitted)) == (entry.createdAt.formatted(date: .complete, time: .omitted)) {
                isEditable = true
                speechRecognizer.requestSpeechAuthorization()
            }
            content = entry.content
            Task {
                do {
                    let data = await entry.getPlacemark() 
                    placemark = data
                    if let coordinate = data?.location?.coordinate {
                        position = .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: coordinate.latitude + 0.00030, longitude: coordinate.longitude - 0.00100), distance: 300, pitch: 30))
                    }
                    
                 }
                
            }
        }
        .onDisappear {
            Task {
                do {
                    entry.content = content 
                    try modelContext.save()
                }catch {
                    print("Not saved")
                }
                
            }
            
        }
    }
}

#Preview {
    EntryView(entry: Entry(location: nil, content: "Content"))
        .modelContainer(for: Entry.self, inMemory: true)

}
