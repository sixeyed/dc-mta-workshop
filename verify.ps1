
[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [string] $dockerID
)

docker build `
 -t $dockerID/mta-verify `
 $pwd\verify

docker run --rm $dockerID/mta-verify
