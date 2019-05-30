## extract_profileps
example bash script to extract profiles/permissionsets from an org (requires sfdx, unzip, awk)

## process_profileps
example bash script to strip out everything but objectPermssions from profiles/permissionsets (requires xslt, awk)

## example steps migrating from one org to another (eg. sandbox -> target)

1. connect sfdx cli to the orgs

	`sfdx force:auth:web:login -r https://test.salesforce.com -a sandbox`

	`sfdx force:auth:web:login -r https://test.salesforce.com -a target`

2. extract the profiles

	`./extract_profileps.sh sandbox`

3. process the profiles from sandbox and output to sandbox_deploy

	`./process_profileps.sh sandbox sandbox_deploy`

4. deploy to target org (check)

	`sfdx force:mdapi:deploy -c -d src/sandbox_deploy -w -1 -u target`

5. fix errors (eg. fix missing target objects by adding to `process_objectPermissions.awk`, fix userPermissions in target org or directly in profiles/permissionsets in `src/sandbox_deploy` folder) and repeat step 4.

## note
These scripts are provided for example purposes only.  Please ensure you understand the implications of the commands you are running especially any `sfdx force:mdapi:deploy` commands.
