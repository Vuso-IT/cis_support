--http://portal.vuso.ua/issues/127289
--��������� ��.���. �������� ���������

--��������� �������, �������������� ������� ��������� ����� ��������� - xd_generate_full

select * from xd_generate_full (null, 999)

--� �������� ���������� ����� ����� �������. ��� ���������� ��������� � ��������� ����, � ����� ��������� � ��������� �������� IBExpert.


--��������! ��������� ������, ������� ����� �������� ��������� ��������������� � ���� ���������. ����� ����, ��� ��� ��� ���������, � �� ������, ��� ������ ������ ������� ���������� ���� ������ ���������, ������� ���� ��������� ��������.

--����� ������ �������� ��������� ���������� ������ ��������� � � �����:
--�������� ������
--���� �������
--������ �������
--���� ��������� �������


--������:

  /* ������������� ���������� */
/*
  -- �������� ���
  arch_num_min_id = 447;--����� ����� ����������, �������� �� ������ ����� ����
  arch_num_max_id = 455;--����� ����� ����������, �������� �� ��������� ����� ����
  -- ����� � ������
  arch_tom_num_id = 1;
  -- ������ ���������
  doc_num_min = 2609363;
  doc_num_max = 2617431;
  -- ���� �������
  pay_date_min = cast('01.01.2016' as tdate);
  pay_date_max = cast('31.03.2016' as tdate);
  -- �������� ��� ������ �������� (87552 ��-���������, ������ 87555)
  id_operation = 87552;
*/
  /* ��������� ������� �������� */
/*  
  arch_num_id = :arch_num_min_id;
  if (:id_temp_key is null) then id_temp_key = 999;
*/ 







--��� �� ������, ������!!!
/*
�����, �������:
        --------------------------------------------------------------------------
        --- ���������� ��������� �������
        result =  result ||
                  'update t_temp_table set STR_FIELD1 = '''||:reg_num_str||''','||
                    'STR_FIELD4='''||:arch_num_str||''','||
                    'INT_FIELD4=(select d.id_doc '||
                      'from d_dt_document d inner join t_temp_table tt '||
                        'on d.reg_num starting with tt.str_field1 || ''-'' '||
                          'and d.id_state=3 '||
                          'and d.id_doc_source=3 '||
                      'where tt.int_field1='||:id_temp_key||
                        ' and tt.int_field2='||:id_pay||')'||
                  ' where INT_FIELD1=' || :id_temp_key ||
                      ' and INT_FIELD2=' ||:id_pay||';
        ';

�������� �� ������ 320 : 'and d.id_state=3 '||    ��    'and d.id_state in (1, 3) '||

        --------------------------------------------------------------------------
        --- ���������� ��������� �������
        result =  result ||
                  'update t_temp_table set STR_FIELD1 = '''||:reg_num_str||''','||
                    'STR_FIELD4='''||:arch_num_str||''','||
                    'INT_FIELD4=(select d.id_doc '||
                      'from d_dt_document d inner join t_temp_table tt '||
                        'on d.reg_num starting with tt.str_field1 || ''-'' '||
                          'and d.id_state in (1, 3) '||
                          'and d.id_doc_source=3 '||
                      'where tt.int_field1='||:id_temp_key||
                        ' and tt.int_field2='||:id_pay||')'||
                  ' where INT_FIELD1=' || :id_temp_key ||
                      ' and INT_FIELD2=' ||:id_pay||';
        ';		
		
*/		