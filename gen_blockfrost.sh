set -ex

openapi3-code-generator-exe -- \
  --use-float-with-arbitrary-precision \
  --use-int-with-arbitrary-precision \
  --property-type-suffix="'" \
  --package-name blockfrost-api \
  --module-name BlockfrostAPI \
  --convert-to-camel-case \
  --do-not-generate-stack-project \
  -i ~/blockfrost/openapi/swagger.yaml \
  -o ~/blockfrost/Haskell-Blockfrost-API

# hack
pushd ~/blockfrost/Haskell-Blockfrost-API
blockfrost-fix-collisions
