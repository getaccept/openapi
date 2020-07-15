const converter = require('api-spec-converter');
const fs = require('fs');
// Convert to openapi 2 / swagger
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
          .then(function(result) {
            if (result.errors) {
              // return console.error(JSON.stringify(result.errors, null, 2));
              console.log(JSON.stringify(result.errors, null, 2));
            }
            if (result.warnings) {
              return console.error(JSON.stringify(result.warnings, null, 2));
            }

            fs.writeFileSync('swagger2.json', converted.stringify());
          });
    });

// Convert to connector
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
          .then(function(result) {
            if (result.errors) {
              // return console.error(JSON.stringify(result.errors, null, 2));
              console.log(JSON.stringify(result.errors, null, 2));
            }
            if (result.warnings) {
              return console.error(JSON.stringify(result.warnings, null, 2));
            }
            fs.writeFileSync(
                'connector/apiDefinition.swagger.json',
                converted.stringify(),
            );
          });
    });

// Convert to openapi 2 yaml
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
          .then(function(result) {
            if (result.errors) {
              // return console.error(JSON.stringify(result.errors, null, 2));
              console.log(JSON.stringify(result.errors, null, 2));
            }
            if (result.warnings) {
              return console.error(JSON.stringify(result.warnings, null, 2));
            }
            const options = {syntax: 'yaml', order: 'openapi'};
            fs.writeFileSync('swagger2.yaml', converted.stringify(options));
          });
    });

// Convert to openapi 3 json
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
          .then(function(result) {
            if (result.errors) {
              // return console.error(JSON.stringify(result.errors, null, 2));
              console.log(JSON.stringify(result.errors, null, 2));
            }
            if (result.warnings) {
              return console.error(JSON.stringify(result.warnings, null, 2));
            }

            fs.writeFileSync('openapi.json', converted.stringify());
          });
    });
