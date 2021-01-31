connection: "snowlooker"

# include all the views
include: "/views/**/*.view"

datagroup: yokoyama1_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

datagroup: default {
    sql_trigger: select current_date;;
    max_cache_age: "24 hours"
}

datagroup: order_items {
    sql_trigger: select max(created_at) from order_items ;;
    max_cache_age: "4 hours"
}
persist_with: yokoyama1_default_datagroup

explore: distribution_centers {}

explore: etl_jobs {}

explore: events {
    join: users {
        type: left_outer
        sql_on: ${events.user_id} = ${users.id} ;;
        relationship: many_to_one
    }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  # ----- exercise -----
  sql_always_where: ${order_items.returned_date} IS NULL ;;
  sql_always_having: ${order_items.total_sales} > 200 ;;
  # sql_always_where: ${order_items.status} = 'complete' ;;
  # sql_always_having: ${order_items.count} > 5000 ;;
  conditionally_filter: {
      filters: {
        field: users.created_date
        value: "last 90 days"
      }
      unless: [users.id, users.state]
  }
  persist_with: order_items
}

explore: products {
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: users {
    # ----- exercise -----
    join: order_items {
        type: left_outer
        sql_on: ${users.id} = ${order_items.user_id} ;;
        relationship: one_to_many
    }
    always_filter: {
        filters: {
            field: order_items.created_date
            value: "before today"
        }
    }
    persist_with: default
}
