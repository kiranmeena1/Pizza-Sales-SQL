--  1. Retrieve the total number of orders placed.
select 
count(order_id) as total_orders 
from orders;


--  Calculate the total revenue generated from pizza sales.
select 
round(sum(p.price*o.quantity),2)
as total_revenue
from pizzas as p
join order_details as o
on p.pizza_id=o.pizza_id;

-- 3 Identify the highest-priced pizza.
select pizza_types.name ,pizzas.price
from pizzas join pizza_types
on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by pizzas.price desc limit 1;


-- 4 Identify the most common pizza size ordered.
select pizzas.size,count(order_details.order_details_id) 
as order_count 
from pizzas
join order_details
on pizzas.pizza_id=order_details.pizza_id
group by  pizzas.size order by order_count  desc limit 1;

-- 5 List the top 5 most ordered pizza types along with their quantities.
select pt.name ,sum(o.quantity) 
from pizza_types as pt
join pizzas as p
on p.pizza_type_id=pt.pizza_type_id
join order_details as o
on p.pizza_id=o.pizza_id
group by pt.name 
order by count(o.quantity) desc limit 5 ;
 
 -- intermediate
-- 6 join the necessary tables to find the total quantity of each pizza category ordered.
 select pt.category,sum(o.quantity) as total_quantity 
 from pizza_types as pt
 join pizzas as p 
 on p.pizza_type_id=pt.pizza_type_id
 join order_details as o 
 on p.pizza_id=o.pizza_id
 group by pt.category;
 
 -- 7 Determine the distribution of orders by hour of the day.
 select hour(order_time) as hours,
 count(order_id) as order_count
 from orders 
 group by hours;
 
 -- 8 Join relevant tables to find the category-wise distribution of pizzas.
 select  category,count(name) 
 from pizza_types
 group by category;
 
 -- 9 Group the orders by date and calculate the average number of pizzas ordered per day.
 select round(avg(quantity),0) as avg_pizza_order
 from (select o1.order_date as days, sum(o2.quantity) as quantity
 from orders as o1 
 join order_details as o2
 on o1.order_id=o2.order_id
 group by o1.order_date) as order_quantity ;
 
 
 -- 10 Determine the top 3 most ordered pizza types based on revenue.
 select pt.name, sum(p.price* o.quantity) as total_revenue
 from pizzas as p
 join pizza_types as pt
 on p.pizza_type_id=pt.pizza_type_id
 join order_details as o
 on o.pizza_id=p.pizza_id
 group by pt.name  order by total_revenue desc limit 3 ;

-- Advanced:
-- 11 Calculate the percentage contribution of each pizza type to total revenue.
 
select pt.category ,round((sum(p.price* o.quantity)/(select round(sum(p.price* o.quantity),2) 
as total_revenue
from pizzas as p
join order_details as o
on o.pizza_id=p.pizza_id))*100,2) as revenue
from pizzas as p
join pizza_types as pt
on p.pizza_type_id=pt.pizza_type_id
join order_details as o
on o.pizza_id=p.pizza_id
group by pt.category ;
 
 -- 12  Analyze the cumulative revenue generated over time.
select order_date,sum(revenue) over(order by order_date) as cum_revenue
from (select ORDERS.ORDER_DATE, round(sum(p.price* o.quantity),2) as revenue 
from pizzas as p
join order_details as o
on o.pizza_id=p.pizza_id
JOIN ORDERS 
ON  ORDERS.ORDER_ID=O.ORDER_ID
GROUP BY ORDERS.ORDER_DATE) AS sales;
 
 -- 13 Determine the top 3 most ordered pizza types based on revenue for each pizza category
 
 select category,name, revenue from 
 (select category,name ,revenue,rank() over(partition by category order by revenue desc) as rn
 from (select pt.category,pt.name, round(sum(p.price* o.quantity),2) as revenue
 from pizza_types as pt
 join pizzas as p
 on p.pizza_type_id=pt.pizza_type_id
 join order_details as o
 on p.pizza_id =o.pizza_id
 group by pt.category,pt.name)
 as a) as b
 where rn<=3;
