# 1. Create feature branch off main
git checkout -b feat/s3-encryption-setup

# 2. Work and commit frequently
git add terraform/modules/s3/s3.tf
git commit -m "feat: add SSE-KMS encryption with key rotation"

# 3. Before pushing, sync with main
git fetch origin
git rebase origin/main


# After rebase, verify nothing broke
terraform validate
terraform plan

# 4. Push to remote (creates PR)
git push --force-with-lease origin feat/s3-encryption-setup

# 5. (In real team) Open PR, get review, merge to main
#    (Solo) You just merge your own PR and delete branch
