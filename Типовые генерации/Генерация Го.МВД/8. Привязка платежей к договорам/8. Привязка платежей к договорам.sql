--http://portal.vuso.ua/issues/127289
--��������� ��.���. �������� ���������


/*
8. �������� �������� � ���������

���������� ��� �������� �������� �������� � ���������:
��������. ���� ������������ �������� � �������� �������, ����� ��������� �������� ��������������� � �������� �������. � ���� ������ ������� � 1� ����� ���������� ������� (�����-�������, �����-�������), �� ����� ������� ����� ����� ����� ����������� � 1�. ��� ��� ������������ ����� ������ ����� ������ � ��� ������, ���� ���� ����������� ����� �������.
�������. ������� � �������� ���������� ������� ���� (� �.3 ���� ������������������ ������ ��������� update, ������� ��� ��� ����������� � �������� ������ ����). ��� ������ ���� �����-������� ������������ �������� ���� "����� ����-�� ��.���", ������ ����� ����� ������� ���������. ����� �������� ������������� ������������ �� 500 � ������, ������� ��� �������� � 1� ����� ������ ���������� ("����������" �����). ������ ��������, ����� ������� �������� ����������� ��������� � ������, ����� ��������� ��� �� �������� ��������� �������.
8.1. �������� �������� � ��������� ��������������� � �������

������� �������� - ������� ������ ��������� D_UP_DT_SCHEDULES � ������� �����������???

*/
execute block
as
  declare variable id_doc tinteger;
  declare variable id_pay tinteger;
begin
  for
    select t.int_field2, t.int_field4--, p.id_doc
    from t_temp_table t
      inner join d_dt_document d
        on d.id_doc = t.int_field4
      inner join f_dt_payments p
        on p.id_payment = t.int_field2
    where t.int_field1 = 999
      and t.int_field4 is not null
      and p.id_doc is null
      and p.cf_division = 1497
      and t.date_field1 in (
	  
	  
/*--1
date '01-jun-2016', --491
date '02-jun-2016', --433
/**/
/*--2
date '03-jun-2016' --478
/**/
/*--3
date '06-jun-2016' --853
/**/
/*--4
date '07-jun-2016', --432
date '08-jun-2016' --545
/**/
/*--5
date '09-jun-2016', --493
date '10-jun-2016' --524
/**/
/*--6
date '13-jun-2016' --768
/**/
/*--7
date '14-jun-2016', --515
date '15-jun-2016' --565
/**/
/*--8
date '16-jun-2016', --501
date '17-jun-2016' --448
/**/
/*--9
date '21-jun-2016' --834
/**/
/*--10
date '22-jun-2016', --543
date '23-jun-2016' --469
/**/
/*--11
date '24-jun-2016', --472
date '30-jun-2016' --577
/**/
/*--12
date '29-jun-2016' --777
/**/
	  
	  
	  
	  
	  )
    into :id_pay, :id_doc
  do
  begin
    update d_dt_document d
    set d.id_status = 1
    where d.id_doc = :id_doc; /**/

    update f_dt_payments p
    set p.id_doc = :id_doc,
      p.id_operation = null,
      p.cf_type = 26,
      p.id_bu_fu = 1,
      p.cf_division = 1497
    where p.id_payment = :id_pay
      and p.cf_type in (148, 26)
      and p.id_doc is null
      and p.id_operation = 87552;
  end
end

/*
������ ������� ����� ���� ������: update d_dt_document �������� ������� �� ��������, � update f_dt_payments �� ������ ����������� ����� � ��������, �� � �������� �� �������� �������. ��� ��� ������� �� �����������, ���� �� ��������� ��� ��������, ��, �������� ������, ����� �� � ��� ������������ �� �����: � ��������, � ������� ���������� � �������������� ������.
��� ��� �������� ������� � �������� - ���������� ���������� �� ������� �������� (15..20 ������), �� ���������� ��������� �������� �� �������, ����� ������ ����������� ��������� ������ ������� �� ������ ��������� � ������� ����� �������. ��� ���� ������� ��������� �� ����� ��������� ���������, ����� ����� ���� ��������� ��������� �������� �����������, � ��� �� ����������� ���� ����� (� ���������� ���������, ���� ��� ������� ���������� �������� �� �������� ���� � �� �� �������)
8.2. ��������� �������� ��� �������� �������� � ���������
*/

execute block
as
  declare variable id_payment tinteger;
  declare variable date_payment tdate;
  declare variable descr_payment type of column f_dt_cash_flow.cf_descr;
  declare variable sum_payment tmoney;
  declare variable acc_name type of column f_sp_accounts.name_account;
  declare variable id_customer tinteger;
  declare variable id_doc tinteger;
  declare variable num_doc type of column d_dt_document.reg_num;
  declare variable id_operation tinteger;
  declare variable date_operation tdate;
  declare variable id_offset_deal tinteger;
  declare variable cf_type tinteger;
begin
  date_operation = date '31.03.2016';
  -- ���������� ����������� ����������
  select rdb$set_context('USER_SESSION', 'EXPORT_IGNORE', 1) from rdb$database into :id_doc;
  select rdb$set_context('USER_SESSION', 'CRM_IGNORE', 1) from rdb$database into :id_doc;
  select rdb$set_context('USER_SESSION', 'EXPORT_PERIOD', 1) from rdb$database into :id_doc;
  -- ���� �� ���������
  for
    select t.int_field2, cf.cf_date, cf.cf_descr, p.fact_sum,
      acc.name_account, p.id_customer, t.int_field4, d.reg_num, p.cf_type
    from t_temp_table t
      inner join d_dt_document d
        on d.id_doc = t.int_field4 
      inner join f_dt_payments p
        on p.id_payment = t.int_field2
      inner join f_dt_cash_flow cf
        on cf.id_cash_flow = p.id_cash_flow
      left join f_sp_accounts acc
        on acc.id_account = cf.cf_id_acc_reciep 
    where t.int_field1 = 999
      and p.id_operation in (87552, 87555)
      and t.int_field4 is not null
      and t.int_field5 is null
      and t.date_field1 <= :date_operation
    rows 1 to 1000 -- 2000 => 3 hours
    into :id_payment, :date_payment, :descr_payment, :sum_payment,
      :acc_name, :id_customer, :id_doc, :num_doc, :cf_type
  do
  begin
    -- ������ ��������
    select id_operation
    from
      f_up_dt_operations(1, gen_id(gen_f_dt_operations, 1), 10,
        1/*��������*/, :date_operation, :date_operation, :sum_payment,
        '�������� ������� �� ' || lpad(extract(day from cast(:date_payment as timestamp)),2,'0') || '.'
                               || lpad(extract(month from cast(:date_payment as timestamp)),2,'0') || '.'
                               || lpad(extract(year from cast(:date_payment as timestamp)),4,'0')||'�.'
          || ' �� ����� ' || :sum_payment || ' �� ���� ' || coalesce(:acc_name, '')
          || ' � �������� ' || :num_doc || ', ����������:  '|| :descr_payment,
        null, null, null, null, null, null, null, null)
    into :id_operation;
    -- ��������� � �������� ����������� (������������) �����
    select null
    from f_up_dt_offset_deals(1, gen_id(gen_f_up_dt_offset_deal_id, 1), :date_payment,
                        :sum_payment, :id_customer, :cf_type, null, null,
                        :id_operation, :id_payment, 1/*�����������*/, 1, null, null, null)
    into :id_offset_deal;
    -- ��������� � �������� ������ ��� �������
    select null
    from f_up_dt_offset_deals(1, gen_id(gen_f_up_dt_offset_deal_id, 1), :date_operation,
                        :sum_payment, :id_customer, 26/*��*/, :id_doc, null,
                        :id_operation, null, 1/*�����������*/, null, null, null, null)
    into :id_offset_deal;
    -- ��������� ������ ������������� �������
    select null
    from f_up_dt_offset_deals(1, gen_id(gen_f_up_dt_offset_deal_id, 1), :date_operation,
                        :sum_payment, :id_customer, :cf_type, null, null,
                        :id_operation, null, 2/*��������*/, null, null, null, 1)
    into :id_offset_deal;
    -- ��������� ��������
    update f_dt_operations o
    set o.id_state_operation = 2 -- ���������
    where o.id_operation = :id_operation;
    -- �������� ���������
    update t_temp_table t
    set t.int_field5 = :id_operation
    where t.int_field1 = 999
      and t.int_field2 = :id_payment;
  end
  -- ��������� ����������� ����������
  select rdb$set_context('USER_SESSION', 'EXPORT_IGNORE', null) from rdb$database into :id_doc;
  select rdb$set_context('USER_SESSION', 'CRM_IGNORE', null) from rdb$database into :id_doc;
  select rdb$set_context('USER_SESSION', 'EXPORT_PERIOD', null) from rdb$database into :id_doc;
end

/*

--�������� ID (t.int_field5) �� ��������� �������
select
  t.int_field1 as id_temp,
  t.int_field2 as id_payment,
  t.int_field3 as id_tariff_member,
  t.int_field4 as id_doc,
  t.int_field5 as id_operation,
  t.date_field1 as doc_date,
  t.date_field2 as inure_date,
  t.date_filed3 as end_date,
  t.str_field1 as doc_number,
  t.str_field2 as customer,
  t.str_field3 as ins_type,
  t.str_field4 as arch_num,
  t.curr_field1 as ins_sum,
  t.curr_field2 as tariff,
  t.curr_filed3 as ins_pay
from t_temp_table t
where t.int_field1 in (999)
and t.int_field4 is not null
and t.int_field5 is not null


*/


/*
����� ����� ������������ ��������, ������ �� �� �����, � ������ �� ������� (ROWS � FOR SELECT). ����� ����� ��������� ��������� �������� �����������. ������������� ��������� ������ 500, ����� ���������� ����������� �����.
������� ��������, ��� ������ ��������� ������� ����������� �� ��������. �� ����� ����� �������� �, ��������, ��������� ��������.
*/