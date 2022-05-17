CREATE TABLE pseof (
	agg_level_pseo INT NOT null, 
	inst_level TEXT, 
	institution INT, 
	degree_level INT, 
	cip_level TEXT, 
	cipcode INT, 
	grad_cohort INT, 
	grad_cohort_years INT, 
	geo_level TEXT, 
	geography INT, 
	ind_level TEXT, 
	industry INT, 
	y1_grads_emp INT, 
	y1_grads_emp_instate INT, 
	y5_grads_emp INT, 
	y5_grads_emp_instate INT, 
	y10_grads_emp INT, 
	y10_grads_emp_instate INT, 
	y1_grads_nme INT, 
	y5_grads_nme INT, 
	y10_grads_nme INT, 
	status_y1_grads_emp INT, 
	status_y1_grads_emp_instate INT, 
	status_y5_grads_emp INT, 
	status_y5_grads_emp_instate INT, 
	status_y10_grads_emp INT, 
	status_y10_grads_emp_instate INT, 
	status_y1_grads_nme INT, 
	status_y5_grads_nme INT, 
	status_y10_grads_nme INT
);

CREATE TABLE pseoe (
	agg_level_pseo INT, 
	inst_level TEXT, 
	institution INT, 
	degree_level INT, 
	cip_level TEXT, 
	cipcode INT, 
	grad_cohort INT, 
	grad_cohort_years INT, 
	geo_level TEXT, 
	geography INT, 
	ind_level TEXT, 
	industry INT, 
	y1_p25_earnings INT, 
	y1_p50_earnings INT, 
	y1_p75_earnings INT, 
	y1_grads_earn INT, 
	y5_p25_earnings INT, 
	y5_p50_earnings INT, 
	y5_p75_earnings INT, 
	y5_grads_earn INT, 
	y10_p25_earnings INT, 
	y10_p50_earnings INT, 
	y10_p75_earnings INT, 
	y10_grads_earn INT, 
	y1_ipeds_count INT, 
	y5_ipeds_count INT, 
	y10_ipeds_count INT, 
	status_y1_earnings INT, 
	status_y1_grads_earn INT, 
	status_y5_earnings INT, 
	status_y5_grads_earn INT, 
	status_y10_earnings INT, 
	status_y10_grads_earn INT, 
	status_y1_ipeds_count INT, 
	status_y5_ipeds_count INT, 
	status_y10_ipeds_count INT
);

-- Check both tables imported correctly
SELECT * FROM pseof;
SELECT * FROM pseoe;

-- Drop the table if it already exists
DROP TABLE IF EXISTS pseo_all;
-- All columns to be put into machine learning model are selected
SELECT pe.agg_level_pseo, 
	pe.inst_level, pe.institution, pe.degree_level,
	pe.cip_level, pe.cipcode, pe.grad_cohort, pe.grad_cohort_years,
	pe.geo_level, pe.geography, pe.ind_level, pe.industry,
	pe.y1_p50_earnings, pe.y5_p50_earnings, pe.y1_ipeds_count,
	pe.y5_ipeds_count, pe.status_y1_earnings, pe.status_y5_earnings,
	pf.y1_grads_emp, pf.y1_grads_emp_instate, pf.y5_grads_emp,
	pf.y5_grads_emp_instate, pf.status_y1_grads_emp,
	pf.status_y1_grads_emp_instate, pf.status_y5_grads_emp,
	pf.status_y5_grads_emp_instate
-- Joining pseoe and pseof tables
INTO pseo_all
FROM pseoe as pe
    LEFT JOIN pseof as pf
     ON pe.agg_level_pseo = pf.agg_level_pseo
     AND pe.institution = pf.institution
	 AND pe.degree_level = pf.degree_level
	 AND pe.grad_cohort_years = pf.grad_cohort_years
	 AND pe.cipcode = pf.cipcode
ORDER BY pe.agg_level_pseo, pe.institution;

-- Check all tables are correct
SELECT * FROM pseoe;
SELECT * FROM pseof;
SELECT * FROM pseo_all;
-- Check how many rows are in the new pseo_all table
SELECT COUNT(agg_level_pseo) FROM pseo_all;