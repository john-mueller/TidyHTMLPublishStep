// TidyHTMLPublishStep
// © 2019 John Sundell, 2020 John Mueller
// MIT license, see LICENSE.md for details
//
// This file was copied as-is from the Publish test target

import Plot
import Publish

final class HTMLFactoryMock<Site: Website>: HTMLFactory {
    typealias Closure<T> = (T, PublishingContext<Site>) throws -> HTML

    var makeIndexHTML: Closure<Index> = { _, _ in HTML(.body()) }
    var makeSectionHTML: Closure<Section<Site>> = { _, _ in HTML(.body()) }
    var makeItemHTML: Closure<Item<Site>> = { _, _ in HTML(.body()) }
    var makePageHTML: Closure<Page> = { _, _ in HTML(.body()) }
    var makeTagListHTML: Closure<TagListPage>? = { _, _ in HTML(.body()) }
    var makeTagDetailsHTML: Closure<TagDetailsPage>? = { _, _ in HTML(.body()) }

    func makeIndexHTML(for index: Index,
                       context: PublishingContext<Site>) throws -> HTML {
        try makeIndexHTML(index, context)
    }

    func makeSectionHTML(for section: Section<Site>,
                         context: PublishingContext<Site>) throws -> HTML {
        try makeSectionHTML(section, context)
    }

    func makeItemHTML(for item: Item<Site>,
                      context: PublishingContext<Site>) throws -> HTML {
        try makeItemHTML(item, context)
    }

    func makePageHTML(for page: Page,
                      context: PublishingContext<Site>) throws -> HTML {
        try makePageHTML(page, context)
    }

    func makeTagListHTML(for page: TagListPage,
                         context: PublishingContext<Site>) throws -> HTML? {
        try makeTagListHTML?(page, context)
    }

    func makeTagDetailsHTML(for page: TagDetailsPage,
                            context: PublishingContext<Site>) throws -> HTML? {
        try makeTagDetailsHTML?(page, context)
    }
}
