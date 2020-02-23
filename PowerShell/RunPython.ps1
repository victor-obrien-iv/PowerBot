function RunPython($fileName, $arg) {
    $version = python -V

    if ($version -match "Python 3") {
        $argString = foreach ($i in $arg) { """$i""" }
        $filePath = """$PSScriptRoot\..\Python\$fileName"""
        $output = Invoke-Expression "python $filePath $argString" 
        return @{ExitCode=$LASTEXITCODE; Output=$output}
    }
    else {
        Write-Error "Could not find Python 3.X.X
        is it in your $PATH variable?"
    }
}

function LocateImage($superImage, $subImage) {
    $r = RunPython "LocateImage.py" @($superImage, $subImage)

    if ($r.ExitCode -eq 0) { $r["Result"] = $true }
    else { $r["Result"] = $false }

    return $r
}

function LocateOnScreen($subImage, $confidence) { # TODO refactor this
    if (!$confidence) { $confidence = 0.7 }

    $r = RunPython "LocateOnScreen.py" @($subImage, $confidence)

    if ($r.ExitCode -eq 0) { $r["Result"] = $true }
    else { $r["Result"] = $false }

    return $r
}


