# Copyright 2026 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
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
