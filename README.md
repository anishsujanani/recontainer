# Build container with:
`docker build . -t recontainer`

# Run the container:
The script dumps output for the input domain to `/tmp/$1`, so volume map onto that path on your host.  
`docker run --rm -v /path/to/store/files:/tmp/<DOMAIN> recontainer <DOMAIN>`

If you need to run recon on multiple domains, I'd suggest dumping them in a file, new-line separated and running:
`for i in $(cat domains_file); do docker run --rm -d -v /path/to/store/files/$i:/tmp/$i --name $i recontainer $i; done`

Depending on your network bandwidth, limit the number of lines (and containers) or add a wait to the loop.
