with 
source as (
    select * from {{ source('deel_inputs', 'invoices') }}
)

, final as (

    select 
        invoice_id
        , parent_invoice_id
        , transaction_id
        , organization_id
        , type
        , status
        , currency
        , payment_currency
        , payment_method
        , amount
        , payment_amount
        , fx_rate
        , fx_rate_payment
    from source 
)

select * from final
