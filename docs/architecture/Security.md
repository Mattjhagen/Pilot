Security Architecture

This document defines the security architecture for Pilot, an AI‑powered financial operating system.  Financial applications handle highly sensitive data, so the bar for protecting user information is extremely high.  The guidelines here set out how every layer of Pilot—from data storage to networking, authentication, development, and operations—must be designed to minimise risk.

Threat Model and Security Goals

Before implementing any features, understand the threats that Pilot must defend against.  Threats include credential theft, man‑in‑the‑middle (MitM) attacks on network traffic, device loss or theft, reverse‑engineering of the binary, malicious third‑party code, rogue insiders, and compromised backends.  Pilot’s security goals are:

* Confidentiality: Sensitive data (authentication tokens, personal information, transaction history) must remain secret.  Protect data at rest and in transit with encryption .
* Integrity: Data must not be tampered with.  Ensure that network requests are authenticated, responses are validated, and local data is signed or hashed when appropriate .
* Authenticity: Verify the identity of users and servers.  Only trusted code should run, and communications should be mutually authenticated .
* Least Privilege: Request only the permissions and data absolutely necessary to perform a task .
* Defense in Depth: Combine multiple controls.  If one layer fails, others still protect the user .

Secure Storage

Pilot stores secrets such as OAuth tokens, refresh tokens, cryptographic keys and user preferences.  These must never be hard‑coded or stored in plaintext:

Keychain and Data Protection

* Use Keychain Services for credentials and tokens.  The Keychain is encrypted by iOS and protected by the user’s passcode .  It offers hardware‑backed encryption and ensures secrets are not accessible if the device is locked.
* Select appropriate accessibility constants.  Use kSecAttrAccessibleWhenUnlockedThisDeviceOnly or kSecAttrAccessibleWhenPasscodeSetThisDeviceOnly for highly sensitive items .  These constants tie data to the device and require a passcode to access. .
* Avoid UserDefaults for secrets.  Secrets must not be stored in UserDefaults, plist files or plain text files .
* Clean up on first install.  Wipe any legacy Keychain data on first install to avoid reusing data if a device is sold .
* Use Data Protection classes for files.  For local files (e.g. encrypted account statements), apply NSFileProtectionComplete or CompleteUntilFirstUserAuthentication as appropriate .

Secure Enclave

* Generate private keys in the Secure Enclave when asymmetric cryptography is required.  Keys generated with kSecAttrTokenIDSecureEnclave never leave the enclave and can require Face ID, Touch ID or passcode for access  .
* Use access control flags such as kSecAccessControlBiometryAny or kSecAccessControlUserPresence to require biometric or passcode authentication before secret retrieval .

Minimise Token Exposure

* Use short‑lived access tokens and refresh tokens.  Keep access tokens valid for minutes and rotate refresh tokens on every use .  Store refresh tokens in the Keychain and never embed them in the binary.
* Apply the principle of least privilege to tokens.  Grant only the permissions necessary for the requested operation .
* Encrypt sensitive files before writing.  When storing user documents or cached data offline, encrypt them with keys stored in the Keychain .

Secure Networking

All off‑device communication must be secure.  Users entrust Pilot with highly sensitive financial data; network traffic is a prime attack vector.

* Enforce App Transport Security (ATS).  ATS requires TLS for all network requests.  Do not disable ATS or add domains to the exception list .  Use TLS 1.2 or TLS 1.3 with strong cipher suites .
* Implement certificate pinning.  Pin the public key or certificate of your backend to mitigate MitM attacks .  Provide a backup pin to allow certificate rotation without breaking the app .
* Use mutual TLS when appropriate.  For highly sensitive services (e.g. trust score computation), require client certificates .
* Validate TLS errors and fail closed.  Never silently accept invalid certificates .  Log failures for monitoring without leaking sensitive details.
* Use PKCE with OAuth 2.0.  For authorisation flows, use the OAuth 2.0 Authorisation Code flow with Proof Key for Code Exchange (PKCE) instead of the implicit flow .
* Do not cache sensitive responses.  Disable caching for requests that may contain secrets.  Review caching APIs to ensure they are not storing sensitive data on disk .

Authentication & User Access

* Leverage Face ID or Touch ID.  Use LocalAuthentication to prompt users for biometrics when retrieving sensitive data or performing high‑risk actions (e.g. confirming a loan).  Combine biometrics with Keychain access controls to ensure secrets are released only after biometric verification .
* Design fallback flows.  Provide passcode fallbacks if biometrics fail or are unavailable .
* Implement session management.  Invalidate tokens on logout, support silent token refresh with exponential backoff, and allow users to view and terminate other sessions .
* Detect state changes.  Detect if a new fingerprint has been enrolled since last login and require re‑authentication .

Privacy and Data Minimisation

* Collect only what is necessary.  Justify each permission request.  Provide clear usage descriptions in Info.plist for sensitive capabilities such as HealthKit, location, camera and microphone .  Pilot should never request unnecessary access to the user’s data.
* Avoid storing PII in logs.  Remove verbose logging from release builds and scrub sensitive data from crash reports .
* Respect user privacy regulations.  Support data deletion and export flows, and clearly communicate data practices in the privacy policy .

Logging and Debugging

* Do not log secrets.  Remove use of NSLog, printf or similar calls that may log sensitive information in production.  Sensitive values should never appear in logs .
* Mask sensitive data on backgrounding.  Use applicationWillResignActive and applicationDidEnterBackground to hide sensitive information before iOS takes a snapshot for the app switcher .
* Secure the pasteboard.  Avoid using the global pasteboard for secrets; clear the clipboard on exit and exclude sensitive information from the Universal Clipboard .
* Detect screen capture.  For screens displaying sensitive information (e.g. account numbers), detect if the screen is being recorded or captured and warn or obscure information .

Build Pipeline and Secret Management

* Never commit secrets.  API keys, certificates, provisioning profiles and other secrets must not reside in the repository.  Use environment variables or secure secret storage provided by CI/CD systems .
* Use secure certificate management.  Use Fastlane Match or Apple‑managed signing to store signing certificates in encrypted repositories with restricted access .
* Protect CI pipelines.  Ensure only authorised contributors can trigger releases.  Keep audit logs of who uploaded what to App Store Connect .
* Use reproducible builds.  Build artifacts should be reproducible and traceable; this helps detect tampering.

Dependencies and Supply‑Chain Security

* Vet third‑party libraries.  Use only actively maintained and trusted libraries.  Keep dependencies up to date and pin versions to known safe releases .
* Audit transitive dependencies.  Use software composition analysis (SCA) tools to detect known vulnerabilities in dependencies .
* Prefer Swift Package Manager.  Avoid loading remote code at runtime; use static dependencies over dynamic scripts .

Secure Coding Practices

* Validate inputs and parse defensively.  Perform client‑side validation for UX but enforce validation on the server .  Use Swift’s type safety and limit recursion when parsing JSON .
* Avoid injection and code execution vulnerabilities.  Do not use unsafe deserialization or dynamic code loading.
* Strip debug symbols for release.  Obfuscate string literals when possible to make reverse‑engineering more difficult .
* Detect jailbreaks for high‑risk data.  If Pilot handles sensitive transactions, consider implementing jailbreak detection.  Use it only as an indicator; do not rely solely on it .

Testing and Verification

* Run static analysis.  Use Xcode’s static analyser and third‑party tools (e.g., MobSF, AppSweep) to detect insecure APIs, weak cryptography, or secrets in code .
* Perform dynamic testing.  Pen‑test authentication flows, token handling, local file exposure and network communications through proxy tools like Charles to ensure TLS and pinning behave correctly .
* Fuzz inputs.  Fuzz JSON parsers and local data stores to detect unexpected behaviours .
* Threat model regularly.  Use a structured approach (e.g., STRIDE or OWASP Mobile Top Ten) to identify and mitigate risks .
* Fix issues promptly.  Treat security vulnerabilities as high‑priority bugs; patch them quickly and release updates to users.

Response and Monitoring

* Implement anomaly detection.  Monitor for unusual behaviour (e.g. repeated failed logins, unexpected network destinations) and flag suspicious activity on the backend .
* Revoke credentials when compromise is suspected.  The backend must be able to revoke tokens or sessions if a device is stolen or a credential is exposed .
* Educate users.  Provide clear error messages and guidance when suspicious activity is detected.  Encourage them to use strong device passcodes and to enable automatic OS updates.

Ongoing Commitment

Security is not a one‑time task.  The landscape evolves, attackers adapt and new OS features emerge.  Pilot’s security posture should be continuously improved through regular reviews, penetration tests, code audits and training.  Each new feature must undergo a security review before release, and DECISIONS.md should document the rationale for any changes to the security architecture.
