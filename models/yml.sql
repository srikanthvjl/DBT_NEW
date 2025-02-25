name: $(Date:yyyyMMdd)$(Rev:.r)

pool: 'RedGate-FlyWay'  

resources:
  repositories:
    - repository: templates
      type: git
      name: "Infrastructure Automation/AzureDevOps.Pipeline.Templates"

trigger:
  - master

extends:
  template: dataservices/redGateFlyWay/redGateFlyWayMain.yaml@templates
  parameters:
    dbName: "ENT_KYC"
    dbFolder: '/ENT_KYC/migrations'
    flyWayCmdArgs: '-X -outputType=json -table=FLYWAY_HISTORY -baselineOnMigrate=true -createSchemas=false -defaultSchema=FLYWAY'
    
    azureKeyVaultServiceConnectionName: "Azure_MRC_Lower_KeyVaults_Reader"
    devAzureKeyVault: "mrc-dbanosql-kv-dev"
    qaAzureKeyVault: "mrc-dbanosql-kv-qa"
    uatAzureKeyVault: "mrc-dbanosql-kv-uat"
    prodAzureKeyVault: "mrc-dbanosql-kv-prod"
    
    dbUrlKey: "snowflake-jdbc-url" 
    dbUserNameKey: orig-snowflake-dbac-uid
    dbPasswordKey: orig-snowflake-dbac-pwd
    
    deployDev: true
    deployQA: true
    deployUAT: true
    deployProd: true


    fly FlyWay
    databaseType = "Snowflake"
id = "60f07b1e-a6f4-442a-ae28-6a9cb56e9fe2"
name = "ENT_KYC"

[flyway]
locations = [ "filesystem:migrations" ]
mixed = true
outOfOrder = true
schemaModelLocation = "schema-model"
validateMigrationNaming = true

[flyway.check]
majorTolerance = 0

[flywayDesktop]
developmentEnvironment = "development"
schemaModel = "schema-model"
shadowEnvironment = "shadow"

[redgateCompare]
filterFile = "filter.rgf"