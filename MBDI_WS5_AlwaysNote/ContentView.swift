//
//  ContentView.swift
//  MBDI_WS5_AlwaysNote
//
//  Created by Tim Kaerts on 23/03/2022.
//

import SwiftUI

struct ContentView: View {
    let fontName = "Noteworthy-Bold"
    let fontSizeKey = "nl.avans.alwaysnote.fontsize"
    let fileName = "note.txt"
    let titleFontSize = 60.0
    let myButtonHorizontalPadding = 30.0
    
    @State var fontSize = 17.0
    @State var noteContent = "Lief dagboek, \n\nVandaag heb ik op Avans geleerd hoe ik een notitie app moet maken. Het was eigenlijk best"
    @State private var showAlert = false
    @Environment(\.verticalSizeClass) var sizeClass
    
    init() {
        UITextView.appearance().backgroundColor = .clear
    }
    
    var body: some View {
        ZStack {
            Color("FlexLabelBackgroundColor").edgesIgnoringSafeArea(.all)
            VStack {
                headerView
                editorView
                Spacer()
            }
            .padding(.all)
            .onAppear(perform: initView)
            .alert(isPresented: $showAlert, content: {Alert(title: Text("Your note has been stored"))})
        }
    }
    
    var headerView: some View {
        HStack {
            if sizeClass == .compact {
                HStack { titleView; buttonStack }
            } else {
                VStack { titleView; buttonStack }
            }
        }
    }
    
    var titleView: some View {
        Text("AlwaysNote")
            .font(.custom("Hoefler Text", size: titleFontSize))
            .foregroundColor(Color("FlexLabelColor"))
    }
    
    var buttonStack: some View {
        HStack {
            Button(action: save) { Text("save") }
            Spacer()
            Button(action: decreaseFontSizePressed) { Text("a") }
            Spacer()
            Button(action: increaseFontSizePressed) { Text("A") }
        }
        .padding(.vertical)
        .padding(.horizontal, myButtonHorizontalPadding)
    }
    
    var editorView: some View {
        TextEditor(text: $noteContent)
            .padding()
            .font(.custom(fontName, size: CGFloat(fontSize)))
            .foregroundColor(Color("FlexTextColor"))
            .background(Color("FlexTextBackgroundColor"))
    }
    
    func initView() {
        let standard = UserDefaults.standard
        if standard.object(forKey: fontSizeKey) == nil {
            UserDefaults().set(fontSize, forKey: fontSizeKey)
        }
        fontSize = standard.double(forKey: fontSizeKey)
        if let fileURL = constructFileUrl( fileName: fileName ) {
            do {
                noteContent = try String(contentsOf: fileURL)
            } catch { }
        }
    }
    
    func save() {
        guard let fileURL = constructFileUrl( fileName: fileName ) else {
            return
        }
        do {
            try noteContent.write(to: fileURL, atomically: true, encoding: String.Encoding.unicode)
        } catch { }
        showAlert = true
    }
    
    func decreaseFontSizePressed()	{
        fontSize = max(fontSize - 1.0, 8.0)
        saveFontSize()
    }
    
    func increaseFontSizePressed() {
        fontSize = min(fontSize + 1.0, 40.0)
        saveFontSize()
    }
    
    func saveFontSize() {
        UserDefaults().set(fontSize, forKey: fontSizeKey)
    }
    
    func constructFileUrl(fileName: String) -> URL? {
        var documentDirectory: URL?
        do {
            documentDirectory = try FileManager.default.url(
                for: .documentDirectory,
                   in: .userDomainMask,
                   appropriateFor: nil,
                   create: false)
        } catch {}
        if let documentDirectory = documentDirectory {
            return documentDirectory.appendingPathComponent(fileName)
        }
        return nil
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
