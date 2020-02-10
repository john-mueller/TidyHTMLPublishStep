/**
 *  TidyHTMLPublishStep
 *  © 2019 John Sundell, 2020 John Mueller
 *  MIT license, see LICENSE.md for details
 *
 *  This file was adapted from the Publish test target
 */

import Files
import Plot
import Publish
import XCTest

class TidyHTMLTestCase: XCTestCase {
    func publishWebsite(
        _ site: TidyHTMLWebsite = .init(),
        in folder: Folder? = nil,
        using theme: Theme<TidyHTMLWebsite>,
        content: [Path: String] = [:],
        preGenerationSteps: [PublishingStep<TidyHTMLWebsite>] = [],
        postGenerationSteps: [PublishingStep<TidyHTMLWebsite>] = [],
        plugins: [Plugin<TidyHTMLWebsite>] = [],
        expectedHTML: [Path: String],
        allowWhitelistedOutputFiles: Bool = true,
        file: StaticString = #file,
        line: UInt = #line
    ) throws {
        let folder = try Folder.temporary
            .createSubfolderIfNeeded(at: "TidyHTMLTests")
            .createSubfolder(named: UUID().uuidString)

        let contentFolderName = "Content"
        try? folder.subfolder(named: contentFolderName).delete()

        let contentFolder = try folder.createSubfolder(named: contentFolderName)
        try addFiles(withContent: content, to: contentFolder, pathPrefix: "")

        try site.publish(
            withTheme: theme,
            at: Path(folder.path),
            preGenerationSteps: preGenerationSteps,
            postGenerationSteps: postGenerationSteps,
            plugins: plugins
        )

        try verifyOutput(
            in: folder,
            expectedHTML: expectedHTML,
            allowWhitelistedFiles: allowWhitelistedOutputFiles,
            file: file,
            line: line
        )
    }

    func verifyOutput(in folder: Folder,
                      expectedHTML: [Path: String],
                      allowWhitelistedFiles: Bool = true,
                      file: StaticString = #file,
                      line: UInt = #line) throws {
        let outputFolder = try folder.subfolder(named: "Output")

        let whitelistedPaths: Set<Path> = [
            "index.html",
            "posts/index.html",
            "tags/index.html",
        ]

        var expectedHTML = expectedHTML

        for outputFile in outputFolder.files.recursive where outputFile.extension == "html" {
            let relativePath = Path(outputFile.path(relativeTo: outputFolder))

            guard let html = expectedHTML.removeValue(forKey: relativePath) else {
                guard allowWhitelistedFiles,
                    whitelistedPaths.contains(relativePath) else {
                        return XCTFail(
                            "Unexpected output file: \(relativePath)",
                            file: file,
                            line: line
                        )
                }

                continue
            }

            let outputHTML = try outputFile.readAsString()

            XCTAssert(
                outputHTML == html,
                "HTML mismatch. '\(outputHTML)' is not equal to '\(html)'.",
                file: file,
                line: line
            )
        }

        let missingPaths = expectedHTML.keys.map { $0.string }

        XCTAssert(
            missingPaths.isEmpty,
            "Missing output files: \(missingPaths.joined(separator: ", "))",
            file: file,
            line: line
        )
    }
}

private extension TidyHTMLTestCase {
    func addFiles(withContent fileContent: [Path: String],
                  to folder: Folder,
                  pathPrefix: String) throws {
        for (path, content) in fileContent {
            let path = pathPrefix + path.string
            try folder.createFile(at: path).write(content)
        }
    }
}
