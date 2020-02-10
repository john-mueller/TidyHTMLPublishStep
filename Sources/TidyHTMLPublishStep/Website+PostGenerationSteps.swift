/**
 *  TidyHTMLPublishStep
 *  © 2019 John Sundell, 2020 John Mueller
 *  MIT license, see LICENSE.md for details
 *
 *  This file was adapted from the Publish API
 */

import Plot
import Publish

public extension Website {
    /// Publish this website using a default pipeline. To build a completely
    /// custom pipeline, use the `publish(using:)` method.
    /// - parameter theme: The HTML theme to generate the website using.
    /// - parameter indentation: How to indent the generated files.
    /// - parameter path: Any specific path to generate the website at.
    /// - parameter rssFeedSections: What sections to include in the site's RSS feed.
    /// - parameter rssFeedConfig: The configuration to use for the site's RSS feed.
    /// - parameter deploymentMethod: How to deploy the website.
    /// - parameter preGenerationSteps: Additional steps to add to the publishing
    ///   pipeline. Will be executed right before the HTML generation process begins.
    /// - parameter postGenerationSteps: Additional steps to add to the publishing pipeline.
    ///   Will be executed after generation steps, right before the deployment process begins.
    /// - parameter plugins: Plugins to be installed at the start of the publishing process.
    /// - parameter file: The file that this method is called from (auto-inserted).
    /// - parameter line: The line that this method is called from (auto-inserted).
    @discardableResult
    func publish(withTheme theme: Theme<Self>,
                 indentation: Indentation.Kind? = nil,
                 at path: Path? = nil,
                 rssFeedSections: Set<SectionID> = Set(SectionID.allCases),
                 rssFeedConfig: RSSFeedConfiguration? = .default,
                 deployedUsing deploymentMethod: DeploymentMethod<Self>? = nil,
                 preGenerationSteps: [PublishingStep<Self>] = [],
                 postGenerationSteps: [PublishingStep<Self>] = [],
                 plugins: [Plugin<Self>] = [],
                 file: StaticString = #file) throws -> PublishedWebsite<Self> {
        try publish(
            at: path,
            using: [
                .group(plugins.map(PublishingStep.installPlugin)),
                .optional(.copyResources()),
                .addMarkdownFiles(),
                .sortItems(by: \.date, order: .descending),
                .group(preGenerationSteps),
                .generateHTML(withTheme: theme, indentation: indentation),
                .unwrap(rssFeedConfig) { config in
                    .generateRSSFeed(
                        including: rssFeedSections,
                        config: config
                    )
                },
                .generateSiteMap(indentedBy: indentation),
                .group(postGenerationSteps),
                .unwrap(deploymentMethod, PublishingStep.deploy),
            ],
            file: file
        )
    }
}
