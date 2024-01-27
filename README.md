# FoxOps

Final project for Telerik Academy

## Description

Static application consisted of HTML, CSS and vanilla Javascript, which is built, tested, scan, format, containerized and deployed on public cloud of AWS. The backbone of the process is GitHub Actions.

Consist of 2 main GitHub Actions workflows:

- Production -> triggered by the deployment of pre.requisite flow , deploys the application on AWS with terraform
- Dev -> trigger by the deployment of feature branch - does not deploy on public cloud

## Used tools

- GitHub/Github Actions
- Public cloud - AWS
- Terraform
- Docker
- DevSecOps tools - SNYK, Frogbot, Gitleaks

## Project map

├── .editorconfig
├── .github
│   └── workflows
| ├── dev.workflow.yml
│   └── prod.workflow.yml
│── .markdownlint.json
├── dist/
├── node_modules/
├── .parcel-cache/
├── Dockerfile
├── src  
│ ├── style.css
│ ├── index.html
│ ├── init.js
│ ├── logic.test.py
│ └── GameRules.md
├── .editorconfig
├── .eslintrc.json
├── docker-compose.yml
├── Dockerfile
├── package.json
├── package-lock.json
├── README.md
├── sonar-project.properties
└── requirements.txt

## Project sketch

## Actions used

Test
[![Super-Linter](https://github.com/<OWNER>/<REPOSITORY>/actions/workflows/<WORKFLOW_FILE_NAME>/badge.svg)](https://github.com/marketplace/actions/super-linter)
Scan
[![Scanned by Frogbot](https://raw.github.com/jfrog/frogbot/master/images/frogbot-badge.svg)](https://docs.jfrog-applications.jfrog.io/jfrog-applications/frogbot)
