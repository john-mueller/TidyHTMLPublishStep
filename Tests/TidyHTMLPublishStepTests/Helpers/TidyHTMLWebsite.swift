// TidyHTMLPublishStep
// © 2020 John Mueller
// MIT license, see LICENSE.md for details

import Foundation
import Plot
import Publish

class TidyHTMLWebsite: Website {
    enum SectionID: String, WebsiteSectionID {
        case posts
    }

    struct ItemMetadata: WebsiteItemMetadata {}

    var url = URL(string: "https://tidyhtmltests.com")!
    var name = "Tidy HTML Tests"
    var description = "Description"
    var language = Language.english
    var imagePath: Path?
}
