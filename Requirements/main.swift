//
//  main.swift
//  Requirements
//
//  Created by Ernest Chechelski on 30/04/2020.
//  Copyright © 2020 Ernest Chechelski. All rights reserved.
//

import Foundation
import Files
import MarkdownGenerator

start()

/// Start parsing
///
/// - Parameters:
///   - CommandLine.arguments[0]: this app path
///   - CommandLine.arguments[1]: path to the project with source code to parse
///   - CommandLine.arguments[2]: path to the template file with requirements
///   - CommandLine.arguments[3]: path to the report file
func start() {
    print("Requirements! started")
    let arguments = CommandLine.arguments

    guard arguments.count == 4 else { return }

    let projectURL = URL(fileURLWithPath: arguments[1])
    let templateURL = URL(fileURLWithPath: arguments[2])
    let reportFolderURL = URL(fileURLWithPath: arguments[3])

    guard
        let projectFolder = try? Folder(path: projectURL.path),
        let templateFile =  try? File(path: templateURL.path),
        let reportFolder =  try? Folder(path: reportFolderURL.path)
    else {
        return
    }

    let templateRequirementsSet = Set(templateFile.requirements)
    let projectRequirementsSet = Set(projectFolder.requirements)

    print("Fullfilled requirements")
    let fullfilledRequirements = projectRequirementsSet.intersection(templateRequirementsSet)
    if fullfilledRequirements.isEmpty {
        print("Empty")
    }
    fullfilledRequirements.forEach {
        print($0)
    }
    print("Not fullfilled requirements")
    let notFullfilledRequirements = templateRequirementsSet.subtracting(fullfilledRequirements)
    if notFullfilledRequirements.isEmpty {
        print("Empty")
    }

    notFullfilledRequirements.forEach {
        print($0)
    }

    print("Unknown requirements")
    let unknownRequirements = projectRequirementsSet.subtracting(templateRequirementsSet)
    if unknownRequirements.isEmpty {
        print("Empty")
    }
    unknownRequirements.forEach {
        print($0)
    }

    print("Generating raport...")
    let details: [MarkdownConvertible] = [
        MarkdownHeader(title: "Requirements! 🧐"),
        MarkdownTable(headers: ["ID", "State", "Description"],
                      data: fullfilledRequirements.map { ["\($0.id)","✅","\($0.description)"] } +
                            notFullfilledRequirements.map { ["\($0.id)","🔴","\($0.description)"] }),
        "Fullfillment percentage \(Float(fullfilledRequirements.count) / Float(templateRequirementsSet.count) * 100)%",
        "Generated at \(Date())"
    ]
    try? reportFolder.createFile(at: "report.md").write(details.markdown)
}

// MARK: - Classes and Structs

struct Requirement {

    static let regex = try! NSRegularExpression(pattern: #"(\[RQ:).*:.*]"#, options: [])

    let id: String

    let description: String
}

// MARK: - Extensions

extension Requirement {

    static func from(text: String) -> Requirement? {
        let components = text.split(separator: ":")
        guard components.count == 3 else { return nil }
        let id = "\(components[1])"
        var description = "\(components[2])"
        description.removeLast()
        return Requirement(id: id, description: description)
    }
}

extension Requirement: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id.elementsEqual(rhs.id)
    }
}

extension Requirement: Hashable {

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension Folder {

    var requirements: [Requirement] {
        let folder = try? Folder(path: self.path)
        return folder?.subfolders
            .recursive
            .map { $0.files }
            .flatMap { $0 }
            .filter { $0.extension == "swift" }
            .flatMap { $0.requirements } ?? []
    }
}

extension File {

    var text: String? {
        let data = try? String(contentsOfFile: self.path)
        let myStrings = data?.components(separatedBy: .newlines)
        let text = myStrings?.joined(separator: "\n")
        return text
    }

    var requirements: [Requirement] {
        guard let text = self.text else { return [] }
        let matches = Requirement.regex
            .matches(in: text, options: [], range: text.wholeRange)
            .map { String(text[Range($0.range, in: text)!]) }
        return matches.compactMap { Requirement.from(text: $0) }
    }
}

extension String {

    var wholeRange: NSRange {
        NSRange(startIndex..<endIndex, in: self)
    }
}
