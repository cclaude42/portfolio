Auth
- Create AWS account
- Set credentials locally

Backend
- Create S3 state bucket
- Create DDB lock table (LockID)
- Set backend.tfvars

Config
- Create certificate in AWS (GLOBAL !!)
- Copy CNAME pairs in registrar
- Set variables.tfvars

Build
- terraform init -backend-config=backend.tfvars
- terraform plan
- terraform apply

Finalize
- Add Cloudfront URL to registrar
- Wait ?
- Test using script

To do :
- [x] Add error page to CF
- [x] Add lambda for path resolving
- [ ] Write readme
- [ ] Test to see if it works on domain name ?
