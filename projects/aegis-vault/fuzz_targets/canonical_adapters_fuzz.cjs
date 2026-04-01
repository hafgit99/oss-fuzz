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
