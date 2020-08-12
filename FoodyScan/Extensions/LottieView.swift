//
//  LottieView.swift
//  FoodyScan
//
//  Created by Noe De La Croix on 12/08/2020.
//  Copyright © 2020 Noe De La Croix. All rights reserved.
//

import SwiftUI
import Lottie


struct LottieView: UIViewRepresentable {
    let animationView = AnimationView()
    var filename : String
    var speed: Double
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        
        let animation = Animation.named(filename)
        animationView.animation = animation
        animationView.animationSpeed = CGFloat(speed)
        animationView.contentMode = .scaleAspectFit
        animationView.play()
        
            animationView
            .translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(animationView)
        
        NSLayoutConstraint.activate([
            animationView.heightAnchor
                .constraint(equalTo: view.heightAnchor),
            
            animationView.widthAnchor
                .constraint(equalTo: view.widthAnchor),
        ])
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<LottieView> ) {
    }
}
