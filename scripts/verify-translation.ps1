param(
    [string]$Orig = '',
    [string]$Trans = (Join-Path $PSScriptRoot '../docs/src')
)

$ErrorActionPreference = 'Stop'
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$OutputEncoding = [System.Text.Encoding]::UTF8

$trans = [System.IO.Path]::GetFullPath($Trans)

if ([string]::IsNullOrWhiteSpace($Orig)) {
    $candidates = @(
        (Join-Path $PSScriptRoot '../../whamm/docs/src'),
        (Join-Path $PSScriptRoot '../whamm/docs/src'),
        (Join-Path (Get-Location) 'whamm/docs/src')
    )
    foreach ($cand in $candidates) {
        if (Test-Path -LiteralPath $cand) {
            $Orig = $cand
            break
        }
    }
}

if ([string]::IsNullOrWhiteSpace($Orig) -or (-not (Test-Path -LiteralPath $Orig))) {
    Write-Error "Cannot find upstream whamm docs/src directory.`nPlease provide the path using: ./scripts/verify-translation.ps1 -Orig <path-to-whamm/docs/src>"
    exit 1
}

$orig = [System.IO.Path]::GetFullPath($Orig)
Write-Output "Comparing translation against upstream:"
Write-Output "  Upstream:    $orig"
Write-Output "  Translation: $trans"

# ---------------------------------------------------------------------------
# Documented upstream fixes
#
# The whamm! book (v1.2.1) ships a few broken links. Instead of preserving
# them, whamm-th repairs them and records every repair below, so this verifier
# still rejects any *undocumented* divergence from upstream.
#
#   * SUMMARY.md: two chapters that exist and are linked from language.md
#     (conditionals, frame_vars) were missing from the table of contents, so
#     mdbook never built them. They are listed here.
#   * devs/intro.md: the relative link `devs/transform_ast.md` resolved to
#     `devs/devs/transform_ast.md`; fixed to `transform_ast.md`.
#   * devs/verifying.md: the ref link pointed at the stale anchor
#     `emit/emitting.md#parta-initgenerator`; the InitGenerator docs live in
#     `emit/rewriting.md#1-initgenerator`. Only the file part is compared,
#     the anchor itself is verified against the built book.
#   * intro/syntax/frame_vars.md: upstream titles the page `shared Variables`
#     (copy-paste from shared_vars.md); the translation titles it
#     `ตัวแปร frame`. Heading text is not compared (only levels are), so this
#     is recorded here for the sake of an honest diff.
#   * intro/syntax/probes.md: upstream leaves the inline span "`event` and
#     `mode." unclosed; the translation closes it. Inline code is not compared
#     by this verifier (only fenced blocks are), so this is recorded here too.
# ---------------------------------------------------------------------------
$KnownLinkRewrites = @{
    'devs/intro.md' = @{
        'devs/transform_ast.md' = 'transform_ast.md'
    }
}
$KnownLinkAdditions = @{
    'SUMMARY.md' = @(
        'intro/syntax/conditionals.md',
        'intro/syntax/frame_vars.md'
    )
}
$KnownRefRewrites = @{
    'devs/verifying.md' = @{
        'emit/emitting.md' = 'emit/rewriting.md'
    }
}

function Read-Normalized($path) {
    return ([System.IO.File]::ReadAllText($path, [System.Text.Encoding]::UTF8)).Replace("`r`n", "`n")
}

function Get-CodeBlocks($path) {
    $content = Read-Normalized $path
    $rx = [regex]'```(?s:.*?)```'
    return @($rx.Matches($content) | ForEach-Object { $_.Value })
}

function Get-Headings($path) {
    $content = Read-Normalized $path
    $rx = [regex]'(?m)^#{1,6} .*$'
    return @($rx.Matches($content) | ForEach-Object { ($_.Value -replace '^#+ ','') -replace '^#+','' | Out-Null; $_.Value })
}

function Get-RefLinks($path) {
    $content = Read-Normalized $path
    $rx = [regex]'(?m)^\[[^\]]+\]:\s+\S+.*$'
    return @($rx.Matches($content) | ForEach-Object { $_.Value -replace '\s+$','' })
}

function Get-InlineLinkTargets($path) {
    $content = Read-Normalized $path
    $rx = [regex]'\[[^\]]*\]\(([^)]+)\)'
    return @($rx.Matches($content) | ForEach-Object { $_.Groups[1].Value -replace '\s+$','' })
}

function Normalize-LinkTarget($url) {
    if ([string]::IsNullOrWhiteSpace($url)) {
        return ''
    }
    $trimmed = $url.Trim()
    # In-page anchor link (anchors are translated to Thai slugs and checked by check-links.ps1)
    if ($trimmed.StartsWith('#')) {
        return '#anchor'
    }
    # File link with in-page anchor (e.g. probes.md#helpful-info-in-cli vs probes.md#ตัวชวย-info-ใน-cli)
    if ($trimmed -match '^([^#]+)#(.+)$') {
        return $Matches[1]
    }
    return $trimmed
}

function Apply-Rewrite($rel, $url) {
    if ($KnownLinkRewrites.ContainsKey($rel) -and $KnownLinkRewrites[$rel].ContainsKey($url)) {
        Write-Host "[NOTE] $rel : documented upstream fix '$url' -> '$($KnownLinkRewrites[$rel][$url])'"
        return $KnownLinkRewrites[$rel][$url]
    }
    return $url
}

$origFiles = Get-ChildItem -Recurse -File $orig -Filter *.md
$fail = 0
$total = 0

foreach ($f in $origFiles) {
    $rel = $f.FullName.Substring($orig.Length + 1)
    $relKey = $rel.Replace('\','/')
    $tPath = Join-Path $trans $rel
    $total++
    if (-not (Test-Path -LiteralPath $tPath)) {
        Write-Output "[FAIL] $rel : missing translated file"
        $fail++
        continue
    }

    $oc = Get-CodeBlocks $f.FullName
    $tc = Get-CodeBlocks $tPath
    if ($oc.Count -ne $tc.Count) {
        Write-Output "[FAIL] $rel : code block count differs (orig=$($oc.Count) trans=$($tc.Count))"
        $fail++
    } else {
        for ($i = 0; $i -lt $oc.Count; $i++) {
            if ($oc[$i] -cne $tc[$i]) {
                Write-Output "[FAIL] $rel : code block #$($i+1) differs"
                $fail++
            }
        }
    }

    $oh = Get-Headings $f.FullName
    $th = Get-Headings $tPath
    if ($oh.Count -ne $th.Count) {
        Write-Output "[FAIL] $rel : heading count differs (orig=$($oh.Count) trans=$($th.Count))"
        $fail++
    } else {
        for ($i = 0; $i -lt $oh.Count; $i++) {
            $ol = ($oh[$i] -split ' ')[0]
            $tl = ($th[$i] -split ' ')[0]
            if ($ol -cne $tl) {
                Write-Output "[FAIL] $rel : heading #$($i+1) level differs (orig='$($oh[$i])' trans='$($th[$i])')"
                $fail++
            }
        }
    }

    $or = Get-RefLinks $f.FullName
    $tr = Get-RefLinks $tPath
    if ($or.Count -ne $tr.Count) {
        Write-Output "[FAIL] $rel : ref-link count differs (orig=$($or.Count) trans=$($tr.Count))"
        $fail++
    } else {
        for ($i = 0; $i -lt $or.Count; $i++) {
            $ourl = Normalize-LinkTarget (($or[$i] -split ':\s*',2)[1])
            $turl = Normalize-LinkTarget (($tr[$i] -split ':\s*',2)[1])
            if ($KnownRefRewrites.ContainsKey($relKey) -and $KnownRefRewrites[$relKey].ContainsKey($ourl)) {
                Write-Host "[NOTE] $relKey : documented upstream fix ref-link '$ourl' -> '$($KnownRefRewrites[$relKey][$ourl])'"
                $ourl = $KnownRefRewrites[$relKey][$ourl]
            }
            if ($ourl -cne $turl) {
                Write-Output "[FAIL] $rel : ref-link #$($i+1) url differs (orig='$ourl' trans='$turl')"
                $fail++
            }
        }
    }

    $oi = @(Get-InlineLinkTargets $f.FullName | ForEach-Object { Normalize-LinkTarget $_ } | ForEach-Object { Apply-Rewrite $relKey $_ })
    $ti = @(Get-InlineLinkTargets $tPath | ForEach-Object { Normalize-LinkTarget $_ })
    $os = @($oi | Sort-Object -Unique)
    $ts = @($ti | Sort-Object -Unique)
    $missing = @($os | Where-Object { $_ -notin $ts })
    $extra = @($ts | Where-Object { $_ -notin $os })
    if ($KnownLinkAdditions.ContainsKey($relKey)) {
        $allowed = @($KnownLinkAdditions[$relKey])
        foreach ($added in @($extra | Where-Object { $_ -in $allowed })) {
            Write-Host "[NOTE] $relKey : documented upstream fix added link '$added'"
        }
        $extra = @($extra | Where-Object { $_ -notin $allowed })
    }
    if ($missing.Count -gt 0 -or $extra.Count -gt 0) {
        Write-Output "[FAIL] $rel : inline link targets differ (missing=[$($missing -join ', ')] extra=[$($extra -join ', ')])"
        $fail++
    }
}

Write-Output "---"
Write-Output "Checked $total files, $fail problem(s)"
if ($fail -eq 0) { Write-Output "ALL OK: code blocks, headings, links match 100% (with documented upstream fixes)" }
exit ($fail -gt 0)
