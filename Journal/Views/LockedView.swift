//
//  LockedView.swift
//  Journal
//
//  Created by Mélissa Kintz on 17/07/2023.
//

import SwiftUI

struct LockedView: View {
    @EnvironmentObject var securityController: SecurityController
    
    var body: some View {
        Button("Unlock") {
            securityController.authenticate()
        }
    }
}

#Preview {
    LockedView()
}
