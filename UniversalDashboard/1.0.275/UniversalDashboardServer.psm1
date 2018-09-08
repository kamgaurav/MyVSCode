function Out-UDMonitorData {
	[CmdletBinding()]
    param(
	[Parameter(ValueFromPipeline = $true)]
	$Data)

	Process {
		@{ 
			x = [DateTime]::UtcNow
			y = $Data
		} | ConvertTo-Json
	}
}

function Out-UDChartData {
	[CmdletBinding()]
    param(
		[Parameter(ValueFromPipeline = $true)]
		$Data, 
		[Parameter()]
		[string]$DataProperty, 
		[Parameter()]
		[string]$LabelProperty,
		[Parameter()]
		[string]$DatasetLabel = "",
		[Parameter()]
		[Hashtable[]]$Dataset,
		[Parameter()]
		[PowerShellProTools.UniversalDashboard.Models.DashboardColor[]]$BackgroundColor = @("#808978FF"),
		[Parameter()]
		[PowerShellProTools.UniversalDashboard.Models.DashboardColor[]]$BorderColor = @("#FF8978FF"),
		[Parameter()]
		[PowerShellProTools.UniversalDashboard.Models.DashboardColor[]]$HoverBackgroundColor = @("#807B210C"),
		[Parameter()]
		[PowerShellProTools.UniversalDashboard.Models.DashboardColor[]]$HoverBorderColor = @("#FF7B210C")
	)
	
    Begin {
        New-Variable -Name Items -Value @()
    }

	Process {
		$Items += $Data
	}

	End {
		$datasets = @()

		if ($Dataset -ne $null) {
			Foreach($datasetDef in $Dataset) {
				$datasetDef.data = @($Items | ForEach-Object { $_.($datasetDef.DataProperty) })
				$datasets += $datasetDef
			}
		}
		else {
			$datasets += 
				@{
					label = $DatasetLabel
					backgroundColor = $BackgroundColor.HtmlColor
					borderColor = $BorderColor.HtmlColor
					hoverBackgroundColor = $HoverBackgroundColor.HtmlColor
					hoverBorderColor = $HoverBorderColor.HtmlColor
					borderWidth = 1
					data = @($Items | ForEach-Object { $_.$DataProperty })
				}
		}

	    @{
			labels = @($Items | ForEach-Object { $_.$LabelProperty })
			datasets = $datasets
		} | ConvertTo-Json -Depth 10
	}
}

function New-UDChartDataset {
	[CmdletBinding()]
	param(
		[string]$DataProperty,
		[string]$Label,
		[PowerShellProTools.UniversalDashboard.Models.DashboardColor[]]$BackgroundColor = @("#807B210C"),
		[PowerShellProTools.UniversalDashboard.Models.DashboardColor[]]$BorderColor = @("#FF7B210C"),
		[int]$BorderWidth,
		[PowerShellProTools.UniversalDashboard.Models.DashboardColor[]]$HoverBackgroundColor = @("#807B210C"),
		[PowerShellProTools.UniversalDashboard.Models.DashboardColor[]]$HoverBorderColor = @("#FF7B210C"),
		[int]$HoverBorderWidth,
		[string]$XAxisId,
		[string]$YAxisId,
		[Hashtable]$AdditionalOptions
	)

	Begin {
		$datasetOptions = @{
			data = @()
			DataProperty = $DataProperty
			label = $Label
			backgroundColor = $BackgroundColor.HtmlColor
			borderColor = $BorderColor.HtmlColor
			borderWidth = $BorderWidth
			hoverBackgroundColor = $HoverBackgroundColor.HtmlColor
			hoverBorderColor = $HoverBorderColor.HtmlColor
			hoverBorderWidth = $HoverBorderWidth
			xAxisId = $XAxisId
			yAxisId = $YAxisId
		}

		if ($AdditionalOptions) {
			$AdditionalOptions.GetEnumerator() | ForEach-Object {
				$datasetOptions.($_.Key) = $_.Value
			}
		}

		$datasetOptions
	}
}

function Out-UDGridData {
	[CmdletBinding()]
    param(
		[Parameter(ValueFromPipeline = $true)]
		$Data,
		[Switch]$NoAutoPage,
		$TotalItems
	)
	
    Begin {
        New-Variable -Name Items -Value @()
    }

	Process {
		$Items += $Data
	}

	End {

		if (-not $NoAutoPage) {
			$total = $Items.length
			$Items = $Items | Select-Object -First $take -Skip $skip
		} else {
			$total = $TotalItems
		}

	    @{
			data = $Items
			recordsTotal = $total
			recordsFiltered = $total
			draw = $drawId
		} | ConvertTo-Json -Depth 10
	}
}

function Out-UDTableData {
	[CmdletBinding()]
    param(
	[Parameter(Mandatory = $true, ValueFromPipeline = $true)]
	$Data,
	[Parameter(Mandatory = $true)]
	[string[]]$Property
	)
	
    Begin {
        New-Variable -Name Items -Value @()
    }

	Process {
		$Items += $Data
	}

	End {
		$rows = @()
		foreach($item in $items) {
			$row = @()

			foreach($itemProperty in $Property) {
				$row += $item.$itemProperty
			}
			$rows += , $row
		}

	    $rows | ConvertTo-Json -Depth 10
	}
}
