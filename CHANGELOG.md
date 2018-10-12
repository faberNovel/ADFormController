# Change Log
All notable changes to this project will be documented in this file.
`ADFormController` adheres to [Semantic Versioning](http://semver.org/).

## [5.5.3]

### Added
- Add `hideRightViewWhenEditing` to FormCellConfiguration

## [5.5.2]

### Fixed
- Change `.asciiCapable` keyboard type to `.default`

## [5.5.1]

### Fixed
- Fully disable text view when cell is not enabled

## [5.5.0]

### Added
- Add `clearButtonMode` to text configuration
- Add `currentEditingIndexPath() -> IndexPath?` method on form controller

## [5.4.0]

### Added
- Add `FormControllerAction`: be notified when the user taps the right or the left view of a cell

## [5.3.0]

### Added
- Add `textInputAccessibilityIdentifier` and `switchAccessibilityIdentifier` in configurations (usefull in UI tests)

## [5.2.0]

### Added
- Add possibility to customize `UIDatePicker` in `.date` mode
- Add possibility to override `returnKeyType` and `returnAction` for each cell

## [5.1.0]

### Added
- Add possibility to override cell `inputAccessoryView`

## [5.0.1]

### Fixed
- Fix crash when picker options are empty

## [5.0.0]

### Added
- Add `contentInset` property
- Each cell can have a right and left accessory view

### Updated
- Bump project to iOS9
- Use stack view instead of manual constraints

### Removed

### Fixed
