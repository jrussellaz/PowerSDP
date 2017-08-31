function Get-MERequestWorkLog
{
        <#
        .SYNOPSIS
     This function is used to return all WorkLogs For The Supplied Request ID.
        .DESCRIPTION
     Get Request WorkLog
        .EXAMPLE
     Get-MERequestWorkLog -SdpUri "http://sdp.domain.com" -ApiKey "1234567A-2AB0-12A3-A123-1234567890AB" -RequestID 1234
        .PARAMETER RequestID
        The RequestID is the integer assigned to a "ticket" automatically by service desk plus
        .PARAMETER ApiKey
        This parameter is the API Key assigned to each technician. This serves as authentication to Service Desk Plus
        .PARAMETER SdpUri
        This is the URI for Service Desk Plus
       
        #>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $false, ValueFromPipelineByPropertyName = $true, Position = 0)]
		[alias ("id")]
		[Int32]$RequestID = $null,
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
		if ($RequestID -gt 0)
		{
			$Uri = $Uri + "/" + "$RequestID/worklogs"
			$Uri = $Uri + "?format=json&OPERATION_NAME=GET_WORKLOGS&TECHNICIAN_KEY=$ApiKey"
			$result = Invoke-RestMethod -Method GET -Uri $Uri -ErrorAction SilentlyContinue -ErrorVariable GetWorkLogError
			$result.operation.details
		}
		else
		{
			Write-Warning -Message "Enter A Valid Request ID"
		}
		if ($GetWorkLogError)
		{
			Write-Warning -Message "API Call Failed Reason : $GetWorkLogError"
		}
		
	}
}
