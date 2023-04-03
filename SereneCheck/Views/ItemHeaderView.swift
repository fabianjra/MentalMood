//
//  ItemsHeaderView.swift
//  SereneCheck
//
//  Created by Fabian Josue Rodriguez Alvarez on 17/3/23.
//

import SwiftUI

struct ItemHeaderView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Mood.date, ascending: false)], animation: .easeInOut)
    private var moodsList: FetchedResults<Mood>
    
    public var body: some View {
        HStack {
            
            let registeredTasks = moodsList.reduce(.zero) { partialResult, mood in
                return partialResult + (mood.tasks?.count ?? .zero)
            }
            
            let completedTasks = moodsList.reduce(.zero) { partialResult, mood in
                return partialResult + ((mood.tasks?.filter({ task in
                    (task as? Task)?.completed ?? false
                }))?.count ?? .zero)
            }

            ItemHeader(model: ItemHeaderModel(count: moodsList.count, title: Constants.Texts.moodsRegistered))
                .frame(maxWidth: .infinity, alignment: .center)
            
            ItemHeader(model: ItemHeaderModel(count: registeredTasks, title: Constants.Texts.tasksRegistered))
                .frame(maxWidth: .infinity, alignment: .center)
            
            ItemHeader(model: ItemHeaderModel(count: completedTasks, title: Constants.Texts.taskCompleted))
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(.horizontal, Constants.Spacing.medium)
        .padding(.vertical, Constants.Spacing.medium)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Frame.viewRadius))
        .shadow(color: .gray.opacity(Constants.Colors.opacity), radius: Constants.Frame.shadowRadius, x: .zero, y: .zero)
        .padding(.horizontal, Constants.Spacing.medium)
        .frame(maxWidth: Constants.Frame.heightBigXL, alignment: .center)
        .frame(maxHeight: Constants.Frame.heightMedium, alignment: .center)
    }
}

extension ItemHeaderView {
    struct Constants {
        
        struct Texts {
            static var moodsRegistered: LocalizedStringKey { return "Moods registered" }
            static var tasksRegistered: LocalizedStringKey { return "Tasks registered" }
            static var taskCompleted: LocalizedStringKey { return "Tasks completed" }
            static var emptyText: LocalizedStringKey { return "Press the + button to start" }
        }
        
        struct Spacing {
            static var medium: CGFloat { return 20.0 }
        }
        
        struct Frame {
            static var heightMedium: CGFloat { return 120.0 }
            static var heightBigXL: CGFloat { return 400.0 }

            static var shadowRadius: CGFloat { return 10.0 }
            static var viewRadius: CGFloat { return 20.0 }
        }
        
        struct Colors {
            static var opacity: CGFloat { return 0.5 }
        }
    }
}

struct ItemHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        return ItemHeaderView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
