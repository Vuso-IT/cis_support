delete from T_TEMP_TABLE t where t.INT_FIELD1 = 4030;


/*
select
--t.int_field1 as ID_KEY,
t.int_field2 as ID_PAYMENT,   --����������� ���� ID_PAYMENT �� f_dt_payments
t.int_field3 as ID_CASH_FLOW, --����������� ���� ID_CASH_FLOW �� f_dt_cash_flow
t.str_field1 as cf_descr,     --����������� ���� "����������" �� f_dt_cash_flow
t.CURR_FIELD1 as FACT_SUM,    --����������� ���� "����������� ����� ������� (�����������)" �� f_dt_payments
t.DATE_FIELD1 as cf_date      --����������� ���� "���� �������� �������� �������" �� f_dt_cash_flow
from T_TEMP_TABLE t where t.INT_FIELD1 = 4030;
/**/





INSERT INTO T_TEMP_TABLE (INT_FIELD1, int_field2, int_field3, STR_FIELD1, CURR_FIELD1, DATE_FIELD1) 
VALUES (4030, 8111111, 9111111, '1777771;0501263548;��;������������ ���������� ������������;TRU8766666; 0969292980;1111111111; 01.07.2016; 10003/0618;����-������������;��6655��;VOLKSWAGEN Transporter', 680.40, '07.07.2016');

INSERT INTO T_TEMP_TABLE (INT_FIELD1, int_field2, int_field3, STR_FIELD1, CURR_FIELD1, DATE_FIELD1) 
VALUES (4030, 8111112, 9111112, '      1557762  ;  0505551150;��    ;��� "���� � ������";     0000AA00000000000    ;       0969998833;2741708592; 04.07.2016    ; 10005/0619  ;�������    ;��0099��   ;  ��� 1105   ', 1078.27, '03.07.2016');

INSERT INTO T_TEMP_TABLE (INT_FIELD1, int_field2, int_field3, STR_FIELD1, CURR_FIELD1, DATE_FIELD1) 
VALUES (4030, 8111113, 9111113, '5577761;0505551250;��;��� "���� � ��������"; JN1WNYD21U012001; 0989998832;21642228; 05.07.2016; 10005/0619;�������;��0099��;��� 1105', 561.60, '01.07.2016');

INSERT INTO T_TEMP_TABLE (INT_FIELD1, int_field2, int_field3, STR_FIELD1, CURR_FIELD1, DATE_FIELD1) 
VALUES (4030, 8111114, 9111114, '1127762;0685551150;��;������� ����� �������; JN1WNYD21U0067890; 0937778833;3336289098; 06.07.2016; 10105/0119;���;��0099��;��� 1105', 270, '03.07.2016');

INSERT INTO T_TEMP_TABLE (INT_FIELD1, int_field2, int_field3, STR_FIELD1, CURR_FIELD1, DATE_FIELD1) 
VALUES (4030, 8111115, 9111115, '1557761;0735551151;��;������� �������� �������; SA1WNYD21U0000001; 0509998123;4420374098; 05.07.2016; 10005/0619;�������;��0099��;��� 1105', 367.20, '04.07.2016');

INSERT INTO T_TEMP_TABLE (INT_FIELD1, int_field2, int_field3, STR_FIELD1, CURR_FIELD1, DATE_FIELD1) 
VALUES (4030, 8111116, 9111115, '1557761;0735551151;��;������� ����� �������; SA1WNYD21U0000001; 0509998123;4420374098; 05.07.2016; 10005/0619;�������;��0099��;��� 1105', 302.40, '01.07.2016');