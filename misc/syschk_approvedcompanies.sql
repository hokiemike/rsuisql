SET QUOTED_IDENTIFIER ON 
GO
SET ANSI_NULLS ON 
GO




ALTER  procedure syschk_PoliciesCodedToUnapprovedStates
--drop procedure syschk_PoliciesCodedToUnapprovedStates
--exec           syschk_PoliciesCodedToUnapprovedStates 1

@CheckerMode         tinyint  



as 

set nocount on

-- ------------------------------------------------------------------------------------------------------------------------------------



-- ------------------------------------------------------------------------------------------------------------------------------------
begin



if @CheckerMode = 0
	BEGIN
		select distinct b.sub_current_effective_date, e.effectivedate, e.expirationdate,
		acp.effectivedate as programeffective, acp.expirationdate as programexp,
		b.sub_policy_number, b.department_number, a.sub_record_no, d.company_name, a.state_abbreviation
		from location_premium_allocation a
		join submission b on a.sub_record_no = b.sub_record_number
		join insurance_companies d on d.company_record_number = b.company_record_number
		join approvedcompany e on e.company_record_number = b.company_record_number and e.state_abbreviation = a.state_abbreviation and b.department_number = e.department_number
		left outer join approvedcompanyprogram acp on acp.ApprovedCompanyKey = e.ApprovedCompanyKey
		where 1=1
		and d.org_number = 2
		and b.sub_policy_number not in
		(22285,
		331488,
		408287,
		408138,
		22674,
		22558,
		24171,
		614747,
		23949,
		24071,
		615025,
		66211)
		and 
		--
		-- find policies that either:
		--	a) have a program and the current_effective is outside the dates of the approvedcompanyprogram dates
		--       or
		--      b) do not have a program and the current_effective is outside the dates of the approvedcompany dates
		--
		 ( 
			--
			-- a) have a program and the current_effective is outside the dates of the approvedcompanyprogram dates
			--
		        (
			   
			   ( acp.Type_Skey in ( select qa.type_skey 
		                from submissionattribute sa
				join qualifiedattribute qa on sa.attributeid = qa.attributeid
				and sa.sub_record_number = b.sub_record_number ) )               
			     and ( isnull(acp.effectivedate,'2099-01-01') > b.sub_current_effective_date
		             and isnull(acp.expirationdate,'1900-01-01') < b.sub_current_effective_date )
			)
		 	or
		        --
			-- b) do not have a program and the current_effective is outside the dates of the approvedcompany dates
			--
		 	(
		 	  isnull(acp.Type_Skey,0) = 0 
		 	    and ( isnull(e.effectivedate,'2099-01-01') > b.sub_current_effective_date
		                  and isnull(e.expirationdate,'1900-01-01') < b.sub_current_effective_date )		 
		 	)
)
		order by 1
	END
else
	BEGIN
		select count(*)
		from location_premium_allocation a
		join submission b on a.sub_record_no = b.sub_record_number
		join insurance_companies d on d.company_record_number = b.company_record_number
		join approvedcompany e on e.company_record_number = b.company_record_number and e.state_abbreviation = a.state_abbreviation and b.department_number = e.department_number
		left outer join approvedcompanyprogram acp on acp.ApprovedCompanyKey = e.ApprovedCompanyKey
		where 1=1
		and d.org_number = 2
		and b.sub_policy_number not in
		(22285,
		331488,
		408287,
		408138,
		22674,
		22558,
		24171,
		614747,
		23949,
		24071,
		615025,
		66211)
		--
		-- find policies that either:
		--	a) have a program and the current_effective is outside the dates of the approvedcompanyprogram dates
		--       or
		--      b) do not have a program and the current_effective is outside the dates of the approvedcompany dates
		--
		 ( 
			--
			-- a) have a program and the current_effective is outside the dates of the approvedcompanyprogram dates
			--
		        (
			   
			   ( acp.Type_Skey in ( select qa.type_skey 
		                from submissionattribute sa
				join qualifiedattribute qa on sa.attributeid = qa.attributeid
				and sa.sub_record_number = b.sub_record_number ) )               
			     and ( isnull(acp.effectivedate,'2099-01-01') > b.sub_current_effective_date
		             and isnull(acp.expirationdate,'1900-01-01') < b.sub_current_effective_date )
			)
		 	or
		        --
			-- b) do not have a program and the current_effective is outside the dates of the approvedcompany dates
			--
		 	(
		 	  isnull(acp.Type_Skey,0) = 0 
		 	    and ( isnull(e.effectivedate,'2099-01-01') > b.sub_current_effective_date
		                  and isnull(e.expirationdate,'1900-01-01') < b.sub_current_effective_date )		 
		 	)
		)
		order by 1

	END






--RAISEERROR('test error', 16, 1)





end

-- ----------------------------------------------------------------------------------------------------------------------
-- Version History
-- ---------------   
-- Date          Developer       Comment(s)
-- ----------    --------------  ----------------------------------------------------------------------------------------
-- 09/25/2004    treyk           Original.
-- 10/26/2005    mikes           Added logic for new ApprovedCompanyProgram table




GO
SET QUOTED_IDENTIFIER OFF 
GO
SET ANSI_NULLS ON 
GO

