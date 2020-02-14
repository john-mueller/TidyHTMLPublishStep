// TidyHTMLPublishStep
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Plot
import Publish
import SwiftSoup

extension PublishingStep {
    /// Tidy and indent all generated HTML files.
    ///
    /// - Important: This step must be run *after* HTML generation.
    ///
    /// - Parameters:
    ///   - indentation: How each HTML file should be indented. Defaults to one space if not specified.
    public static func tidyHTML(indentedBy indentation: Indentation.Kind? = nil) -> Self {
        .step(named: "Tidy HTML") { context in
            do {
                let root = try context.folder(at: "")

                let files = root.files.recursive

                for file in files where file.extension == "html" {
                    let html = try file.readAsString()

                    let outputSettings = OutputSettings()
                    switch indentation {
                    case let .spaces(num), let .tabs(num):
                        outputSettings.indentAmount(indentAmount: UInt(num))
                    default:
                        break
                    }

                    let doc = try SwiftSoup.parse(html)
                    doc.outputSettings(outputSettings)

                    var tidyHTML = try doc.html()

                    if case .tabs = indentation {
                        var isPreCode = false
                        tidyHTML = tidyHTML.components(separatedBy: .newlines).map { line in
                            if isPreCode {
                                guard line.hasPrefix("</pre></code>") else {
                                    return line
                                }
                                isPreCode = false
                            }

                            let tabs = line.prefix(while: { $0 == " " }).map { _ in Character("\t") }
                            let range = line.startIndex ..< line.index(line.startIndex, offsetBy: tabs.count)

                            if line[range.upperBound...].hasPrefix("<pre><code>") {
                                isPreCode = true
                            }

                            return line.replacingCharacters(in: range, with: String(tabs))
                        }.joined(separator: "\n")
                    }

                    try file.write(tidyHTML)
                }
            } catch {
                print("Error while tidying HTML:")
                print(error)
            }
        }
    }
}
