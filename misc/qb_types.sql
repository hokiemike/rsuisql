select qb.QB_TYPE, qb.QB_CREATION_DATE
from QUOTE_BINDER qb
join Submission s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
where 1=1
and s.DEPARTMENT_NUMBER = 1900
and qb.QB_CREATION_DATE > '11/1/2007'
order by qb.QB_CREATION_DATE


select qb.QB_TYPE, qb.QB_CREATION_DATE
from QUOTE_BINDER qb
join Submission s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER
where 1=1
and s.DEPARTMENT_NUMBER = 1900
and qb.QB_CREATION_DATE > '11/1/2007'
and qb_type like '%Combo%'
and s.PRIOR_SUB_RECORD_NUMBER is null
order by qb.QB_CREATION_DATE



CREATE UNIQUE INDEX [rbd_unique_doc_state_admitted]
    ON [dbo].[RuleBasedDocStateApproval]([DocId], [STATE_ABBREVIATION], [Admitted])
GO

select * from ProfLiabBusinessType

select * from QuoteBinderPro   

select * from REFERENCE_TYPE