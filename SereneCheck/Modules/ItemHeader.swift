//
//  ItemHistory.swift
//  SereneCheck
//
//  Created by Fabian Josue Rodriguez Alvarez on 15/3/23.
//

import SwiftUI

struct ItemHeader: View {
    
    @ObservedObject private var model: ItemHeaderModel
    
    init(model: ItemHeaderModel) {
        self.model = model
    }
    
    public var body: some View {
        VStack(spacing: ItemHeader.Constants.Spacing.verticalSpacing) {
            Text(model.count.description)
                .font(.system(size: ItemHeader.Constants.Font.sizeValue, weight: .bold))
            
            Text(model.title)
                .font(.system(size: ItemHeader.Constants.Font.sizeDescription))
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
    }
}

extension ItemHeader {
    struct Constants {
        
        struct Spacing {
            static var verticalSpacing: CGFloat { return 10.0 }
        }
        
        struct Font {
            static var sizeValue: CGFloat { return 24.0 }
            static var sizeDescription: CGFloat { return 15.0 }
        }
    }
}

struct ItemHeader_Previews: PreviewProvider {
    static var previews: some View {
        ItemHeader(model: ItemHeaderModel(count: 10, title: "Moods Registered"))
    }
}
