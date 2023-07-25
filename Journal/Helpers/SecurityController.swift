//
//  SecurityController.swift
//  Journal
//
//  Created by Mélissa Kintz on 17/07/2023.
//

import SwiftUI
import LocalAuthentication

// MARK: - Security Controller
@MainActor
class SecurityController: ObservableObject {

        // MARK: - Variables
    
    var error: NSError?
    
    @Published var isLocked = false
    @Published var isAppLockEnabled: Bool = UserDefaults.standard.object(forKey: "isAppLockEnabled") as? Bool ?? true
}

// MARK: - Biometric Authentication
extension SecurityController {
    
    func authenticate() {
        let context = LAContext()
        let _reason = "Authenticate yourself to unlock Locker"
        
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            
            // Fall back to a asking for username and password.
            // ...
            return
        }
        Task {
            do {
                try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: "Log in to your account")
                isLocked = false
            } catch let error {
                print(error.localizedDescription)
                
                // Fall back to a asking for username and password.
                // ...
            }
        }
    }
    
}

extension SecurityController {
    
    func appLockStateChange(_ isEnabled: Bool) {
        let context = LAContext()
        let reason = "Authenticate to toggle App Lock"
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, error in
                Task { @MainActor in
                    if success {
                        self.isLocked = false
                        self.isAppLockEnabled = isEnabled
                        UserDefaults.standard.set(self.isAppLockEnabled, forKey: "isAppLockEnabled")
                    }
                }
            }
        }
    }
        
}


// MARK: - App Lock Toggle
extension SecurityController {
    
    func showLockedViewIfEnabled() {
        if isAppLockEnabled {
            isLocked = true
            authenticate()
        } else {
            isLocked = false
        }
    }
    
    func lockApp() {
        if isAppLockEnabled {
            isLocked = true
        } else {
            isLocked = false
        }
    }
    
}

