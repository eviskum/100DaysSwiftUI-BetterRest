//
//  ContentView.swift
//  BetterRest
//
//  Created by Esben Viskum on 06/04/2021.
//

import SwiftUI

struct ContentView: View {
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
//    var components = DateComponents()
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date()
    }

    @State private var wakeUp = defaultWakeTime

    var body: some View {
//        Stepper(value: $sleepAmount, in: 8...12, step: 0.25) {
//            Text("\(sleepAmount, specifier: "%g") hours")
//        }
//        Form {
//            DatePicker("Please enter a date", selection: $wakeUp, displayedComponents: .hourAndMinute)
//                .labelsHidden()
//        }
        NavigationView {
            Form {
                Section(header: Text("Hvornår vil du vågne?"))
                {
                    DatePicker("Vælg et tidspunkt", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }

                VStack(alignment: .leading, spacing: 0)
                {
                    Text("Ønsket søvn")
                        .font(.headline)
                    
                    Stepper(value: $sleepAmount, in: 4...12, step: 0.25) {
                        Text("\(sleepAmount, specifier: "%g") timer")
                    }
                }
                
//                Section(header: Text("Dagligt kaffeforbrug")) {
                    Picker("Dagligt kaffeforbrug", selection: $coffeeAmount) {
                        ForEach(1..<20) { i in
                            Text("\(i)")
                        }
                    }
//                }
                
                Section(header: Text("Du skal i seng kl...")) {
                    Text(calculateBedtime())
                }

//                VStack(alignment: .leading, spacing: 0)
//                {
//                    Text("Dagligt kaffeforbrug")
//                        .font(.headline)
//
//                    Stepper(value: $coffeeAmount, in: 1...20) {
//                        if coffeeAmount == 1 {
//                            Text("1 kop kaffe")
//                        } else {
//                            Text("\(coffeeAmount) koppper kaffe")
//                        }
//                    }
//                }
            }
            .navigationBarTitle("BetterRest")
//            .navigationBarItems(trailing:
//                                    Button(action: calculateBedtime) {
//                                        Text("Beregn")
//                                    }
//            )
//            .alert(isPresented: $showingAlert) {
//                Alert(title: Text(alertTitle), message: Text(alertMessage), dismissButton: .default(Text("OK")))
//            }
        }
    }
    
    func calculateBedtime()->String {
        let model = SleepCalculator()
        
        let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
        let hour = (components.hour ?? 0) * 60 * 60
        let minute = (components.minute ?? 0) * 60
        
        do {
            let prediction = try model.prediction(wake: Double(hour+minute), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            let sleepTime = wakeUp - prediction.actualSleep
            let formatter = DateFormatter()
            formatter.timeStyle = .short
            
            alertTitle = "Du skal i seng kl..."
            alertMessage = formatter.string(from: sleepTime)
            
            return formatter.string(from: sleepTime)
        } catch {
            alertTitle = "Error"
            alertMessage = "Beklager, det virkede ikke"
            
            return "Fejl"
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
