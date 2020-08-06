## Guide to inspecting robustness checks via log files

1. Alternative Measures I: Lagged academic proficiency rates (2013-14 and 2015-16 instead of 2014-15):
</br> `logs/robust_laggedscores_mi5_linear_101019.smcl`

2. Alternative Measures II: Narrow dictionaries of IBL rather than 50-term full dictionary: seed (5 terms), narrow (20 terms), and full w/o “hands-on” term (49 terms)
</br> `logs/robustness_check_dictionary_size.pdf`

3. Alternative Measures III: Race/class differentials between district and school
</br> `logs/robustness_check_district_differentials.pdf`

4. Fully nested mixed-effects linear models (100 imputations) 
-	pt. 1: Race & poverty -> IBL
</br> `logs/robustness_check_fully_nested_models_1.pdf`
- pt. 2: IBL, academic proficiency -> Poverty
</br> `logs/robustness_check_fully_nested_models_2.pdf`
- pt. 3: IBL, academic proficiency -> Race
</br> `logs/robustness_check_fully_nested_models_3.pdf`

5. Filter Dataset: Restrict sample to only those schools with:
- precise academic data: readlevel14 & mathlevel14 == 1
</br> `logs/robustness_check_precise_scores.pdf`
- above-average district poverty
 </br> `logs/robustness_check_high_poverty_districts.pdf`
- above-average district POC
 </br> `logs/robustness_check_high_POC_districts.pdf`
- above-average district population density
</br> `logs/robustness_check_high_density_districts.pdf`
- inquiry_full_count < 10000
</br> `logs/robustness_check_ibl_outliers.pdf`
- numpages < 100
</br> `logs/robustness_check_large_websites.pdf`
- students > 10
</br> `logs/robustness_check_small_schools.pdf`
