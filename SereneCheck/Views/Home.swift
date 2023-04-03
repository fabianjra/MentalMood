//
//  Home.swift
//  SereneCheck
//
//  Created by Fabian Josue Rodriguez Alvarez on 15/3/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest( sortDescriptors: [NSSortDescriptor(keyPath: \Mood.date, ascending: false)], animation: .easeInOut)
    private var moodsList: FetchedResults<Mood>

    @State private var selectedCheckList: Mood = Mood()
    @State var showModal = false
    @State var showNewMoodModal = false
    @State var showLoader = false
    @State var alertType: CustomAlertType = .loading
    @State var checkListType: ChecklistType = .none
    @State var saveConfirmation: Bool?
        
    init() {
    }
    
    var body: some View {
        ZStack {
            
            VStack {
                headerBackground
                Spacer()
            }
            
            VStack {
                headerTitle
                Spacer()
            }
            
            VStack {
                Spacer()
                    .frame(height: Constants.Frame.medium)
                
                ItemHeaderView()
                
                if moodsList.isEmpty {
                    Spacer()
                        .frame(height: Constants.Frame.large)
                    
                    emptyListText
                    
                    Spacer()
                } else {
                    cardList
                }
            }
            .sheet(isPresented: $showModal) {
                CheckListModal(checkListType: checkListType, checkList: $selectedCheckList, saveConfirmation: $saveConfirmation)
                    .background(BackgroundClearView())
                    .onDisappear {
                        checkListType = .none
                        try? viewContext.save()
                    }
            }
            .onChange(of: saveConfirmation) { isConfirmed in
                guard saveConfirmation != nil else { return }
                
                if case .new = checkListType, let isConfirmed = isConfirmed {
                    if !isConfirmed {
                        viewContext.delete(selectedCheckList)
                    }
                }
                saveConfirmation = nil
            }
            .onChange(of: checkListType) { newValue in
                print(newValue)
            }

            VStack {
                Spacer()
                buttonAdd
            }
            
            if showLoader {
              CustomAlertView(type: alertType)
            }
        }
    }
    
    var headerBackground: some View {
        Rectangle()
            .fill(LinearGradient(colors: Constants.Colors.greenGradiant,
                                 startPoint: .top,
                                 endPoint: .bottom))
            .frame(maxWidth: .infinity)
            .frame(height: Constants.Frame.heightBig)
            .mask({
                CustomRectangle()
            })
            .edgesIgnoringSafeArea(.top)
    }
    
    var headerTitle: some View {
        VStack {
            Text(Constants.Texts.header)
                .font(.system(size: Constants.Font.big, weight: .bold))
                .padding(.horizontal, Constants.Spacing.medium)
                .padding(.vertical, Constants.Spacing.small)
                .foregroundColor(.white)
        }
    }
    
    var emptyListText: some View {
        Text(Constants.Texts.empty)
            .font(.system(size: Constants.Font.big, weight: .light))
            .foregroundColor(Color.gray)
            .multilineTextAlignment(.center)
    }
    
    var cardList: some View {
        List(moodsList, id: \.id) { item in
            Card(model: item)
                .environmentObject(moodsList.first ?? item)
                .onTapGesture {
                    checkListType = .saved
                    selectedCheckList = item
                    showModal = true
                }
                .swipeActions(allowsFullSwipe: false) {
                    Button {
                        deleteMood(mood: item)
                    } label: {
                        Label(Constants.Texts.delete, systemImage: Constants.Images.trash)
                    }
                    .tint(Color.moodRed)
                }
        }
        .padding(.horizontal, .zero)
        .listStyle(.plain)
    }
    
    var buttonAdd: some View {
        ZStack {
            HStack {
                Spacer()
                
                Button(action: {
                    showNewMoodModal = true
                }, label: {
                    Constants.Images.add
                        .font(.system(size: Constants.Font.bigL, weight: .bold))
                        .frame(width: Constants.Frame.large, height: Constants.Frame.large)
                        .foregroundColor(Color.moodRed)
                    
                })
                .background(Color.moodWhite)
                .cornerRadius(Constants.Frame.buttonRadius)
                .shadow(color: Color.black.opacity(Constants.Colors.opacity),
                        radius: Constants.Frame.buttonShadowRadius,
                        x: Constants.Frame.positionXY,
                        y: Constants.Frame.positionXY)
                .overlay {
                    Circle()
                        .stroke(Color.moodGreenLight, lineWidth: Constants.Frame.lineWidth)
                }
                .padding()
                .sheet(isPresented: $showNewMoodModal) {
                    NewMoodView(
                        selectedCheckList: $selectedCheckList,
                        checkListType: $checkListType,
                        showLoader: $showLoader,
                        alertType: $alertType,
                        showModal: $showModal)
                        .presentationDetents([.height(Constants.Frame.heightBigXL)])
                }
            }
        }
    }
        
    func deleteMood(mood: Mood) {

        viewContext.delete(mood)
        
        do {
            try viewContext.save()
        } catch {
            Log.writeCatchExeption(error: error)
            assertionFailure("Error saving record")
        }
    }
    
}

extension HomeView {
    struct Constants {
        
        struct Texts {
            static var header: String { return "Serene Check" }
            static var empty: LocalizedStringKey { return "Press the + button to start" }
            static var delete: LocalizedStringKey { return "Delete" }
        }
        
        struct Spacing {
            static var small: CGFloat { return 10.0 }
            static var medium: CGFloat { return 20.0 }
        }
        
        struct Font {
            static var medium: CGFloat { return 25.0 }
            static var big: CGFloat { return 32.0 }
            static var bigL: CGFloat { return 50.0 }
            static var bigXL: CGFloat { return 60.0 }
        }
        
        struct Colors {
            static let greenGradiant: Array = [Color.moodGreen, Color.moodGreen, Color.moodGreenLight]
            static var opacity: CGFloat { return 0.5 }
        }
        
        struct Images {
            static let add = Image(systemName: "plus")
            static var trash: String { return "trash" }
        }
        
        struct Frame {
            static var medium: CGFloat { return 60.0 }
            static var large: CGFloat { return 80.0 }
            
            static var heightBig: CGFloat { return 150.0 }
            static var heightBigXL: CGFloat { return 300.0 }
            
            static var lineWidth: CGFloat { return 5.0 }
            static var positionXY: CGFloat { return 3.0 }
            static var buttonShadowRadius: CGFloat { return 5.0 }
            static var buttonRadius: CGFloat { return 40.0 }
        }
    }

    struct BackgroundClearView: UIViewRepresentable {
        func makeUIView(context: Context) -> UIView {
            let view = UIView()
            DispatchQueue.main.async {
                view.superview?.superview?.backgroundColor = .clear
            }
            return view
        }

        func updateUIView(_ uiView: UIView, context: Context) {}
    }
}
struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
            .environment(\.locale, .init(identifier: "es"))
    }
}
