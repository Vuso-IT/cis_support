/*
��������� ���
3_���������_������������ 
��������� �.�. 06.06.2016
/**/

execute block as
declare variable TEMP_KEY integer; --���� ��������� �������
declare variable TEMP_KEY_CUSTOMER integer; --���� ��������� ������� ������ ������������
declare variable ID_NUMBER integer; --����������� ID �������
declare variable id_customer TINTEGER; --ID �����������
declare variable SEX integer;  --0-�, 1-�
declare variable LAST_NAME varchar(30);
declare variable FIRST_NAME varchar(30);
declare variable PATRONIMIC_NAME varchar(30);

begin

  --���������
  TEMP_KEY          = 4240;  --���� ��������� �������
  TEMP_KEY_CUSTOMER = 4030;  --���� ��������� ������� ������ ������������
  ����� �������������� ����� TEMP_KEY_CUSTOMER, ��������� � ���������� ��� ��� ����� ������!!!

--������� ��������� ������� ������������
delete from t_temp_table tt where tt.int_field1 = :TEMP_KEY_CUSTOMER;

--��������� ��������� ������� ������������� � ����������� ���������, ��� ������� ������� �� �������.
--��������� �������
for select first 20000
  distinct trim(SN.LAST_NAME),

 (select first 1 SN1.first_name from C_SP_NATURALS SN1 where SN1.last_name = sn.last_name
   and SN1.SEX = 0 and  char_length(trim(SN1.first_name)) > 5),
 (select first 1 SN1.patronimic_name from C_SP_NATURALS SN1 where SN1.last_name = sn.last_name
   and SN1.SEX = 0 and  char_length(trim(SN1.patronimic_name)) > 5),

  SN.SEX
  from C_SP_NATURALS SN
  where    SN.SEX = 0
   and  char_length(trim(SN.LAST_NAME)) > 5 and
        trim(SN.LAST_NAME) similar to '([�-��-�]*)' --'([�-��-�����Ii����]*)'
order by rand()
into :LAST_NAME, :FIRST_NAME, :patronimic_name, :SEX
do begin
INSERT INTO T_TEMP_TABLE (INT_FIELD1, INT_FIELD2, STR_FIELD1, STR_FIELD2, STR_FIELD3) values (:TEMP_KEY_CUSTOMER, :SEX, :LAST_NAME, :FIRST_NAME, :patronimic_name);
end

--��������� ���
for select first 20000 
  distinct trim(SN.LAST_NAME),

 (select first 1 SN1.first_name from C_SP_NATURALS SN1 where SN1.last_name = sn.last_name
   and SN1.SEX = 1 and  char_length(trim(SN1.first_name)) > 5),
 (select first 1 SN1.patronimic_name from C_SP_NATURALS SN1 where SN1.last_name = sn.last_name
   and SN1.SEX = 1 and  char_length(trim(SN1.patronimic_name)) > 5),

   SN.SEX
  from C_SP_NATURALS SN
  where    SN.SEX = 1
   and  char_length(trim(SN.LAST_NAME)) > 5 and
        trim(SN.LAST_NAME) similar to '([�-��-�]*)' --'([�-��-�����Ii����]*)'
order by rand()
into :LAST_NAME, :FIRST_NAME, :patronimic_name, :SEX
do begin
INSERT INTO T_TEMP_TABLE (INT_FIELD1, INT_FIELD2, STR_FIELD1, STR_FIELD2, STR_FIELD3) values (:TEMP_KEY_CUSTOMER, :SEX, :LAST_NAME, :FIRST_NAME, :patronimic_name);
end

  --��������� ������������
for select TT.INT_FIELD2 as ID_NUMBER
    from T_TEMP_TABLE TT
    where TT.INT_FIELD1 = :TEMP_KEY
    and TT.INT_FIELD4 is null
    order by TT.INT_FIELD2
    into :ID_NUMBER
do
  begin
   
   --��������� �����������
   --���������� ��� ��������� �����������
  if (rand() > 0.5) then begin 
    SEX = 0; 
  end else begin
    SEX = 1;
  end

  LAST_NAME = null;
  FIRST_NAME = null;
  PATRONIMIC_NAME = null;
  
  --��������� ��������� �������
  select first 1 upper(left(trim(tt.str_field1), 1)) || lower(substring(tt.str_field1 from 2))
    from t_temp_table tt
    where tt.int_field1 = :TEMP_KEY_CUSTOMER
  and tt.int_field2 = :SEX
  and tt.int_field1 is not null
   order by rand()
   into :LAST_NAME;

  --��������� ��������� ��������� (���)
  select first 1 upper(substring(trim(tt.str_field2) FROM 1 FOR 1))
    from t_temp_table tt
    where tt.int_field1 = :TEMP_KEY_CUSTOMER
  and tt.int_field2 = :SEX
  and tt.str_field2 is not null
   order by rand()
  into :FIRST_NAME;

  --��������� ��������� ��������� (��������)
  select first 1 upper(substring(trim(tt.str_field3) FROM 1 FOR 1))
    from t_temp_table tt
    where tt.int_field1 = :TEMP_KEY_CUSTOMER
  and tt.int_field2 = :SEX
  and tt.str_field3 is not null
   order by rand()
  into :PATRONIMIC_NAME;

 --������� �����������
  id_customer = gen_id(gen_c_sp_customers_id, 1);
  insert into c_sp_customers (id_customer, id_customer_type, search_name, id_cust_category, inn_okpo, citizenship, is_valid, date_beg, id_progenitor)
  --values (:id_customer, 1, :last_name || ' ' || :first_name || ' '|| :PATRONIMIC_NAME, 5, '0000000000', 1, 30, null, :id_customer);
  values (:id_customer, 1, :last_name || ' ' || :first_name || ' '|| :PATRONIMIC_NAME, 5, '0000000000', 1, 30, null, :id_customer);
  
  insert into c_sp_naturals (id_customer, last_name, last_name_hash, first_name, PATRONIMIC_NAME, first_name_hash, PATRONIMIC_NAME_HASH, inn, citizenship, sex)
  values (:id_customer, :last_name, (select STR_RET from s_meta_phone_ru(:last_name)),
          :first_name, :PATRONIMIC_NAME, (select STR_RET from s_meta_phone_ru(:first_name)), (select STR_RET from s_meta_phone_ru(:patronimic_name)), '0000000000', 1, :SEX);

    --���������� ��������� �������
    update T_TEMP_TABLE TT
    set TT.INT_FIELD4 = :id_customer
    where TT.INT_FIELD1 = :TEMP_KEY and
          TT.INT_FIELD2 = :ID_NUMBER;

  end
 --������� ��������� ������� ������������ (��� ������ �� �����)
 delete from t_temp_table tt where tt.int_field1 = :TEMP_KEY_CUSTOMER;
 /**/
end

/* --��������
select
--TT.INT_FIELD1 as TEMP_KEY,
TT.INT_FIELD2 as ID_NUMBER,
TT.INT_FIELD3 as ID_BLANK,
TT.INT_FIELD4 as id_customer,
sn.last_name,
sn.first_name,
sn.patronimic_name,
sn.sex,
TT.CURR_FIELD1
from T_TEMP_TABLE TT
left join c_sp_naturals sn on sn.id_customer = tt.int_field4
where TT.INT_FIELD1 = 4240
order by TT.INT_FIELD2  
/**/