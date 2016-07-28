--http://portal.vuso.ua/issues/127289
--��������� ��.���. �������� ���������

/*
������ ������� �� ������������� ��� ������� ������������� �������� ���� ����������
������ ��������� I_UP_ADD_CUSTOM, ������� ��������� ��� ������ �� ��������� ��������
��������� update, ������� ��������� �� ��������� ������� ID ���������������� ��������
����� ������ 5 ��� ���������� ��������� ����������� commit. ��� ��� ���� ���� � �������� ��������� ���-�� �����, ������� �� ��� ������, � ���� � �����.

������ �������� ���������� �����: ��������� ������ �������� �������� 10..15 ������. ��! ������ ������������ ������������������. ����� ������ ������� ���� �� ����� � ��������� � ���������� ����������� IBExpert. ��� ��������� ������������ � ������ �������, ��� ���� ������������������ ������� ����������� �� ���������.

����������: ��� ��� ��������� �������� ������ � �������� �������, � ����� ����� �� ��������� ����������� ����� � 1�, ��������������� �������� �� ��������� �� ���������� �� �������� � 1�.

*/

--�������� ��������
select count(*)
--select count(*), /*���������*/0 + count(*)
from D_DT_DOCUMENT T
where cast(T.STATE_CHANGE_DATE as date) = current_date --�������
and T.ID_REGISTRATION_DEPARTMENT = 1497 --������ ��.���
and t.ID_DOC_SOURCE = 3 --���������
and T.ID_DOC > 3354838 --��� �������� ������



--�������� ID (t.int_field4) �� ��������� �������
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