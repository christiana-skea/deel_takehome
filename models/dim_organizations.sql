with

organizations as (
    select * from {{ ref('stg_organizations') }}
)

, final as (

    select
        organization_id
        , legal_entity_country_code
        , last_payment_date
        , first_payment_date
        , created_at
    from organizations
)

select * from final
