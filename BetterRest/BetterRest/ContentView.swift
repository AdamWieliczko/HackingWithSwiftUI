//
//  ContentView.swift
//  BetterRest
//
//  Created by Student2 on 10/02/2022.
//

import CoreML
import SwiftUI



struct ContentView: View {
    @State private var wakeUp = defaultWakeTime
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount = 1
    
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    @State private var showingAlert = false
    
    @State private var cupsOfCoffeeRange = 1...20
    
    static var defaultWakeTime: Date {
        var components = DateComponents()
        components.hour = 7
        components.minute = 0
        return Calendar.current.date(from: components) ?? Date.now
    }
    
    var body: some View {
        NavigationView {
            Form {
                //Zostawiam VStacki jako ze wygladaja lepiej wedlug mnie, ale
                //zgodnie z challengami dodaje tez Section
                //
                //Section(header: Text("When do you want to wake up?")) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("When do you want to wake up?")
                        .font(.headline)
                    
                    DatePicker("Please enter a time", selection: $wakeUp, displayedComponents: .hourAndMinute)
                        .labelsHidden()
                }
                
                //Section(header: Text("Desired amount of sleep")) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Desired amount of sleep")
                        .font(.headline)
                    
                    Stepper("\(sleepAmount.formatted()) hours", value: $sleepAmount, in: 4...12, step: 0.25)
                }
                
                //Section(header: Text("Daily coffee intake")) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Daily coffee intake")
                        .font(.headline)
                    
                    Picker("Number of cups", selection: $coffeeAmount) {
                        ForEach(cupsOfCoffeeRange, id: \.self) {
                            Text("\($0)")
                        }
                    }
                }
            }
            .navigationTitle("BetterRest")
            .toolbar {
                Button("Calculate", action: calculateBedtime)
            }
            .alert(alertTitle, isPresented: $showingAlert) {
                Button("OK") {}
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func calculateBedtime() {
        do {
            let config = MLModelConfiguration()
            let model = try SleepCalculator(configuration: config)
            
            let components = Calendar.current.dateComponents([.hour, .minute], from: wakeUp)
            let hour = (components.hour ?? 0)
            let minute = (components.minute ?? 0)
            
            // w poradniku bylo powiekszenie hour i minute od razu powyzej, ale
            // wedlug mnie sensowniej bedzie miec orginalne wartosci i powiekszyc
            // je nizej zgodnie z ich nazwami
            
            let prediction = try model.prediction(wake: Double(((hour * 60) + minute) * 60), estimatedSleep: sleepAmount, coffee: Double(coffeeAmount))
            
            let sleepTime = wakeUp - prediction.actualSleep
            
            alertTitle = "Your ideal bedtime is..."
            alertMessage = sleepTime.formatted(date: .omitted, time: .shortened)
            
        } catch {
            alertTitle = "Error"
            alertMessage = "Sorry, there was a problem calculating your bedtime."
        }
        
        showingAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
