param(
    [string]$BookDir = (Join-Path $PSScriptRoot '../docs/book')
)
$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8
$book = [System.IO.Path]::GetFullPath($BookDir)

$files = Get-ChildItem -Recurse -File $book -Filter *.html
$broken = @()
$total = 0

foreach ($f in $files) {
    $content = [System.IO.File]::ReadAllText($f.FullName)
    $ids = @{}
    # Regular heading/element ids
    foreach ($m in [regex]::Matches($content, 'id="([^"]+)"')) { $ids[$m.Groups[1].Value] = $true }
    # Legacy named anchors (`<a name="...">`) such as #silent_h and #why_target
    foreach ($m in [regex]::Matches($content, '<a\s[^>]*\bname="([^"]+)"')) { $ids[$m.Groups[1].Value] = $true }

    $rel = $f.FullName.Substring($book.Length + 1).Replace('\','/')
    foreach ($m in [regex]::Matches($content, 'href="([^"]*)"')) {
        $href = $m.Groups[1].Value
        if ($href -like 'http*' -or $href -like 'javascript*' -or $href -eq '') { continue }
        if ($href.StartsWith('#')) {
            $total++
            $target = $href.Substring(1)
            if (-not $ids.ContainsKey($target)) {
                $broken += "$rel -> #$target (id not found)"
            }
        } elseif ($href -like '*.html*') {
            $page = ($href -split '[?#]')[0]
            $resolved = [System.IO.Path]::GetFullPath((Join-Path (Split-Path $f.FullName) ($page -replace '/', [System.IO.Path]::DirectorySeparatorChar)))
            if (-not (Test-Path -LiteralPath $resolved)) {
                $broken += "$rel -> $href (file missing)"
                continue
            }
            if ($href -match '#(.+)$') {
                $total++
                $target = $Matches[1]
                $pContent = [System.IO.File]::ReadAllText($resolved)
                $found = $pContent -match 'id="' + [regex]::Escape($target) + '"'
                if (-not $found) {
                    $found = $pContent -match '<a\s[^>]*\bname="' + [regex]::Escape($target) + '"'
                }
                if (-not $found) {
                    $broken += "$rel -> $href (anchor not found in target)"
                }
            }
        }
    }
}

Write-Output "Checked $total anchor links"
if ($broken.Count -eq 0) { Write-Output "ALL ANCHOR LINKS OK" }
else { $broken | ForEach-Object { Write-Output "[BROKEN] $_" } }
exit ($broken.Count -gt 0)
