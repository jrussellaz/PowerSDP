function Close-MERequest
{
     <#
        .SYNOPSIS
     Close a request. This function assumes the closure has been acknowledged.
        .DESCRIPTION
     Close a request. This function assumes the closure has been acknowledged.
       
     .EXAMPLE
        Close-MERequest -RequestID $request.WORKORDERID -ApiKey $ApiKey -SdpUri $SdpUri
     
        .PARAMETER RequestID
        The RequestID is the integer assigned to a "ticket" automatically by service desk plus
        .PARAMETER SdpUri
        This is the URI for Service Desk Plus
     
     .PARAMETER ApiKey
        This parameter is the API Key assigned to each technician. This serves as authentication to Service Desk Plus
     
       
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
		[String]$SdpUri
	)
	begin
	{
		if ($SdpUri[$SdpUri.Length - 1] -eq "/") { $Uri = $SdpUri + "sdpapi/request/$RequestID" }
		else { $Uri = $SdpUri + "/sdpapi/request/$RequestID" }
	}
	process
	{
		$Parameters = @{
			"operation" = @{
				"details" = @{
					"closeAccepted" = "Accepted";
					"closeComment"  = "Review Completed"
				}
			}
		}
		
		$input_data = $Parameters | ConvertTo-Json -Depth 50
		$Uri = $Uri + "?format=json&OPERATION_NAME=CLOSE_REQUEST&INPUT_DATA=$input_data&TECHNICIAN_KEY=$ApiKey"
		$result = Invoke-RestMethod -Method POST -Uri $Uri
		$result
	}
}


