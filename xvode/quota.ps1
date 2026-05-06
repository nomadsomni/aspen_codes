try {
    $response = Invoke-RestMethod -Uri "https://api.example.com/data" -Method Get
    # Process your response
}
catch {
    if ($_.Exception.Response.StatusCode -eq '403') {
        Write-Host "Error: Quota exceeded. Please check your API usage."
    } else {
        Write-Host "An unexpected error occurred: $($_.Exception.Message)"
    }
}
