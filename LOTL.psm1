foreach ($file in(Get-ChildItem "$PSScriptRoot\Functions" -Filter *.ps1 -Recurse)) {
    . $file.FullName
}