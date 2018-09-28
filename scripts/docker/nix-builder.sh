export PATH="$coreutils/bin"
mkdir -p $out/bin
mkdir -p $out/schemas
cp $schemapath/*.yaml $out/schemas/
cp $mytaxsyspath $out/bin/mytaxsys
