#
# Copyright 2019, Alexis La Goutte <alexis dot lagoutte at gmail dot com>
#
# SPDX-License-Identifier: Apache-2.0
#

function Add-ArubaIAPSSID {

    <#
        .SYNOPSIS
        Add a SSID to Aruba Instant Cluster

        .DESCRIPTION
        Add a SSID to Aruba Instant Cluster

        .EXAMPLE
        Add-ArubaIAPSSID -SSID PowerArubaIAP-Guest -type Guest -opmode opensystem -vlan 1

        Add a Open SSID (type Guest) named PowerArubaIAP-Guest on vlan 1

    #>

    Param(
        [Parameter (Mandatory = $true)]
        [string]$ssid,
        [Parameter (Mandatory = $true)]
        [ValidateSet("Employee", "Voice", "Guest")]
        [string]$type,
        [Parameter (Mandatory = $true)]
        [ValidateSet("opensystem", "wpa2-aes", "wpa2-psk-aes", "wpa-tkip",
            "wpa-psktkip", "wpa-tkip wpa2-aes", "wpa-psk-tkip",
            "wpa2-psk-aes", "static-wep", "dynamicwep", "mpskaes",
            "wpa3-open", "wpa3-sae-aes")]
        [string]$opmode,
        [Parameter (Mandatory = $true)]
        [int]$vlan
    )

    Begin {
    }

    Process {

        $uri = "rest/ssid"

        $vlan_info = @{
            "action" = "create"
            "value"   = $vlan.ToString()
        }

        $ssid_profile = @{
            "action"       = "create"
            "ssid-profile" = $ssid
            "type"         = $type
            "opmode"       = $opmode
            "vlan"         = $vlan_info
        }

        $body = @{
            "ssid-profile" = $ssid_profile
        }

        $body | Convertto-Json

        $response = Invoke-ArubaIAPRestMethod -uri $uri -body $body -method 'POST'

        $response
    }

    End {
    }
}
