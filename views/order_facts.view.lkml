view: order_facts{
  derived_table: {
    sql:
        with a as (
        select
          date(a.created_at) as created_date,
          b.state,
          count(distinct a.id) as order_count
        from order_items a
        inner join users b
          on a.user_id = b.id
        where created_date between '2020-09-01' and '2020-09-30'
          and b.state like 'A%'
        group by 1,2
        ),

        b as (
        select
          created_date,
          max(order_count) as order_count
        from a
        group by created_date
        )

        select
          a.created_date,
          a.state,
          a.order_count
        from a
        inner join b
        on a.created_date = b.created_date
        and a.order_count = b.order_count
        order by created_date

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

  measure: max_order_count {
    type: max
    sql: ${order_count} ;;
  }

  set: detail {
    fields: [created_date, state, order_count]
  }
}
