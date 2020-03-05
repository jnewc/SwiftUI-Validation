//
//  ContentView.swift
//  SwiftUI-Validation
//
//  Created by Jack Newcombe on 29/02/2020.
//  Copyright © 2020 Jack Newcombe. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var model = Model()
    
    @State var isSaveDisabled = true
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Name")) {
                    TextField("First Name", text: $model.firstName)
                        .validation(model.firstNameValidation)
                    TextField("Middle Names", text: $model.middleNames)
                    TextField("Last Name", text: $model.lastNames)
                        .validation(model.lastNamesValidation)
                }
                Section(header: Text("Personal Information")) {
                    DatePicker(selection: $model.birthday,
                               displayedComponents: [.date],
                               label: { Text("Birthday") })
                        .validation(model.birthdayValidation)
                }
                Section(header: Text("Address")) {
                    TextField("Street Number or Name", text: $model.addressHouseNumberOrName)
                        .validation(model.addressHouseNumberOrNameValidation)
                    TextField("First Line", text: $model.addressFirstLine)
                        .validation(model.addressFirstLineValidation)
                    TextField("Second Line", text: $model.addressSecondLine)
                    TextField("Postcode", text: $model.addressPostcode)
                        .validation(model.postcodeValidation)
                    TextField("Country", text: $model.addressCountry)
                }
                Button(action: {}, label: {
                    HStack {
                        Text("Submit")
                        Spacer()
                        Image(systemName: "checkmark.circle.fill")
                    }
                })
                .disabled(self.isSaveDisabled)
            }
            .navigationBarTitle("Form")
            .onReceive(model.allValidation) { validation in
                self.isSaveDisabled = !validation.isSuccess
            }
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
