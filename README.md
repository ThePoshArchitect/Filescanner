# File Share Scanner

A PowerShell script that scans directories and generates comprehensive reports to help administrators analyze file information. The script can either focus on large files above a configurable size threshold or scan all files in a directory structure.

## Features

- Recursively scans directories and their subdirectories
- **Two scanning modes:**
  - **Large files only**: Filters files based on a configurable minimum size threshold (default: 2 MB)
  - **All files**: Scans every file regardless of size
- Collects comprehensive file information including:
  - Full file path
  - File extension
  - File size in bytes (raw value)
  - File size (formatted as GB, MB, KB, or B)
  - Creation time
  - Last write time (modification date)
  - Last access time
  - Parent directory path
- Exports results to a CSV file for easy analysis
- Displays results in a formatted table using PwshSpectreConsole
- Provides visual feedback during scanning process

## Requirements

- Windows PowerShell 5.1 or later
- PwshSpectreConsole module (for formatted table display)
- Appropriate permissions to access the directories you want to scan

## Installation

1. Install the required PwshSpectreConsole module:
```powershell
Install-Module pwshspectreconsole -Force
```

## Usage

1. Open PowerShell as Administrator (recommended for full access)
2. Navigate to the script directory
3. Run the script with default parameters:

```powershell
.\filescan.ps1
```

### Parameters

- `-Path`: The directory path to scan (default: "C:\python312")
- `-ReportPath`: Output CSV file path (default: "FileAuditReport.csv")
- `-DaysOld`: Days old parameter (currently not used in filtering, default: 180)
- `-MinSizeMB`: Minimum file size in MB to include in results when filtering by size (default: 2)
- `-AllFiles`: Switch parameter to scan all files regardless of size

### Examples

**Scan for large files only (default behavior):**
```powershell
.\filescan.ps1
```

**Scan ALL files regardless of size:**
```powershell
.\filescan.ps1 -AllFiles
```

**Scan a specific directory for large files:**
```powershell
.\filescan.ps1 -Path "C:\MyData"
```

**Scan all files in a specific directory:**
```powershell
.\filescan.ps1 -Path "C:\MyData" -AllFiles
```

**Scan with different size threshold (100MB):**
```powershell
.\filescan.ps1 -Path "C:\MyData" -MinSizeMB 100
```

**Custom output file for all files:**
```powershell
.\filescan.ps1 -Path "C:\MyData" -ReportPath "AllFiles.csv" -AllFiles
```

## Output

The script generates:

1. **CSV Report**: A file (default: `FileAuditReport.csv`) containing comprehensive file information
2. **Console Table**: A formatted table displayed in the terminal showing the results

### CSV Report Columns

- **FullName**: Complete path to the file
- **Extension**: File extension (e.g., .txt, .pdf, .docx)
- **Length**: File size in bytes (raw number)
- **CreationTime**: When the file was originally created
- **LastWriteTime**: When the file was last modified
- **LastAccessTime**: When the file was last accessed/read
- **DirectoryName**: Parent directory path
- **Size**: Human-readable formatted file size (e.g., "1.25 GB", "500.00 MB")

## Scanning Modes

### Large Files Mode (Default)
- **Purpose**: Identify files that consume significant disk space
- **Behavior**: Only includes files larger than the specified `MinSizeMB` threshold
- **Use cases**: Storage cleanup, identifying space hogs, capacity planning

### All Files Mode (`-AllFiles` switch)
- **Purpose**: Complete file inventory and analysis
- **Behavior**: Includes every file regardless of size
- **Use cases**: Full audits, compliance reporting, detailed file analysis

## Notes

- **Flexible scanning**: Choose between large files only or comprehensive all-files scanning
- **Rich metadata**: Captures complete file information including timestamps and directory structure
- **Access permissions**: The script requires appropriate permissions to access files in the target directory
- **Performance considerations**: 
  - Large directories may take time to scan; the script provides progress feedback
  - All-files mode will generate larger reports and take longer than large-files-only mode
- **Module dependency**: Requires the PwshSpectreConsole module for table formatting

## Error Handling

- The script uses `-ErrorAction SilentlyContinue` to skip files that can't be accessed
- Files that can't be read due to permissions are silently skipped
- Critical errors during scanning are displayed but don't stop the entire process
- Different feedback messages based on scanning mode (all files vs. large files only)

## Limitations

- The `DaysOld` parameter is defined but not currently used in the filtering logic
- Very large directory structures may impact performance in all-files mode
- File access times may not be accurate on systems with access time updates disabled
