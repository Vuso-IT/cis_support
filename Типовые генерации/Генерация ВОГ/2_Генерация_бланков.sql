/*
��������� ���
2_���������_�������
��������� �.�. 04.06.2016
/**/

execute block as
declare variable TEMP_KEY integer; --���� ��������� �������
declare variable ID_NUMBER integer; --����������� ID �������
declare variable ID_BLANK TINTEGER; --ID ������
declare variable BLANK_NUMBER TINTEGER; --����� ������
declare variable STATE_PERIOD date; --���� ��������� ��������� ������
declare variable ID_RESP_CUSTOMER TINTEGER; --������������� ����
declare variable ID_RESP_DEPARTMENT TINTEGER; --������������� �������������
declare variable ID_HOLD_AGENT TINTEGER; --����������� ������������� �����
declare variable ID_USER TINTEGER;
declare variable ID_USER_CUSTOMER TINTEGER;

begin
  --���������
  TEMP_KEY      = 4240;          --���� ��������� �������
  STATE_PERIOD  = '01.XX.201X';  --������ ������� ���������
  
  
  --���������
  ID_RESP_CUSTOMER = 356040;-- ������������� ���� (������� ����� �������)
  ID_RESP_DEPARTMENT = 96;--������������� ������������� (��)
  ID_HOLD_AGENT = 2518680;--����������� ������������� ����� (6450 )

  --��������� �������� ������������
  select au.id_user, au.id_customer from a_user au where au.login = current_user
  --select RDB$GET_CONTEXT('USER_SESSION', 'CURRENT_USER_ID'), AU.ID_CUSTOMER
  --from RDB$DATABASE
  --join A_USER AU on AU.ID_USER = RDB$GET_CONTEXT('USER_SESSION', 'CURRENT_USER_ID')
  into :ID_USER, :ID_USER_CUSTOMER;

  --��������� �������
  for select TT.INT_FIELD2 as ID_NUMBER
      from T_TEMP_TABLE TT
      where TT.INT_FIELD1 = :TEMP_KEY
	  and TT.INT_FIELD3 is null
      order by TT.INT_FIELD2
      into :ID_NUMBER
  do
  begin

    -- ��������� ������
    BLANK_NUMBER = gen_id(GEN_B_DT_BLANKS_NUMBER, 1);
    ID_BLANK = gen_id(GEN_B_DT_BLANKS, 1);

    insert into B_DT_BLANKS (ID_BLANK, ID_TYPE, SERIES, NUMBER, ID_BLANK_STATE, STATE_PERIOD, ID_HOLD_AGENT,
                             ID_HOLD_DEPARTMENT, BLANK_STRING, ID_RESP_CUSTOMER, ID_RESP_DEPARTMENT, ID_OPERATOR,
                             IS_VIRTUAL, IS_NUMDOC, BLANK_COST)
    values (:ID_BLANK, 3, '', :BLANK_NUMBER, 0, :STATE_PERIOD, :ID_HOLD_AGENT, :ID_RESP_DEPARTMENT, :BLANK_NUMBER,
            :ID_RESP_CUSTOMER, :ID_RESP_DEPARTMENT, :ID_USER_CUSTOMER, 1, 1, 0.00);

    --���������� ��������� �������
    update T_TEMP_TABLE TT
    set TT.INT_FIELD3 = :ID_BLANK
    where TT.INT_FIELD1 = :TEMP_KEY and
          TT.INT_FIELD2 = :ID_NUMBER;

  end

end

/* --��������
select
--TT.INT_FIELD1 as TEMP_KEY,
TT.INT_FIELD2 as ID_NUMBER,
TT.INT_FIELD3 as ID_BLANK,
TT.CURR_FIELD1
from T_TEMP_TABLE TT
where TT.INT_FIELD1 = 4240
order by TT.INT_FIELD2  
/**/ 