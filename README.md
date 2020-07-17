![getaccept icon](https://www.getaccept.com/hs-fs/hubfs/GetAccept_Logo_Grey_Web-1.png?width=260&name=GetAccept_Logo_Grey_Web-1.png) 

# GetAccept OpenAPI collection

#### Contents 

1. [Getting Started](#getting-started)
2. [OpenAPI formats](#openapi-formats)
3. [Creating Microsoft Custom connector](#creating-microsoft-custom-connector)
4. [Running the converter](#running-the-converter)

---

## Getting Started
Welcome to GetAccept API! You can use this API to access all our API endpoints.

The API is organized around REST. All requests should be made over SSL to the servers. All request and response bodies, including errors, are encoded in JSON.

To authenticate to the API you need to have a valid and active GetAccept account.

We welcome the study and testing of our API to all GetAccept users but commercial usage is subject to the purchase of a GetAccept API package.

If you need help during the integration or want to learn more about pricing, please don't hesitate to reach out to us using the built-in support-chat on this page at the lower-right corner.


## OpenAPI formats
* [openapi.json](openapi.json)  OpenAPI 3 definition in JSON format
* [swagger.yaml](swagger.yaml)  OpenAPI 3 definition in YAML format
* [swagger2.json](swagger2.json)  OpenAPI 2 definition in JSON format
* [swagger2.yaml](swagger2.yaml)  OpenAPI 2 definition in YAML format


## Creating Microsoft Custom connector
To run these scripts, you need to have a copy of the NodeJS runtime. The easiest way to do this is through npm. If you have NodeJS installed you have npm installed as well.

In the [connector](connector) folder we have the files needed to create a custom connectors to be used in Azure Logic Apps, Microsoft Power Automate, and Microsoft Power Apps.

**Install required packages**
To create a custom connector in your Microsoft Power Platform environment, follow the guide below.
```terminal
$ npm install
```

**Install paconn**

Paconn is the Microsoft Power Platform Connectors CLI which is required to install a custom connector from the terminal.
```terminal
$ npm run ms-install
```

**Login to Power Platform**

```terminal
$ npm run ms-login
```
This will ask you to login using the device code login process. Follow the prompt for the login.


**Create Custom connector**

A new custom connector can be created from the files in the connector folder. Create a connector by running:
```terminal
$ npm run ms-create
```
When the environment is not specified the command will prompt for it. 


**Update Custom connector**

Currently you can't update a connector so you will have to remove the [existing custom connector](https://us.flow.microsoft.com/manage/environments/Default/connections/custom) before creating it again.


## Running the converter

The convert script will generate the custom connector definition files and swagger 2 versions of the OpenAPI definintion.
```terminal
$ npm run convert
```
