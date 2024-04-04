

with fct_organization_balances as (

    select * from {{ ref('fct_organization_balances') }}
)

, organizations_to_test as (

    select 
        organization_id
        , date
        , (total_invoices_amount_usd - lag(total_invoices_amount_usd) over (partition BY organization_id order by date)) as delta 
        , delta / total_invoices_amount_usd as percent_change
    from fct_organization_balances
)


select * from organizations_to_test
where date = current_date and abs(percent_change) > 0.5