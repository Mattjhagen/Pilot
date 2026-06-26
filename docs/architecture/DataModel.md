Data Flow & DTOs

Data may originate from external APIs or be stored locally. We distinguish between:

* Domain models: Rich types used throughout the app to represent data and encapsulate basic logic (e.g. Account, Transaction).
* DTOs (Data Transfer Objects): Lightweight structs used to map external data (JSON from APIs) or plain types returned by repository interfaces. A DTO isolates decoding logic and shields domain models from external schema changes . When a DTO is complex or belongs to an external domain (e.g. bank API responses), it makes sense to define a separate DTO layer. For simple, flat data structures, mapping directly to a domain model may suffice.

Use dedicated services or importers to convert between DTOs and domain models. Avoid using domain models directly for JSON decoding or network requests; this reduces coupling and allows you to validate and transform data before persisting.

Relationships & Cascade Rules

When modelling relationships:

* Choose @Relationship(deleteRule: .cascade) for entities where deleting the parent should remove all children (e.g. removing an Account deletes its Transactions).
* Use .nullify delete rules when you want to disassociate relationships but preserve child records (e.g. unlinking a subscription from a user but keeping the subscription record for historical reporting).
* For many-to-many relationships (e.g. tags on transactions), use bridging models (Tagging) or SwiftData’s support for to-many relationships on both sides.

Ensure each relationship declares an inverse so SwiftData can maintain referential integrity. Write unit tests to ensure cascade behavior works as expected.

Domain Evolution & Versioning

Financial products evolve—new account types, features, and regulatory requirements will appear. Plan for change:

* Version your models: Use migration strategies when adding or renaming properties. SwiftData may automate migrations for simple changes. For complex migrations, write custom migration scripts to transform existing data.
* Use transient properties: For data derived from other fields (e.g. computed interest), mark them with @Transient so they are not persisted and can be recalculated.
* Deprecate gracefully: When replacing a field or model, maintain compatibility by mapping old data to the new format until a full migration is completed.

Testing & Previews

* Unit tests: Write tests for validation methods, computed properties and repository functions. Use in-memory ModelContainers to isolate tests from persistent stores.
* UI Previews: Use modelContainer(for:inMemory:) to provide mock model contexts for SwiftUI previews. Provide sample data via DTOs or repository injections.

Testing ensures that business logic within models behaves correctly across a range of scenarios .

Security & Privacy Considerations

* Token storage: Persist tokens or sensitive credentials in the Keychain or Secure Enclave. Do not store plain account numbers or API secrets in SwiftData.
* Encryption: Encrypt local data if it contains sensitive information. SwiftData does not provide encryption by default.
* Least privilege: Do not persist more data than necessary. Delete or anonymize data when it is no longer needed.
* Auditing: For features like trust metrics and lending, log changes to key entities (e.g. loans) in an audit trail for compliance and analysis.

Extensibility & Future Work

* New modules: When adding features (e.g. investments, taxes), define new models in their respective modules while following the principles outlined here. Reuse existing patterns for validation, repository abstraction and relationship definitions.
* Remote sync: Integrate remote synchronization (e.g. iCloud, custom backend) via repository implementations. Keep synchronization logic separate from domain models to minimize coupling.
* Data analytics: When building analytics features, define analytics models or DTOs separate from domain models. Aggregate data via services to generate insights rather than embedding analytics logic in the models.

Conclusion

A well-designed data model architecture is the backbone of Pilot. By modelling domain entities clearly, embedding simple business rules within them, abstracting persistence behind protocols, and maintaining flexibility for future changes, we ensure that Pilot can grow into a robust, secure and maintainable financial operating system. Carefully planned relationships, validation logic, and data access layers will allow us to evolve the product without rewriting the entire codebase, providing a solid foundation for the AI and financial functionality to build upon.
