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
const adapters = require(process.env.SRC + "/aegis-vault/oss_fuzz_build/src/lib/canonical-adapters.js");

function text(buf, start, len) {
  return buf.slice(start, start + len).toString("utf8");
}

module.exports.fuzz = function (data) {
  const b = Buffer.from(data);
  const entry = {
    id: b.length % 100000,
    title: text(b, 0, 32),
    username: text(b, 8, 24),
    website: text(b, 16, 64),
    category: text(b, 24, 16),
    pass: text(b, 32, 32),
    notes: text(b, 40, 64),
    tags: [text(b, 48, 8), text(b, 56, 8)],
    updated_at: new Date().toISOString()
  };

  try {
    const canonical = adapters.toCanonicalVaultRecord(entry);
    adapters.fromCanonicalVaultRecord(canonical);
  } catch (_) {}
};
