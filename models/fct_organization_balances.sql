{{ 
    config(
        materialized = 'incremental'
        , unique_key = ['organization_id', 'date']
        , incremental_strategy = 'delete+insert'
    )
}}

with

required_organizations as (

    select organizations.* 
    from {{ ref('stg_organizations') }} as organizations
    {% if is_incremental() %}
        --ideally would utilize a date from the invoice for this fct
        --here we will use the last_payment_date as an indicator of new information
        where last_payment_date > (select max(date) from {{ this }})
    {% endif %}
)

, all_invoices as (
    select * from {{ ref('stg_invoices') }}
)

, required_invoices as (

    select
        required_organizations.organization_id
        , required_organizations.last_payment_date
        , all_invoices.fx_rate * all_invoices.amount as converted_amount
    from required_organizations
    --limit the invoices were handling to only those related to organizations with change
    inner join all_invoices
        on required_organizations.organization_id = all_invoices.organization_id
)

, final as (

    select 
        organization_id
        , last_payment_date as date
        , round(sum(converted_amount), 2) total_invoices_amount_usd
    from required_invoices
    group by 1, 2

)

select * from final
