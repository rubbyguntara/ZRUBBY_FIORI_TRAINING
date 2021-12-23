class ZCL_ZPRJ_RUB_EMPLOYEE__DPC_EXT definition
  public
  inheriting from ZCL_ZPRJ_RUB_EMPLOYEE__DPC
  create public .

public section.
protected section.

  methods EMPVACDATASET_CREATE_ENTITY
    redefinition .
  methods EMPVACDATASET_GET_ENTITY
    redefinition .
  methods EMPVACDATASET_GET_ENTITYSET
    redefinition .
  methods EMPVACDATASET_UPDATE_ENTITY
    redefinition .
  methods EMPVACDATASET_DELETE_ENTITY
    redefinition .
private section.
ENDCLASS.



CLASS ZCL_ZPRJ_RUB_EMPLOYEE__DPC_EXT IMPLEMENTATION.


  METHOD empvacdataset_create_entity.
**TRY.
*CALL METHOD SUPER->EMPVACDATASET_CREATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA : ls_entry   TYPE zcl_zprj_rub_employee__mpc=>ts_empvacdata,
           ls_emp_vac TYPE zta_emp_vac_rub.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_entry ).

    IF ls_entry IS NOT INITIAL.
      ls_emp_vac = CORRESPONDING #( ls_entry ).
      INSERT zta_emp_vac_rub FROM ls_emp_vac.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        er_entity = CORRESPONDING #( ls_entry ).
      ELSE.
        DATA(message_container) = me->/iwbep/if_mgw_conv_srv_runtime~get_message_container( ).

        message_container->add_message(
        EXPORTING
        iv_msg_type = 'E'
        iv_msg_id = '/IWBEP/CM_OC1'
        iv_msg_number = 45
        iv_add_to_response_header = abap_true
        ).
        RAISE EXCEPTION TYPE /iwbep/cx_mgw_busi_exception
          EXPORTING
            message_container = message_container.
      ENDIF.
    ENDIF.
  ENDMETHOD.


  METHOD empvacdataset_delete_entity.
**TRY.
*CALL METHOD SUPER->EMPVACDATASET_DELETE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
    DATA(persno_key) = it_key_tab[ name = 'Persno' ]-value.

    DELETE FROM zta_emp_vac_rub WHERE persno EQ @persno_key.
    IF sy-subrc EQ 0.
      COMMIT WORK.
    ENDIF.
  ENDMETHOD.


  METHOD empvacdataset_get_entity.
**TRY.
*CALL METHOD SUPER->EMPVACDATASET_GET_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_request_object       =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**  IMPORTING
**    er_entity               =
**    es_response_context     =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA(persno_key) = it_key_tab[ name = 'Persno' ]-value.
    SELECT SINGLE * FROM zta_emp_vac_rub INTO @DATA(line_data)
      WHERE persno EQ @persno_key.

    IF line_data IS NOT INITIAL.
      er_entity = CORRESPONDING #( line_data ).
    ENDIF.

  ENDMETHOD.


  METHOD empvacdataset_get_entityset.
**TRY.
*CALL METHOD SUPER->EMPVACDATASET_GET_ENTITYSET
*  EXPORTING
*    IV_ENTITY_NAME           =
*    IV_ENTITY_SET_NAME       =
*    IV_SOURCE_NAME           =
*    IT_FILTER_SELECT_OPTIONS =
*    IS_PAGING                =
*    IT_KEY_TAB               =
*    IT_NAVIGATION_PATH       =
*    IT_ORDER                 =
*    IV_FILTER_STRING         =
*    IV_SEARCH_STRING         =
**    io_tech_request_context  =
**  IMPORTING
**    et_entityset             =
**    es_response_context      =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.
    SELECT * FROM zta_emp_vac_rub INTO TABLE @DATA(vac_data)
      ORDER BY persno DESCENDING.

    et_entityset = CORRESPONDING #( vac_data ).

  ENDMETHOD.


  METHOD empvacdataset_update_entity.
**TRY.
*CALL METHOD SUPER->EMPVACDATASET_UPDATE_ENTITY
*  EXPORTING
*    IV_ENTITY_NAME          =
*    IV_ENTITY_SET_NAME      =
*    IV_SOURCE_NAME          =
*    IT_KEY_TAB              =
**    io_tech_request_context =
*    IT_NAVIGATION_PATH      =
**    io_data_provider        =
**  IMPORTING
**    er_entity               =
*    .
**  CATCH /iwbep/cx_mgw_busi_exception.
**  CATCH /iwbep/cx_mgw_tech_exception.
**ENDTRY.

    DATA : ls_entry   TYPE zcl_zprj_rub_employee__mpc=>ts_empvacdata,
           ls_emp_vac TYPE zta_emp_vac_rub.

    io_data_provider->read_entry_data( IMPORTING es_data = ls_entry ).

    DATA(persno_key) = it_key_tab[ name = 'Persno' ]-value.

    IF ls_entry IS NOT INITIAL.
      ls_emp_vac = CORRESPONDING #( ls_entry ).
      MODIFY zta_emp_vac_rub FROM ls_emp_vac.
      IF sy-subrc EQ 0.
        COMMIT WORK AND WAIT.
        er_entity = CORRESPONDING #( ls_entry ).
      ENDIF.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
