with source as (
select * from {{ source('rds', 'suppliers') }}
),
renamed AS (
    SELECT supplier_id, company_name,
        SPLIT_PART(contact_name, ' ',  1) AS contact_first_name,
        SPLIT_PART(contact_name, ' ',  -1) AS contact_last_name, 
        contact_title,
        REPLACE(TRANSLATE(phone, '-,(,) ', ''), ' ', '') AS phone,
        address,
        city,
        postal_code,
        region,
        fax,
        homepage
    FROM source
    ), 
    final as (
    SELECT supplier_id, company_name,
    contact_first_name, contact_last_name, contact_title,
    CASE WHEN LENGTH(phone) = 10 THEN
        '(' || SUBSTRING(phone, 1, 3) || ') ' ||
        SUBSTRING(phone, 4, 3) || '-' ||
        SUBSTRING(phone, 7, 4)
        END as phone,
        address, city, postal_code,
        region, fax, homepage
    FROM renamed
)

SELECT * FROM final
-- SELECT * FROM  source
