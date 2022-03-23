//
//  ContentView.swift
//  MBDI_WS5_AlwaysNote
//
//  Created by Tim Kaerts on 23/03/2022.
//

import SwiftUI

struct ContentView: View {
    @State var fontSize = 17.0
    @State var noteContent = "Lief dagboek, \n\nVandaag heb ik op Avans geleerd hoe ik een notitie app moet maken. Het was eigenlijk best"
    @State private var showAlert = false
    let fontSizeKey = "nl.avans.alwaysnote.fontsize"
    let fileName = "note.txt"
    var fontName = "Noteworthy-Bold"
    
    var body: some View {
        VStack {
            Text("AlwaysNote")
                .font(.custom("Hoefler Text", size: 60))
                .foregroundColor(.yellow)
            HStack {
                Button("Save") {
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Action@*/ /*@END_MENU_TOKEN@*/
                }
                Spacer()
                Button("a") {
                    decreaseFont()
                }
                Spacer()
                Button("A") {
                    increaseFont()
                }
            }.padding()
            VStack {
                TextEditor(text: $noteContent)
                    .padding()
                    .font(.custom(fontName, size: CGFloat(fontSize)))
            }
            .padding(10)
        }
        .alert(isPresented: $showAlert, content: {Alert(title: Text("Your note has been stored"))})
    }
    
    func initView() {
        let standard = UserDefaults.standard
        if standard.object(forKey: fontSizeKey) == nil {
            UserDefaults().set(fontSize, forKey: fontSizeKey)
        }
        fontSize = standard.double(forKey: fontSizeKey)
        
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            noteContent = try String(contentsOf: fileURL)
        } catch {}
    }
    func decreaseFont()	{
        fontSize = max(fontSize - 1.0, 8.0)
        saveFontSize()
    }
    func increaseFont() {
        fontSize = min(fontSize + 1.0, 40.0)
        saveFontSize()
    }
    func saveFontSize() {
        UserDefaults().set(fontSize, forKey: fontSizeKey)
    }
    func save() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = documentDirectory.appendingPathComponent(fileName)
            try noteContent.write(to: fileURL, atomically: true, encoding: String.Encoding.unicode)
        } catch {}
//        showAlert = true
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
