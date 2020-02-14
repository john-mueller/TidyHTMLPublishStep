// TidyHTMLPublishStep
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Plot
import Publish
import TidyHTMLPublishStep
import XCTest

final class TidyHTMLPublishStepTests: TidyHTMLTestCase {
    private var htmlFactory: HTMLFactoryMock<TidyHTMLWebsite>!

    override func setUp() {
        super.setUp()
        htmlFactory = HTMLFactoryMock()
    }

    func testTidyWithoutIndentation() throws {
        htmlFactory.makePageHTML = { page, _ in
            HTML(.body(.p(.text(page.title))))
        }

        try publishWebsite(
            using: Theme(htmlFactory: htmlFactory),
            content: [
                "page1.md": "# Hello",
            ],
            postGenerationSteps: [
                .tidyHTML(),
            ],
            expectedHTML: [
                "page1/index.html": """
                <!doctype html>
                <html>
                 <head></head>
                 <body>
                  <p>Hello</p>
                 </body>
                </html>
                """,
            ]
        )
    }

    func testTidyWithSpacedIndentation() throws {
        htmlFactory.makePageHTML = { page, _ in
            HTML(.body(.p(.text(page.title))))
        }

        try publishWebsite(
            using: Theme(htmlFactory: htmlFactory),
            content: [
                "page1.md": "# Hello",
            ],
            postGenerationSteps: [
                .tidyHTML(indentedBy: .spaces(2)),
            ],
            expectedHTML: [
                "page1/index.html": """
                <!doctype html>
                <html>
                  <head></head>
                  <body>
                    <p>Hello</p>
                  </body>
                </html>
                """,
            ]
        )
    }

    func testTidyWithTabbedIndentation() throws {
        htmlFactory.makePageHTML = { page, _ in
            HTML(.body(.p(.text(page.title))))
        }

        try publishWebsite(
            using: Theme(htmlFactory: htmlFactory),
            content: [
                "page1.md": "# Hello",
            ],
            postGenerationSteps: [
                .tidyHTML(indentedBy: .tabs(2)),
            ],
            expectedHTML: [
                "page1/index.html": """
                <!doctype html>
                <html>
                \t\t<head></head>
                \t\t<body>
                \t\t\t\t<p>Hello</p>
                \t\t</body>
                </html>
                """,
            ]
        )
    }
}
