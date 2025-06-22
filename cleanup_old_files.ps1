# This script will delete the old non-modularized files
# Run this only after you've verified that the modularized code works correctly

$filesToRemove = @(
    "lib\screens\book_screen.dart",
    "lib\screens\home_screen.dart",
    "lib\screens\leaderboard_screen.dart",
    "lib\screens\onboarding_screen.dart",
    "lib\screens\practice_screen.dart",
    "lib\screens\profile_screen.dart",
    "lib\screens\splash_screen.dart",
    "lib\widgets\navbar.dart"
)

Write-Host "Warning: This will delete the original files now that they have been modularized."
Write-Host "Make sure you've verified that the new modular code works correctly before proceeding."
Write-Host ""
$confirmation = Read-Host "Do you want to proceed? (yes/no)"

if ($confirmation -eq "yes") {
    foreach ($file in $filesToRemove) {
        $fullPath = Join-Path $PSScriptRoot $file
        if (Test-Path $fullPath) {
            Remove-Item $fullPath -Force
            Write-Host "Deleted: $file"
        } else {
            Write-Host "File not found: $file"
        }
    }
    Write-Host "Cleanup complete."
} else {
    Write-Host "Operation cancelled."
}
