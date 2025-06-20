*Master file MaRBLe thesis 
*Author: Henri Runge
* Date: 01/05/2025

*define stata setting

clear all 
version 18

*Overall directory path
global pp ="C:\Users\greix-hiwi-04\Nextcloud\Henri_real_estate_tax"
global hh ="C:\Users\greix-hiwi-04\Nextcloud\GREIX-Mikro-Daten\research\Abschlussarbeiten\Henri_real_estate_tax\data\raw"

*Additional directory paths
global cc="$pp\code"
global oo="$pp\output"

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

*                           Graphical analysis

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

*----------------------------------Bavaria---------------------------------


run "$cc\Final Codes\Bavaria\Graphical analysis\ntransactions_bavaria_index_etw.do"

run "$cc\Final Codes\Bavaria\Graphical analysis\ntransactions_bavaria_index_etw_rented.do"

run "$cc\Final Codes\Bavaria\Graphical analysis\ntransactions_bavaria_index_etw_wcontrol.do"

run "$cc\Final Codes\Bavaria\Graphical analysis\price_index_bavaria_etw.do"

run "$cc\Final Codes\Bavaria\Graphical analysis\price_index_bavaria_etw_rented.do"

run "$cc\Final Codes\Bavaria\Graphical analysis\price_index_bavaria_etw_wcontrol.do"


*----------------------------------Brandenburg---------------------------------


run "$cc\Final Codes\Brandenburg\ntransactions_brandenburg_index_etw.do"

run "$cc\Final Codes\Brandenburg\ntransactions_brandenburg_index_efh.do"

run "$cc\Final Codes\Brandenburg\ntransactions_brandenburg_index_etw_buyer.do"

run "$cc\Final Codes\Brandenburg\ntransactions_brandenburg_index_efh_buyer.do"

run "$cc\Final Codes\Brandenburg\price_index_brandenburg_etw.do"

run "$cc\Final Codes\Brandenburg\price_index_brandenburg_efh.do"

run "$cc\Final Codes\Brandenburg\price_index_brandenburg_etw_buyer.do"

run "$cc\Final Codes\Brandenburg\price_index_brandenburg_efh_buyer.do"

*----------------------------------Hesse---------------------------------

run "$cc\Final Codes\Hesse\Graphical analysis\ntransactions_hesse_index_etw.do"

run "$cc\Final Codes\Hesse\Graphical analysis\ntransactions_hesse_index_efh.do"

run "$cc\Final Codes\Hesse\Graphical analysis\ntransactions_hesse_index_mfh.do"

run "$cc\Final Codes\Hesse\Graphical analysis\price_index_hesse_efh.do"

run "$cc\Final Codes\Hesse\Graphical analysis\price_index_hesse_etw.do"

run "$cc\Final Codes\Hesse\Graphical analysis\price_index_hesse_mfh.do"

run "$cc\Final Codes\Hesse\Graphical analysis\ntransactions_hesse_index_etw_buyer.do"

run "$cc\Final Codes\Hesse\Graphical analysis\ntransactions_hesse_index_efh_buyer.do"

run "$cc\Final Codes\Hesse\Graphical analysis\ntransactions_hesse_index_mfh_buyer.do"

run "$cc\Final Codes\Hesse\Graphical analysis\price_index_hesse_efh_buyer.do"

run "$cc\Final Codes\Hesse\Graphical analysis\price_index_hesse_etw_buyer.do"

run "$cc\Final Codes\Hesse\Graphical analysis\price_index_hesse_mfh_buyer.do"

run "$cc\Final Codes\Hesse\Graphical analysis\ntransactions_hesse_index_etw_rented.do"

run "$cc\Final Codes\Hesse\Graphical analysis\price_index_hesse_etw_rented.do"


*----------------------------------NRW---------------------------------

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_etw.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_efh.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_mfh.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_efh.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_etw.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_mfh.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_etw_control.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_efh_control.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_mfh_control.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_efh_control.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_etw_control.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_mfh_control.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_etw_buyer.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_efh_buyer.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_mfh_buyer.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_efh_buyer.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_etw_buyer.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_mfh_buyer.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_etw_rented.do"

run "$cc\Final Codes\NRW\Graphical analysis\ntransactions_nrw_index_efh_rented.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_efh_rented.do"

run "$cc\Final Codes\NRW\Graphical analysis\price_index_nrw_etw_rented.do"

*----------------------------------Thuringia---------------------------------

run "$cc\Final Codes\Thuringia\ntransactions_thuringia_index_etw.do"

run "$cc\Final Codes\Thuringia\ntransactions_thuringia_index_efh.do"

run "$cc\Final Codes\Thuringia\ntransactions_thuringia_index_mfh.do"

run "$cc\Final Codes\Thuringia\price_index_thuringia_efh.do"

run "$cc\Final Codes\Thuringia\price_index_thuringia_etw.do"

run "$cc\Final Codes\Thuringia\price_index_thuringia_mfh.do"

run "$cc\Final Codes\Thuringia\price_index_thuringia_efh_buyer.do"

run "$cc\Final Codes\Thuringia\price_index_thuringia_etw_buyer.do"

run "$cc\Final Codes\Thuringia\price_index_thuringia_mfh_buyer.do"

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

*                          	Event studies

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 


*----------------------------------Bavaria---------------------------------


run "$cc\Final Codes\Bavaria\Event Study\event_study_bavaria_intro.do"

run "$cc\Final Codes\Bavaria\Event Study\event_study_bavaria_outro.do"

run "$cc\Final Codes\Bavaria\Event Study\event_study_bavaria_transactions.do"


*----------------------------------Hesse---------------------------------

run "$cc\Final Codes\Hesse\Event Study\event_study_hesse_efh.do"

run "$cc\Final Codes\Hesse\Event Study\event_study_hesse_efh_transactions.do"

run "$cc\Final Codes\Hesse\Event Study\event_study_hesse_mfh.do"

run "$cc\Final Codes\Hesse\Event Study\event_study_hesse_mfh_transactions.do"

run "$cc\Final Codes\Hesse\Event Study\event_study_hesse_buyer_type.do"

run "$cc\Final Codes\Hesse\Event Study\event_study_hesse_rentstatus.do"

*----------------------------------NRW---------------------------------

run "$cc\Final Codes\NRW\Event Study Individual Transactions\event_study_nrw_efh.do"

run "$cc\Final Codes\NRW\Event Study Individual Transactions\event_study_nrw_efh_transactions.do"

run "$cc\Final Codes\NRW\Event Study Individual Transactions\event_study_nrw_mfh.do"

run "$cc\Final Codes\NRW\Event Study Individual Transactions\event_study_nrw_mfh_transactions.do"

run "$cc\Final Codes\NRW\Event Study Individual Transactions\event_study_nrw_etw.do"

run "$cc\Final Codes\NRW\Event Study Individual Transactions\event_study_nrw_etw_transactions.do"


* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

*                          	Synthetic Control Method

* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

*----------------------------------Bavaria---------------------------------

run "$cc\Final Codes\Bavaria\SCM\SCM_bavaria.do"

run "$cc\Final Codes\Bavaria\SCM\SCM_bavaria_inference.do"

run "$cc\Final Codes\Bavaria\SCM\SCM_bavaria_transactions.do"

run "$cc\Final Codes\Bavaria\SCM\SCM_bavaria_transactions_inference.do"

*----------------------------------Hesse---------------------------------

run "$cc\Final Codes\Hesse\SCM\SCM_hesse_efh.do"

run "$cc\Final Codes\Hesse\SCM\SCM_hesse_mfh.do"


*----------------------------------NRW---------------------------------

run "$cc\Final Codes\NRW\SCM\SCM_nrw_efh.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_efh_inference.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_efh_transactions.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_efh_transactions_inference.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_mfh.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_mfh_inference.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_mfh_transactions.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_mfh_transactions_inference.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_etw.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_etw_inference.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_etw_transactions.do"

run "$cc\Final Codes\NRW\SCM\SCM_nrw_etw_transactions_inference.do"
