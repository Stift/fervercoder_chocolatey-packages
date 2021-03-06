﻿#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' 'http://download.skype.com/3694814915aaa38100bfa0933f948e65/partner/59/SkypeSetup.exe'
#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' 'http://download.skype.com/msi/SkypeSetup_6.22.81.104.msi'
#Install-ChocolateyPackage 'skype' 'exe' '/SILENT /nogoogle /noie /nodesktopicon' 'http://download.skype.com/SkypeSetupFull.exe'


function isInstalled() {
  return Get-WmiObject -Class Win32_Product | Where-Object {$_.Name -match 'Skype\u2122 [\d\.]+$'}
}

$packageName = 'skype'
$fileType = 'msi'
$silentArgs = '/qn /norestart'
$url = 'http://download.skype.com/msi/SkypeSetup_6.22.81.104.msi'

try {

  $appInstalled = isInstalled

  if ($appInstalled) {
      # If Skype (in any version) is already installed on the computer, remove it first, otherwise the
      # installation of Skype will fail with an error.
      $msiArgs = $('/x' + $appInstalled.IdentifyingNumber + ' ' + $silentArgs)
      Write-Host "Uninstalling previous version of Skype, otherwise installing the new version won’t work."
      Start-ChocolateyProcessAsAdmin $msiArgs 'msiexec'

      # This loop checks every 5 seconds if Skype is already uninstalled.
      # Then it proceeds with the download and installation of the Skype
      # version specified in the package.
      do {
        Start-Sleep -Seconds 5
        $i += 1

        # Break if too much time passed
        if ($i -gt 12) {
          Write-Error 'Could not uninstall the previous version of Skype.'
          break
        }

      } until (-not (isInstalled))
  }

  Install-ChocolateyPackage $packageName $fileType $silentArgs $url

} catch {
  Write-ChocolateyFailure $packageName $($_.Exception.Message)
  throw
}

