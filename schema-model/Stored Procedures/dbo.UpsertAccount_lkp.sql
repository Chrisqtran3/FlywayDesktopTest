SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

/*
-- Created By: Rajesh RJ Mangipudi
-- Created On: 05/05/2016
-- Description: This stored procedure upserts account_lkp. 
		Please follow steps in this document: https://docs.google.com/document/d/1h6XBNuV36vx-c5PJ0TAHE4_kylbtWvFhEaIi9AKNSVc/edit
*/

CREATE procedure [dbo].[UpsertAccount_lkp]
as
	begin tran

	update dest
	set 
		dest.account_code	=	src.account_code	,
		dest.account_description	=	src.account_description	,
		dest.account_description2	=	src.account_description2	,
		dest.account_type	=	src.account_type	,
		dest.company	=	src.company	,
		dest.bank	=	src.bank	,
		dest.branch	=	src.branch	,
		dest.branch_description	=	src.branch_description	,
		dest.currency	=	src.currency	,
		dest.country	=	src.country	,
		dest.IBANKey	=	src.IBANKey	,
		dest.BAN	=	src.BAN	,
		dest.statement_identifier	=	src.statement_identifier	,
		dest.signatories	=	src.signatories	,
		dest.Document	=	src.Document	,
		dest.ZBA_identifier	=	src.ZBA_identifier	,
		dest.GL_account_code	=	src.GL_account_code	,
		dest.internal_account_code	=	src.internal_account_code	,
		dest.calendar	=	src.calendar	,
		dest.closed_account	=	src.closed_account	,
		dest.closing_date	=	src.closing_date	,
		dest.status	=	src.status	,
		dest.default_group	=	src.default_group	,
		dest.account_category1	=	src.account_category1	,
		dest.account_category2	=	src.account_category2	,
		dest.account_category3	=	src.account_category3	,
		dest.account_category4	=	src.account_category4	,
		dest.account_category5	=	src.account_category5
	from account_lkp dest
	inner join Loadaccount_lkp as src on dest.account_code = src.account_code

	if @@error <> 0 
	begin
		rollback
		raiserror('Updating account_lkp failed',16,1)
		return -1

	end

	insert into account_lkp 
	(account_code, account_description, account_description2, account_type, company, bank, branch, branch_description, 
	currency, country, IBANKey, BAN, statement_identifier, signatories, Document, ZBA_identifier, GL_account_code, internal_account_code, calendar, 
	closed_account, closing_date, status, default_group, account_category1, account_category2, account_category3, account_category4, account_category5 )
	select account_code, account_description, account_description2, account_type, company, bank, branch, branch_description, 
	currency, country, IBANKey, BAN, statement_identifier, signatories, Document, ZBA_identifier, GL_account_code, internal_account_code, calendar, 
	closed_account, closing_date, status, default_group, account_category1, account_category2, account_category3, account_category4, account_category5
	from Loadaccount_lkp
	where account_code not in (select account_code from account_lkp)

	if @@error <> 0 
	begin
		rollback
		raiserror('Insert into account_lkp failed',16,1)
		return -1
	end
	else 
	begin 
		print 'Transaction complete.'
		commit
	end
GO
