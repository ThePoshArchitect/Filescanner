param (
    [string]$Path = "C:\Users\kkerr",
    [string]$ReportPath = "FileAuditReport.csv",
     [int]$DaysOld = 180,
    [int]$MinSizeMB = 500
)

import-module pwshspectreconsole

function Format-Size {
    param ([long]$Bytes)

    if ($Bytes -ge 1GB) {
        return ("{0:N2} GB" -f ($Bytes / 1GB))
    } elseif ($Bytes -ge 1MB) {
        return ("{0:N2} MB" -f ($Bytes / 1MB))
    } elseif ($Bytes -ge 1KB) {
        return ("{0:N2} KB" -f ($Bytes / 1KB))
    } else {
        return ("{0} B" -f $Bytes)
    }
}

function Audit-LargeFilesOnly {
    param (
        [string]$TargetPath,
        [int]$MinSizeMB,
        [string]$OutputFile
    )

    $minBytes = $MinSizeMB * 1MB
    $results = @()

    Write-Host "Scanning for files larger than $MinSizeMB MB in: $TargetPath" -ForegroundColor Cyan

    try {
        Get-ChildItem -Path $TargetPath -Recurse -File -ErrorAction SilentlyContinue | ForEach-Object {
            $sizeBytes = $_.Length

            if ($sizeBytes -ge $minBytes) {
                $results += [PSCustomObject]@{
                    FilePath        = $_.FullName
                    LastAccessTime  = $_.LastAccessTime
                    Size            = Format-Size $sizeBytes
                }
            }
        }

        if ($results.Count -gt 0) {
            $results | Export-Csv -Path $OutputFile -NoTypeInformation -Encoding UTF8
            Write-Host "`nReport saved to: $OutputFile" -ForegroundColor Green
            $results | Format-SpectreTable -Title "Large Files Report" | Out-SpectreHost
        } else {
            Write-Host "`nNo large files found in $TargetPath." -ForegroundColor Yellow
        }
    } catch {
        Write-Error "Audit failed: $_"
    }
}

# Run it
Audit-LargeFilesOnly -TargetPath $Path -MinSizeMB $MinSizeMB -OutputFile $ReportPath
