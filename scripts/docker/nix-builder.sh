export PATH="$coreutils/bin"
mkdir -p $out/bin
mkdir -p $out/schemas
cp -r $schemapath $out/schemas
cp $mytaxsyspath $out/bin/mytaxsys
