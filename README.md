# bxms_decision_mgmt_foundations_lab
Decision Management Foundations Lab

## Using the JSON template
1. Login to master host
  ```
  oc login
  ```
2. Create the template in the project
  ```
  oc create -f pquote-mysql-persistent-template.json
  ```
3. Create the environment using the template
  ```
  oc process pquote-mysql-persistent -p MYSQL_USER=pquote -p MYSQL_PASSWORD=pquote -p MYSQL_DATABASE=pquote | oc create -f -
  ```
## Using the yaml template
1. Login to master host
  ```
  oc login
  ```
1. Create the template in the project
  ```
  oc process -f pquote-mysql-persistent.yaml -p MYSQL_USER=pquote -p MYSQL_PASSWORD=pquote | oc create -f -
  ```
