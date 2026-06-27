import Foundation

extension DependencyContainer {
    static let mock = DependencyContainer(
        configuration: .mock,
        logger: .mock
    )
}
