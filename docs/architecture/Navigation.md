Each module implements its own coordinator. The start() method sets up the root screen; navigate(to:) interprets route commands; finish() handles cleanup (e.g. dismissing modals). For tabs, use a TabCoordinator with multiple child coordinators, each handling navigation for its module. Use dependency injection to pass services and other dependencies to each coordinator.

Composition Root

The composition root (app entry point) sets up the root navigation environment and injects dependencies. It creates:

* The AppRouter or tab coordinator.
* Feature-specific routers/coordinators.
* Shared services (e.g. account repository, trust engine).

This centralizes the creation of flows and ensures consistent configuration across the app.

Integration with Other Modules

* Money: The Money module uses a dedicated router to navigate between account lists, transaction details, bill payments, etc.
* Trust: The Trust module presents metrics and improvement tips. Its coordinator handles flows to deeper explanations or improvement tutorials.
* AI: The AI module may trigger navigations based on insights. For example, if the AI suggests reviewing a bill, it calls the Money coordinator to present the Bill detail screen. Such cross-module navigation should go through a top-level router or a shared coordinator to avoid tight coupling.
* Automations: The Automations module may present creation wizards in modals or full screen covers; use .sheet(item:) for the wizard flow.
* Integrations & Lending: Integrations and Lending modules integrate seamlessly by conforming to the coordinator pattern. They provide routes for linking accounts, loan applications, and payment screens. The AppRouter orchestrates flows between them and other modules.

Testing & Previews

* Unit Tests: Test routers and coordinators by asserting state changes on the NavigationPath when calling navigation methods. Verify deep link handling maps URLs to correct routes.
* UI Tests: Simulate user taps and deep link openings to ensure navigation flows work end-to-end.
* Previews: For SwiftUI previews, provide mock routers/coordinators and sample data. This allows designers to preview flows without relying on live services.

Accessibility & UI Consistency

* Provide descriptive accessibility labels on navigation buttons and bar items.
* Use voiceOverFocus where appropriate to set focus on the correct element after navigation.
* Ensure navigation controls have sufficient size and hit targets. Use the design system’s button components to ensure consistency.
* Use system-provided gestures and controls (e.g. swipe to go back) unless custom interactions provide clear benefits.

Future Considerations

* State Restoration: Implement state restoration by serializing the NavigationPath and restoring it on app relaunch.
* Dynamic Tabs: As new features like Goals and Notifications are added, consider making the tab structure dynamic. Each feature module can register a tab configuration with the AppRouter.
* Custom Transitions: For some flows (e.g. AI insights or microloan offers), custom animations may enhance the experience. Encapsulate custom transitions within coordinators to avoid scattering animation code in views.
* Integration with Apple Intelligence: As Apple Intelligence APIs become available, integrate voice commands and natural language deep links. Map voice intents to route enums and update navigation accordingly.

Conclusion

A robust navigation architecture is essential for a complex application like Pilot. By adopting NavigationStack, route enums, centralized navigation state, and the Coordinator/Router pattern, we ensure navigation flows are type-safe, maintainable, and scalable. Decoupling navigation logic from views improves testability and reusability, while consistent modal presentation and deep link handling keep the user experience coherent. As the app evolves with new modules and features, this architecture provides a strong foundation to extend navigation patterns and maintain a seamless user journey.
