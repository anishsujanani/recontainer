# Build container with:
`docker build . -t recontainer`

# Run the container:
The script dumps output for the input domain to `/tmp/$1`, so volume map onto that path on your host.  
`docker run --rm -v /path/to/store/files:/tmp/<DOMAIN> recontainer <DOMAIN>`
