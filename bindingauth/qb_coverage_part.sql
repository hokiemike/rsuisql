

select qb.*
from QUOTE_BINDER qb
join Submission s on s.SUB_RECORD_NUMBER = qb.SUB_RECORD_NUMBER and s.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO
join QB_POLICY_LIMITS qbpl on qbpl.QB_SEQUENCE_NO = qb.QB_SEQUENCE_NO and qb.SUB_RECORD_NUMBER = qbpl.SUB_RECORD_NUMBER
where 1=1
and s.DEPARTMENT_NUMBER = 10006
and qbpl.CoveragePartKey = 4

