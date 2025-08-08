param (
    [string]$Path = "C:\python312",
    [string]$ReportPath = "FileAuditReport.csv",
    [string]$xlsReportPath = "FileAuditReport.xlsx",
    [int]$DaysOld = 180,   # kept for future use
    [int]$MinSizeMB = 50
)

import-module pwshspectreconsole

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
                    FullName        = $_.FullName
                    Extension       = $_.Extension
                    Length          = $_.Length
                    CreationTime    = $_.CreationTime
                    LastWriteTime   = $_.LastWriteTime
                    LastAccessTime  = $_.LastAccessTime
                    DirectoryName   = $_.DirectoryName
                    Size            = Format-Size $sizeBytes
                }
            }
        }

        if ($results.Count -gt 0) {
            $results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
            Write-Host "`nReport saved to: $OutputFile" -ForegroundColor Green
            
            if ($ScanAllFiles) {
                $results | Format-SpectreTable -Title "All Files Report" | Out-SpectreHost
            } else {
                $results | Format-SpectreTable -Title "Large Files Report" | Out-SpectreHost
            }
        } else {
            if ($ScanAllFiles) {
                Write-Host "`nNo files found in $TargetPath." -ForegroundColor Yellow
            } else {
                Write-Host "`nNo large files found in $TargetPath." -ForegroundColor Yellow
            }
        }
    } catch {
        Write-Error "Audit failed: $_"
    }
    finally {
        $ErrorActionPreference = 'Continue'
    }
}

# Run it
Audit-LargeFilesOnly -TargetPath $Path -MinSizeMB $MinSizeMB -OutputFile $ReportPath
