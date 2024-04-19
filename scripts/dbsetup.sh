
USERNAME=""
DB_NAME=""

# make new user, grant permissions, set password
# drop permissions of postgres user

sudo -u postgres createuser -s blueteam
createdb db
psql -U $USERNAME -d $DB_NAME -f ncaedb.sql