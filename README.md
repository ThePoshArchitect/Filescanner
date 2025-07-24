# File Share Scanner

A PowerShell script that generates comprehensive reports about files in a specified directory, helping administrators track file sizes, access times, and ownership information.

## Features

- Recursively scans directories and their subdirectories
- Collects detailed file information including:
  - File path and name
  - File size in MB
  - Last access time
  - Last write time
  - Creation time
  - File owner
  - Last user to modify the file (when available)
  - File extension
- Identifies large files based on a configurable size threshold
- Exports results to a CSV file for easy analysis
- Provides a summary of the scan results

## Requirements

- Windows PowerShell 5.1 or later
- Appropriate permissions to access the directories you want to scan

## Usage

1. Open PowerShell
2. Navigate to the script directory
3. Run the script with required parameters:

```powershell
.\filescan.ps1 -Path "C:\PathToScan"
```

### Optional Parameters

- `-MinimumSizeMB`: Specify the threshold (in MB) for what constitutes a "large file" (default is 100MB)

Example with optional parameter:
```powershell
.\filescan.ps1 -Path "C:\PathToScan" -MinimumSizeMB 500
```

## Output

The script generates a CSV file named `FileReport_[DATE]_[TIME].csv` containing all file information. The report includes:

- FilePath
- SizeInMB
- Owner
- LastAccessTime
- LastWriteTime
- LastWrittenBy
- CreationTime
- Extension
- IsLargeFile

## Notes

- The "LastWrittenBy" information may show as "N/A" if:
  - File history is not enabled
  - The file system doesn't support file history
  - There's no historical data available
- The script requires appropriate permissions to access files and read their security information

## Error Handling

- The script includes error handling and will continue scanning even if individual files can't be accessed
- Any errors encountered during the scan will be displayed in the console
- The script will exit with code 1 if a critical error occurs
