//
//  OnboardingView.swift
//  SereneCheck
//
//  Created by Juan Eduardo Garcia Montenegro on 15/03/23.
//

import SwiftUI

struct OnboardingView: View {
  
  @AppStorage("onboarding") var isOnboardingViewActive: Bool = true

  var body: some View {
    ZStack {
      Color("BackgroundColor")
        .ignoresSafeArea(.all, edges: .all)
      VStack(spacing: 20) {
        Spacer()
        VStack(spacing: 0) {
          Text("How is your mood?")
            .font(.system(size: 40))
            .fontWeight(.heavy)
            .foregroundColor(Color("DarkGreenColor"))
          Text("""
            Tell us about your mood and get a checklist to steps that can help you improve your mood!
            """)
          .font(.title3)
          .fontWeight(.light)
          .foregroundColor(Color("DarkGreenColor"))
          .multilineTextAlignment(.center)
          .padding(.horizontal, 10)
        }
        ZStack {
          Image("tree_2")
            .resizable()
            .scaledToFit()
        }
        Spacer()
        Button {
          isOnboardingViewActive = false
        } label: {
          Text("START")
            .foregroundColor(Color("DarkGreenColor"))
            .font(.headline)
        }
        .tint(Color("OrangeColor"))
        .buttonStyle(.borderedProminent)
        .buttonBorderShape(.capsule)
        .controlSize(.large)
        .padding()
      }
    }
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView()
          .environment(\.locale, .init(identifier: "es"))
  }
}
