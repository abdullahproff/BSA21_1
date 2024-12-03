SELECT 
    buyers.surname AS Покупатели,
    products.product_name AS Товары,
    best_actions.action_name AS Акции,
    baskets.basket_status AS Статус_корзины,
    baskets.basket_quantity AS Количество_товаров,
    products.product_cost AS Стоимость_товаров,
    baskets.basket_cost AS Общая_стоимость_корзины
FROM 
    baskets
JOIN 
    buyers ON baskets.buyer_id = buyers.buyer_id
JOIN 
    baskets_to_products ON baskets.basket_id = baskets_to_products.basket_id
JOIN 
    products ON baskets_to_products.product_id = products.product_id
LEFT JOIN 
    products_to_actions ON products.product_id = products_to_actions.product_id
LEFT JOIN 
    best_actions ON products_to_actions.best_action_id = best_actions.best_action_id;
