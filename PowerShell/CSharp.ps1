function ImportCSharp($fileName) {
    try {
        $filePath = "$PSScriptRoot\..\CSharp\$fileName"
        $s = Get-Content $filePath
        $s = "$s"
        Add-Type -TypeDefinition $s
    }
    catch {
        Write-Host "$fileName could not be loaded, it may already be loaded."
    }
}
