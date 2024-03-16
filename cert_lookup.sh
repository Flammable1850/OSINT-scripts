#!/bin/bash

# Input file containing domain names, assuming it's named domains.lst
input_file="basisscholen.lst"

# Function to extract domain name from URL
extract_domain() {
    url="$1"
    # Use sed to extract the domain name
    domain=$(echo "$url" | sed -e 's|http[s]*://||' | awk -F/ '{print $1}')
    echo "$domain"
}

# Function to check crt.sh for certificates
check_crtsh() {
    domain="$1"
    # Use curl to fetch the certificate information from crt.sh
    crtsh_output=$(curl -k -s "https://crt.sh/?q=%.$domain&output=text" | grep -E "SHA-1|Subject:")

    if [[ -n "$crtsh_output" ]]; then
        echo "Certificate info for $domain found on crt.sh:"
        echo "$crtsh_output"
        echo "$crtsh_output" > "$domain/crtsh_certificate_info.txt"
        echo "Certificate information found on crt.sh for $domain" > "$domain/crtsh_result.txt"
    else
        echo "Certificate information not found on crt.sh for $domain"
        echo "Certificate information not found on crt.sh for $domain" > "$domain/crtsh_result.txt"
    fi
}

# Loop through each domain in the input file
while IFS= read -r url; do
    # Extract domain name from the URL
    domain=$(extract_domain "$url")

    # Create a directory with the domain name if it doesn't exist
    mkdir -p "$domain"

    # Check for certificate information on crt.sh
    check_crtsh "$domain"
done < "$input_file"
