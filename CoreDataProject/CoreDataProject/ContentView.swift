//
//  ContentView.swift
//  CoreDataProject
//
//  Created by Student2 on 11/02/2022.
//

import CoreData
import SwiftUI

struct ContentView: View {
//    @Environment(\.managedObjectContext) var moc
//
//    @FetchRequest(sortDescriptors: []) var wizards: FetchedResults<Wizard>
//
//    var body: some View {
//        VStack {
//            List(wizards, id: \.self) { wizard in
//                Text(wizard.name ?? "Unknown")
//            }
//        }
//
//        Button("Add") {
//            let wizard = Wizard(context: moc)
//            wizard.name = "Harry Potter"
//        }
//
//        Button("Save") {
//            if moc.hasChanges {
//                try? moc.save()
//            }
//        }
//    }
    
    @Environment(\.managedObjectContext) var moc

    @FetchRequest(sortDescriptors: [], predicate: nil) var ships: FetchedResults<Ship>

    var body: some View {
        VStack {
            List(ships, id: \.self) { ship in
                Text(ship.name ?? "Unknown name")
            }

            Button("Add Examples") {
                let ship1 = Ship(context: moc)
                ship1.name = "Enterprise"
                ship1.universe = "Star Trek"

                let ship2 = Ship(context: moc)
                ship2.name = "Defiant"
                ship2.universe = "Star Trek"

                let ship3 = Ship(context: moc)
                ship3.name = "Millennium Falcon"
                ship3.universe = "Star Wars"

                let ship4 = Ship(context: moc)
                ship4.name = "Executor"
                ship4.universe = "Star Wars"

                try? moc.save()
            }
        }
    }
//
//    @Environment(\.managedObjectContext) var moc
//    @State private var lastNameFilter = "A"
//
//    var body: some View {
//        VStack {
//            FilteredList(filterKey: "lastName", filterValue: lastNameFilter) { (singer: Singer) in
//                Text("\(singer.wrappedFirstName) \(singer.wrappedLastName)")
//            }
//
//            Button("Add Examples") {
//                let taylor = Singer(context: self.moc)
//                taylor.firstName = "Taylor"
//                taylor.lastName = "Swift"
//
//                let ed = Singer(context: self.moc)
//                ed.firstName = "Ed"
//                ed.lastName = "Sheeran"
//
//                let adele = Singer(context: self.moc)
//                adele.firstName = "Adele"
//                adele.lastName = "Adkins"
//
//                try? self.moc.save()
//            }
//
//            Button("Show A") {
//                self.lastNameFilter = "A"
//            }
//
//            Button("Show S") {
//                self.lastNameFilter = "S"
//            }
//        }
//    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
