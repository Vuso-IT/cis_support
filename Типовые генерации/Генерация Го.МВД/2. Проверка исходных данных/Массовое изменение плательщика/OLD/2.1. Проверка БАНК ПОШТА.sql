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

      and (
      --�������� �����:
      upper(cf.cf_customer) like '%����%'
          or upper(cf.cf_customer) like '%�����%'
          or upper(cf.cf_customer) like '%���%'
          or upper(cf.cf_customer) like '%²�%')
          


/*

--2. �������, � ����� ������

select CA.CF_CUSTOMER from F_DT_CASH_FLOW CA

--update F_DT_CASH_FLOW CA set CA.CF_CUSTOMER = '��������� �.�.' --������ ����� ������� � ��������

where CA.ID_CASH_FLOW in (

4229045,
4229046,
4229047,
4229048,
4228218,
4230389,
4230547,
4230559,
4231914,
4231991,
4232780,
4232859,
4232940,
4234730,
4234855,
4291484,
4291491,
4291516,
4291526,
4291561,
4292706,
4292846,
4292867,
4292878,
4293915,
4293916,
4293917,
4293992,
4294096,
4295079,
4295091,
4296608,
4296609,
4296610,
4296699,
4298017,
4298046,
4299513,
4299651,
4299711,
4301874,
4303105,
4304639,
4307128,
4307177,
4311048,
4314485,
4363525,
4369661,
4369662
)    

/**/