Function Decode-FromBase64 {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'FromFile')]
        [string]$Path,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'FromText')]
        [string]$Text
    )
    Begin {}
    Process {
        If ($Path) {
            [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String([IO.File]::ReadAllText($Path)))
        }
        ElseIf ($Text) {
            [Text.Encoding]::UTF8.GetString([Convert]::FromBase64String($Text))
        }
    }
    End {}
}