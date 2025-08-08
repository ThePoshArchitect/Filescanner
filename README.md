# File Share Scanner

A comprehensive PowerShell script that scans directories and generates detailed reports to help administrators analyze file information. The script can either focus on large files above a configurable size threshold or scan all files in a directory structure, providing rich visualizations and multiple output formats.

## Features

- **Dual scanning modes:**
  - **Large files only**: Filters files based on a configurable minimum size threshold (default: 50 MB)
  - **All files**: Scans every file regardless of size using the `-AllFiles` switch
- **Comprehensive file analysis:**
  - Full file path and parent directory
  - File extension and size (both raw bytes and formatted)
  - Complete timestamp information (creation, modification, last access)
  - File age calculation in days from creation date
- **Rich visualizations:**
  - Console table display with formatted data
  - Color-coded bar chart showing age distribution percentages
  - Excel workbook with pie charts and formatted tables
- **Multiple output formats:**
  - CSV export for data analysis and reporting
  - Excel workbook with multiple worksheets and embedded charts
  - Real-time console display with professional formatting
- **Advanced age analysis with 6 categories:**
  - 0-30 days (Recent files)
  - 31-180 days (Medium-aged files)
  - 181-365 days (Older files)
  - 1-2 years (Very old files)
  - 2-3 years (Ancient files)
  - Over 3 years (Extremely old files)

## Requirements

- Windows PowerShell 5.1 or later
- **PwshSpectreConsole module** (for formatted table display and charts)
- **ImportExcel module** (for Excel report generation)
- Appropriate permissions to access the directories you want to scan

## Installation

1. Install the required PowerShell modules:
```powershell
Install-Module pwshspectreconsole -Force
Install-Module ImportExcel -Force
```

## Usage

1. Open PowerShell as Administrator (recommended for full access)
2. Navigate to the script directory
3. Run the script with default parameters:

```powershell
.\filescan.ps1
```

### Parameters

- `-Path`: The directory path to scan (default: "z:\")
- `-ReportPath`: Output CSV file path (default: "FileAuditReport.csv")
- `-xlsReportPath`: Output Excel file path (default: "FileAuditReport.xlsx")
- `-DaysOld`: Days old parameter (reserved for future use, default: 180)
- `-MinSizeMB`: Minimum file size in MB to include in results when filtering by size (default: 50)
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

**Scan with different size threshold (10MB):**
```powershell
.\filescan.ps1 -Path "C:\MyData" -MinSizeMB 10
```

**Custom output files:**
```powershell
.\filescan.ps1 -Path "C:\MyData" -ReportPath "MyFiles.csv" -xlsReportPath "MyFiles.xlsx" -AllFiles
```

## Output

The script generates multiple output formats for comprehensive analysis:

### 1. Console Display
- **Main results table**: Formatted table showing all file details
- **Age distribution summary**: Table with counts and percentages for each age range
- **Color-coded bar chart**: Visual representation of file age distribution with percentages

### 2. CSV Report (`FileAuditReport.csv`)
Contains detailed information for each file:
- **FullName**: Complete path to the file
- **Extension**: File extension (e.g., .txt, .pdf, .docx)
- **Length**: File size in bytes (raw number)
- **CreationTime**: When the file was originally created
- **LastWriteTime**: When the file was last modified
- **LastAccessTime**: When the file was last accessed/read
- **DirectoryName**: Parent directory path
- **AgeInDays**: Number of days since file creation
- **Size**: Human-readable formatted file size (e.g., "1.25 GB", "500.00 MB")

### 3. Excel Workbook (`FileAuditReport.xlsx`)
Professional Excel report with multiple worksheets:
- **Age Summary**: Summary table with file counts and percentages by age range
- **Raw Data**: Complete file listing with all details
- **Charts**: Exploded pie chart showing file age distribution
- **Auto-formatting**: Professional styling with bold headers and auto-sized columns

## Age Categories

The script analyzes files across 6 distinct age ranges:

| Age Range | Description | Color (Console) | Typical Use Case |
|-----------|-------------|-----------------|------------------|
| **0-30 days** | Recently created files | Green | Active work files |
| **31-180 days** | Medium-aged files | Yellow | Recent projects |
| **181-365 days** | Older files | Orange | Archived projects |
| **1-2 years** | Very old files | Red | Long-term storage |
| **2-3 years** | Ancient files | Dark Red | Compliance retention |
| **Over 3 years** | Extremely old files | Maroon | Candidates for deletion |

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

- **Multiple output formats**: CSV for analysis, Excel for professional reporting, console for immediate feedback
- **Rich visualizations**: Color-coded charts and professional Excel graphics
- **Flexible scanning**: Choose between large files only or comprehensive all-files scanning
- **Comprehensive age analysis**: 6 distinct age categories with color coding and percentage analysis
- **Professional reporting**: Excel workbooks with embedded charts and formatted tables
- **Access permissions**: The script requires appropriate permissions to access files in the target directory
- **Performance considerations**: 
  - Large directories may take time to scan; the script provides progress feedback
  - All-files mode will generate larger reports and take longer than large-files-only mode
- **Module dependencies**: Requires both PwshSpectreConsole and ImportExcel modules

## Error Handling

- The script uses `-ErrorAction SilentlyContinue` to skip files that can't be accessed
- Files that can't be read due to permissions are silently skipped
- Critical errors during scanning are displayed but don't stop the entire process
- Different feedback messages based on scanning mode (all files vs. large files only)
- Debug output shows data being exported to Excel for troubleshooting

## Limitations

- The `DaysOld` parameter is defined but not currently used in the filtering logic
- Very large directory structures may impact performance in all-files mode
- File access times may not be accurate on systems with access time updates disabled
- Excel chart generation requires the ImportExcel module to be properly installed