SELECT campaign_id, 
       startdate, 
       enddate 
       FROM {{ ref('workload') }}
       WHERE startdate >= enddate