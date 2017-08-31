function Get-MEApprovals
{
        <#
        .SYNOPSIS
     This function is used to return Pending Approvals.
        .DESCRIPTION
     Get Peending Approvals
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
		if ($SdpUri[$SdpUri.Length - 1] -eq "/") { $Uri = $SdpUri + "sdpapi/approvals" }
		else { $Uri = $SdpUri + "/sdpapi/approvals" }
	}
	process
	{
		$Uri = $Uri + "?format=json&OPERATION=GET_APPROVALS&TECHNICIAN_KEY=$ApiKey"
		$result = Invoke-RestMethod -Method Post -Uri $Uri -ErrorAction SilentlyContinue -ErrorVariable GetApprovalError
		$result.operation.details
		
		if ($GetApprovalError)
		{
			Write-Warning -Message "API Call Failed Reason : $GetApprovalError"
		}
		
	}
}