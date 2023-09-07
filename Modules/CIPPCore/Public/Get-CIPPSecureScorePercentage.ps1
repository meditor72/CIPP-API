function Get-CIPPSecureScorePercentage {
    [CmdletBinding()]
    param (
        $TenantFilter,
        $APIName = "Get Secure Score Percentage",
        $ExecutingUser
    )

   # Get Secure Score
try {
    $SecureScore = New-GraphGetRequest -uri "https://graph.microsoft.com/beta/security/secureScores?$top=1" -tenantid $TenantFilter -noPagination $true

    $scores = $SecureScore | select-object currentScore,maxScore
    $Result = [PSCustomObject]@{
    Percentage     = [int]((([int]($scores.currentScore[0])) / ([int]($scores.maxScore[0]))) * 100)
    CurrentScore = $scores.currentScore[0]
    MaxScore = $scores.maxScore[0]
    }

    Write-Host "Doing: Get-CIPPSecureScorePercentage with percentage $($Result.Percentage)"

}
catch {
    
    Write-Host "Error: CIPPValueFunction - $($_.exception.message)"

    $Result = [PSCustomObject]@{
    Percentage     = 0
    CurrentScore = 0
    MaxScore = 0
    }
}
    return $Result
}
