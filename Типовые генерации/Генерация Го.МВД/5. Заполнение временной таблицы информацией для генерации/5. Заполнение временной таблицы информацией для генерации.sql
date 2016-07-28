--http://portal.vuso.ua/issues/127289
--��������� ��.���. �������� ���������

--1. ���� ��������� ���� �� ��������� �������
select t.int_field1, count(*) from t_temp_table t where t.int_field1 between 992 and 999 group by 1
--delete from t_temp_table t where t.int_field1 = 999

--2. ��������� ��������� �������

--"ID �������� (87552, 87555)"                       - 87552,
--"ID �� ��������� ������� (999)"                    - 999,
--"������ ��������� ������� (NULL - �� ����������)"  - XXXXXXX ����� �,
--"����� ��������� �������"                          - XXXXXXX ����� ��,
--"����� ��������� ���� (NULL - ��� ��������)"       - 306,    --���, ��� ���� ����������� (������)
--"�������� ����� � ���� (1..999)"                   - 1       --������ ����� � ����

/*
 *  ������������ ������� �������� ��� ��������� ��.���
 *  ���������� ��������� ������� � ����������� ������������ ��������� �����������
 */
execute block (

  id_oper tinteger = :"ID �������� (87552, 87555)",
  id_temp tinteger = :"ID �� ��������� ������� (999)",
  first_blank tinteger = :"������ ��������� ������� (NULL - �� ����������)",
  last_blank tinteger = :"����� ��������� �������",
  tome_num tinteger = :"����� ��������� ���� (NULL - ��� ��������)",
  arch_num tinteger = :"�������� ����� � ���� (1..999)" 
)
as
  declare variable id_payment tinteger;
  declare variable customer type of column f_dt_payments.customer;
  declare variable pay_sum tmoney;
  declare variable doc_sum tmoney;
  declare variable ins_sum tmoney;
  declare variable pay_date tdate;
  declare variable end_date tdate;
  declare variable ins_type tvarchar4;
begin
  if (:tome_num is not null and :arch_num is null) then arch_num = 1;

  for
    select p.id_payment, p.customer, p.fact_sum, cf.cf_date
    from f_dt_payments p
      inner join f_dt_cash_flow cf
        on p.id_cash_flow = cf.id_cash_flow
    where p.id_operation = :id_oper
	--and cf.cf_date >= '01.05.2016' -- ��������... 2 ������� � ������!!!
    order by p.cf_division, cf.cf_date
    into :id_payment, :customer, :pay_sum, :pay_date
  do
  begin
    doc_sum = :pay_sum;
    -- ���������� ��� �����������
    ins_type = case
      when :doc_sum in (10, 40) then '��'
      when :doc_sum = 30 then '��'
      when :doc_sum in (50, 60, 75, 100, 150) then '���'
      when :doc_sum in (80, 140, 160, 200, 240, 280, 300, 320, 340, 360, 380, 400, 600) then '����'
      when :doc_sum in (120, 125, 170, 182, 245, 272, 350, 392, 420, 425, 450, 476, 480, 500, 680, 686, 800, 980) then '���'
      else null
    end;
    -- ���������� ��������� �����
    ins_sum = case
      when :ins_type = '��' then 5000
      when :ins_type = '��' then 1000
      when :ins_type = '���' then 50000
      when :ins_type = '����' then 20000
      when :ins_type = '���' then 40000
      else null
    end;

    if (:ins_sum is not null) then
    begin
      -- ������ �������
      update f_dt_payments p
      set p.memo_1 = null,
        p.memo_3 = :ins_type
      where p.id_payment = :id_payment;

      -- ���������� ���� ��������� ��������
      end_date = dateadd(-1 day to
        case
          when :doc_sum in (30, 50, 60, 75, 100, 150, 400, 480, 500, 600, 680, 980) then dateadd(1 year to :pay_date)
          else dateadd(
            case
              when :doc_sum in (10, 80, 120, 125, 170, 245) then 1
              when :doc_sum in (140, 182) then 2
              when :doc_sum in (160, 272, 392) then 3
              when :doc_sum = 200 then 4
              when :doc_sum = 240 then 5
              when :doc_sum in (40, 280, 350, 476, 686) then 6
              when :doc_sum = 300 then 7
              when :doc_sum = 320 then 8
              when :doc_sum in (340, 420, 425) then 9
              when :doc_sum in (360, 450) then 10
              when :doc_sum = 380 then 11
              when :doc_sum = 800 then 24
              else 12
            end
            month to :pay_date
          )
        end
      );

      -- ������� ������ � �������� �������
      update or insert into t_temp_table (
        INT_FIELD1,  -- ���������� ID �� ��������� �������
        INT_FIELD2,  -- ID_PAYMENT
        INT_FIELD3,  -- �� ����������� (���� �� 4166, 4180, 4251, 4255, 4279, 4281, 4282 ��� 4317 ��� ��������)
        DATE_FIELD1, -- ���� �������� (� �������� 01.01.2011 - 31.12.2014)
        DATE_FIELD2, -- ���� ������ (����� ���� ��������)
        DATE_FILED3, -- ���� ��������� (���� ������ + 1..12 ������� ����� 1 ����)
        STR_FIELD1,  -- �������� ����� ������ ��� ������������� ��������
        STR_FIELD2,  -- ��� ����������� (��� NULL, ���� ��������� ��������� ���)
        STR_FIELD3,  -- ��� ����������� (��, ���, ����, ��), �������� (���) �� ������������
        STR_FIELD4,  -- �������� �����
        CURR_FIELD1, -- ��������� ����� �� ��������
        CURR_FIELD2, -- ��������� ����� �� �������� ( = CURR_FILED3 / CURR_FIELD1 * 100 )
        CURR_FILED3  -- ��������� ������ �� ��������.
      )
      values (
        :id_temp, 
        :id_payment, 
        case
          when :ins_type = '��' then 4166
          when :ins_type = '��' then 4180
          when :ins_type = '����' then 20660
          when :ins_type = '���' then 20661
          when :ins_type = '���' then 20662
          else null
        end,
        :pay_date,
        :pay_date,
        :end_date,
        :first_blank,
        :customer,
        :ins_type,
        (extract(year from :pay_date) - 2000) || '-' || right('00' || :tome_num, 3) || '/' || right('00' || :arch_num, 3),
        :ins_sum,
        :doc_sum * 100 / :ins_sum,
        :doc_sum
      )
      matching (int_field1, int_field2);

      -- ����� ���������� ������
      if (:first_blank is not null) then
      begin
        first_blank = :first_blank + 1;

        if (:first_blank > coalesce(:last_blank, 9999999)) then
          first_blank = null;
      end

      -- ��������� �������� �����
      if (:tome_num is not null) then
      begin
        arch_num = :arch_num + 1;
        if (:arch_num > 999) then
        begin
          tome_num = :tome_num + 1;
          arch_num = 1;
        end
      end
    end
  end
end

/*

--����������, ��� �� ��������� �������

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

*/