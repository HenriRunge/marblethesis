The code for the summary statistics table is contained in the summary_statistics_overall do-file.
The preparing_data file has all the modifications to the data in it that were done after the panel dataset had been created.
The master file can be disregarded as you cannot run the code anyways.
The did files run the dynamic diff-in-diff regression as follows:
For Bavaria the _intro file runs equation (1) including all levels of clustering. _rented runs equation (2) with rented_city and rented_state clustering at city- and state-level. Equation (4) is run by _transactions.
For NRW the _efh file runs equation (1) for all market segments using district-level clustering. _city_cluster and _state_cluster run equation (1) with the different types of clustering. _rented runs equation (2) and _rented_city as well as _rented_state test for clustering. 
For Hesse the _prices file runs equation (1) with _prices_state and _prices_city testing for clustering. Equation (2) is run by _rentstatus and equation (3) by _buyer_type. Equation (4) is run by _transactions where _transactions_city and _transactions_state test for clustering.

The n_transactions and price files run the graphical analysis and should be self-explanatory
