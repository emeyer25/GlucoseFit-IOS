//
//  ExportView.swift
//  GlucoseFit
//
//  Created by Ian Burall on 4/11/25.
//
import SwiftUI
import UniformTypeIdentifiers

struct ExportView: View {
    
    @Environment(\.colorScheme) private var colorScheme
    
    private var backgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.18, green: 0.23, blue: 0.28) : Color(red: 0.33, green: 0.62, blue: 0.68)
    }
    
    private var secondaryBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.3, blue: 0.35) : Color(red: 0.6, green: 0.89, blue: 0.75)
    }
    
    private var cardBackgroundColor: Color {
        colorScheme == .dark ? Color(red: 0.25, green: 0.25, blue: 0.3) : Color.white.opacity(0.7)
    }
    
    private var buttonColor: Color {
        colorScheme == .dark ? Color.blue.opacity(0.8) : Color.blue
    }
    
    @State private var startTime = Date()
    @State private var endTime = Date()
    @State private var review = false
    @State private var export = false
    
    @State private var fileName = ""
    
    var body: some View {
        ZStack {
            LinearGradient(
                stops: [
                    .init(color: backgroundColor, location: 0),
                    .init(color: secondaryBackgroundColor, location: 1),
                ],
                startPoint: .leading,
                endPoint: .trailing
            )
            .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 15) {
                Text("Export Your Logs")
                    .font(.title.bold())
                HStack {
                    Text("Pick a start time:")
                    Spacer()
                    DatePicker("", selection: $startTime, displayedComponents: .date)
                        .labelsHidden()
                }
                HStack {
                    Text("Pick an end time:")
                    Spacer()
                    DatePicker("", selection: $endTime, displayedComponents: .date)
                        .labelsHidden()
                }
                Button("Select and Review logs") {
                    review = true
                }
                .frame(maxWidth: .infinity)
                .font(.headline)
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(buttonColor)
                .cornerRadius(8)
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(cardBackgroundColor)
            .cornerRadius(10)
            .padding(.horizontal)
            .sheet(isPresented: $review) {
                ReviewExports(startDate: startTime, endDate: endTime) { fileName in
                    review = false
                    export = true
                }
            }
            .fileExporter(isPresented: $export, document: TextFile(contents: "Sample Text"), contentType: .plainText, defaultFilename: fileName) { result in
                export = false
            }
        }
    }
    
    func exportFile() {
        
    }
}

struct TextFile: FileDocument {
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            fileText = String(decoding: data, as: UTF8.self)
        }
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
    }
    
    static var readableContentTypes = [UTType.plainText]
    
    var fileText: String
    
    init(contents: String) {
        self.fileText = contents
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(fileText.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
}

#Preview {
    ExportView()
}
