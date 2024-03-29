# Function to search for SSL/TLS certificates on crt.sh
function Search-Certificates {
    param(
        [string]$domain
    )

    # Define the API endpoint
    $url = "https://crt.sh/?q=%.$domain"

    try {
        # Invoke the API
        $response = Invoke-RestMethod -Uri $url -Method Get
        write-host $response

        # Parse the response
        $certificates = $response

         # Create a file for saving certificate results
        $outputFile = "$domain-certificates.txt"
        $certificates | ForEach-Object {
            $_.name_value -split "`n" | ForEach-Object {
                $_.Trim() | Out-File -FilePath $outputFile -Append
            }
        }

        # Display the results
        if ($certificates.Count -gt 0) {
            Write-Host "Found $($certificates.Count) certificates for $domain"
            $certificates | ForEach-Object {
                $_.name_value -split "`n" | ForEach-Object {
                    $_.Trim()
                }
            }
        } else {
            Write-Host "No certificates found for $domain."
        }
    } catch {
        Write-Host "Error occurred while fetching certificates: $_"
    }
}

# Read domain names from file
$domains = Get-Content "C:\Users\sater\Downloads\basisscholen.lst"

# Search for certificates for each domain
foreach ($domain in $domains) {
    Search-Certificates -domain $domain
}