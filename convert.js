var converter = require('api-spec-converter');
var fs = require('fs');
converter.convert({
  from: 'openapi_3',
  to: 'swagger_2',
  source: 'swagger.yaml',
})
  .then(function(converted) {
    // [Optional] Fill missing fields with dummy values
    converted.fillMissing();

    // [Optional] Validate converted spec
    return converted.validate()
      .then(function (result) {
        if (result.errors)
          // return console.error(JSON.stringify(result.errors, null, 2));
      	  console.log(JSON.stringify(result.errors, null, 2));
        if (result.warnings)
          return console.error(JSON.stringify(result.warnings, null, 2));

        fs.writeFileSync('swagger2.json', converted.stringify());
      });
  });

// Convert to json
converter.convert({
  from: 'openapi_3',
  to: 'openapi_3',
  source: 'swagger.yaml',
})
  .then(function(converted) {
    // [Optional] Fill missing fields with dummy values
    converted.fillMissing();

    // [Optional] Validate converted spec
    return converted.validate()
      .then(function (result) {
        if (result.errors)
          // return console.error(JSON.stringify(result.errors, null, 2));
      	  console.log(JSON.stringify(result.errors, null, 2));
        if (result.warnings)
          return console.error(JSON.stringify(result.warnings, null, 2));

        fs.writeFileSync('openapi.json', converted.stringify());
      });
  });