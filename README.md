![getaccept icon](https://www.getaccept.com/hs-fs/hubfs/GetAccept_Logo_Grey_Web-1.png?width=260&name=GetAccept_Logo_Grey_Web-1.png) 

# GetAccept OpenAPI collection

#### Contents 

1. [Getting Started](#getting-started)
2. [OpenAPI formats](#openapi-formats)
3. [Microsoft Custom connector](#microsoft-custom-connector)
4. [Creating Custom connector](#creating-custom-connector)
5. [Running the converter](#running-the-converter)

---

## Getting Started
To run these scripts, you need to have a copy of the NodeJS runtime. The easiest way to do this is through npm. If you have NodeJS installed you have npm installed as well.

## OpenAPI formats
In the Connector folder we have the files needed to create a custom connectors to be used in Azure Logic Apps, Microsoft Power Automate, and Microsoft Power Apps.
* [openapi.json](openapi.json)  OpenAPI 3 definition in JSON format
* [swagger.yaml](swagger.yaml)  OpenAPI 3 definition in YAML format
* [swagger2.json](swagger2.json)  OpenAPI 2 definition in JSON format
* [swagger2.yaml](swagger2.yaml)  OpenAPI 2 definition in YAML format

## Microsoft Custom connector
In the [connector](connector) folder we have the files needed to create a custom connectors to be used in Azure Logic Apps, Microsoft Power Automate, and Microsoft Power Apps.

## Creating Custom connector
To automatically create a custom connector in your Microsoft environment, follow the guide below.
** Install required packages
```terminal
$ npm install
```

Install paconn, Microsoft Power Platform Connectors CLI, by running:
```terminal
$ npm run ms-install
```

Login to Power Platform by running:
```terminal
$ npm run ms-login
```
This will ask you to login using the device code login process. Follow the prompt for the login.

Install custom connector
A new custom connector can be created from the files in the connector folder. Create a connector by running:
```terminal
$ npm run ms-create
```
When the environment is not specified the command will prompt for it. 
Currently you can't update a connector so you will have to remove the [existing custom connector](https://us.flow.microsoft.com/manage/environments/Default/connections/custom) first before creating it again.

## Running the converter

The convert script will generate the custom connector definition files and swagger 2 versions of the OpenAPI definintion.
```terminal
$ npm run convert
```
