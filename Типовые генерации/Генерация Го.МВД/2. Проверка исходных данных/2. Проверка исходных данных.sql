--http://portal.vuso.ua/issues/127289
--��������� ��.���. �������� ���������

--1) �.2. �������� �������� ������

select
p.id_payment,
cf.id_cash_flow,
 cf.cf_customer
    from f_dt_payments p
      inner join f_dt_cash_flow cf
        on cf.id_cash_flow = p.id_cash_flow
    where cf.cf_date between date '01.05.2016' and date '31.05.2016'  -- ������
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
          or upper(cf.cf_customer) like '%²�%'

          --���������
          --or upper(cf.cf_customer) = upper('�-1')

      --�����������, ��� ��� ������� � �������� �����:
          or CHAR_LENGTH(trim(cf.cf_customer)) - CHAR_LENGTH(REPLACE(trim(cf.cf_customer), ' ', '')) = 0
           )

   --���������
      /*
           and upper(cf.cf_customer) <> '²���������� ���ò� �����˲�����'
           and upper(cf.cf_customer) <> '²������� ��������� ���ò�����'
           and upper(cf.cf_customer) <> '²��������� ���ò� ²��������'
           and upper(cf.cf_customer) <> '²�������� �²����� ��������в���'
           and upper(cf.cf_customer) <> '²������ϲ� ������ ���ͲĲ���'
           and upper(cf.cf_customer) <> '²������ ������ �����Ĳ�����'
           /**/
  --���������(�����)




/*--������ ��������
select cf.id_cash_flow, cf.cf_customer from f_dt_cash_flow cf
where cf.id_cash_flow in(
 4454176
)





  /**/