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
        ),

        c as (
        select distinct
          date(created_at) as created_date
        from order_items
        where created_date between '2020-09-01' and '2020-09-30'
        )

        select
          a.created_date,
          a.state,
          a.order_count
        from c
        left join a
          on a.created_date = c.created_date
        inner join b
          on b.created_date = a.created_date
          and b.order_count = a.order_count
        order by created_date,state

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
