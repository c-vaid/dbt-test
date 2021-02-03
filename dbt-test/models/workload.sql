SELECT campaign_name 
    , campaign_id
    , d as date
    , EXTRACT(MONTH FROM d) as month
    , EXTRACT(WEEK FROM d) as week
    , EXTRACT(DATE from startdate) as startdate
    , EXTRACT(DATE from enddate) as enddate
    , CASE WHEN EXTRACT(DATE from startdate) = d THEN "Starting" WHEN EXTRACT(DATE from enddate) = d THEN "Ending" ELSE "Live" END as live_status
    FROM (
    SELECT campaign_name, campaign_id, startdate, enddate, d
        FROM (
            SELECT campaign_name, campaign_id, startdate, enddate, GENERATE_DATE_ARRAY(EXTRACT(DATE from startdate), EXTRACT(DATE from enddate), INTERVAL 1 DAY) d
            FROM {{ source('mbk-zeus', 'crm_campaign') }}
            WHERE EXTRACT(DATE from startdate) BETWEEN DATE_SUB(CURRENT_DATE(), INTERVAL 1 YEAR) AND DATE_ADD(CURRENT_DATE(), INTERVAL 1 YEAR)
            ),
        UNNEST(d) d
        )
    GROUP BY 1,2,3,4,5,6,7,8