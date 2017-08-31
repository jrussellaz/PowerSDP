function Get-MERequest
{
        <#
        .SYNOPSIS
     This function is used to return a list of requests. If RequestID is specified then a single request is returned. If RequestID is ommited then all requests assigned to the specified filter are returned. The filter will default to All Requests if one is not specified.
        .DESCRIPTION
     Get a list of Requests
        .EXAMPLE
     Get-MERequest -SdpUri "http://sdp.domain.com" -ApiKey "1234567A-2AB0-12A3-A123-1234567890AB" -RequestID 1234
        .PARAMETER RequestID
        The RequestID is the integer assigned to a "ticket" automatically by service desk plus
        .PARAMETER Filter
        The Request View Filter. These filters can be created in SDP. To find the filter name, Click on the ADMIN tab in SDP. Under General Settings click API, and Documentation.
     
     In the new Tab click "Requests" then "View Requests Filters", then "Try now". This parameter accepts the VIEWID
       
        .PARAMETER ApiKey
        This parameter is the API Key assigned to each technician. This serves as authentication to Service Desk Plus
     
     .PARAMETER Limit
        This parameter limits the number of returned requests. the default is 50
        .PARAMETER SdpUri
        This is the URI for Service Desk Plus
       
        #>
	[CmdletBinding(DefaultParameterSetName = 'RequestByID')]
	param
	(
		[Parameter(Mandatory = $true ,ValueFromPipeline = $true, Position = 0, ParameterSetName = 'RequestByID')]
		[alias ("id")]
		[Int32]$RequestID = $null,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true, Position = 1, ParameterSetName = 'RequestByFilter')]
		[ValidateSet('All_Requests','Acquisitions & Engineering Team_QUEUE')]
		[String]$Filter = "All_Requests",
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[String]$ApiKey,
		[Parameter(Mandatory = $true, ValueFromPipelineByPropertyName = $true)]
		[String]$SdpUri,
		[Parameter(Mandatory = $false, ParameterSetName = 'RequestByFilter')]
		[String]$limit = 50
	)
	begin
	{
		if ($SdpUri[$SdpUri.Length - 1] -eq "/") { $Uri = $SdpUri + "sdpapi/request" }
		else { $Uri = $SdpUri + "/sdpapi/request" }
	}
	process
	{
		if ($PSCmdlet.ParameterSetName -eq 'RequestByID')
		{
			$Uri = $Uri + "/" + $RequestID
			$Uri = $Uri + "?format=json&OPERATION_NAME=GET_REQUEST&TECHNICIAN_KEY=$ApiKey"
			$result = Invoke-RestMethod -Method Get -Uri $Uri
			$result
		}
		elseif ($PSCmdlet.ParameterSetName -eq 'RequestByFilter')
		{
			$Parameters = @{
				"operation" = @{
					"details" = @{
						"from"	 = "0";
						"limit"    = $limit;
						"filterby" = $filter
					}
				}
			}
			
			$input_data = $Parameters | ConvertTo-Json -Depth 50
			$Uri = $Uri + "?format=json&OPERATION_NAME=GET_REQUESTS&INPUT_DATA=$input_data&TECHNICIAN_KEY=$ApiKey"
			$result = Invoke-RestMethod -Method Get -Uri $Uri
			$result.operation.details
			}
		}
	}
