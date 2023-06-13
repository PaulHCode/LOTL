Function Encode-AsImage {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'FromFile')]
        [string]$Path,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'FromText')]
        [string]$Text,
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'FromFile')]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'FromText')]
        [string]$OutputPath
    )
    Begin {}
    Process {
        If ($Path) {
            #$base64String = Encode-AsBase64 -Path $Path
            #$stream = [System.IO.File]::ReadAllBytes($Path)
            $stream = (Get-Content -Path $Path -AsByteStream)
        }
        ElseIf ($Text) {
            #$base64String = Encode-AsBase64 -Text $Text
            #$stream = [Text.Encoding]::UTF8.GetBytes($Text)
        }
        #$base64String = $base64String -replace '.{80}', "$&`r`n"
    
        $stream = [System.IO.MemoryStream][Convert]::FromBase64String($base64String)
        #$stream = [System.IO.Stream][convert]::FromBase64String($base64String) 
        #$stream = [System.IO.File]::ReadAllBytes() #ReadAllText($base64String)  # ReadAllText($base64String)
        $image = [System.Drawing.Bitmap][System.Drawing.Image]::FromStream($stream)
        $image.Save($OutputPath)
    }
    End {}
}