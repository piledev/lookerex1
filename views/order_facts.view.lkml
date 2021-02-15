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
        where b.state like 'A%'
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
        ),

        d as (
          select
            created_date,
            state,
            order_count
          from a
          where order_count > 5
        )

        select distinct
          b.created_date,
          b.order_count,
          d.state,
          d.order_count as order_count_over5
        from c
        left join a
          on a.created_date = c.created_date
        inner join b
          on b.created_date = a.created_date
          and b.order_count = a.order_count
        left join d
          on d.created_date = a.created_date
          and d.state = a.state
        order by 1,2
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

  dimension: order_count_over5 {
    type: number
    sql: ${TABLE}."ORDER_COUNT_OVER5" ;;
  }

  measure: max_order_count {
    type: max
    sql: ${order_count} ;;
  }

  measure: max_order_count_over5_Alabama {
    type: max
    label: "Alabama"
    sql: ${order_count_over5} ;;
    filters: {
      field: state
      value: "Alabama"
    }
  }

  measure: max_order_count_over5_Arizona {
    type: max
    label: "Arizona"
    sql: ${order_count_over5} ;;
    filters: {
      field: state
      value: "Arizona"
    }
  }

  set: detail {
    fields: [created_date, state, order_count, order_count_over5]
  }
}
