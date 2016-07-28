/*
��������� ��� 
5_��������_�����_�������� (���: ����� ��-� - ��)
��������� �.�. 06.06.2016
/**/

execute block as
declare variable TEMP_KEY integer; --���� ��������� �������
declare variable ID_NUMBER integer; --����������� ID �������
declare variable id_doc tinteger;
declare variable ins_pay tmoney;
declare variable ID_PAYMENT_PART TINTEGER;  --ID �������-����� ��� ������
declare variable ID_OPERATION TINTEGER;     --�� ��������
declare variable ID_PAYMENT_WOG TINTEGER;   --ID ������� ��� ������
declare variable fact_sum_wog TNUMERIC16_2; --������ ����� ������� ���
declare variable CF_DATE_WOG TDATE;         --���� ������� ���
declare variable id_doc_wog tinteger;       --ID ���������� �������� ���
declare variable id_customer_wog tinteger;  --ID ����������� ���
declare variable sum_operation tmoney;      --������ ����� ��������
declare variable DATE_OPERATION TDATE;      --���� ��������
declare variable DESCRIPTION TVARCHAR400;   --��������
declare variable ID_OFFSET_DEAL tinteger;
declare variable id_customer tinteger;

begin

���� ������ ������� �� 500 ��������� � ����� ��������. ���� ���������, ������ 500, ����� ��������� ��������� ���. �������� 1020 ��������� - 3 ������� (500+500+20=1020)

--���������
TEMP_KEY       = 4240;         --���� ��������� �������
ID_PAYMENT_WOG = XXXXXXX;      --ID ������� ��� ������
DATE_OPERATION = 'XX.XX.201X'; --��������� ���� ������� ���������
--�� �����������. ���� NULL, �� �������������. 
--DESCRIPTION    = --'�������� ���������� ������� ��� ������ �� 30.06.2016 �. � �������������� ���������� ��������� ����������� (���������)';
 
--��������� ID ���������� �������� � ID ����������� ��� �� �������.
select pa.id_customer, pa.id_doc, cf.cf_date, pa.fact_sum from f_dt_payments pa
join f_dt_cash_flow cf on cf.id_cash_flow = pa.id_cash_flow
where pa.id_payment = :ID_PAYMENT_WOG
into :id_customer_wog, :id_doc_wog, :CF_DATE_WOG, :fact_sum_wog;

--��������� ����� ����� �������� �� ��������� �������
select sum(T.CURR_FIELD1) from 
(select
TT.CURR_FIELD1
from T_TEMP_TABLE TT
where TT.INT_FIELD1 = :TEMP_KEY
and TT.INT_FIELD6 is null
order by TT.INT_FIELD2 --������������ ���������� �� "�������" ��� � � ������� �� ������� (������ 79)
rows 1 to 500 --����� ������ 500
) t
into :sum_operation;

if (:sum_operation is not null) then begin

	--�������� ��������
	if (:DESCRIPTION is null) then begin
	  --DESCRIPTION = '�������� ����� ������� ��� "��� ������" (ID='||:ID_PAYMENT_WOG||' �� '||:CF_DATE_WOG||' �� ���. ����� '||:fact_sum_wog||' ���.) � ����� '||:sum_operation||' ���. � ��������������� ��������� �����������';
	  DESCRIPTION = '�������� ���������� ������� ��� ������ �� '||:CF_DATE_WOG||' �. � �������������� ���������� ��������� ����������� (���������)';
	end

	ID_OPERATION = gen_id(GEN_F_DT_OPERATIONS, 1);
	 
	--��������� ������� ��������
	INSERT INTO F_DT_OPERATIONS (ID_OPERATION, ID_TYPE_OPERATION, ID_STATE_OPERATION, DATE_BEG, DATE_END, SUMMA, DESCRIPTION, NOTE, ID_PAY_ABSTRACT, DATE_EDIT, ID_CUSTOMER_EDIT, IS_UPLOAD_EXTERNAL_SYSTEM) 
	VALUES (:ID_OPERATION, 12, 1, :DATE_OPERATION, :DATE_OPERATION, :sum_operation, :DESCRIPTION, NULL, NULL, NULL, NULL, 1);
	 
	 for
	--��������� ������������, ID ��������� � ���� �������� �� ��������� �������:
	select tt.int_field2,
	  TT.INT_FIELD5 as id_doc,
	  TT.CURR_FIELD1 as INSURANCE_PAYMENT,
	  TT.INT_FIELD6 as id_payment,
	  TT.INT_FIELD4 as id_customer

	from T_TEMP_TABLE TT
	where TT.INT_FIELD1 = :TEMP_KEY
	and TT.INT_FIELD6 is null
	order by TT.INT_FIELD2 --������������ ���������� �� "�������" ��� � � �������� ����� (������ 49)
	rows 1 to 500  --����� ������ 500
	into :ID_NUMBER, :id_doc, :ins_pay, :ID_PAYMENT_PART, :id_customer

	 do
	begin

		--������ ������� ��������� ��������
		--��������. �� �������, ������� ���������
		ID_OFFSET_DEAL = gen_id(GEN_F_UP_DT_OFFSET_DEAL_ID, 1);
		INSERT INTO f_dt_offset_deals (ID_OFFSET_DEAL, OD_DATE, OD_SUM, ID_CUSTOMER, ID_CF_TYPE, ID_DOC, ID_DOC_1C, ID_DOC_CLAIM, ID_OPERATION, ID_CL_TYPE, ID_PAYMENT, IS_FIXED, ID_PAY_DIRECTION, ID_REGRESS, CF_REPAYMENT)
		VALUES (:ID_OFFSET_DEAL, :DATE_OPERATION, :ins_pay, :id_customer, 26, :id_doc, NULL, NULL, :ID_OPERATION, 1, NULL, NULL, NULL, NULL, NULL);

		--���������� ��������� �������
		update T_TEMP_TABLE TT
		set TT.INT_FIELD6 = :ID_OPERATION,
		TT.INT_FIELD7 = :ID_OFFSET_DEAL
		where TT.INT_FIELD1 = :TEMP_KEY and
		TT.INT_FIELD2 = :ID_NUMBER;

	end    

	--������ ������� ��������� ��������
	--�������. ���� ��������� �� ����� ��������
	INSERT INTO f_dt_offset_deals (ID_OFFSET_DEAL, OD_DATE, OD_SUM, ID_CUSTOMER, ID_CF_TYPE, ID_DOC, ID_DOC_1C, ID_DOC_CLAIM, ID_OPERATION, ID_CL_TYPE, ID_PAYMENT, IS_FIXED, ID_PAY_DIRECTION, ID_REGRESS, CF_REPAYMENT)
	VALUES (gen_id(GEN_F_UP_DT_OFFSET_DEAL_ID, 1), :DATE_OPERATION, :sum_operation, :id_customer_wog, 138, :id_doc_wog, NULL, NULL, :ID_OPERATION, 2, NULL, NULL, NULL, NULL, 1);

	-- ��������� ��������
	update f_dt_operations o
	set o.id_state_operation = 2 -- ���������
	where o.id_operation = :ID_OPERATION; 

end

end


/* --��������
select
--TT.INT_FIELD1 as TEMP_KEY,
TT.INT_FIELD2 as ID_NUMBER,
TT.INT_FIELD3 as ID_BLANK,
TT.INT_FIELD4 as id_customer,
TT.INT_FIELD5 as id_doc,
TT.INT_FIELD6 as ID_OPERATION,
TT.INT_FIELD7 as ID_OFFSET_DEAL,
TT.CURR_FIELD1 as INSURANCE_PAYMENT
from T_TEMP_TABLE TT
where TT.INT_FIELD1 = 4240
order by TT.INT_FIELD2  
/**/

