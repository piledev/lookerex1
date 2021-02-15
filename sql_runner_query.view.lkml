view: sql_runner_query {
  derived_table: {
    sql: select
        date(a.created_at) as created_date,
        b.state,
        count(distinct a.id) as order_count
      from order_items a
      inner join users b
      on a.user_id = b.id
      where created_date between '2020-09-01' and '2020-09-30'
      and b.state like 'A%'
      group by 1,2
      order by 1,2,3
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: created_date {
    type: date
    sql: ${TABLE}."CREATED_DATE" ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}."STATE" ;;
  }

  dimension: order_count {
    type: number
    sql: ${TABLE}."ORDER_COUNT" ;;
  }

  set: detail {
    fields: [created_date, state, order_count]
  }
}
