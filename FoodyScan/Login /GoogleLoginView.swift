//
//  GoogleLoginView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 23/07/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Firebase
import GoogleSignIn

struct GoogleLoginView: UIViewRepresentable {
    
    func makeCoordinator() -> GoogleLoginView.Coordinator {
        return GoogleLoginView.Coordinator()
    }
    
    class Coordinator: NSObject, GIDSignInDelegate {
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
          if let error = error {
            print(error.localizedDescription)
            return
          }

          guard let authentication = user.authentication else { return }
          let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                            accessToken: authentication.accessToken)
          Auth.auth().signIn(with: credential) { (authResult, error) in
            if let error = error {
              print(error.localizedDescription)
              return
            }
            print("signIn result: " + authResult!.user.email!)
            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            
          }
            
        }
    }
    
    func makeUIView(context: UIViewRepresentableContext<GoogleLoginView>) -> GIDSignInButton {
        let view = GIDSignInButton()
        GIDSignIn.sharedInstance().delegate = context.coordinator
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        
        return view
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleLoginView>) { }
}



struct GoogleLoginView_Previews: PreviewProvider {
    static var previews: some View {
        GoogleLoginView()
    }
}
