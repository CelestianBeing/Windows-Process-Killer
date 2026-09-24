# Security Policy

## Scope

This project terminates explicitly selected Windows processes. It does not intentionally modify system files, registry settings, credentials, or security policies.

## Reporting a security issue

Please do not publish sensitive exploit details in a public issue.

Open a private security report through the repository's supported GitHub security reporting mechanism if enabled.

Include:

- Windows version
- PowerShell version
- Reproduction steps
- Expected behavior
- Actual behavior
- Relevant process name
- Relevant output or error message

## Safety concerns

If a proposed change could terminate a Windows authentication, security, update, networking, or core system process, verify it against current Microsoft documentation before submitting the change.
