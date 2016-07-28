--1) �.2. �������� �������� ������

--1. �������� id_cash_flow
select
cf.id_cash_flow
 --��� ������������, ��� ��������� ID - ���
, cf.cf_customer
/**/
    from f_dt_payments p
      inner join f_dt_cash_flow cf
        on cf.id_cash_flow = p.id_cash_flow
    where cf.cf_date between date '01.01.2016' and date '30.04.2016'  -- ������
      and cf.cf_cl_type = 1                -- �����������
      and p.cf_type in (26, 123, 148)      -- ������ �� (��� ��������� �������) ��� ���� (��� ��������� � ��� �������)
      and p.cf_division = 1497             -- ������������� ��.���
      and p.fact_sum in (10, 30, 40, 50, 60, 75, 80, 100, 140, 150, 160, 200, 240, 280, 300, 320, 340, 360, 380, 400)
        --120, 125, 170, 182, 245, 272, 350, 392, 420, 425, 450, 476, 480, 500, 600, 680, 686, 800, 980) -- ���������� �� ��������
      and p.id_doc is null            -- ��� �������� ��������
      and p.id_operation is null
      --�������� ��������
      and (CHAR_LENGTH(trim(cf.cf_customer)) - CHAR_LENGTH(REPLACE(trim(cf.cf_customer), ' ', '')) = 0)
	  

/*

--2. �������, � ����� ������

select CA.CF_CUSTOMER from F_DT_CASH_FLOW CA

--update F_DT_CASH_FLOW CA set CA.CF_CUSTOMER = upper(left(trim(CA.CF_CUSTOMER), 1)) || lower(substring(trim(CA.CF_CUSTOMER) from 2)) || ' �.�.' --������ ����� ��������. � ����������, ����� ����������������� � ������� �� �������...

where CA.ID_CASH_FLOW in (

4228237,
4290203,
4295175,
4295296,
4295459,
4295516,
4304542,
4354575,
4354592,
4354594,
4354602,
4354608

)    

/**/
