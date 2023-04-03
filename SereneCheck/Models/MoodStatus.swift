//
//  MoodStatus.swift
//  SereneCheck
//
//  Created by Fabian Josue Rodriguez Alvarez on 15/3/23.
//

import SwiftUI

enum MoodStatus: String, Identifiable, Decodable, CustomLocalizedStringResourceConvertible {
    
    public var id: Self { self }
    case current
    case pending
    case completed
    
    var color: Color {
        switch self {
        case .current: return Color.moodYellow
        case .pending: return Color.moodRed
        case .completed: return Color.moodGreen
        }
    }
    
    var localizedStringResource: LocalizedStringResource {
        switch self {
        case .current: return "Current"
        case .pending: return "Pending"
        case .completed: return "Completed"
        }
    }
}
