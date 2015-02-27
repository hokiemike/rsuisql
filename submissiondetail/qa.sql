select * from GenInfo where sub_record_no = 1003607

select * from GenInfo where sub_record_no = 1025049

select * from Submission where sub_record_number = 1025049

select a.* from Address a 
left outer join Submission s on a.AddressKey = s.DecInsuredAddressKey
where s.sub_Record_number = 1025049
