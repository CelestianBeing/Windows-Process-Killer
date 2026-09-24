# Contributing

## Before opening a pull request

- Test on Windows 10 or Windows 11.
- Run the script with `-DryRun` first.
- Confirm the target process is optional and non-critical.
- Confirm the process is not required by a common Windows feature.
- Confirm it is not already in the protection list.
- Do not add Windows security or authentication processes to `$targets`.
- Do not add registry or service-disabling behavior without a separate design discussion.

## Pull requests

Include:

- What process was added or changed
- Why it is considered optional
- Windows versions tested
- Whether the process automatically restarts
- Whether terminating it affects a user-visible feature

Keep changes narrowly scoped.
