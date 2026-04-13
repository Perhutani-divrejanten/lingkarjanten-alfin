# Rebrand Script for Lingkar Janten
# Backup articles.json
$timestamp = Get-Date -Format "yyyyMMddHHmmss"
Copy-Item "articles.json" "articles.json.bak.$timestamp"

# Function to fix encoding
function Fix-Encoding {
    param([string]$filePath)
    $content = Get-Content $filePath -Raw -Encoding UTF8
    # Replace smart quotes
    $content = $content -replace '“', '"'
    $content = $content -replace '”', '"'
    $content = $content -replace '‘', "'"
    $content = $content -replace '’', "'"
    $content = $content -replace '–', '-'
    $content = $content -replace '—', '-'
    $content = $content -replace '\uFFFD', ' '  # Replace replacement char with space
    $content = $content -replace '\u00A0', ' '  # Replace nbsp with space
    Set-Content $filePath $content -Encoding UTF8
}

# Function to rebrand content
function Rebrand-Content {
    param([string]$filePath)
    $content = Get-Content $filePath -Raw -Encoding UTF8
    # Replace branding
    $content = $content -replace 'Warta Janten', 'Lingkar Janten'
    $content = $content -replace 'wartajanten', 'lingkarjanten'
    $content = $content -replace 'WartaJanten', 'LingkarJanten'
    $content = $content -replace 'wartajanten@gmail\.com', 'lingkarjanten@gmail.com'
    # Replace social handles
    $content = $content -replace 'facebook\.com/wartajanten', 'facebook.com/lingkarjanten'
    $content = $content -replace 'twitter\.com/wartajanten', 'twitter.com/lingkarjanten'
    $content = $content -replace 'instagram\.com/wartajanten', 'instagram.com/lingkarjanten'
    $content = $content -replace 'youtube\.com/wartajanten', 'youtube.com/lingkarjanten'
    # Replace title suffix - adjust for various formats
    $content = $content -replace 'Warta Janten - ', 'Lingkar Janten - '
    # Replace logo in navbar-brand
    $content = $content -replace '<span style="font-weight: bold; color: #[0-9A-Fa-f]{6}; font-size: 24px; letter-spacing: -0.5px;">WARTA<span style="color: #[0-9A-Fa-f]{6}; font-weight: normal; font-size: 18px; margin-left: 2px;">JANTEN</span></span>', '<span style="font-weight: bold; color: #2563EB; font-size: 24px; letter-spacing: -0.5px;">LINGKAR<span style="color: #F59E0B; font-weight: normal; font-size: 18px; margin-left: 2px;">JANTEN</span></span>'
    # Remove logo.png references
    $content = $content -replace '<img[^>]*src="[^"]*logo\.png"[^>]*>', ''
    $content = $content -replace 'img src="\.\./img/logo\.png"', ''
    Set-Content $filePath $content -Encoding UTF8
}

# Process HTML files
$htmlFiles = Get-ChildItem -Recurse -Include *.html
$mainPages = 0
$articlePages = 0
foreach ($file in $htmlFiles) {
    Fix-Encoding $file.FullName
    Rebrand-Content $file.FullName
    if ($file.Directory.Name -eq 'article') {
        $articlePages++
    } else {
        $mainPages++
    }
}

# Process CSS files
$cssFiles = Get-ChildItem -Recurse -Include *.css
$cssCount = 0
foreach ($file in $cssFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    # Update CSS variables
    $content = $content -replace '--primary: #[0-9A-Fa-f]{6};', '--primary: #2563EB;'
    $content = $content -replace '--dark: #[0-9A-Fa-f]{6};', '--dark: #1E293B;'
    $content = $content -replace '--secondary: #[0-9A-Fa-f]{6};', '--secondary: #F59E0B;'
    # Update inline colors if any
    $content = $content -replace '#FFCC00', '#F59E0B'
    $content = $content -replace '#1E2024', '#1E293B'
    Set-Content $file.FullName $content -Encoding UTF8
    $cssCount++
}

# Process package.json files
$packageFiles = Get-ChildItem -Recurse -Include package.json
$packageCount = 0
foreach ($file in $packageFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $content = $content -replace '"name": "wartajanten"', '"name": "lingkarjanten"'
    $content = $content -replace '"name": "wartajanten-article-generator"', '"name": "lingkarjanten-article-generator"'
    $content = $content -replace '"description": "[^"]*Warta Janten[^"]*"', '"description": "Generator artikel otomatis dari Google Sheets untuk Lingkar Janten"'
    $content = $content -replace '"wartajanten"', '"lingkarjanten"'
    $content = $content -replace '"Warta Janten Team"', '"Lingkar Janten Team"'
    Set-Content $file.FullName $content -Encoding UTF8
    $packageCount++
}

# Process documentation files
$docFiles = Get-ChildItem -Recurse -Include *.md,*.txt,*.yml,*.toml
$docsCount = 0
foreach ($file in $docFiles) {
    $content = Get-Content $file.FullName -Raw -Encoding UTF8
    $content = $content -replace 'Warta Janten', 'Lingkar Janten'
    $content = $content -replace 'wartajanten', 'lingkarjanten'
    $content = $content -replace 'WartaJanten', 'LingkarJanten'
    Set-Content $file.FullName $content -Encoding UTF8
    $docsCount++
}

# Output summary
Write-Host "Rebrand completed:"
Write-Host "Main pages changed: $mainPages"
Write-Host "Article pages changed: $articlePages"
Write-Host "CSS files changed: $cssCount"
Write-Host "Package files changed: $packageCount"
Write-Host "Documentation files changed: $docsCount"
Write-Host "Rebrand Lingkar Janten selesai ✅"