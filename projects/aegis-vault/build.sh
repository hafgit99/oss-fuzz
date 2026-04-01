#!/bin/bash -eu

cd "$SRC/aegis-vault"

npm ci --ignore-scripts

# Create a dedicated TS config for OSS-Fuzz (emit JS as CommonJS).
cat > "$SRC/aegis-vault/tsconfig.ossfuzz.json" << 'EOF'
{
  "compilerOptions": {
    "target": "ES2020",
    "module": "CommonJS",
    "moduleResolution": "Node",
    "esModuleInterop": true,
    "skipLibCheck": true,
    "strict": false,
    "outDir": "oss_fuzz_build",
    "noEmit": false
  },
  "include": [
    "src/lib/ImportService.ts",
    "src/lib/canonical-adapters.ts",
    "src/lib/canonical-schema.ts"
  ]
}
EOF

npx tsc -p tsconfig.ossfuzz.json

mkdir -p "$SRC/aegis-vault/oss_fuzz_targets"
cp -r "$SRC/fuzz_targets/." "$SRC/aegis-vault/oss_fuzz_targets/"

compile_javascript_fuzzer aegis-vault oss_fuzz_targets/import_csv_fuzz.cjs
compile_javascript_fuzzer aegis-vault oss_fuzz_targets/import_json_fuzz.cjs
compile_javascript_fuzzer aegis-vault oss_fuzz_targets/canonical_adapters_fuzz.cjs
