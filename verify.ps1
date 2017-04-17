docker build `
 -t $Env:dockerID/mta-verify `
 $pwd\verify;

docker run --rm $Env:dockerID/mta-verify;
