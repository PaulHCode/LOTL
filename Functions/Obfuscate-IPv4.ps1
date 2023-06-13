<#
.SYNOPSIS
    Obfuscate an IPv4 address.
.DESCRIPTION
    Obfuscate an IPv4 address.
.PARAMETER IPv4
    The IPv4 address to obfuscate.
.PARAMETER Octal
    Obfuscate the IPv4 address using octal notation.
.PARAMETER Hex
    Obfuscate the IPv4 address using hexadecimal notation.
.PARAMETER Decimal
    Obfuscate the IPv4 address using decimal notation.
.PARAMETER ListAll
    Obfuscate the IPv4 address using all methods and return all results.
.PARAMETER Random
    Obfuscate the IPv4 address using a random method for each octet.
.EXAMPLE
    Obfuscate-IPv4 -IPv4 192.168.1.1 -Octal
    Convert the IP address to Octal notation.
.EXAMPLE
    @('192.168.1.1','10.10.10.1') | obfuscate-IPv4 -Octal
    Convert an array of IP addresses to Octal notation.
.EXAMPLE
    Obfuscate-IPv4 -IPv4 -ListAll
    List all ways to represent the IP using a combination of traditional, octal, and hex for each octet randomly
.EXAMPLE
    Obfuscate-IPv4 -IPv4 -Random
    Obfuscate the IP address using a random method for each octet.
.NOTES
    This function shows how to use:
    - ParameterSetName parameter to allow for multiple parameter sets
    - ValidateScript to validate the input
    - Switch parameters
    - Configure a function to process input from the pipeline
#>
Function Obfuscate-IPv4 {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Octal')]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Hex')]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Decimal')]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'Random')]
        [Parameter(Mandatory = $true, ValueFromPipeline = $true, ParameterSetName = 'ListAll')]
        [ValidateScript({ $_ -match [IPAddress]$_ -and ([ipaddress]$_).IsIPv4MappedToIPv6 -eq $false -and ([ipaddress]$_).IsIPv6LinkLocal -eq $false -and ([ipaddress]$_).IsIPv6SiteLocal -eq $false -and ([ipaddress]$_).IsIPv6Teredo -eq $false -and ([ipaddress]$_).IsIPv4MappedToIPv6 -eq $false })]
        [String]$IPv4,
        [Parameter(Mandatory = $false, ParameterSetName = 'Octal')]
        [switch]$Octal,
        [Parameter(Mandatory = $false, ParameterSetName = 'Hex')]
        [switch]$Hex,
        [Parameter(Mandatory = $false, ParameterSetName = 'Decimal')]
        [switch]$Decimal,
        [Parameter(Mandatory = $false, ParameterSetName = 'ListAll')]
        [switch]$ListAll,
        [Parameter(Mandatory = $false, ParameterSetName = 'Random')]
        [switch]$Random
    )
    Begin {
        
    }
    Process {
        If ($Octal) {
            (([ipaddress]$IPv4).IPAddressToString.Split('.') | ForEach-Object {
                '0' + [Convert]::ToString($_, 8)
            }) -join '.'
        }
        ElseIf ($Hex) {
            (([ipaddress]$IPv4).IPAddressToString.Split('.') | ForEach-Object {
                '0x' + [Convert]::ToString($_, 16)
            }) -join '.'
        }
        ElseIf ($Decimal) {
            $exp = 24
            ((([ipaddress]$IPv4).IPAddressToString.Split('.') | ForEach-Object {
                    [Math]::Pow(2, $exp) * $_
                    $exp = $exp - 8
                }) | Measure-Object -Sum).Sum
        }
        <#ElseIf ($Binary) {
            (([ipaddress]$IPv4).IPAddressToString.Split('.') | ForEach-Object {
                [Convert]::ToString($_, 2).PadLeft(8, '0')
            }) -join '.'
        }#>
        ElseIf ($ListAll) {
            $myOctal = (Obfuscate-IPv4 -IPv4 $IPv4 -Octal).split('.')
            $myHex = (Obfuscate-IPv4 -IPv4 $IPv4 -Hex).split('.')
            $myRegular = $ipv4.split('.')
            
            $results = ForEach ($octet0 in @($myOctal[0], $myHex[0], $myRegular[0])) {
                ForEach ($octet1 in @($myOctal[1], $myHex[1], $myRegular[1])) {
                    ForEach ($octet2 in @($myOctal[2], $myHex[2], $myRegular[2])) {
                        ForEach ($octet3 in @($myOctal[3], $myHex[3], $myRegular[3])) {
                            $octet0 + '.' + $octet1 + '.' + $octet2 + '.' + $octet3
                        }
                    }
                }
            }
            $results | Where-Object { $_ -ne $IPv4 }
            Obfuscate-IPv4 -IPv4 $IPv4 -Decimal
        }
        elseif ($Random) {
            $results = Obfuscate-IPv4 -IPv4 $IPv4 -ListAll
            $decimalResult = Obfuscate-IPv4 -IPv4 $IPv4 -Decimal
            $results = $results | Where-Object { $_ -ne $decimalResult } # Remove the decimal result from the list since it doesn't have octets
            $max = $results.count - 1
            $results[$(Get-Random -Minimum 0 -Maximum $max)]
        }
    }
    End {
        
    }
}

