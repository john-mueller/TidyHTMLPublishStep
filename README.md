# Tidy HTML step for Publish

A `PublishingStep` for [Publish](https://github.com/JohnSundell/Publish) that nicely formats your website's HTML using [SwiftSoup](https://github.com/scinfu/SwiftSoup).

## Installation

To install the step, add it as a dependency within your `Package.swift` manifest:

```swift
let package = Package(
    ...
    dependencies: [
        ...
        .package(url: "https://github.com/john-mueller/TidyHTMLPublishStep", from: "0.1.0")
    ],
    targets: [
        .target(
            ...
            dependencies: [
                ...
                "TidyHTMLPublishStep"
            ]
        )
    ]
    ...
)
```

Then import `TidyHTMLPublishStep` where you'd like to use it.

## Usage

The `tidyHTML(withIndentation:)` step should be inserted into your publishing pipeline *after* your HTML is generated. The default indentation is one space, if the parameter is omitted.

```swift
import TidyHTMLPublishStep
...
try DeliciousRecipes().publish(using: [
    ...
    .generateHTML(withTheme: .foundation),
    ...
    .tidyHTML(indentedBy: .spaces(4))
    ...
])
```

This package also provides an alternate convenience API to the `Website.publish(withTheme:...:additionalSteps:...)` method, replacing `additionalSteps` with `preGenerationSteps` and `postGenerationSteps`. The `tidyHTML` step should be passed to the `postGenerationSteps` parameter:

```swift
import TidyHTMLPublishStep
...
try DeliciousRecipes().publish(
    withTheme: theme,
    postGenerationSteps: [
        .tidyHTML()
    ]
)
