//
//  NewMoodView.swift
//  SereneCheck
//
//  Created by Edgar Alexis Negrete Hernandez on 16/03/23.
//

import SwiftUI
import CoreData

enum ChecklistType: Equatable {
    case new(header: String, footer: String)
    case saved
    case none
}

struct NewMoodView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.dismiss) var dismiss
    @Binding var selectedCheckList: Mood
    @Binding var checkListType: ChecklistType
    
    @State private var textInput: String = ""
    @Binding var showLoader: Bool
    @Binding var alertType: CustomAlertType
    @Binding var showModal: Bool
    
    private let maxLength = 120
    private var isInputValid: Bool {
        !textInput.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    private let currentMoodLabel = NSLocalizedString("current.mood.label", comment: "")
    
    var body: some View {
        VStack(spacing: 16) {
            HStack {
                Text("How do you feel today?")
                    .font(.title2)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark.circle")
                        .font(.system(size: 26))
                        .tint(.black)
                }
            }

            Text(currentMoodLabel)
            
            TextField("I feel....", text: $textInput, prompt: Text("I feel...."), axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3)
                .lineLimit(3, reservesSpace: true)
                .submitLabel(.done)
                .onChange(of: textInput) { newValue in
                    textInput = String(newValue.prefix(maxLength))
                }
            Button {
                dismiss()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    self.showLoader = true
                }
                
                RecommendationsModel().getRecomendations(for: textInput) { promptResponse in
                    
                  guard let promptResponse = promptResponse else {
                    alertType = .botError
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.showLoader = false
                        self.alertType = .loading
                    }
                    return
                  }
                    
                  if promptResponse.isValidMood() {
                    showLoader = false
                    saveMood(promptResponse: promptResponse, input: textInput)
                  } else {
                    alertType = .notMoodError
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.showLoader = false
                        self.alertType = .loading
                    }
                    return
                  }
                    
                  if let lastMood = getLastMood() {
                      
                      checkListType = .new(header: promptResponse.header,
                                           footer: promptResponse.footer)
                      DispatchQueue.main.asyncAfter(deadline: .now() + 0.33) {
                          selectedCheckList = lastMood
                          showModal = true
                      }
                  }
                    
                }
            } label: {
                Text("Add mood")
                    .padding(16)
                    .background(Color.moodWhite)
                    .tint(.black)
                    .fontWeight(.bold)
                    .cornerRadius(16)
            }.disabled(!isInputValid)
        }.padding(16)
    }
    
    private func getLastMood() -> Mood? {
        let fetchRequest: NSFetchRequest<Mood> = Mood.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(keyPath: \Mood.date, ascending: false)]
        fetchRequest.fetchLimit = 1
         
        do {
            let moods = try viewContext.fetch(fetchRequest)
            return moods.first
        } catch {
            Log.writeCatchExeption(error: error)
            assertionFailure("An error occurred while trying to obtain the last Mood element")
            return nil
        }
    }
    
    func saveMood(promptResponse: PromptResponse, input: String) {
        let newMood = Mood(context: viewContext)
        newMood.title = input
        newMood.date = Date()
        newMood.status = "current"
        
      promptResponse.checklist.forEach({ (taskDescription) in
                      let task = Task(context: viewContext)
                      task.completed = false
                      task.taskDescription = taskDescription
                      newMood.addToTasks(task)
                  })
        
        do {
            try viewContext.save()
        } catch {
            Log.writeCatchExeption(error: error)
            assertionFailure("Error saving record")
        }
    }
}

struct NewMoodView_Previews: PreviewProvider {
  
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
        
        return NewMoodView(
            selectedCheckList: .constant(mood),
            checkListType: .constant(.new(header: "Hedaer text", footer: "Footer text")),
            showLoader: Binding<Bool>(get: {
            true
        }, set: { _, _ in
            
        }), alertType: .constant(.loading), showModal: .constant(true))
    }
}
