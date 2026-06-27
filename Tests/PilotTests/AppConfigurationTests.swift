import Testing
@testable import Pilot

struct AppConfigurationTests {

    @Test func testConfigurationLoadsCorrectly() {
        // Given we have a mock configuration
        let config = AppConfiguration.mock
        
        // Then it should have the development environment
        #expect(config.environment == .development)
        #expect(config.isDebugMenuEnabled == true)
    }

}
