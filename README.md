# RxNorm-PostgreSQL-Scripts
Scripts for loading RxNorm into PostgreSQL

These scripts were created by modifying the MySQL scripts supplied with the RxNorm_full_07032017.zip. They have only been tested for that release in a macOS Sierra (10.12) environment against a PostgreSQL 9.6 server running on a mac OS X El Capitan (10.11) environment.

To run them:
1. Download RxNorm from https://www.nlm.nih.gov/research/umls/rxnorm/docs/rxnormfiles.html
2. Extract the zip file.
3. Put the script files into an equivalent directory as the mysql and oracle scripts, e.g. `RxNorm_full_07032017/scripts/postgres`
4. Edit populate_pg_rxn.sh, set the database variables `PG_HOME`, `user`, `db_name`, `schema_name`, and `dbserver`
to match your environment
5. Open a shell, change directory to the `RxNorm_full_07032017/scripts/postgres` directory, and execute
```bash
. ./populate_pg_rxn.sh
```
6. **Make sure and check the pg.log file for any errors**.
7. Drink a beer.
