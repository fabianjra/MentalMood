//
//  ItemHeaderModel.swift
//  SereneCheck
//
//  Created by Fabian Josue Rodriguez Alvarez on 15/3/23.
//

import SwiftUI

class ItemHeaderModel: ObservableObject {
    
    @Published public var count: Int
    public var title: LocalizedStringKey
    
    init(count: Int, title: LocalizedStringKey) {
        self.count = count
        self.title = title
    }
}
