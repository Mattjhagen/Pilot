import Testing
import SwiftUI
@testable import Pilot

struct DesignSystemTests {

    @Test func testTypographyModifiers() {
        let titleFont = Font.pilotTitle
        #expect(titleFont != nil)
    }

    @Test func testSpacingValues() {
        #expect(Spacing.xs == 4)
        #expect(Spacing.sm == 8)
        #expect(Spacing.md == 12)
        #expect(Spacing.lg == 16)
        #expect(Spacing.xl == 24)
        #expect(Spacing.xxl == 32)
    }
}
