select * from claims where claimnumber = '0000112'

select * from claimpolicy where claimpolicykey = 18098

select * from location_premium_allocation where sub_record_no = 545180

select * from location_premium_allocation

select distinct sub_record_no from location_premium_allocation


select clms.claimkey, count(lpa.sub_record_no)
from location_premium_allocation lpa
 join claimpolicy cp on cp.subrecordnumber = lpa.sub_record_no
 left outer join claims clms on clms.claimpolicykey = cp.claimpolicykey
where (clms.localc_record_no is null or clms.localc_record_no = 0)
--and clms.ClaimStatus != 'C'
group by clms.claimkey
having count(lpa.sub_record_no) > 1



select ch.claimkey, ch.StatutoryState
from ClaimHistory ch
 join (
	select clms.claimkey as claimkey, count(lpa.sub_record_no) as policylocations
	from location_premium_allocation lpa
	 join claimpolicy cp on cp.subrecordnumber = lpa.sub_record_no
	 left outer join claims clms on clms.claimpolicykey = cp.claimpolicykey
	where (clms.localc_record_no is null or clms.localc_record_no = 0)
	--and clms.ClaimStatus != 'C'
	group by clms.claimkey
	having count(lpa.sub_record_no) > 1
      ) claimlocs on ch.ClaimKey = claimlocs.claimkey
 join claims clms on clms.claimkey = ch.claimkey
 join claimpolicy cp on cp.claimpolicykey = clms.claimpolicykey
where ch.statutorystate not in ( select state_abbreviation 
				 from location_premium_allocation lpa2
				 where lpa2.sub_record_no = cp.subrecordnumber
				)
--and cp.Department != 200
order by ch.claimkey


select ch.claimkey, ch.StatutoryState, ch.DateReported, lpa.state_abbreviation
from ClaimHistory ch
 join claims clms on clms.claimkey = ch.claimkey
 join claimpolicy cp on cp.claimpolicykey = clms.claimpolicykey
 join Insurance_Companies ic on ic.Company_Record_Number = cp.Company_Record_Number
 join location_premium_allocation lpa on lpa.sub_record_no = cp.subrecordnumber
where ch.statutorystate not in ( select state_abbreviation 
				 from location_premium_allocation lpa2
				 where lpa2.sub_record_no = cp.subrecordnumber
				)
and (clms.localc_record_no is null or (clms.localc_record_no is not null and clms.localc_record_no = 0))
--and cp.Department = 200
and ch.iscurrent = 1
 and ic.org_number = 2
order by ch.claimkey, ch.DateReported

select *
from ClaimHistory
where ch.DateReported, claimkey = 52

select *
from ClaimHistory
where ClaimKey = 47751


select lpa.*
from location_premium_allocation lpa
 join claimpolicy cp on cp.subrecordnumber = lpa.sub_record_no
 left outer join claims clms on clms.claimpolicykey = cp.claimpolicykey
where clms.claimkey = 44641



select cs.ClaimKey as ClaimKey, 
        cs.ClaimSuffixKey as ClaimSuffixKey, 
  cs.ClaimTypeKey as ClaimTypeKey,
 case
           when cp.Department = 200 then isnull(lpa.state_abbreviation, isnull(c.AccidentState,cp.insuredstate))
           else isnull(c.AccidentState,cp.insuredstate)
        end as StatutoryState,
 isnull(cs.DateReported,c.DateOfLoss) as DateReported,
 c.DateOfLoss as DateOfLoss,
 1 as IsCurrent
from ClaimSuffix cs
 join Claims c on cs.ClaimKey = c.ClaimKey
 join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 left outer join Location_Premium_Allocation lpa on c.localc_record_no = lpa.localc_record_no 
       and cp.subrecordnumber = lpa.sub_record_no
  join Insurance_Companies ic on ic.Company_Record_Number = cp.Company_Record_Number
where cp.Department != 200
order by ch.Claimkey



select * from claims where claimkey = 44203
select * from claimpolicy where claimpolicykey = 15901
select * from location_premium_allocation where sub_record_no = 467736 






select hist.* 
from 
(
select cp.subrecordnumber as policynum, 
 case
   when cp.Department = 200 then isnull(lpa.state_abbreviation, isnull(c.AccidentState,cp.insuredstate))
   else isnull(c.AccidentState,cp.insuredstate)
 end as StatutoryState
from Claims c
 join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 left outer join Location_Premium_Allocation lpa on c.localc_record_no = lpa.localc_record_no 
       and cp.subrecordnumber = lpa.sub_record_no
  join Insurance_Companies ic on ic.Company_Record_Number = cp.Company_Record_Number
) hist
where hist.StatutoryState not in ( select state_abbreviation 
				     from location_premium_allocation lpa2
				     where lpa2.sub_record_no = hist.policynum
		            )
order by hist.policynum




select cp.subrecordnumber as policynum, c.claimkey, lpa.sub_record_no, 
 case
   when cp.Department = 200 then isnull(lpa.state_abbreviation, isnull(c.AccidentState,cp.insuredstate))
   else isnull(c.AccidentState,cp.insuredstate)
 end as StatutoryState
from Claims c
 join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 left outer join Location_Premium_Allocation lpa on c.localc_record_no = lpa.localc_record_no 
       and cp.subrecordnumber = lpa.sub_record_no
  join Insurance_Companies ic on ic.Company_Record_Number = cp.Company_Record_Number

order by policynum

select * from Claims wheer




select ch.claimkey, ch.StatutoryState, lpa.state
from Location_Premium_Allocation lpa 
 join 
(
select  c.ClaimKey as ClaimKey, 
	cp.subrecordnumber as policynum, 
 case
   when cp.Department = 200 then isnull(lpa.state_abbreviation, isnull(c.AccidentState,cp.insuredstate))
   else isnull(c.AccidentState,cp.insuredstate)
 end as StatutoryState
from Claims c
 join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 left outer join Location_Premium_Allocation lpa on c.localc_record_no = lpa.localc_record_no 
       and cp.subrecordnumber = lpa.sub_record_no
  join Insurance_Companies ic on ic.Company_Record_Number = cp.Company_Record_Number
) hist on hist.subrecordnumber on lpa.sub_record_no

select * from claims where ClaimKey = 37809

select * from claimpolicy where claimpolicykey = 13263

select * from location_premium_allocation where sub_record_no = 545180


select cp.subrecordnumber as policynum, c.claimkey, lpa.sub_record_no, 
 case
   when cp.Department = 200 then isnull(lpa.state_abbreviation, isnull(c.AccidentState,cp.insuredstate))
   else isnull(c.AccidentState,cp.insuredstate)
 end as StatutoryState
from Claims c
 join ClaimPolicy cp on cp.ClaimPolicyKey = c.ClaimPolicyKey
 left outer join Location_Premium_Allocation lpa on c.localc_record_no = lpa.localc_record_no 
       and cp.subrecordnumber = lpa.sub_record_no
  join Insurance_Companies ic on ic.Company_Record_Number = cp.Company_Record_Number
