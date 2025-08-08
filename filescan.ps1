param (
<<<<<<< HEAD
    [string]$Path = "z:\",
    [string]$ReportPath = "FileAuditReport.csv",
    [string]$xlsReportPath = "FileAuditReport.xlsx",
    [int]$DaysOld = 180,   # kept for future use
    [int]$MinSizeMB = 50
)

Import-Module pwshspectreconsole
Import-Module ImportExcel
=======
    [string]$Path = "C:\Python312",
    [string]$ReportPath = "FileAuditReport.csv",
    [string]$xlsReportPath = "FileAuditReport.xlsx",
     [int]$DaysOld = 180,
    [int]$MinSizeMB = 2
)

import-module pwshspectreconsole
import-module importexcel
>>>>>>> 37cda95 (sdasd)

function Format-Size {
    param ([long]$Bytes)
    if ($Bytes -ge 1GB) { return ("{0:N2} GB" -f ($Bytes / 1GB)) }
    elseif ($Bytes -ge 1MB) { return ("{0:N2} MB" -f ($Bytes / 1MB)) }
    elseif ($Bytes -ge 1KB) { return ("{0:N2} KB" -f ($Bytes / 1KB)) }
    else { return ("{0} B" -f $Bytes) }
}

function Audit-LargeFilesOnly {
    param (
        [string]$TargetPath,
        [int]$MinSizeMB,
        [string]$OutputFile,
        [string]$xlsOutputFile,
        [switch]$ScanAllFiles
    )

    $ErrorActionPreference = 'Stop'
    $minBytes = $MinSizeMB * 1MB
    $results = @()

    if ($ScanAllFiles) {
        Write-Host "Scanning ALL files in: $TargetPath" -ForegroundColor Cyan
    }
    else {
        Write-Host "Scanning for files larger than $MinSizeMB MB in: $TargetPath" -ForegroundColor Cyan
    }

    try {
        Get-ChildItem -Path $TargetPath -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
            $sizeBytes = $_.Length
            $currentDate = Get-Date
            $ageInDays = ($currentDate - $_.CreationTime).Days

            if ($ScanAllFiles -or ($sizeBytes -ge $minBytes)) {
                $results += [PSCustomObject]@{
<<<<<<< HEAD
                    FullName       = $_.FullName
                    Extension      = $_.Extension
                    Length         = $_.Length
                    CreationTime   = $_.CreationTime
                    LastWriteTime  = $_.LastWriteTime
                    LastAccessTime = $_.LastAccessTime
                    DirectoryName  = $_.DirectoryName
                    AgeInDays      = $ageInDays
                    Size           = Format-Size $sizeBytes
=======
                    FullName        = $_.FullName
                    Extension       = $_.Extension
                    Length          = $_.Length
                    CreationTime    = $_.CreationTime
                    LastWriteTime   = $_.LastWriteTime
                    LastAccessTime  = $_.LastAccessTime
                    DirectoryName   = $_.DirectoryName
                    AgeInDays       = $ageInDays
                    Size            = Format-Size $sizeBytes
>>>>>>> 37cda95 (sdasd)
                }
            }
        }

<<<<<<< HEAD
        if ($results.Count -le 0) {
            if ($ScanAllFiles) { Write-Host "`nNo files found in $TargetPath." -ForegroundColor Yellow }
            else { Write-Host "`nNo large files found in $TargetPath." -ForegroundColor Yellow }
            return
=======
        if ($results.Count -gt 0) {
            $results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
            $excelreport = $results | Export-Excel -Path $xlsOutputFile -AutoSize -WorksheetName "File Audit Report" -BoldTopRow
            $excelreport
            Write-Host "`nReport saved to: $OutputFile" -ForegroundColor Green
            
            # Display main results table
            if ($ScanAllFiles) {
                $results | Format-SpectreTable -Title "All Files Report" | Out-SpectreHost
            } else {
                $results | Format-SpectreTable -Title "Large Files Report" | Out-SpectreHost
            }

            # Generate and display age summary
            $totalFiles = $results.Count
            $filesUnder30Days = ($results | Where-Object { $_.AgeInDays -le 30 }).Count
            $files30to180Days = ($results | Where-Object { $_.AgeInDays -gt 30 -and $_.AgeInDays -le 180 }).Count
            $files180to365Days = ($results | Where-Object { $_.AgeInDays -gt 180 -and $_.AgeInDays -le 365 }).Count
            $files1to2Years = ($results | Where-Object { $_.AgeInDays -gt 365 -and $_.AgeInDays -le 730 }).Count
            $files2to3Years = ($results | Where-Object { $_.AgeInDays -gt 730 -and $_.AgeInDays -le 1095 }).Count
            $filesOver3Years = ($results | Where-Object { $_.AgeInDays -gt 1095 }).Count

            $ageSummary = @(
                [PSCustomObject]@{
                    AgeRange = "0-30 days"
                    FileCount = $filesUnder30Days
                    Percentage = [math]::Round(($filesUnder30Days / $totalFiles) * 100, 1)
                },
                [PSCustomObject]@{
                    AgeRange = "31-180 days"
                    FileCount = $files30to180Days
                    Percentage = [math]::Round(($files30to180Days / $totalFiles) * 100, 1)
                },
                [PSCustomObject]@{
                    AgeRange = "181-365 days"
                    FileCount = $files180to365Days
                    Percentage = [math]::Round(($files180to365Days / $totalFiles) * 100, 1)
                },
                [PSCustomObject]@{
                    AgeRange = "1-2 years"
                    FileCount = $files1to2Years
                    Percentage = [math]::Round(($files1to2Years / $totalFiles) * 100, 1)
                },
                [PSCustomObject]@{
                    AgeRange = "2-3 years"
                    FileCount = $files2to3Years
                    Percentage = [math]::Round(($files2to3Years / $totalFiles) * 100, 1)
                },
                [PSCustomObject]@{
                    AgeRange = "Over 3 years"
                    FileCount = $filesOver3Years
                    Percentage = [math]::Round(($filesOver3Years / $totalFiles) * 100, 1)
                }
            )

            Write-Host "`n" -NoNewline
            $ageSummary | Format-SpectreTable -Title "File Age Distribution Summary" | Out-SpectreHost
            #$chart = New-ExcelChartDefinition $ageSummary -XRange AgeRange -YRange FileCount -ChartType pie -Title "File Age Distribution" -LegendPosition Right | export-excel -path $excelreport.File -Append -WorksheetName Graphs -ExcelChartDefinition $chart -AutoNameRange -show -Title "File Age Distribution Chart"

            # Create and display bar chart for age distribution
            Write-Host "`n" -NoNewline
            $chartData = @()
            $colors = @("Green", "Yellow", "DarkOrange", "Red", "DarkRed", "Maroon")  # Colors for different age ranges
            $index = 0
            foreach ($item in $ageSummary) {
                # Use minimum of 0.5 for display purposes to ensure small values show a bar
                $displayValue = [math]::Max($item.Percentage, 0.5)
                $chartData += New-SpectreChartItem -Label "$($item.AgeRange) ($($item.Percentage)%)" -Value $displayValue -Color $colors[$index]
                $index++
            }
            Format-SpectreBarChart -Data $chartData -Label "File Age Distribution (Percentages)" -Width 60
        } else {
            if ($ScanAllFiles) {
                Write-Host "`nNo files found in $TargetPath." -ForegroundColor Yellow
            } else {
                Write-Host "`nNo large files found in $TargetPath." -ForegroundColor Yellow
            }
>>>>>>> 37cda95 (sdasd)
        }

        # CSV for convenience
        $results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
        Write-Host "`nReport saved to: $OutputFile" -ForegroundColor Green

        # Console table
        if ($ScanAllFiles) {
            $results | Format-SpectreTable -Title "All Files Report" | Out-SpectreHost
        }
        else {
            $results | Format-SpectreTable -Title "Large Files Report" | Out-SpectreHost
        }

        # ---- Age Summary ----
        $totalFiles = $results.Count
        $filesUnder30Days = ($results | Where-Object { $_.AgeInDays -le 30 }).Count
        $files30to180Days = ($results | Where-Object { $_.AgeInDays -gt 30 -and $_.AgeInDays -le 180 }).Count
        $files180to365Days = ($results | Where-Object { $_.AgeInDays -gt 180 -and $_.AgeInDays -le 365 }).Count
        $files1to2Years = ($results | Where-Object { $_.AgeInDays -gt 365 -and $_.AgeInDays -le 730 }).Count
        $files2to3Years = ($results | Where-Object { $_.AgeInDays -gt 730 -and $_.AgeInDays -le 1095 }).Count
        $filesOver3Years = ($results | Where-Object { $_.AgeInDays -gt 1095 }).Count

        $ageSummary = @(
            [PSCustomObject]@{ AgeRange = "0-30 days"; FileCount = $filesUnder30Days; Percentage = [math]::Round(($filesUnder30Days / $totalFiles) * 100, 1) }
            [PSCustomObject]@{ AgeRange = "31-180 days"; FileCount = $files30to180Days; Percentage = [math]::Round(($files30to180Days / $totalFiles) * 100, 1) }
            [PSCustomObject]@{ AgeRange = "181-365 days"; FileCount = $files180to365Days; Percentage = [math]::Round(($files180to365Days / $totalFiles) * 100, 1) }
            [PSCustomObject]@{ AgeRange = "1-2 years"; FileCount = $files1to2Years; Percentage = [math]::Round(($files1to2Years / $totalFiles) * 100, 1) }
            [PSCustomObject]@{ AgeRange = "2-3 years"; FileCount = $files2to3Years; Percentage = [math]::Round(($files2to3Years / $totalFiles) * 100, 1) }
            [PSCustomObject]@{ AgeRange = "Over 3 years"; FileCount = $filesOver3Years; Percentage = [math]::Round(($filesOver3Years / $totalFiles) * 100, 1) }
        )

        Write-Host "`n"
        $ageSummary | Format-SpectreTable -Title "File Age Distribution Summary" | Out-SpectreHost

        # Create and display bar chart for age distribution
        Write-Host "`n" -NoNewline
        $chartData = @()
        $colors = @("Green", "Yellow", "DarkOrange", "Red", "DarkRed", "Maroon")  # Colors for different age ranges
        $index = 0
        foreach ($item in $ageSummary) {
            # Use minimum of 0.5 for display purposes to ensure small values show a bar
            $displayValue = [math]::Max($item.Percentage, 0.5)
            $chartData += New-SpectreChartItem -Label "$($item.AgeRange) ($($item.Percentage)%)" -Value $displayValue -Color $colors[$index]
            $index++
        }
        Format-SpectreBarChart -Data $chartData -Label "File Age Distribution (Percentages)" -Width 60

        # Ensure output dir; overwrite workbook to avoid duplicate tables/sheets
        $dir = Split-Path -Path $xlsOutputFile -Parent
        if ($dir -and -not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
        if (Test-Path $xlsOutputFile) { Remove-Item $xlsOutputFile -Force }

        # Debug: Show what we're about to export
        Write-Host "`nAge Summary Data for Excel:" -ForegroundColor Magenta
        $ageSummary | Format-Table -AutoSize

        # 1) Write Age Summary with simple structure for charting
        $null = $ageSummary | Export-Excel -Path $xlsOutputFile `
            -WorksheetName 'Age Summary' -AutoSize -TableName 'AgeSummary' -BoldTopRow

        # 2) Write Raw Data (append)
        $null = $results | Export-Excel -Path $xlsOutputFile `
            -WorksheetName 'Raw Data' -AutoSize -TableName 'RawData' -Append

        # 3) Create chart using Export-Excel's built-in chart capability
        $chartDef = New-ExcelChartDefinition -XRange "AgeRange" -YRange "FileCount" -ChartType PieExploded -Title "File Age Distribution" -LegendPosition Right
        
        $ageSummary | Export-Excel -Path $xlsOutputFile -WorksheetName 'Charts' -AutoNameRange -ExcelChartDefinition $chartDef -Append -Show
    }
    catch {
        Write-Error "Audit failed: $_"
    }
    finally {
        $ErrorActionPreference = 'Continue'
    }
}

# Run it
<<<<<<< HEAD
Audit-LargeFilesOnly -TargetPath $Path -MinSizeMB $MinSizeMB -OutputFile $ReportPath -xlsOutputFile $xlsReportPath
=======
Audit-LargeFilesOnly -TargetPath $Path -MinSizeMB $MinSizeMB -OutputFile $ReportPath -xlsOutputFile $xlsReportPath 
>>>>>>> 37cda95 (sdasd)
