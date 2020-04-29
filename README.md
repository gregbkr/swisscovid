# COVID

## Overview

### Scope
- Simple webpage list covid19 news and useful links

### Tech
- Hosting: AWS S3
- Front: Gatsby-React
- CDN: Cloudfront
- Code + CICD: gitlab.com

## Dev
```
npm install --g gatsby-cli
gatsby new gatsby-universal https://github.com/fabe/gatsby-universal
gatsby develop

```
gatsby new gatsby-contentful-portfolio https://github.com/wkocjan/gatsby-contentful-portfolio

## Infra

### Requisit
- Purchase domain `swisscovid.com` in route53
- Create custom certificate: swisscovid.com in zone `us-east-1` (for cloudfront to see)

### Terraform
- First deploy S3 to store the state and dynamodb to lock it: 
```
cd infra/terraform-state-backend
terraform init
terraform apply
```
- Then deploy all component: IAM user, S3 hosting, Cloudfront...
```
cd infra/terraform/prod
nano main.tf <-- edit to your needs
terraform init
terraform apply
```

### Deploy code

- Find IAM user `covid-write-to-s3` credential to add to Gitlab setting cicd variable.
- Run a pipeline.
- Access site from s3 hosting: [Master](https://swisscovid.com)

## ToDo

- [x] Add Swiss infected / death data on header (fetch rest API)
- [x] Cloudfront + https + terraform
- [x] Image size
- [x] Better Domain name swisscovid.com
- [x] Add google analytics
- [x] Fix contact
- [x] To fix: in order to be able to refresh subpage, need cloudfront origin to be "swisscovid.com.s3-website.eu-west-3.amazonaws.com"