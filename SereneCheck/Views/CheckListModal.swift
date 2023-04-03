//
//  CheckListModal.swift
//  SereneCheck
//
//  Created by Alan Anaya Araujo on 15/03/23.
//

import SwiftUI

struct CheckListModal: View {
    @Environment(\.dismiss) var dismiss
    let frameHeightLimit: CGFloat = (UIScreen.main.bounds.size.height / 2)
    @State var checkListType: ChecklistType
    @Binding var checkList: Mood
    @State var tasks: [Task] = []
    @Binding var saveConfirmation: Bool?
    
    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 12) {
                HStack {
                    Group {
                        Text(Texts.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        Spacer()
                        Button {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                                if case .new = checkListType {
                                    saveConfirmation = false
                                }
                                dismiss()
                            }
                        } label: {
                            Image(systemName: "xmark.circle")
                                .font(.system(size: 26))
                                .tint(.black)
                        }
                    }
                    .padding(.horizontal, 16)
                }
                .padding(.top, 12)
                Text(checkList.title ?? "")
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .font(.callout)
                    .fontWeight(.light)
                    .padding(.horizontal, 16)
                    .minimumScaleFactor(0.4)
                
                if case .new(let header, _) = checkListType {
                    Text(header)
                        .padding(.horizontal, 16)
                        .fontWeight(.bold)
                        .minimumScaleFactor(0.4)
                }
                
                LazyVGrid(columns: [GridItem(.flexible())]) {
                    ScrollView {
                        ForEach(tasks.sorted(by: {$0.taskDescription ?? "" < $1.taskDescription ?? ""}), id: \.id) { task in
                            CheckListItem(task: task)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 4)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: frameHeightLimit)
                    .padding(0)
                }
                
                Spacer()
                    .frame(maxHeight: 0)
                Text(Texts.messageCheckList)
                    .font(.caption)
                    .padding(.horizontal, 12)
                if case .new(_, let footer) = checkListType {
                    Text(footer)
                        .font(.caption)
                        .fontWeight(.medium)
                    Button("confirm_checklist_button") {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            saveConfirmation = true
                            dismiss()
                        }
                    }
                    .buttonStyle(.bordered)
                    .tint(.white)
                    .background(Color.moodGreen)
                    .fontWeight(.bold)
                    .cornerRadius(8)
                }
                Spacer()
                    .frame(maxHeight: 10)
                
            }
            .background(Color.white)
            .cornerRadius(12, corners: [.topLeft, .topRight])
            .shadow(radius: 4)
            
        }
        .background(Color.clear)
        .ignoresSafeArea()
        .onAppear {
            tasks = checkList.getTasksArray()
        }
    }
}

struct CheckListModal_Previews: PreviewProvider {
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
     
    return CheckListModal(checkListType: .saved, checkList: .constant(mood), saveConfirmation: .constant(false))
    .environment(\.locale, .init(identifier: "es"))  }
}

extension CheckListModal {
    struct Texts {
        static var title: String { "Mood:" }
        static var messageCheckList: LocalizedStringKey {
            "footer_modal"
        }
        static var confirmCheckListText: LocalizedStringKey {
            "confirm_checklist_text"
        }
        static var confirmCheckListButton: LocalizedStringKey {
            "confirm_checklist_button"
        }
    }
}
