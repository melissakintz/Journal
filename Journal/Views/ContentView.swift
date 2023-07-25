//
//  ContentView.swift
//  Journal
//
//  Created by Mélissa Kintz on 03/07/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.scenePhase) var scenePhase
    
    @StateObject private var securityController = SecurityController()
        
    @StateObject var locationDataManager = LocationDataManager()
    @Query private var entries: [Entry]
    
    @State var selectedEntry : Entry?
    
    var body: some View {
        NavigationSplitView {
            List(selection: $selectedEntry) {
                ForEach(entries) { entry in
                    NavigationLink(value: entry) {
                        Text(entry.createdAt.formatted(date: .abbreviated, time: .shortened))
                    }
                }
            }
            .toolbar {
                ToolbarItem{
                    Button {
                        addEntry()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        } detail: {
            
            if let selectedEntry {
                EntryView(entry: selectedEntry)
            }else {
                Text("Pick an entry")
            }
        }
        .sheet(isPresented: $securityController.isLocked) {
                        LockedView()
                            .environmentObject(securityController)
                            .interactiveDismissDisabled()
                    }
        .onAppear {
            securityController.showLockedViewIfEnabled()
        }
        .onChange(of: scenePhase) { _oldValue, newValue in
            print(securityController.isAppLockEnabled, "enable")
            print(newValue)
            switch newValue {
            case .background, .inactive:
                securityController.lockApp()
            default:
                break
            }
        }
    }

    func addEntry () {
        withAnimation {
            let coordinate = locationDataManager.locationManager.location?.coordinate
            let location : [String]?;
            if let latitude = coordinate?.latitude, let longitude = coordinate?.longitude {
                location = [latitude.description, longitude.description]
            }else {
                location = nil
            }
            
            let newEntry = Entry(location: location, content: "Un jour une histoire")
            modelContext.insert(newEntry)
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: Entry.self, inMemory: true)
}
