Function Set-VSEnvironment() {
    # Just use whatever is VS's official .bat to setup command prompt
    if (($env:FrameworkDir -eq $null) -or 
        ($env:FrameworkDir -eq "")) {

        # A few places, in decreasing priority, for script that setups up VS environment
        $VsDevCmdPaths = @(
            "C:\Program Files (x86)\Microsoft Visual Studio\2017\Enterprise\Common7\Tools\VsDevCmd.bat",
            "C:\Program Files (x86)\Microsoft Visual Studio\2017\Community\Common7\Tools\VsDevCmd.bat", 
            "C:\Program Files (x86)\Microsoft Visual Studio 14.0\Common7\Tools\VsDevCmd.bat")
        foreach ($VsDevCmdPath in $VsDevCmdPaths) {
            if (Test-Path $VsDevCmdPath) {
                cmd /c """$VsDevCmdPath""&set" |
                    foreach {
                        # Just dumping env vars to console/log
                        if ($_ -match "=") {
                            $v = $_.split("="); 
                            Write-Host "Setting $($v[0])" -ForegroundColor Yellow
                            Set-Item -force -path "ENV:\$($v[0])"  -value "$($v[1])"
                        }
                    }
                write-host "`nVisual Studio Command Prompt variables set via $VsDevCmdPath" -ForegroundColor Yellow
                break;
            }
        }
    } else {
        Write-Host "Visual Studio environment already setup" -ForegroundColor Yellow
    }
}

# Just setup the VS CLI environment
Set-VSEnvironment

# This is necessary to trigger the issue
gci . -Recurse -Include bin,obj | % { ri -Recurse -Force $_.FullName }

# And now it barfs :/
# building in VS2017 (15.7.4) works just fine though
msbuild .\ClassLibraryFw462NewProj\ClassLibraryFw462NewProj.csproj /p:SolutionDir=C:\temp\new-old-proj-mix-soln /p:Configuration=Debug /m /t:build

msbuild /version