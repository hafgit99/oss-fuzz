const { ImportService } = require(process.env.SRC + "/aegis-vault/oss_fuzz_build/src/lib/ImportService.js");

module.exports.fuzz = function (data) {
  const input = data.toString("utf8");
  try { ImportService.parseCsv(input); } catch (_) {}
  try { ImportService.parseCsvCanonical(input); } catch (_) {}
};
