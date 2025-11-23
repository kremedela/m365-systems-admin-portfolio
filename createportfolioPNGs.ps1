# ==================================================
# M365 Portfolio Creator for Euron Pennyman
# ==================================================
Add-Type -AssemblyName System.Drawing

# -----------------------------
# Paths
# -----------------------------
$repoPath = "C:\Users\Star Wars\Documents\m365-systems-admin-portfolio"
$bannerPath = Join-Path $repoPath "banner.png"
$archPath = Join-Path $repoPath "architecture-dark.png"
$readmeFile = Join-Path $repoPath "README.md"

# Create portfolio folder if missing
if (-not (Test-Path $repoPath)) { New-Item -ItemType Directory -Path $repoPath | Out-Null }

# -----------------------------
# Create portfolio subfolders
# -----------------------------
$folders = @(
    "Hybrid-Lab",
    "Teams-Governance",
    "Intune-SCCM",
    "PowerShell-Automation",
    "Security-Compliance"
)

foreach ($folder in $folders) {
    $fullPath = Join-Path $repoPath $folder
    if (-not (Test-Path $fullPath)) { New-Item -ItemType Directory -Path $fullPath | Out-Null }
}

# -----------------------------
# Function to create PNGs
# -----------------------------
function Create-PNG {
    param(
        [string]$Path,
        [int]$Width,
        [int]$Height,
        [string]$Text = "",
        [switch]$AddCloudIcons,
        [switch]$DrawArchitecture
    )

    $bmp = New-Object System.Drawing.Bitmap $Width, $Height
    $graphics = [System.Drawing.Graphics]::FromImage($bmp)
    $graphics.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias

    # Gradient background
    $rect = New-Object System.Drawing.Rectangle(0,0,$Width,$Height)
    $brush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($rect,
        [System.Drawing.Color]::FromArgb(13,17,23),
        [System.Drawing.Color]::FromArgb(31,41,55),
        [System.Drawing.Drawing2D.LinearGradientMode]::Horizontal)
    $graphics.FillRectangle($brush, $rect)

    # Draw banner text
    if ($Text -ne "") {
        $font = New-Object System.Drawing.Font("Segoe UI",48,[System.Drawing.FontStyle]::Bold)
        $brushText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
        $size = $graphics.MeasureString($Text,$font)
        $x = ($Width - $size.Width)/2
        $y = ($Height - $size.Height)/2
        $graphics.DrawString($Text,$font,$brushText,$x,$y)
    }

    # Optional cloud icons
    if ($AddCloudIcons) {
        $cloudFont = New-Object System.Drawing.Font("Segoe UI Emoji",48)
        $graphics.DrawString("☁️",$cloudFont,$brushText,50,($Height/2)-24)
        $graphics.DrawString("☁️",$cloudFont,$brushText,$Width-120,($Height/2)-24)
    }

    # Optional architecture diagram
    if ($DrawArchitecture) {
        $pen = New-Object System.Drawing.Pen([System.Drawing.Color]::White,2)
        $fontBox = New-Object System.Drawing.Font("Segoe UI",16,[System.Drawing.FontStyle]::Bold)
        $fontArrow = New-Object System.Drawing.Font("Segoe UI",12)

        # Cloud boxes
        $cloudComponents = @("Exchange Online","Teams","SharePoint","OneDrive")
        $xStart = 250; $yStart = 50; $boxWidth = 250; $boxHeight = 70; $gap = 20
        foreach ($comp in $cloudComponents) {
            $graphics.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40,50,100,150))), $xStart, $yStart, $boxWidth, $boxHeight)
            $graphics.DrawRectangle($pen, $xStart, $yStart, $boxWidth, $boxHeight)
            $graphics.DrawString($comp, $fontBox, [System.Drawing.Brushes]::White, $xStart+10, $yStart+20)
            $xStart += $boxWidth + $gap
        }

        # On-prem boxes
        $onPremComponents = @("AD DS / DNS / DHCP","Exchange 2019","SCCM/MECM")
        $xStart = 350; $yStart = 300; $boxWidth = 200; $boxHeight = 60; $gap = 30
        foreach ($comp in $onPremComponents) {
            $graphics.FillRectangle((New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(40,100,50,50))), $xStart, $yStart, $boxWidth, $boxHeight)
            $graphics.DrawRectangle($pen, $xStart, $yStart, $boxWidth, $boxHeight)
            $graphics.DrawString($comp, $fontBox, [System.Drawing.Brushes]::White, $xStart+10, $yStart+15)
            $xStart += $boxWidth + $gap
        }

        # Arrows
        $arrowPen = New-Object System.Drawing.Pen([System.Drawing.Color]::White,3)
        $arrowPen.CustomEndCap = New-Object System.Drawing.Drawing2D.AdjustableArrowCap(5,5)
        $graphics.DrawLine($arrowPen, 400, 360, 300, 100)
        $graphics.DrawLine($arrowPen, 600, 360, 500, 100)
        $graphics.DrawLine($arrowPen, 800, 360, 700, 100)
        $graphics.DrawString("AAD Connect / Mail Flow", $fontArrow, [System.Drawing.Brushes]::White, 500, 250)
    }

    $bmp.Save($Path,[System.Drawing.Imaging.ImageFormat]::Png)
    $graphics.Dispose()
    $bmp.Dispose()
    Write-Host "Created PNG: $Path"
}

# -----------------------------
# Create banner
# -----------------------------
Create-PNG -Path $bannerPath -Width 1600 -Height 400 -Text "Euron Pennyman - M365 Systems Administrator" -AddCloudIcons

# -----------------------------
# Create architecture diagram
# -----------------------------
Create-PNG -Path $archPath -Width 1200 -Height 600 -DrawArchitecture

# -----------------------------
# Create README.md
# -----------------------------
$readmeContent = @"
<!-- ================================================== -->
<!-- BANNER PLACEHOLDER -->
<p align='center'>
  <img src='banner.png' alt='Euron Pennyman — Microsoft 365 Systems Administrator Banner' width='100%'>
</p>

<!-- BADGES -->
<div align='center'>
![PowerShell](https://img.shields.io/badge/PowerShell-Automation-5391FE?logo=powershell&logoColor=white)
![Microsoft365](https://img.shields.io/badge/Microsoft%20365-Expert-EB3C00?logo=microsoft&logoColor=white)
![AzureAD](https://img.shields.io/badge/Entra%20ID%20(Azure%20AD)-Identity%20Mgmt-0078D4?logo=microsoftazure&logoColor=white)
![Intune](https://img.shields.io/badge/Intune-Device%20Mgmt-5E5E5E?logo=microsoft&logoColor=white)
![SCCM](https://img.shields.io/badge/SCCM%2FMECM-Enterprise%20Mgmt-00695C)
![Security](https://img.shields.io/badge/Security-Compliance%20%26%20Zero%20Trust-CC0000)
![Teams](https://img.shields.io/badge/Microsoft%20Teams-Governance-4B53BC?logo=microsoftteams&logoColor=white)
</div>

# ✨ Euron Pennyman — Microsoft 365 Systems Administrator Portfolio

Welcome to my **enterprise-ready Microsoft 365 portfolio**, showcasing hands-on experience with:

- 🔄 **Exchange Hybrid**  
- 📡 **Teams Governance**  
- 🖥 **Intune + SCCM Endpoint Management**  
- ⚙️ **PowerShell Automation**  
- 🛡 **Security + Compliance**  
- ☁️ **Entra ID (Azure AD)**

---

# 🖼 Architecture Diagram (Dark Mode / PNG)
<p align='center'>
  <img src='architecture-dark.png' width='90%' alt='Dark Mode Hybrid Architecture Diagram'>
</p>

# 🌐 Repository Structure
\`\`\`
m365-systems-admin-portfolio
├── Hybrid-Lab/
├── Teams-Governance/
├── Intune-SCCM/
├── PowerShell-Automation/
└── Security-Compliance/
\`\`\`

# 🔗 Contact
<p align='center'>
<a href='mailto:your-euron.pennyman@midnightmoonlight.com'>
  <img src='https://img.shields.io/badge/Email-Contact%20Me-blue?logo=gmail&logoColor=white' />
</a>
<a href='https://www.linkedin.com/in/euron-pennyman-499018376/'>
  <img src='https://img.shields.io/badge/LinkedIn-Connect-blue?logo=linkedin&logoColor=white' />
</a>
<a href='https://github.com/kremedela/m365-systems-admin-portfolio'>
  <img src='https://img.shields.io/badge/GitHub-Profile-black?logo=github' />
</a>
</p>

<p align='center'>
  <sub>© 2025 — Euron Pennyman • Microsoft 365 Systems Administrator Portfolio • Built with ❤️ and PowerShell</sub>
</p>
"@

Set-Content -Path $readmeFile -Value $readmeContent -Force
Write-Host "README.md created successfully at $readmeFile"

Write-Host "`n✅ Portfolio setup complete! PNGs, folders, and README are ready."
