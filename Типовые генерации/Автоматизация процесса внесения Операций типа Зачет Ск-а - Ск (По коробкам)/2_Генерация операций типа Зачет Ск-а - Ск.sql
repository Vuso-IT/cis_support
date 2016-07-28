/*
http://portal.vuso.ua/issues/130405

terminal7
D:\������\���\����� ��� ��

���������:
1) ���� ��������                      - ���� �������� 30.06.2016
2) ����� ��������                     - ����� �������� 7433,00 
3) ���� ��������� �������             - 6464455
4) ID_DOC ���������� ��������         - 2555161
5) ����� ��������, ���������� ������� - 0
6) �������� ��������                  - �������� ���������� ������� ��� ������ �� 29.06.2016 �. � �������������� ���������� ��������� �����������


�������:
1) ���� �������� - ����� ���� �������? ������� ����, ������� ���������� ���������
6) �������� �������� - �������� ���������� ������� ��� ������ �� 19.05.2016 �. � �������������� ���������� ��������� �����������  - ����� ���� �������? ������� ���� ��, ������� � ������� (�� ������� ������� ������ �����)

/**/



/************************************************************************************************
 *  ��������� �������� ���� ����� ��-� - ��
 *
 *  �������� ������ � T_TEMP_TABLE
 *    INT_FIELD1 - ���� (6464455 �� ���������)
 *    INT_FIELD2 - ID_DOC �������� ����������� (����� ���� NULL, ����� ����� �� ��������� �����)
 *    STR_FIELD1 - REG_NUM �������� �����������
 *    DATE_FIELD1 - DATE_DOC �������� �����������
 *    STR_FIELD2 - ������������ (���) ������������
 *    CURR_FIELD1 - ����� �������, ������� ����� ��������� � ��������
 *  ��������� ���������
 *    DATE_OPER - ����, ������� ������������ ��������
 *    SUM_OPER - ����� ����������
 *    ID_TEMP_KEY - ���� �� ��������� �������, 6464455 �� ���������
 *    ID_AG_DOC - ID_DOC ���������� ��������
 *    SUM_AG - ����� ����������� ������� ������������� �������������� (����� ���� NULL)
 *      ������ ����������� ���������: SUM(T_TEMP_TABLE.CURR_FIELD1) = SUP_OPER + coalesce(SUM_AG, 0)
 *    DESCR - �������� ��������
 *  ������������ ��������
 *    ID_OPER - ���� �� ������, NULL - ���� ������
 */
execute block(
  date_oper tdate = :"���� ��������",
  sum_oper tmoney = :"����� ��������",
  id_temp_key tinteger = :"���� ��������� ������� (6464455)",
  id_doc_ag tinteger = :"ID_DOC ���������� ��������",
  sum_ag tmoney = :"����� ��������, ���������� �������",
  descr tvarchar400 = :"�������� ��������" 
) returns (id_oper tinteger)
as
  declare variable tmp_cnt tinteger;
  declare variable tmp_sum tmoney;
  declare variable reg_num tvarchar40;
  declare variable date_doc tdate;
  declare variable id_doc tinteger;
  declare variable id_customer tinteger;
  declare variable list_ids tvarchar810;
begin
  -- �������� ������� ����������
  if (:date_oper is null or :sum_oper is null or :id_doc_ag is null) then
    exception s_exception '���� ��������, ����� �������� � ID_DOC ���������� �������� ������ ���� ������ (NOT NULL)';
  if (:id_temp_key is null) then
    id_temp_key = 6464455;
  if (:sum_ag is null) then
    sum_ag = 0;
  if (:sum_oper <= 0 or :sum_ag < 0) then
    exception s_exception '����� �������� ������ ���� �������������, ����� �������� �� ����� ���� �������������';

  select cc.id_customer
  from d_dt_document d
    inner join d_dt_contract_customers cc
      on cc.id_contract_customer = d.id_contract_customer
  where d.id_doc = :id_doc_ag
    and d.id_state in (2, 3)
    and d.id_doc_type = 1
  into :id_customer;
  if (:id_customer is null) then
    exception s_exception '����������� ��� ����������� ��������� ������� �� ������, ID_DOC = ' || :id_doc_ag;

  -- �������� �������� ������ �� ��������� �������
  select count(*), sum(t.curr_field1)
  from t_temp_table t
  where t.int_field1 = :id_temp_key 
  into :tmp_cnt, :tmp_sum;

  if (:tmp_cnt = 0 or :tmp_sum is null) then
    exception s_exception '��� ������ �� ��������� ����������� � T_TEMP_TABLE �� ����� ' || :id_temp_key;
  if (exists (select * from t_temp_table where int_field1 = :id_temp_key and (curr_field1 is null or curr_field1 = 0))) then
    exception s_exception '����� �������� �� ������ �� ��������� ����������� �� ����� ���� NULL ��� 0.00';
  if (:tmp_sum <> :sum_oper + :sum_ag) then
    exception s_exception '����� �� ��������� ����������� (' || :tmp_sum || ') �� �������� � ������ �������� (' || (:sum_oper + :sum_ag) || ')';
  if (exists (
      select t.str_field1, t.date_field1
      from t_temp_table t
      where t.int_field1 = :id_temp_key
      group by 1, 2
      having count(*) > 1
    )
  ) then
  begin
    select t.str_field1, t.date_field1
    from t_temp_table t
    where t.int_field1 = :id_temp_key
    group by 1, 2
    having count(*) > 1
    rows 1
    into :reg_num, :date_doc;

    exception s_exception '����������� ������������ ��������� ����������� � �������, ' || reg_num;
  end

  -- ���������� ID_DOC
  for
    select t.str_field1, t.date_field1, t.curr_field1
    from t_temp_table t
    where t.int_field1 = :id_temp_key 
      and t.int_field2 is null
    into :reg_num, :date_doc, :tmp_sum
  do
  begin
    select min(d.id_doc), count(*)
    from d_dt_document d
    where d.reg_num = :reg_num
      and d.date_doc = :date_doc
      and d.id_state in (1, 2, 3)
    into :id_doc, :tmp_cnt;

    if (:tmp_cnt = 0) then
      exception s_exception '�� ������ ID_DOC ��� �������� ' || :reg_num || ', ����� ' || :tmp_sum;
    else if (:tmp_cnt > 1) then
      exception s_exception '��� �������� ' || :reg_num || ', ����� ' || :tmp_sum || ' ������� ��������� (' || :tmp_cnt || ') ������������!';
    else
      update t_temp_table t
      set t.int_field2 = :id_doc
      where t.int_field1 = :id_temp_key
        and t.str_field1 = :reg_num
        and t.date_field1 = :date_doc;
  end 

  -- �������� ������������ ���������
  select list(t.int_field2)
  from t_temp_table t
    left join d_dt_document d
      on d.id_doc = t.int_field2
    left join d_dt_insurance di
      on di.id_doc = d.id_doc
  where t.int_field1 = :id_temp_key
    and (d.id_doc is null
      or di.id_doc is null
      or d.id_state not in (2, 3)
      or d.id_doc_inure_type = 8
      or di.sum_doc < t.curr_field1
      or d.date_doc > :date_oper
    )
  into :list_ids;

  if (:list_ids is not null) then
    exception s_exception '��������� �������� �� �������, �� �������� ��������� �����������, ��������� ����� ���� ��������
'     || '�� ��������� � ��������� "��������" ��� "��������" ��� ����� ��� ���������� "�� ������������ ��������".
'     || 'ID_DOC in (' || :list_ids || ')';

  -- �������� ��������
  if (:descr is null) then
    select '�������� ���������� ������� ' ||
      trim(iif(position('(' in c.search_name) > 0, left(c.search_name, position('(' in c.search_name) - 1), c.search_name)) ||
      ' (������� ' || d.reg_num || ') ' ||
      '�� ' || lpad(extract(day from :date_oper),2,'0') || '.'
            || lpad(extract(month from :date_oper),2,'0') || '.'
            || lpad(extract(year from :date_oper),4,'0')|| ' �. ' ||
      '� ����� ' || :sum_oper || ' ���. � ��������� ����������� ' ||
      coalesce( (
          select list(distinct ik.short_name_ins_kind)
          from t_temp_table t
            inner join d_dt_insurance di
              on di.id_doc = t.int_field2 
            inner join b_sp_ins_kind ik
              on ik.id_ins_kind = di.id_ins_kind 
          where t.int_field1 = :id_temp_key
        ), ''
      )
    from d_dt_document d
      inner join d_dt_contract_customers cc
        on cc.id_contract_customer = d.id_contract_customer
      inner join c_sp_customers c
        on c.id_customer = cc.id_customer
    where d.id_doc = :id_doc_ag
    into :descr;

  --exception s_exception :descr;

  -- ��������� ��������
  select id_operation
  from f_up_dt_operations(1, gen_id(gen_f_dt_operations, 1), 12,
    1/*��������*/, :date_oper, :date_oper, :sum_oper + :sum_ag, :descr,
    null, null, null, null, null, null, null, 1)
  into :id_oper;

  -- ��������� "������" ������������� �������
  select null
  from f_up_dt_offset_deals(1, gen_id(gen_f_up_dt_offset_deal_id, 1), :date_oper,
    :sum_oper, :id_customer, 138 /* ��-� */, :id_doc_ag, null,
    :id_oper, null, 2/* �������� */, null, null, null, 1)
  into :tmp_cnt;

  -- ��������� ������� ��������
  if (:sum_ag > 0) then
    select null
    from f_up_dt_offset_deals(1, gen_id(gen_f_up_dt_offset_deal_id, 1), :date_oper,
      :sum_ag, :id_customer, 32 /* �� */, :id_doc_ag, null,
      :id_oper, null, 2/* �������� */, null, null, null, null)
    into :tmp_cnt;

  -- ��������� ������� �� �������� �����������
  for
    select d.id_doc, cc.id_customer, t.curr_field1
    from t_temp_table t
      inner join d_dt_document d
        on d.id_doc = t.int_field2
      inner join d_dt_contract_customers cc
        on cc.id_contract_customer = d.id_contract_customer
    where t.int_field1 = :id_temp_key
    into :id_doc, :id_customer, :tmp_sum
  do
    select null
    from f_up_dt_offset_deals(1, gen_id(gen_f_up_dt_offset_deal_id, 1), :date_oper,
      :tmp_sum, :id_customer, 26 /* �� */, :id_doc, null,
      :id_oper, null, 1/* ����������� */, null, null, null, null)
    into :tmp_cnt;

  -- ����������� ��������
  update f_dt_operations op
  set op.id_state_operation = 2
  where op.id_operation = :id_oper; /**/

  -- �����
  suspend;
end