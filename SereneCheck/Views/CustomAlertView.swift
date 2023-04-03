//
//  CustomAlertView.swift
//  SereneCheck
//
//  Created by Edgar Alexis Negrete Hernandez on 16/03/23.
//

import SwiftUI

enum CustomAlertType {
  case loading
  case notMoodError
  case botError
  
  var message: LocalizedStringKey {
    switch self {
    case .loading:
      return "We are generating your checklist, it may take a while."
    case .notMoodError:
      return "I couldn't identify your mood, could you talk about how you feel?"
    case .botError:
      return "We are having trouble with our bots."
    }
  }
  var iconImage: String {
    switch self {
    case .loading:
      return "person.crop.circle.fill.badge.xmark"
    case .notMoodError:
      return "person.crop.circle.fill.badge.xmark"
    case .botError:
      return "cloud.bolt.fill"
    }
  }
}

struct CustomAlertView: View {
  
  let type: CustomAlertType
  var body: some View {
    VStack {
      Spacer()
      if type == .loading {
        ProgressView()
          .scaleEffect(x: 4, y: 4, anchor: .top)
          .padding(16)
      } else {
        Image(systemName: type.iconImage)
          .font(.largeTitle)
          .scaleEffect(x: 2, y: 2, anchor: .top)
          .foregroundColor(Color("OrangeColor"))
      }
      Spacer()
      Text(type.message)
        .frame(alignment: .center)
        .padding(24)
        .shadow(radius: 10)
        .lineLimit(3)
        .multilineTextAlignment(.center)
    }
    .background(.ultraThinMaterial)
    .cornerRadius(16)
    .padding(48)
    .frame(maxHeight: 330, alignment: .center)
  }
}

enum BottomAlertType {
  case addToWishList
  case removedFromWishList
}

struct CustomAlertView_Previews: PreviewProvider {
  static var previews: some View {
    CustomAlertView(type: .loading)
      .environment(\.locale, .init(identifier: "es"))
  }
}
