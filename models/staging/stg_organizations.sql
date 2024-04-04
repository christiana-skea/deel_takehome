with 
source as (
    select * from {{ source('deel_inputs', 'organizations') }}
)

, renamed as (

    select 
        organization_id
        , legal_entity_country_code
        , count_total_contracts_active
        , last_payment_date
        , first_payment_date
        --created date is a timestamp, rename to differentiate
        , created_date as created_at
    from source
)

select * from renamed
