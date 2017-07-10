function Get-GravatarHash {
    param (
        [String]$EmailAddress
    )
    $EmailAddressSanitized = $EmailAddress.TrimStart().TrimEnd().ToLower()

    $md5 = new-object -TypeName System.Security.Cryptography.MD5CryptoServiceProvider
    $utf8 = new-object -TypeName System.Text.UTF8Encoding
    [System.BitConverter]::ToString($md5.ComputeHash($utf8.GetBytes($EmailAddressSanitized))).ToLower() -replace "-",""
}

function Get-GravatarAvatarURL {
    [CmdletBinding(DefaultParameterSetName="All")]
    param (
        [Parameter(Mandatory)][String]$EmailAddress,
        $Size,
        
        [ValidateSet("404","mm","identicon","monsterid","wavatar","retro","blank")]
        [Parameter(ParameterSetName="DefaultType")]
        $DefaultType,

        [Parameter(ParameterSetName="DefaultURL")]
        $DefaultURL

    )
    $QueryStringParameters = @()
    if ($Size) {
       $QueryStringParameters += "s=$Size"
    }
    if ($DefaultType) {
       $QueryStringParameters += "d=$DefaultType"
    }
    if ($DefaultURL) {
       $QueryStringParameters += "d=$DefaultURL"
    }

    $QueryString = if($QueryStringParameters){
        "?" + ($QueryStringParameters -join "&")
    }

    $Hash = Get-GravatarHash -EmailAddress $EmailAddress
    "https://www.gravatar.com/avatar/$Hash" + $QueryString
}
