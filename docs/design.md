✅ BUILT
├── S3 Module (app bucket)
│   ├── Bucket + public access block
│   ├── Versioning (with commented MFA delete notes)
│   ├── SSE-KMS with key rotation
│   ├── Lifecycle policies (30→STANDARD_IA, 365→GLACIER, expire 600 days)
│   ├── IAM role for EC2 workload (trust + permission + KMS)
│   └── Outputs (bucket_name, bucket_arn)
│
├── Logging Module (separate bucket)
│   ├── Bucket + public access block
│   ├── Lifecycle policies (30→STANDARD_IA, 100→GLACIER, expire 300 days)
│   ├── Bucket policy (S3 logging service can write, source-restricted to app bucket)
│   └── Receives app_bucket_arn as input
│
├── State Bootstrap (S3 + DynamoDB)
│   ├── S3 state bucket (remote state storage)
│   ├── DynamoDB table (state locking)
│   └── Outputs (bucket_name, table_name)
│
└── Environments
    └── dev/
        ├── Remote backend (S3 + DynamoDB)
        ├── Calls s3 module
        └── Calls logging module with cross-module references
