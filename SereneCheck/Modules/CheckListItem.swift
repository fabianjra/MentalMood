//
//  CheckListItem.swift
//  SereneCheck
//
//  Created by Alan Anaya Araujo on 15/03/23.
//

import SwiftUI

struct CheckListItem: View {
    @Environment(\.managedObjectContext) private var viewContext
    @ObservedObject var task: Task

    var body: some View {
        HStack {
            Button {
                task.completed.toggle()
                viewContext.refreshAllObjects()
            } label: {
                Image(systemName: task.completed ? "checkmark.square.fill" : "square.fill")
                    .symbolRenderingMode(.palette)
                    .foregroundStyle(task.completed ? .black : .white, .white)
                    .font(.system(size: 26))
            }

            Text(task.taskDescription ?? "")
                .frame(maxWidth: .infinity, alignment: .leading)
                
        }
        .padding(EdgeInsets(top: 12, leading: 8, bottom: 12, trailing: 16))
        .frame(maxWidth: .infinity)
        .background(Color.moodWhite)
        .listRowSeparator(.hidden)
        .cornerRadius(8)
        .shadow(radius: 3, y: 5)
    }
}

struct CheckListItem_Previews: PreviewProvider {
    static var previews: some View {
        
        @Environment(\.managedObjectContext) var viewContext

        let task = Task(context: viewContext)
        task.taskDescription = "Do excercies"
        task.completed = false

        return CheckListItem(task: task)
    }
}
