# FoxOps

Final project for Telerik Academy

## Description

Static application consisted of HTML, CSS and vanilla Javascript, which is built, tested, scan, format, containerized and deployed on public cloud of AWS. The backbone of the process is GitHub Actions. It is connected with SonarCloud, Jira and Terraform cloud.

Consist of 2 main GitHub Actions workflows:

- Production -> triggered by the deployment of pre.requisite flow , deploys the application on AWS with terraform
- Dev -> trigger by the deployment of feature branch - does not deploy on public cloud

Secondary workflows:

- scan-repository-daily - scheduled,scan the whole repo once a day for errors, smells, security vulnerabilities
- destroy.prod.resources - destroy the resources, created from terraform after the deployment on prod, scheduled on 2 hours
- pre.requisite - creates the backend for the production terraform resources, crates infrastructure for ECS
- scan-pull-request - test and scan the repo on pull requests

## Used tools

- GitHub/Github Actions
- Public cloud - AWS
- Terraform
- Docker
- DevSecOps tools - SNYK, Frogbot, Gitleaks

## Project map

![Screenshot (355)](https://github.com/stkraych/FoxOps/assets/131745030/430d09f7-7e0e-4a68-9452-6d29afe25784)

## Project sketch

Dev workflow

![dev](https://github.com/stkraych/FoxOps/assets/131745030/50a3afed-827a-4b42-802e-850933c83171)

Production workflow

![prod](https://github.com/stkraych/FoxOps/assets/131745030/42f21060-e901-42cd-a112-ac2f10a5d6e2)

## Actions used

Test
[![Super-Linter](https://github.com/<OWNER>/<REPOSITORY>/actions/workflows/<WORKFLOW_FILE_NAME>/badge.svg)](https://github.com/marketplace/actions/super-linter)
Scan
[![Scanned by Frogbot](https://raw.github.com/jfrog/frogbot/master/images/frogbot-badge.svg)](https://docs.jfrog-applications.jfrog.io/jfrog-applications/frogbot)
