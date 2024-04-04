# deel_takehome

### 1. Dimension table for organizations enriched with important information

Created dim_organizations to store the organization ID and key attributes

### 2. Fact table at date / organization_id granularity

Created fct_daily_organization_totals. 
This currently relies on an insert only incremental, ideally we could use a date from the invoice to access reliable daily amounts. This would allow us to full refresh the incremental without losing data and give a more accurate picture of which invoices triggered the change. We may also want to consider only some invoice statuses depending on the balance we are interested in tracking.

### 3. Tests to ensure data quality is accurate

Implemented a few DQ tests on uniqueness and to ensure we have an organization record for all organization IDs in the invoice table (this test identifies many records). This could be expanded, but these test cover some of the assumptions made in generating the dim and fct - the grain and that we only consider invoices belonging to organizations in the organization input data.

### 4. Alert if account balance changes by more than 50%
A function that, when called, sends an alert message to your local console if a daily
financial account balance changes by more than 50% day over day. This should only
look at new days.

Created a dbt test that can be called with `dbt test -s organization_financial_account_balance` that considers only records loaded into the fct same day so we are not re-testing previously loaded rows. It compares the total balance of the organization to that calculated on the last load to determine if the value has changed by more than 50%. Chose to use loaded_at as the identifier of 'new' days rather than the date field incase of partial days (cases where the model is run on a day before all invoices are entered, the next run we would want to test that information).
This was tested by adding some dummy data that breached the threshold an example of pass and failure snips in the screenshot dir.
