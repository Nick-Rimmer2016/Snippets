function Join-Object {
    param (
        [Parameter(Mandatory = $true)] [array]$Left,
        [Parameter(Mandatory = $true)] [array]$Right,
        [Parameter(Mandatory = $true)] [string]$LeftJoinField,
        [Parameter(Mandatory = $true)] [string]$RightJoinField,
        [Parameter()] [string]$JoinType = "Inner" # Options: Inner, Left, Right, Full
    )

    $joinedArray = @()

    foreach ($leftItem in $Left) {
        $matched = $false
        foreach ($rightItem in $Right) {
            if ($leftItem.$LeftJoinField -eq $rightItem.$RightJoinField) {
                $joinedArray += [PSCustomObject]@{
                    # Fields from both CSVs
                    Accounts     = $leftItem.$LeftJoinField
                    Account_Info = $rightItem
                }
                $matched = $true
            }
        }
        if ($JoinType -eq "Left" -and -not $matched) {
            $joinedArray += $leftItem
        }
    }

    return $joinedArray
}
