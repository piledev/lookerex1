view: order_items {
  sql_table_name: "PUBLIC"."ORDER_ITEMS"
    ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}."ID" ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."CREATED_AT" ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."DELIVERED_AT" ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."INVENTORY_ITEM_ID" ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}."ORDER_ID" ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."RETURNED_AT" ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}."SALE_PRICE" ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}."SHIPPED_AT" ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}."STATUS" ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}."USER_ID" ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.first_name,
      users.last_name,
      users.id,
      inventory_items.id,
      inventory_items.product_name
    ]
  }

  # ----- excercise -----

  dimension: shipping_days {
      type: number
      sql: DATEDIFF(day, ${shipped_date}, ${delivered_date}) ;;
  }

  measure: order_count {
      description: "A count of unique orders"
      type: count_distinct
      sql: ${order_id} ;;
  }

  measure: total_sales {
      type: sum
      value_format_name: usd
      sql: ${sale_price} ;;
  }

  measure: average_sales {
      type: average
      sql: ${sale_price} ;;
  }

  measure: total_sales_email_users {
      type: sum
      sql: ${sale_price} ;;
      filters: {
          field: users.is_email_source
          value: "yes"
      }
  }

  measure: percentage_sales_email_source {
    type: number
    value_format_name: percent_2
    sql: 1.0+${total_sales_email_users}/NULLIF(${total_sales},0) ;;
  }

  measure: average_spend_per_user {
    type: number
    value_format_name: usd_0
    sql: 1.0 * ${total_sales} / NULLIF(${users.count},0) ;;
  }

  measure: total_sales_california {
    type: sum
    label: "California"
    value_format_name: usd_0
    sql: ${sale_price} ;;
    filters: {
      field: users.state
      value: "California"
    }
  }

  measure: total_sales_Texas {
    type: sum
    label: "Texas"
    value_format_name: usd_0
    sql: ${sale_price} ;;
    filters: {
      field: users.state
      value: "Texas"
    }
  }

  measure: total_sales_New_York {
    type: sum
    label: "New York"
    value_format_name: usd_0
    sql: ${sale_price} ;;
    filters: {
      field: users.state
      value: "New York"
    }
  }

  measure: total_sales_Illinois {
    type: sum
    value_format_name: usd_0
    sql: ${sale_price} ;;
    filters: {
      field: users.state
      value: "Illinois"
    }
  }

  measure: total_sales_Florida {
    type: sum
    label: "Florida"
    value_format_name: usd_0
    sql: ${sale_price} ;;
    filters: {
      field: users.state
      value: "Florida"
    }
  }

  measure: total_sales_Ohio {
    type: sum
    label: "Ohio"
    value_format_name: usd_0
    sql: ${sale_price} ;;
    filters: {
      field: users.state
      value: "Ohio"
    }
  }

  measure: total_sales_Arizona {
    type: sum
    label: "Arizona"
    value_format_name: usd_0
    sql: ${sale_price} ;;
    filters: {
      field: users.state
      value: "Arizona"
    }
  }



}
