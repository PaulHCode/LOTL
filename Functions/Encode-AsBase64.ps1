Function Encode-AsBase64 {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'FromFile')]
        [string]$Path,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'FromText')]
        [string]$Text
    )
    Begin {}
    Process {
        If ($Path) {
            [Convert]::ToBase64String([IO.File]::ReadAllBytes($Path))
        }
        ElseIf ($Text) {
            [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($Text))
        }
    }
    End {}
}