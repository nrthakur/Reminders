//
//  ContentView.swift
//  Reminders
//
//  Created by Nikunj Thakur on 2024-06-14.
//

import SwiftUI

struct ContentView: View {
    
    @State private var newReminder = ""
    @State private var allReminders: [ReminderItem] = []
    private let RemindersKey = "RemindersKey"
    
    var body: some View {
        
        NavigationView {
        VStack {
            HStack{
                TextField("Add Reminder", text: $newReminder)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    guard !self.newReminder.isEmpty else {return}
                    self.allReminders.append(ReminderItem(Reminder: self.newReminder))
                    self.newReminder = ""
                    self.saveReminders()
                }) {
                    Image(systemName: "plus")
                }.padding(.leading, 5)
            }.padding()
            
        List {
            ForEach(allReminders) { ReminderItem in
                Text(ReminderItem.Reminder)
            }.onDelete(perform: deleteReminder)
                }
            }
        .navigationBarTitle("Reminders")
        }.onAppear(perform: {
            loadReminders()
        })
    }
    private func deleteReminder(at offsets: IndexSet) {
        self.allReminders.remove(atOffsets: offsets)
        saveReminders()
    }
    private func loadReminders() {
        if let RemindersData = UserDefaults.standard.value(forKey: RemindersKey) as? Data {
            if let RemindersList = try? PropertyListDecoder().decode(Array<ReminderItem>.self, from: RemindersData) {
                self.allReminders = RemindersList
            }
        }
    }
    private func saveReminders() {
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(self.allReminders), forKey: RemindersKey)
    }
}

struct ReminderItem: Codable, Identifiable {
    let id = UUID()
    let Reminder: String
}

#Preview {
    ContentView()
}
