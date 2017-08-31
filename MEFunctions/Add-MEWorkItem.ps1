function Add-MEWorkItem
{
     <#
        .SYNOPSIS
     This function adds a work item to a request with a known request ID
     
        .DESCRIPTION
     Add a work item to a request
     
        .EXAMPLE
        Add-MEWorkItem -RequestID $request.WORKORDERID -ApiKey $ApiKey -SdpUri $SdpUri -Description "Review Completed" -workHours 0 -WorkMinutes 15 -Technician "Darth Vader"
     
        .PARAMETER RequestID
        The RequestID is the integer assigned to a "ticket" automatically by service desk plus
        .PARAMETER SdpUri
        This is the URI for Service Desk Plus
     
     .PARAMETER ApiKey
        This parameter is the API Key assigned to each technician. This serves as authentication to Service Desk Plus
     
     .PARAMETER Description
     This is the text that will display in the work item description area.
     
     .PARAMETER Technician
     This is the technician assigned to the work item
     
     .PARAMETER WorkHours
     This is the hours worked on a work item
     
     .PARAMETER WorkMinutes
     This is the minutes worked on a work item
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
		[String]$Description,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[String]$Technician,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Int32]$WorkHours,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[Int32]$WorkMinutes
	)
	begin
	{
		if ($SdpUri[$SdpUri.Length - 1] -eq "/") { $Uri = $SdpUri + "sdpapi/request/$RequestID/worklogs" }
		else { $Uri = $SdpUri + "/sdpapi/request/$RequestID/worklogs" }
	}
	process
	{
		$Parameters = @{
			"operation" = @{
				"details" = @{
					"worklogs" = @{
						"worklog" = @{
							"description" = $Description;
							"technician"  = $Technician;
							"workHours"   = $WorkHours;
							"workMinutes" = $WorkMinutes
						}
					}
				}
			}
		}
		
		$input_data = $Parameters | ConvertTo-Json -Depth 50
		$Uri = $Uri + "?format=json&OPERATION_NAME=ADD_WORKLOG&INPUT_DATA=$input_data&TECHNICIAN_KEY=$ApiKey"
		$result = Invoke-RestMethod -Method POST -Uri $Uri
		$result
	}
}
