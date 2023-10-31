CLASS lhc_Travel DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS get_instance_features FOR INSTANCE FEATURES
      IMPORTING keys REQUEST requested_features FOR Travel RESULT result.

    METHODS acceptTravel FOR MODIFY
      IMPORTING keys FOR ACTION Travel~acceptTravel RESULT result.
    METHODS validateCustomer FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateCustomer.
    METHODS validateDates FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateDates.
    METHODS validateAgency FOR VALIDATE ON SAVE
      IMPORTING keys FOR Travel~validateAgency.

ENDCLASS.

CLASS lhc_Travel IMPLEMENTATION.

  METHOD get_instance_features.
    READ ENTITY zi_travel_m_103  FROM VALUE #( FOR keyval IN keys (
                                                %key = keyval-%key
                                                %control-overall_status = if_abap_behv=>mk-on  ) )
                                RESULT DATA(lt_travel_data).

    result = VALUE #( FOR ls_travel IN lt_travel_data (
             %key = ls_travel-%key
             %features-%action-acceptTravel = COND #( WHEN ls_travel-overall_status = 'A'
                                                      THEN if_abap_behv=>fc-o-disabled
                                                      ELSE if_abap_behv=>fc-o-enabled )
            ) ).

  ENDMETHOD.

  METHOD acceptTravel.
    MODIFY ENTITIES OF zi_travel_m_103 IN LOCAL MODE
        ENTITY Travel
        UPDATE FROM VALUE #( FOR key IN keys (
                                mykey = key-mykey
                                overall_status = 'A'
                                %control-overall_status = if_abap_behv=>mk-on ) )
                                FAILED failed
                                REPORTED reported.

    READ ENTITIES OF zi_travel_m_103 IN LOCAL MODE
         ENTITY Travel
         FROM VALUE #( FOR key IN keys
                         ( mykey = key-mykey
                           %control = VALUE #(
                           agency_id = if_abap_behv=>mk-on
                           customer_id = if_abap_behv=>mk-on
                           begin_date = if_abap_behv=>mk-on
                           end_date = if_abap_behv=>mk-on
                           booking_fee = if_abap_behv=>mk-on
                           total_price = if_abap_behv=>mk-on
                           currency_code = if_abap_behv=>mk-on
                           overall_status = if_abap_behv=>mk-on
                           description = if_abap_behv=>mk-on
                           created_by = if_abap_behv=>mk-on
                           created_at = if_abap_behv=>mk-on
                           last_changed_by = if_abap_behv=>mk-on
                           last_changed_at = if_abap_behv=>mk-on  ) ) )
                     RESULT DATA(lt_travel) .
    result = VALUE #( FOR travel IN lt_travel ( mykey = travel-mykey %param = travel ) ).
  ENDMETHOD.

  METHOD validateCustomer.
    DATA lt_agency TYPE SORTED TABLE OF /dmo/agency WITH UNIQUE KEY agency_id.

    READ ENTITY zi_travel_m_103
         FROM VALUE #( FOR <root_key> IN keys
                       ( %key-mykey = <root_key>-mykey
                         %control   = VALUE #( agency_id = if_abap_behv=>mk-on ) ) )
         " TODO: variable is assigned but never used (ABAP cleaner)
         RESULT DATA(lt_travel).
    lt_agency = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING agency_id = agency_id EXCEPT * ) .

    DELETE lt_agency WHERE agency_id IS INITIAL.

    CHECK lt_agency IS NOT INITIAL.

    SELECT
      FROM /dmo/agency
    FIELDS agency_id
       FOR ALL ENTRIES IN @lt_agency
     WHERE agency_id = @lt_agency-agency_id
      INTO TABLE @DATA(lt_agency_db).

    LOOP AT lt_travel INTO DATA(ls_travel).
      IF ls_travel-agency_id IS NOT INITIAL AND
         NOT line_exists( lt_agency_db[ agency_id = ls_travel-agency_id ] )   .
        APPEND VALUE #( mykey = ls_travel-mykey ) TO failed-travel.
        APPEND VALUE #( mykey = ls_travel-mykey
                        %msg = new_message( id = /dmo/cx_flight_legacy=>customer_unkown-msgid
                                            number = /dmo/cx_flight_legacy=>customer_unkown-msgno
                                            v1 = ls_travel-customer_id
                                            severity = if_abap_behv_message=>severity-error  )
                        %element-customer_id = if_abap_behv=>mk-on ) TO reported-travel.
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateDates.

    READ ENTITY zi_travel_m_103 FROM VALUE #( FOR <root_key> IN keys (
                                                %key-mykey = <root_key>-mykey
                                                %control = VALUE #(
                                                             begin_date = if_abap_behv=>mk-on
                                                             end_date   = if_abap_behv=>mk-on ) ) )
        RESULT DATA(lt_travel_result).

    LOOP AT lt_travel_result INTO DATA(ls_travel_result).
*    　開始日付は終了日付より遅くすることをチェック
      IF  ls_travel_result-end_date < ls_travel_result-begin_date.
        APPEND VALUE #( %key = ls_travel_result-%key
                        mykey = ls_travel_result-mykey ) TO failed-travel.

        APPEND VALUE #( %key = ls_travel_result-%key
                        %msg = new_message(
                                 id = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgid
                                 number = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgno
                                 v1 = ls_travel_result-begin_date
                                 v2 = ls_travel_result-end_date
                                 v3 = ls_travel_result-travel_id
                                 severity = if_abap_behv_message=>severity-error )
                        %element-begin_date = if_abap_behv=>mk-on
                        %element-end_date = if_abap_behv=>mk-on ) TO reported-travel .
*     開始日付は本日以降のチェック
      ELSEIF ls_travel_result-begin_date < cl_abap_context_info=>get_system_date(  ).
        APPEND VALUE #( %key = ls_travel_result-%key
                        mykey = ls_travel_result-mykey ) TO failed-travel.

        APPEND VALUE #( %key = ls_travel_result-%key
                        %msg = new_message(
                                 id = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgid
                                 number = /dmo/cx_flight_legacy=>end_date_before_begin_date-msgno
                                 severity = if_abap_behv_message=>severity-error  )
                        %element-begin_date = if_abap_behv=>mk-on
                        %element-end_date = if_abap_behv=>mk-on ) TO reported-travel .
      ENDIF.
    ENDLOOP.

  ENDMETHOD.

  METHOD validateAgency.
*  対象データの取得
    READ ENTITY zi_travel_m_103 FROM VALUE #(
        FOR <root_key> IN keys ( %key-mykey = <root_key>-mykey
                                 %control = VALUE #( agency_id = if_abap_behv=>mk-on ) ) )
         RESULT DATA(lt_travel).

    DATA lt_agency TYPE SORTED TABLE OF /dmo/agency WITH UNIQUE KEY agency_id.
    lt_agency = CORRESPONDING #( lt_travel DISCARDING DUPLICATES MAPPING agency_id = agency_id EXCEPT * ).
    DELETE lt_agency WHERE agency_id IS INITIAL.
    CHECK lt_agency IS NOT INITIAL.

    SELECT FROM /dmo/agency
    FIELDS agency_id
       FOR ALL ENTRIES IN @lt_agency
     WHERE agency_id = @lt_agency-agency_id
      INTO TABLE @DATA(lt_agency_db).

*  入力したagencyの存在チェック
    LOOP AT lt_travel INTO DATA(ls_travel).
      IF ls_travel-agency_id IS NOT INITIAL AND
         NOT LINE_exists( lt_agency_db[ agency_id = ls_travel-agency_id ] ).

*        エラーリストを追加する
         APPEND VALUE #( mykey = ls_travel-agency_id ) to failed-travel.

*        エラー結果の出力
         append VALUE #( mykey = ls_travel-agency_id
                         %msg = new_message(
                            id = /dmo/cx_flight_legacy=>agency_unkown-msgid
                            number = /dmo/cx_flight_legacy=>agency_unkown-msgno
                            v1 = ls_travel-agency_id
                            severity = if_abap_behv_message=>severity-error )
                         %element-agency_id = if_abap_behv=>mk-on ) to reported-travel.
      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
