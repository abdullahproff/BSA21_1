SELECT 
    buyers.surname AS Покупатели,
    products.product_name AS Товары,
    best_actions.action_name AS Акции,
    baskets.basket_status AS Статус_корзины,
    baskets.basket_quantity AS Количество_товаров,
    (products.product_cost * baskets.basket_quantity) AS Стоимость_товаров,
    baskets.basket_cost AS Общая_стоимость_корзины
FROM 
    baskets
JOIN 
    buyers ON baskets.buyer_id = buyers.buyer_id
JOIN 
    basket_to_products ON baskets.basket_id = basket_to_products.basket_id
JOIN 
    products ON basket_to_products.product_id = products.product_id
LEFT JOIN 
    product_to_actions ON products.product_id = product_to_actions.product_id
LEFT JOIN 
    best_actions ON product_to_actions.best_action_id = best_actions.best_action_id;