-- Data feed are in polymorphic table with all values loaded in single column 
-- Pivot out linear score data and meta data 
-- Join with outcomes data 
-- delta calculations for actual readmission rate - predicted rate 
SELECT *, 
       ( actual_readmission_rate_heart_attack 
         - predicted_readmission_rate_heart_attack 
       )                                                                  AS 
       actual_readmission_rate_minus_predicted_heart_attack, 
       ( actual_readmission_rate_heart_failure 
         - predicted_readmission_rate_heart_failure )                     AS 
       actual_readmission_rate_minus_predicted_heart_failure, 
       ( actual_readmission_rate_copd - predicted_readmission_rate_copd ) AS 
       actual_readmission_rate_minus_predicted_COPD, 
       ( actual_readmission_rate_hip_knee_replace 
         - predicted_readmission_rate_hip_knee_replace )                  AS 
       actual_readmission_rate_minus_predicted_hip_knee_replace, 
       ( actual_readmission_rate_coronary_artery_bypass 
         - predicted_readmission_rate_coronary_artery_bypass )            AS 
       actual_readmission_rate_minus_predicted_coronary_artery_bypass 
FROM   ( 
       -- Add calculations for actual readmission rate in super query 
       SELECT *, 
              Cast(Round((( ( num_readmissions_heart_attack * 100000 ) / 
                                 num_discharges_heart_attack )), 7) AS DECIMAL( 
                   10, 5)) 
              / 1000 
                                          AS 
              actual_readmission_rate_heart_attack, 
              Cast(Round((( ( num_readmissions_heart_failure * 100000 ) / 
                                 num_discharges_heart_failure )), 7) AS DECIMAL( 
                   10, 5)) 
              / 1000 
                                          AS 
              actual_readmission_rate_heart_failure, 
              Cast(Round((( ( num_readmissions_copd * 100000 ) / 
                            num_discharges_copd )) 
                   , 7) AS 
                   DECIMAL(10, 5)) / 1000 AS actual_readmission_rate_COPD, 
              Cast(Round((( ( num_readmissions_hip_knee_replace * 100000 ) / 
                                       num_discharges_hip_knee_replace )), 7) AS 
                   DECIMAL(10, 5)) / 1000 AS 
              actual_readmission_rate_hip_knee_replace, 
              Cast(Round((( ( num_readmissions_coronary_artery_bypass * 100000 ) 
                            / 
                                        num_discharges_coronary_artery_bypass )) 
                   , 7) AS 
                   DECIMAL(10, 5)) / 1000 AS 
              actual_readmission_rate_coronary_artery_bypass 
        FROM   (SELECT a.provider_id, 
                       a.hospital_name, 
                       a.location_city, 
                       a.state, 
                       a.zip_code, 
                       Max(CASE 
                             WHEN a.hcahps_question = 
                                  'Nurse communication - linear mean score' 
                           THEN 
                             hcahps_linear_mean_value 
                           END)                           AS 
                               "Nurse communication - linear mean score", 
                       Max(CASE 
                             WHEN a.hcahps_question = 
                                  'Quietness - linear mean score' 
                           THEN 
                             hcahps_linear_mean_value 
                           END)                           AS 
                       "Quietness - linear mean score", 
                       Max(CASE 
                             WHEN a.hcahps_question = 
                                  'Cleanliness - linear mean score' 
                           THEN 
                             hcahps_linear_mean_value 
                           END)                           AS 
                       "Cleanliness - linear mean score", 
                       Max(CASE 
                             WHEN a.hcahps_question = 
                                  'Care transition - linear mean score' 
                           THEN 
                             hcahps_linear_mean_value 
                           END)                           AS 
                               "Care transition - linear mean score", 
       Max(CASE 
             WHEN a.hcahps_question = 
                  'Communication about medicines - linear mean score' 
           THEN hcahps_linear_mean_value 
           END)                           AS 
               "Communication about medicines - linear mean score", 
       Max(CASE 
             WHEN a.hcahps_question = 
                  'Doctor communication - linear mean score' THEN 
             hcahps_linear_mean_value 
           END)                           AS 
               "Doctor communication - linear mean score", 
       Max(CASE 
             WHEN a.hcahps_question = 
                  'Discharge information - linear mean score' THEN 
             hcahps_linear_mean_value 
           END)                           AS 
               "Discharge information - linear mean score", 
       Max(a.number_of_completed_surveys) AS 
       number_of_completed_surveys 
       --Heart Attack 
       , 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%AMI%' 
                    AND number_of_discharges <> 'Not Available' ) THEN 
             Cast( 
             number_of_discharges AS INT) 
           END)                           AS 
       num_discharges_heart_attack, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%AMI%' 
                    AND number_of_readmissions <> 'Not Available' ) 
           THEN Cast( 
             number_of_readmissions AS INT) 
           END)                           AS 
       num_readmissions_heart_attack, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%AMI%' 
                    AND predicted_readmission_rate <> 'Not Available' ) 
           THEN 
             Cast( 
             predicted_readmission_rate AS FLOAT) 
           END)                           AS 
               predicted_readmission_rate_heart_attack 
       -- heart failure 
       , 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%HF%' 
                    AND number_of_discharges <> 'Not Available' ) THEN 
             Cast( 
             number_of_discharges AS INT) 
           END)                           AS 
       num_discharges_heart_failure, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%HF%' 
                    AND number_of_readmissions <> 'Not Available' ) 
           THEN Cast( 
             number_of_readmissions AS INT) 
           END)                           AS 
       num_readmissions_heart_failure, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%HF%' 
                    AND predicted_readmission_rate <> 'Not Available' ) 
           THEN 
             Cast( 
             predicted_readmission_rate AS FLOAT) 
           END)                           AS 
               predicted_readmission_rate_heart_failure 
       -- pneumonia, obstructive chronic pulmonary disease 
       , 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%COPD%' 
                    AND number_of_discharges <> 'Not Available' ) THEN 
             Cast( 
             number_of_discharges AS INT) 
           END)                           AS num_discharges_COPD, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%COPD%' 
                    AND number_of_readmissions <> 'Not Available' ) 
           THEN Cast( 
             number_of_readmissions AS INT) 
           END)                           AS num_readmissions_COPD, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%COPD%' 
                    AND predicted_readmission_rate <> 'Not Available' ) 
           THEN 
             Cast( 
             predicted_readmission_rate AS FLOAT) 
           END)                           AS 
       predicted_readmission_rate_COPD 
       -- hip/knee replacement 
       , 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%HIP_KNEE%' 
                    AND number_of_discharges <> 'Not Available' ) THEN 
             Cast( 
             number_of_discharges AS INT) 
           END)                           AS 
       num_discharges_hip_knee_replace, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%HIP_KNEE%' 
                    AND number_of_readmissions <> 'Not Available' ) 
           THEN Cast( 
             number_of_readmissions AS INT) 
           END)                           AS 
       num_readmissions_hip_knee_replace, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%HIP_KNEE%' 
                    AND predicted_readmission_rate <> 'Not Available' ) 
           THEN 
             Cast( 
             predicted_readmission_rate AS FLOAT) 
           END)                           AS 
               predicted_readmission_rate_hip_knee_replace 
       -- coronary artery bypass graft surgery 
       , 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%CABG%' 
                    AND number_of_discharges <> 'Not Available' ) THEN 
             Cast( 
             number_of_discharges AS INT) 
           END)                           AS 
               num_discharges_coronary_artery_bypass, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%CABG%' 
                    AND number_of_readmissions <> 'Not Available' ) 
           THEN Cast( 
             number_of_readmissions AS INT) 
           END)                           AS 
               num_readmissions_coronary_artery_bypass, 
       Max(CASE 
             WHEN ( b.measure_name LIKE '%CABG%' 
                    AND predicted_readmission_rate <> 'Not Available' ) 
           THEN 
             Cast( 
             predicted_readmission_rate AS FLOAT) 
           END)                           AS 
               predicted_readmission_rate_coronary_artery_bypass 
                FROM   hcahps_linear_survey_summary_data_07192019 AS a 
                       LEFT JOIN hrrp_summary_data_07302019 AS b 
                              ON Cast(a.provider_id AS NVARCHAR) = Cast( 
                                 b.provider_id AS NVARCHAR) 
                GROUP  BY a.provider_id, 
                          a.hospital_name, 
                          a.location_city, 
                          a.state, 
                          a.zip_code) a) b
;
