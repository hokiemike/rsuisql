SELECT *
FROM RuleBasedDoc rbd join RuleBasedDocStateApproval rbdsa on rbd.DocId = rbdsa.DocId 
 join RuleBasedDocSubTypeXref rbdstx on rbd.DocId = rbdstx.DocId
where rbd.DocTypeId = 163
    and rbdsa.EffectiveDate <= '3/3/08'
    and (rbdsa.ExpirationDate >= '3/3/08' or rbdsa.ExpirationDate is null)
    and rbd.Department_Number =1900
    and rbdsa.State_Abbreviation = 'GA'
    and rbdstx.SubTypeId = 1904
    and rbd.OrgNumber = 2
    and rbdsa.Admitted = 0