<#
.SYNOPSIS
    Converts an Exchange Online user mailbox to a shared mailbox.

.DESCRIPTION
    This reusable script intentionally limits itself to the Exchange Online
    mailbox-type change. Hybrid/on-premises Active Directory account lifecycle,
    licence removal and identity deprovisioning are environment-specific and
    are not automated here.

.PARAMETER Identity
    Mailbox identity, normally a UPN or primary SMTP address.

.PARAMETER DisconnectWhenFinished
    Disconnects the Exchange Online PowerShell session after completion.
#>

[CmdletBinding(SupportsShouldProcess, ConfirmImpact = 'High')]
param(
    [Parameter(Mandatory)]
    [string]$Identity,

    [switch]$DisconnectWhenFinished
)

if (-not (Get-Module -ListAvailable -Name ExchangeOnlineManagement)) {
    throw 'ExchangeOnlineManagement is not installed. Use Install-Module ExchangeOnlineManagement.'
}

Import-Module ExchangeOnlineManagement -ErrorAction Stop
Connect-ExchangeOnline -ShowBanner:$false

try {
    $Mailbox = Get-Mailbox -Identity $Identity -ErrorAction Stop

    if ($Mailbox.RecipientTypeDetails -eq 'SharedMailbox') {
        Write-Output "'$Identity' is already a shared mailbox."
        return
    }

    if ($PSCmdlet.ShouldProcess($Identity, 'Convert Exchange Online mailbox to SharedMailbox')) {
        Set-Mailbox -Identity $Identity -Type Shared -ErrorAction Stop
    }

    $After = Get-Mailbox -Identity $Identity -ErrorAction Stop |
        Select-Object DisplayName, PrimarySmtpAddress, RecipientTypeDetails

    $After
}
finally {
    if ($DisconnectWhenFinished) {
        Disconnect-ExchangeOnline -Confirm:$false
    }
}
