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
                # Combine fields from both CSVs
                $combinedObject = [PSCustomObject]@{
                    # Include all fields from the left item
                    PSObject.Properties.AddRange($leftItem.PSObject.Properties)
                }

                # Include all fields from the right item, avoiding duplicates
                foreach ($property in $rightItem.PSObject.Properties) {
                    if (-not $combinedObject.PSObject.Properties.Match($property.Name)) {
                        $combinedObject | Add-Member -MemberType NoteProperty -Name $property.Name -Value $property.Value
                    }
                }

                $joinedArray += $combinedObject
                $matched = $true
            }
        }

        if ($JoinType -eq "Left" -and -not $matched) {
            $joinedArray += $leftItem
        }
    }

    return $joinedArray
}
