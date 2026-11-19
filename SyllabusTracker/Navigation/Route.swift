import Foundation

/// Every push-navigation destination in the app.
enum Route: Hashable {
    case list
    case detail(UUID)
    /// `nil` = add a new topic, otherwise edit the topic with this id.
    case form(UUID?)
}
