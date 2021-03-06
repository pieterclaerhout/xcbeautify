import ArgumentParser
import Foundation
import XcbeautifyLib


struct Xcbeautify: ParsableCommand {
    @Flag(name: [.short, .long], help: "Only print tasks that have warnings or errors.")
    var quiet = false
    
    @Flag(name: [.long, .customLong("qq", withSingleDash: true)], help: "Only print tasks that have errors.")
    var quieter = false
    
    @Flag(name: .long, help: "Print test result too under quiet/quieter flag.")
    var isCi = false

    @Flag(name: .long, help: "Disable the colored output")
    var disableColoredOutput = false

    func run() throws {
        let parser = Parser()
        let output = OutputHandler(quiet: quiet, quieter: quieter, isCI: isCi, { print($0) })
        
        while let line = readLine() {
            guard let formatted = parser.parse(line: line, colored: !disableColoredOutput) else { continue }
            output.write(parser.outputType, formatted)
        }
        
        if let summary = parser.summary {
            print(summary.format())
        }
    }
}
