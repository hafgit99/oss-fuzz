const { ImportService } = require(process.env.SRC + "/aegis-vault/oss_fuzz_build/src/lib/ImportService.js");

module.exports.fuzz = function (data) {
  const input = data.toString("utf8");
  try { ImportService.parseJson(input); } catch (_) {}
  try { ImportService.parseJsonCanonical(input); } catch (_) {}
};
