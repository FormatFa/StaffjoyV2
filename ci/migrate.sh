export ACCOUNT_MYSQL_CONFIG='mysql://root:SHIBBOLETH@tcp(127.0.0.1:56066)/account'

export COMPANY_MYSQL_CONFIG='mysql://root:SHIBBOLETH@tcp(127.0.0.1:56066)/company'




echo "Running database migration"
migrate -database=${ACCOUNT_MYSQL_CONFIG} -path=${STAFFJOY}/account/migrations/ up
migrate -database=${COMPANY_MYSQL_CONFIG} -path=${STAFFJOY}/company/migrations/ up
