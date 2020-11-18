# Squire
<!-- 
![Squire Logo](./client/public/squire.png)
![Squire Webpage](./client/public/squireWebsite.png) 
-->
## Overview
A project to assist the 497 ISRG in tracking training appropriately.
 
## Setup
### Dependencies
* `java 1.8`
<!-- 
* `mysql stable 5.7.20` (or later) 
* `node 10.16.0` (or later) 
* `yarn 1.17.3` (or later) 
-->

## Environment Variables
* None at this time

<!-- 
These variables are required:
- `PIE_DB_URL` (string)
- `PIE_DB_USERNAME` (string)
- `GETS_REQUEST_TIME_FRAME_IN_DAYS` (int)
- `GETS_URI_CLOSED` (string)
- `GETS_URI_OPEN_PENDING` (string) 

You can setup all required environment variables by running
  * `source ./scripts/setup_env.sh`
 
 ### Setup the database
 * `./scripts/setup_db.sh`
 -->

## Build
* None at this time

<!-- 
### Client
* Be sure dependencies are up to date with `cd client && yarn`
* `cd client && yarn build`

### Backend
* `mvn install`

## Develop
### Client Development Server
* `cd client && yarn start`

### Backend Development Server
* `mvn spring-boot:run`
    * alternatively use IntelliJ `Application` run configuration
-->

## Test 

<!-- 
#### Frontend Tests
* `cd client && yarn test`
    * alternatively use IntelliJ `All Frontend` run configuration

#### Backend Tests
-->
* `mvn test` 
<!-- 
    * alternatively use IntelliJ `All Backend` run configuration
    
#### All Unit Tests (Frontend and Backend)
* `./scripts/tests.sh unit`

#### Acceptance Tests
* `./scripts/tests.sh acc` or `./scripts/tests.sh acceptance`

#### Acceptance Tests without rebuilding the JAR
* `./scripts/tests.sh anj`

#### Specific Acceptance Tests
* `./scripts/tests.sh acc #` or `./scripts/tests.sh anj #` or `./scripts/tests.sh acceptance #` 
    * replace # with the acceptance test number you want to run

#### All tests
* `mvn test`
-->

## Deploy
The app will push at the end of its pipeline cycle (in Jenkins via NGA).  Jenkins will run every push to gitlab.gs.mil through the pipeline, and the develop and main branches will push to their respective spaces in PCF.

* `main` gets pushed to https://squire.east.paas.nga.mil/ (https://squire.gs.mil at later date)
* `develop` gets pushed to https://squire.dev.gs.mil
* `*` (All Others) gets pushed to https://squire-test.dev.gs.mil

## Resources
- [Squire on PivotalTracker](https://www.pivotaltracker.com/n/projects/2476396)
- [Squire CI/CD (Jenkins)](https://jenkins.gs.mil/job/dgs1sdt/job/squire/)

- [Squire (production)](https://squire.east.paas.nga.mil/)
- [Squire (acceptance)](https://squire.dev.gs.mil)
- [Squire (testing)](https://squire.test.gs.mil)
