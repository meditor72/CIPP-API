function Get-CIPPSecureScorePercentage {
    [CmdletBinding()]
    param (
        $TenantFilter,
        $APIName = "Get Secure Score Percentage",
        $ExecutingUser
    )

   # Get Secure Score
try {
    $SecureScore = New-GraphGetRequest -uri "https://graph.microsoft.com/beta/security/secureScores?`$top=1" -tenantid $TenantFilter -noPagination $true

    $Result = [PSCustomObject]@{
    Percentage     = [int](($SecureScore.currentScore / $SecureScore.maxScore) * 100)
    CurrentScore = $SecureScore.currentScore
    MaxScore = $SecureScore.maxScore
    }

    Log-request -API "Get-CIPPSecureScorePercentage" -tenant $tenant -message "Secure Score on $($tenant) is $($Result)" -sev "Debug"
}
catch {
    Log-request -API "Get-CIPPSecureScorePercentage" -tenant $tenant -message "Secure Score Retrieval on $($tenant). Error: $($_.exception.message)" -sev "Error" 
}
    return $Result
}
