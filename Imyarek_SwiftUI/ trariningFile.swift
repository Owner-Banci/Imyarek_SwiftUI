//
//   trariningFile.swift
//  Imyarek_SwiftUI
//
//  Created by Авазбек on 23.11.2024.
//

import SwiftUI

struct ContentView1: View {
    @State private var selectedAge: Age?
    @State private var selectedSex: Sex?
    
    enum Sex: String, CaseIterable, Identifiable {
        case
        male,
        female,
        someone
        var id: Self { self }
    }
    enum Age: String, CaseIterable, Identifiable {
        case
        until17 = "до 17 лет",
        from18To21 = "от 18 до 21 года",
        from22to25 = "от 22 до 25 лет",
        from26to35 = "от 26 до 35 лет",
        olderThan36 = "старше 36"
        var id: Self { self }
    }
    
    var body: some View {
        VStack {
            userSettings
            
            }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
    }
    
    var userSettings: some View {
        VStack {
            Picker (selection: $selectedSex){
                Text("Мужской").tag(Sex.male)
                Text("Женский").tag(Sex.female)
                Text("Некто").tag(Sex.someone)
            } label: {
                Text("Hello, world!")
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()

            List {
                Picker(selection: $selectedAge) {
                    ForEach(Age.allCases, id: \.self) { age in
                        Text(age.rawValue).tag(age)
                    }
                }
                label: {
                    Text("Возраст")
                        .foregroundColor(.white)
                    Text("Укажите свой возраст")
                        .foregroundColor(.white)
                }
                .tint(.white)
                .listRowBackground(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.blue)) // Отступы между яче
            }
            .scrollContentBackground(.hidden) // Убираем системный фон
            .listStyle(PlainListStyle()) // Убираем дополнительные отступы
            .padding(.horizontal)
        }


    }
    
}

#Preview {
    ContentView1()
}
