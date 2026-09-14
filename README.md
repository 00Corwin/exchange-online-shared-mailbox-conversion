# Exchange Online Shared Mailbox Conversion

A small, reusable PowerShell project for converting an Exchange Online user
mailbox to a shared mailbox.

## Example

```powershell
.\Convert-ToSharedMailbox.ps1 `
    -Identity user@example.com `
    -WhatIf
```

Then run without `-WhatIf` after validation.

## Deliberate safety boundary

The original workflow involved identity/mailbox lifecycle work. This sanitised
repository automates only the universally reusable Exchange Online mailbox-type
change.

It does **not** automatically disable/delete an on-premises AD account, remove
an Entra ID identity, remove Microsoft 365 licences, or run
`Disable-Mailbox`. Those actions are topology- and retention-dependent and
should be handled by a separate approved deprovisioning process.
