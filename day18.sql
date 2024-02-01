--ex03
alter table sales_dataset_rfm_prj
add column lastcontactname text,
add column firstcontactname text;
update sales_dataset_rfm_prj
set lastcontactname = LEFT(contactfullname,position('-' in contactfullname)-1),
