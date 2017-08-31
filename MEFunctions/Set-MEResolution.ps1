function Set-MEResolution
{
     <#
        .SYNOPSIS
     Set the Resolution for a request
        .DESCRIPTION
     Set the Resolution for a request
        .EXAMPLE
        Set-MEResolution -RequestID $request.WORKORDERID -ApiKey $ApiKey -SdpUri $SdpUri -Resolution "I rebooted three times"
     
        .PARAMETER RequestID
        The RequestID is the integer assigned to a "ticket" automatically by service desk plus
        .PARAMETER SdpUri
        This is the URI for Service Desk Plus
     
     .PARAMETER ApiKey
        This parameter is the API Key assigned to each technician. This serves as authentication to Service Desk Plus
     
     .PARAMETER Resolution
     This is the text that will be added as a resolution
       
        #>
	[CmdletBinding()]
	param
	(
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 0)]
		[alias ("id")]
		[Int32]$RequestID,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 2)]
		[String]$ApiKey,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 3)]
		[String]$SdpUri,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[String]$Resolution
	)
	begin
	{
		if ($SdpUri[$SdpUri.Length - 1] -eq "/") { $Uri = $SdpUri + "sdpapi/request/$RequestID/resolution" }
		else { $Uri = $SdpUri + "/sdpapi/request/$RequestID/resolution" }
	}
	process
	{
		$Parameters = @{
			"operation" = @{
				"details" = @{
					"resolution" = @{
						"resolutiontext" = $resolution
					}
				}
			}
		}
		
		$input_data = $Parameters | ConvertTo-Json -Depth 50
		$Uri = $Uri + "?format=json&OPERATION_NAME=ADD_RESOLUTION&INPUT_DATA=$input_data&TECHNICIAN_KEY=$ApiKey"
		$result = Invoke-RestMethod -Method POST -Uri $Uri
		$result
	}
}