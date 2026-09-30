# AGENTS.md

Guidance for AI coding agents (Claude, Codex, and others) and human
contributors working in this repository. Read this before making changes.

This file covers **this repository**: how to build it, how it is laid out, and
what will bite you. How work reaches it — which task an agent picks up, when a
task is ready, and what happens after review — lives in
[`laugga/ops`](https://github.com/laugga/ops), which serves every repository
and is where those rules are changed.

## What this is

**KineticTextKit** is a Swift text-animation kit: a `CAShapeLayer` subclass
that renders text as a bezier path and animates between strings, fonts and
weights, plus the UIKit controls built on top of it. Swift + UIKit, packaged
with Swift Package Manager (`Package.swift`, swift-tools-version 5.7). It has
**no dependencies of its own**.

**The repository is `kinetic-text-kit-ios`; the module in it is
`KineticTextKit`.** They differ on purpose: `CONVENTIONS.md` → *Names* names a
library's repository `<product>-<platform>` and keeps its module name, so a
rename never touches an `import`. Do not rename either to match the other —
`Package.swift`, `Sources/KineticTextKit/`, the `KineticTextKit` scheme and
`Example/KineticTextKit.xcodeproj` all carry the module name, which is what
that section asks of them.

**What it is for:** the Lightmate app uses it, as a Swift package. That app's
repository is private, so this file says what the package is for and nothing
more specific about the app. See the branch-pinning gotcha below — it is the
single most important thing to know before merging here.

**It is semi-experimental.** Some components do not have a purpose yet — they
exist ahead of any use. So a component being here says nothing about whether
the app uses it.

The public surface is small:

| Type | What it is |
|---|---|
| `KineticTextLayer` | `CAShapeLayer` that draws text as a path; animates `text`, `font`. |
| `LAUTextView` | `UIView` wrapper hosting a `KineticTextLayer`. |
| `LAULabel` | SwiftUI `UIViewRepresentable` over the text view (iOS 14+). |
| `LAUSwitch` | `UIControl` toggle with animated text titles. |
| `LAUPathSwitch` | Path-morphing toggle (`LAUPathSwitchToggleState`). |
| `KineticTextKitDynamicItem` | `UIDynamicItem` adapter, for UIKit Dynamics. |

## Build and test

Use the `Makefile` targets — they wrap the correct `xcodebuild` invocations so
everyone runs the same known-good commands. Run them from the repo root.

```bash
make build   # compile for the simulator
make test    # run unit tests on a simulator (auto-picks newest iPhone)
make clean   # xcodebuild clean, and remove .build
```

Both were verified from a clean checkout of `main`. Notes:

- **`swift build` and `swift test` do not work here, and are not meant to.**
  Every source file imports UIKit, so a host-macOS SwiftPM build fails with
  `error: no such module 'UIKit'`. It is not a broken checkout — build through
  `xcodebuild` with an iOS Simulator destination, which is what the Makefile
  does. Do not add `#if canImport(UIKit)` guards or a macOS platform just to
  make `swift build` pass.
- **Builds use a generic simulator destination**; tests need a concrete device
  and the Makefile selects the newest available iPhone at runtime. Override
  with `make test TEST_DEVICE='iPhone 17'` if needed.
- **There is no linter** in this repository — no SwiftLint config, no `make
  lint`. Match the conventions of the surrounding file instead.
- The underlying commands, if you must run them directly:
  ```bash
  xcodebuild build -scheme KineticTextKit \
    -destination 'generic/platform=iOS Simulator'
  xcodebuild test -scheme KineticTextKit \
    -destination 'platform=iOS Simulator,name=iPhone 17'
  ```
  The package has no `.xcodeproj` of its own — `xcodebuild` resolves the
  scheme from `Package.swift`, so no `-project` or `-workspace` flag is needed.
- **The example app is built separately**, through its own project and the
  shared `Example` scheme. `make build` and `make test` do not touch it:
  ```bash
  xcodebuild build -project Example/KineticTextKit.xcodeproj -scheme Example \
    -destination 'generic/platform=iOS Simulator'
  ```

## Try it

The Example app has a root `deploy`, so opening a pull request or pushing to
one builds, archives and uploads it to Firebase App Distribution — the same
contract every UI-surface repository follows (`CONVENTIONS.md` → *UI surfaces
only*).

```bash
make deploy   # delegates to $(MAKE) -C Example deploy
```

- **Configuration** — `Example/Makefile` names the destination directly as
  `FIREBASE_PROJECT`/`FIREBASE_APP`/`FIREBASE_GROUPS`: project
  `lightmate-development-390f6` ("Lightmate Development"), app
  `1:480717957783:ios:a6d14a3477535a158f97d2` (*KineticTextKit*), registered
  for `com.laugga.kinetic-text-kit-example`. The Example app links no Firebase
  SDK, so there is no `GoogleService-Info.plist` to read these from instead —
  see the gotchas. A registered bundle identifier never changes, so a new one
  is a new Firebase app: `laugga/ops`'s `host/firebase-app.sh` registers it and
  rewrites `FIREBASE_APP`.
- **Build and signing** — Debug configuration, automatic signing, team
  `JJC3QT2D2L`. `Example/Support/ExportOptions.plist` exports with
  `method = debugging`, so only devices registered in that Apple team can
  install the build.
- **Version** — `Example/Scripts/Version/version.sh`, vendored unchanged from
  `laugga/ops`'s `share/version/` (`CONVENTIONS.md` → *Versioning*).
  `make -C Example deploy` refuses a dirty tree or unpushed commits before
  archiving.
- **Goes to** — Firebase App Distribution, group `internal`. The group and
  the machine's Firebase CLI login are host setup; `deploy` never creates
  either.
- **One-time setup** — the machine running `deploy` must be signed in to
  Apple team `JJC3QT2D2L` in Xcode, and to the Firebase CLI
  (`firebase login`). A new tester's device is registered in that Apple team
  by hand before it can install a build.
- **What it prints** — a tester install link, which goes in this section of
  the pull request description, replaced wholesale on the next build rather
  than appended.

## Project layout

| Path | What's there |
|---|---|
| `Sources/KineticTextKit/` | The whole library, flat — one type per file. `KineticTextLayer.swift` is the core; the rest builds on it. `HapticFeedback.swift` is internal (`HapticFeedbackPlaying` / `HapticFeedbackPlayer`), used by the switches. |
| `Tests/KineticTextKitTests/` | XCTest unit tests. Thin — two tests at present. |
| `Example/` | The example app — `KineticTextKit.xcodeproj`, its sources, and its own `Makefile` (`build`, `test`, `archive`, `deploy`). See below, and "Try it" above. |
| `Playground/` | Xcode playground samples. **Not a build target.** See below. |
| `Package.swift` | One library product, one target, one test target. No dependencies. |

### The example app

`Example/` is an iOS app whose catalog lists a screen — a *scenario* — for each
meaningful configuration of each public type, grouped by type. It follows the
UI component repository example-app pattern, and it consumes the package the
way any other consumer does: a local Swift package dependency, `import
KineticTextKit`, public API only.

- **Public API only.** Never `@testable import`, and never widen the package's
  API to suit the example — if a scenario cannot be written against the public
  surface, that is worth knowing, not working around.
- **Naming.** The app is called *KineticTextKit*, but its target is
  `Example`. The target, its product and its module are all `Example` —
  `PRODUCT_NAME = $(TARGET_NAME)`, so the build is `Example.app` and `deploy`
  uploads `Example.ipa` — and so is the shared scheme, the same name in every
  component repository. The name on the home screen is the display name,
  `INFOPLIST_KEY_CFBundleDisplayName = KineticTextKit`, set in both
  configurations, and it is also what the Firebase app is nicknamed: whatever
  the build calls itself (`CONVENTIONS.md` → *Names* → *Firebase app
  nickname*). The bundle identifier is `com.laugga.kinetic-text-kit-example`.
  That is `template-library-swift`'s Example exactly; the project and the
  source directory keep the library's name, as the template's do.
- **Do not name the target after the library.** A module called
  `KineticTextKit` would clash with the package it imports, and a target
  called `KineticTextKit` puts its intermediates in the same
  `KineticTextKit.build/…/KineticTextKit.build` as the package target — Xcode
  26 refuses that with *Multiple commands produce …*. The target was once
  named that way and needed a `PRODUCT_MODULE_NAME` and a `PROJECT_TEMP_DIR`
  override to build; as `Example` it needs neither, so neither is set.
- **Layout.** `App/` holds the lifecycle, `Catalog/` the index
  (`Catalog.swift` is the list of every entry), `Scenarios/<Type>/` one file per
  scenario, `Resources/` the asset catalog. The project uses a synchronised
  folder, so a new file under `Example/KineticTextKit/` is picked up without
  editing `project.pbxproj`.
- **Adding a scenario** is a file under `Scenarios/<Type>/` plus an entry in
  `Catalog.swift`. Each scenario carries a `#Preview` of itself.
- **The app is pinned to light appearance.** The components' default colours
  are black and are set as `CGColor`s, so they do not follow dark mode.
- **`LAULabel` draws on its top edge.** It never gives its text layer a frame,
  so the text is laid out against a height of zero. The scenarios show that as
  it is rather than hiding it.
- **The `KineticTextLayer` scenarios do the frame work in the open.** The layer
  lays its path out against its own frame at the moment `text`, `font` or
  `contentMode` is set, and a `CALayer` does not resize with the view it was
  added to — so a consumer sets the frame before the content and sets the
  content again when the frame changes. Those screens each write that out
  themselves, deliberately, rather than behind a shared helper the way
  `TextViewStage` does it for the `LAUTextView` section.
- **A scenario's frame work belongs in a view's `layoutSubviews`, not the view
  controller's `viewDidLayoutSubviews`.** `viewDidLayoutSubviews` runs before
  `ScenarioViewController`'s stack view has sized what it arranges, so a canvas
  read there still has zero bounds — and a text layer laid out against that
  never recovers, because nothing asks it again. `LayoutReportingView` exists
  only to hand that moment back to the scenario; it decides nothing about the
  layer.

### The Playground

`Playground/` holds hand-run samples of the controls (`ViewController`,
`PathSwitch`, `SwiftUI`, `UIKit Dynamics`, `Core Animation Sample`, `LAUSwitch`
pages). Open `Playground/LAUTextLayer.xcworkspace` in Xcode.

It is kept alongside `Example/` deliberately, as a separate fast-iteration
surface — not an example waiting to be migrated into the catalog.

**It is exploratory, and it is not expected to keep building.** Nothing gates
it: `make build` and `make test` do not touch it, and there is no CI. Treat it
as sample code, not as a target — a change that breaks a playground page is not
a build failure, and you are not obliged to keep the pages compiling. It is
worth updating a page when you change the API it demonstrates, but say so in
the PR rather than letting it silently rot.

Known rot in it already, none of it worth fixing on the way past unless a task
asks:

- The workspace is still named `LAUTextLayer.xcworkspace`, from before the
  module was renamed to KineticTextKit.
- It references a `group:Dependencies` folder that does not exist in the repo,
  and it has **no schemes** — `xcodebuild -list` on it reports none, so it
  cannot be driven from the command line at all. Xcode GUI only.
- `Pages/LAUSwitchWithLabel.xcplaygroundpage` exists on disk but is not listed
  in `contents.xcplayground`, so Xcode does not show it.

## Conventions

### Branch names

Prefix the branch with the change type (lowercase):

- `fix/<short-slug>`
- `chore/<short-slug>`
- `feature/<short-slug>`
- `refactor/<short-slug>`

### Pull requests

- **Title** is short and matches the originating task title (e.g. the Notion
  task). Prefix with the change type, capitalized with spaces around the slash:
  `Fix / …`, `Chore / …`, `Feature / …`, `Refactor / …`.
- **Description** gives a high-level summary of the code changes, for review
  reference.
- **Reference the Notion task**, when there is one, under a `## Task` heading:

  ```
  closes LM-43 — https://app.notion.com/p/Title-<32-char-id>
  ```

  The full URL goes in every task PR, partial work included — it is what links
  the PR to the task. The magic word alone decides completion: `closes` when
  the task is finished, `ref` when it is not.
- Open PRs against `main` — this repository's default and integration branch.
  Keep them focused and reviewable.
- **Never merge a pull request.**

### Code style

- Match the conventions of the surrounding file — naming, structure, and
  comment density. There is no linter to fall back on.
- The `LAU` prefix is historical (the module was `LAUTextLayer` before the
  rename in #2). Existing type names keep it; new types do not need it.

## Gotchas

- **The Example app's Firebase identity is two literal values, not a config
  file.** `Example/Makefile`'s `FIREBASE_PROJECT`/`FIREBASE_APP` name the
  Firebase App Distribution destination directly. There is deliberately no
  `GoogleService-Info.plist`: the Example app links no Firebase SDK, so
  vendoring the full Google-issued file — API key and all — would commit a
  project-wide credential this public repository has no functional use for.
  If the Example app ever does link the Firebase SDK for something real,
  that's the point to add the plist and switch the Makefile to read from it.
- **`main` ships straight to the app. There are no releases.** The repository
  has no tags, and the Lightmate app follows this package's `main` **branch**,
  not a version. So anything merged to `main` reaches the app the next time it
  resolves packages — there is no version gate in between. Treat every merge
  as potentially breaking a consumer, and check the app's usage before changing
  or removing public API. Moving the app onto a new revision is a change in
  the app's repository, not this one.
- **This repository is public, and it is cloned over HTTPS**, not SSH. Older
  notes that call it private and in need of credentialed access are out of
  date: `gh repo view laugga/kinetic-text-kit-ios` reports `PUBLIC`. Nothing special
  is needed to check it out. Being public also means: no secrets, no customer
  data, no internal URLs — and nothing specific about the private repositories
  that use it. Saying what the package is for is fine; their paths, files and
  configuration do not belong here, in code, docs or comments.
- **CI gates the merge.** `.github/workflows/ci.yml` runs `make build` and
  `make test` on `macos-latest` for every pull request into `main`, and a human
  cannot merge without it passing. Xcode Cloud isn't an option here: it needs
  an app or framework target in an Xcode project, and this SwiftPM package has
  neither.
- **The deployment target is iOS 12.0** — `Package.swift` declares no
  `platforms:`, so SwiftPM's default for tools-version 5.7 applies, and builds
  come out as `arm64-apple-ios12.0-simulator`. Anything newer must be behind
  `@available`, as `LAULabel` (iOS 14+) already is. If you need a real floor,
  raise it deliberately in `Package.swift` and check the app's own target
  first — do not assume.
- **`.build/` and `.swiftpm/` appear after a build** and are git-ignored.
  Do not commit them.

## Definition of done

Before opening a PR, confirm:

- [ ] `make build` succeeds
- [ ] `make test` passes
- [ ] The `Example` scheme builds — it is the check that the public API still
      works for a consumer
- [ ] Public API changes are checked against the Lightmate app's usage —
      `main` is what the app consumes
- [ ] Branch and PR title follow the conventions above
- [ ] No unintended churn (`.build/`, `.swiftpm/`, DerivedData) is committed
