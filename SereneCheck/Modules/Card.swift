//
//  Card.swift
//  SereneCheck
//
//  Created by Fabian Josue Rodriguez Alvarez on 15/3/23.
//

import SwiftUI

struct Card: View {
    
    @ObservedObject var model: Mood
    @EnvironmentObject var itemEnviroment: Mood
    @State var tasks: [Task] = []
    
    init(model: Mood) {
        self.model = model
    }
    
    public var body: some View {
        let completed = tasks.filter { $0.completed == true }
        let moodStatus = getMoodStatus()
        
        VStack(alignment: .leading, spacing: Constants.Spacing.small) {
            HStack {
                
                Text(Constants.Texts.header)
                    .font(.system(size: Constants.Font.small, weight: .bold))
                
                Spacer()
                
                Circle().frame(width: Constants.Frame.small, height: Constants.Frame.small)
                    .foregroundColor(moodStatus.color)
                
                Text(moodStatus.localizedStringResource).font(.system(size: Constants.Font.small, weight: .light))
                    .foregroundColor(.gray)
            }

            Text(model.title ?? "")
                .font(.system(size: Constants.Font.small))
            
            HStack {
                
                Text(tasks.count.description)
                    .font(.system(size: Constants.Font.big, weight: .bold))
                
                Text(Constants.Texts.tasksRegistered)
                    .font(.system(size: Constants.Font.small, weight: .light))
                    .frame(maxWidth: Constants.Frame.width)
                
                Spacer()
                
                Text(completed.count.description)
                    .font(.system(size: Constants.Font.big, weight: .bold))
                
                Text(Constants.Texts.tasksCompleted)
                    .font(.system(size: Constants.Font.small, weight: .light))
                    .frame(maxWidth: Constants.Frame.width)
            }
            
            HStack {
                Text(Constants.Texts.date)
                    .foregroundColor(.gray)
                
                Text(model.formattedDateShort)
                    .font(.system(size: Constants.Font.small, weight: .bold))
                
                Spacer()
            }
        }
        .padding(.horizontal, Constants.Spacing.medium)
        .padding(.vertical, Constants.Spacing.medium)
        .frame(maxWidth: .infinity)
        .overlay(
            HStack {
                Rectangle()
                    .fill(moodStatus.color)
                    .frame(width: Constants.Frame.small)
                Spacer()
            }
        )
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: Constants.Frame.radius))
        .shadow(color: .gray.opacity(Constants.Colors.opacity), radius: Constants.Frame.radius, x: .zero, y: .zero)
        .padding(.vertical, Constants.Spacing.small)
        .listRowSeparator(.hidden)
        .onAppear {
            tasks = model.getTasksArray()
        }
    }
    
    func getMoodStatus() -> MoodStatus {
        let completed = tasks.filter { $0.completed == true }

        var moodStatus: MoodStatus
        
        if completed.count == tasks.count {
            moodStatus = .completed
        } else {
            moodStatus = .pending
        }

        if Utils.isRunningOnCanvas() == false {
            if itemEnviroment.id == model.id && completed.count != tasks.count {
                moodStatus = .current
            }
        }

        return moodStatus
    }
}

extension Card {
    struct Constants {
        
        struct Spacing {
            static var small: CGFloat { return 10.0 }
            static var medium: CGFloat { return 20.0 }
        }
        
        struct Font {
            static var small: CGFloat { return 16.0 }
            static var big: CGFloat { return 30.0 }
        }
        
        struct Frame {
            static var small: CGFloat { return 10.0 }
            static var width: CGFloat { return 100.0 }
            static var radius: CGFloat { return 10.0 }
        }
        
        struct Colors {
            static var opacity: CGFloat { return 0.5 }
        }
        
        struct Texts {
            static var header: String { return "Mood" }
            static var tasksRegistered: LocalizedStringKey { return "Tasks registered" }
            static var tasksCompleted: LocalizedStringKey { return "Tasks completed" }
            static var date: LocalizedStringKey { return "Date" }
        }
    }
}

struct Card_Previews: PreviewProvider {
    static var previews: some View {
        @Environment(\.managedObjectContext) var viewContext
        
        let mood = Mood(context: viewContext)
        mood.title = "I'm feeling a little anxious today"
        mood.date = Date()
        
        let task1 = Task(context: viewContext)
        task1.taskDescription = "Do excercies"
        task1.completed = false
        
        let task2 = Task(context: viewContext)
        task2.taskDescription = "Do yoga"
        task2.completed = false
        
        let task3 = Task(context: viewContext)
        task3.taskDescription = "Breath"
        task3.completed = true
        
        let arrayTask = [task1, task2, task3]
        mood.mutableSetValue(forKey: "tasks").addObjects(from: arrayTask)
        
        return Card(model: mood)
            .environment(\.locale, .init(identifier: "es"))
    }
}
