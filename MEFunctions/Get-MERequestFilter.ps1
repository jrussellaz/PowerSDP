function Get-MERequestFilter
{
        <#
        .SYNOPSIS
     This function is used to return all Queue Filters.
        .DESCRIPTION
     Get Request Queue Filters
        .EXAMPLE
    Get-MERequestFilter -SdpUri "http://sdp.domain.com" -ApiKey "1234567A-2AB0-12A3-A123-1234567890AB" -RequestID 1234
        .PARAMETER ApiKey
        This parameter is the API Key assigned to each technician. This serves as authentication to Service Desk Plus
        .PARAMETER SdpUri
        This is the URI for Service Desk Plus
        #>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 2)]
		[String]$ApiKey,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 3)]
		[String]$SdpUri
		
	)
	begin
	{
		if ($SdpUri[$SdpUri.Length - 1] -eq "/") { $Uri = $SdpUri + "sdpapi/request" }
		else { $Uri = $SdpUri + "/sdpapi/request" }
	}
	process
	{
			$Uri = $Uri + "?format=json&OPERATION_NAME=GET_REQUEST_FILTERS&TECHNICIAN_KEY=$ApiKey"
			$result = Invoke-RestMethod -Method Post -Uri $Uri -ErrorAction SilentlyContinue -ErrorVariable GetRequestFilterError
			$result.operation.details
		
		if ($GetRequestFilterError)
		{
			Write-Warning -Message "API Call Failed Reason : $GetRequestFilterError"
		}
		
	}
}