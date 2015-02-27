 
 
select  
   lossheader.LossHeaderKey, lossdetail.LossDetailKey, 
    lossheader.InsuranceCompanySKey, lossheader.Org_Number, 
    lossheader.AssociatedCompanySKey, lossheader.RecordType, 
    lossheader.ProofNoticeKey, lossheader.ClaimKey, 
    lossheader.ClaimSuffixKey, lossdetail.IndemnityPaid, 
    lossdetail.ExpensePaid, lossdetail.ExpensePaidULAE, 
    lossdetail.ExpensePaidALAE, lossdetail.IndemnityReserve, 
    lossdetail.ExpenseReserve, lossdetail.ExpenseReserveULAE, 
    lossdetail.ExpenseReserveALAE, lossdetail.IndemnityReserveChange, 
    lossdetail.ExpenseReserveChange, lossdetail.ExpenseReserveULAEChange, 
    lossdetail.ExpenseReserveALAEChange, lossheader.Layer_Level_Skey, 
    lossheader.Mkt_Level_Skey, lossheader.Treaty_Mkt_Level_Skey, 
    lossheader.Treaty_Reins_Level_Skey, lossheader.Reins_Level_Skey, 
    lossdetail.DateCreated, lossdetail.GLDate, 
    lossdetail.GLMonth, lossdetail.GLYear,
    lossdetail.GLQtr, policyhistory.PolicyHistoryKey, 
    policyhistory.SUB_RECORD_NUMBER, policyhistory.IsDefault, 
    policyhistory.OccurOrClaimsMade, policyhistory.IsCurrent, 
    policyhistory.IsPackage, policyhistory.ExcessBusinessType, 
    policyhistory.QB_Type, policyhistory.Department_Number, 
    policyhistory.SIC_SKEY, proofnotice.PaymentKey, 
    proofnotice.ReserveKey, proofnotice.PNNumber, 
    lossdetail.ISOCreateDate, lossdetail.StatutoryState, 
    lossdetail.StatutoryLOB, lossdetail.ClaimHistoryKey 
 
    from lossheader 
 
    left outer join 
    ( 
    select lossheader.ClaimSuffixKey as claimsuffixkey, 
    max(lossheader.LossHeaderKey) as maxheaderkey, 
    sum(lossheader.IndemnityReserveChange) as IndReserve, 
    sum(lossheader.ExpenseReserveChange) as ExpReserve 
    from LossHeader where 1=1 and LossHeader.RecordType = 1 and LossHeader.GLDate <= '12/31/2004 23:59:59' 
    group by lossheader.ClaimSuffixKey 
    having (sum(lossheader.IndemnityReserveChange) + sum(lossheader.ExpenseReserveChange)) <> 0 
    ) xref_headers on xref_headers.maxheaderkey = lossheader.lossheaderkey 
 
    join LossDetail on lossheader.LossHeaderKey = LossDetail.LossHeaderKey 
    join policyhistory on policyhistory.policyhistorykey = LossDetail.policyhistorykey 
    join claimhistory on claimhistory.claimhistorykey = LossDetail.claimhistorykey 
    join claimsuffix on claimsuffix.claimsuffixkey = claimhistory.claimsuffixkey 
    join claims on claims.claimkey = claimsuffix.claimkey 
    join claimpolicy on claimpolicy.claimpolicykey = claims.claimpolicykey 
    join insurance_companies on insurance_companies.company_skey = lossheader.insurancecompanyskey 
    join proofnotice on lossheader.proofnoticekey = proofnotice.proofnoticekey 
 
    where lossheader.recordtype = 1  
    and (
         (lossheader.GLQtr = 4 and lossheader.GLYear = 2004 
          and (lossheader.IndemnityPaid <> 0 or lossheader.ExpensePaid <> 0)) 
         or (xref_headers.maxheaderkey = lossheader.lossheaderkey)
        )
    and LossDetail.LossDetailKey = 
         ( select max(lossDetailKey) 
    		from LossDetail ldi where lossheader.LossHeaderKey = ldi.LossHeaderKey
                  and LossDetail.GLDate <= '12/31/2004 23:59:59'  ) 
    and insurance_companies.org_number = 2 
    and admitted = 'Y' 
    and policyhistory.IsDefault = 0 
    And lossdetail.StatutoryState != 'TX' 
    and lossdetail.isocreatedate is null 
    or  ( lossheader.recordtype = 1  
    and ( 
          (lossheader.GLQtr = 4 and lossheader.GLYear = 2004 
           and (lossheader.IndemnityPaid <> 0 or lossheader.ExpensePaid <> 0)) 
         or (xref_headers.maxheaderkey = lossheader.lossheaderkey)
        )
    and LossDetail.LossDetailKey = 
         ( select max(lossDetailKey) 
            from LossDetail ldi where lossheader.LossHeaderKey = ldi.LossHeaderKey 
             and LossDetail.GLDate <= '12/31/2004 23:59:59'  
         ) 
   and insurance_companies.org_number = 2 
   And lossheader.InsuranceCompanySKey = 693 
   and policyhistory.IsDefault = 0 
    And lossdetail.StatutoryState = 'OK' and lossdetail.isocreatedate = null )
 order by lossdetail.statutorylob, 
          lossheader.claimkey, 
           lossheader.claimsuffixkey, proofnotice.pnnumber 