-- 1. Вывести все параметры, относящиеся к покупкам, которые совершал Calvin Potter
SELECT *
FROM coffe_shop.sales s
WHERE customer_name = 'Calvin Potter';

-- 2. Посчитать средний чек покупателей по дням
SELECT  
transaction_date,                    -- Дата транзакции
AVG(unit_price*quantity) AS avg_bill          -- Нахождение среднего значения чека
FROM coffe_shop.sales s
GROUP BY transaction_date            -- Группировка значений по дате
ORDER BY transaction_date ASC;       -- Сортировка значений по дате

-- 3. Преобразуйте дату транзакции в нужный формат: год, месяц, день. 
-- Приведите названия продуктов к стандартному виду в нижнем регистре
SELECT 
    transaction_date,                                       -- Дата транзакции
    EXTRACT(YEAR FROM transaction_date) AS trans_year,      -- Год отдельно
    EXTRACT(MONTH FROM transaction_date) AS trans_month,    -- Месяц отдельно
    EXTRACT(DAY FROM transaction_date) AS trans_day,        -- День отдельно
    LOWER(product_name) AS product_name                     -- Название продукта в нижнем регистре

FROM coffe_shop.sales;

-- 4. Сделать анализ покупателей и разделить их по категориям.
-- Посчитать количество транзакций, сделанных каждым покупателем.
-- Разделить их на категории: Частые гости (>= 23 транзакций), Редкие посетители (< 10 транзакций),
-- Стандартные посетители (все остальные)
SELECT 
     customer_id, 
     customer_name,      -- покупатель
     count(transaction_id) as transactions,    -- количество транзакций, совершенных покупателем
     CASE WHEN count(transaction_id) >= 23 THEN 'Частый гость'     -- выбор категории в зависимости от количества транзакций
         WHEN count(transaction_id) < 10  THEN 'Редкий гость'
         ELSE 'Стандартный посетитель'
     END AS customer_category
FROM coffe_shop.sales s
WHERE customer_name IS NOT NULL
GROUP BY 1,2
ORDER BY 3 DESC, 1 DESC      -- обратнаяя сортировка по количеству транзакций

--5. Посчитать количество уникальных посетителей в каждом магазине каждый день
SELECT 
    transaction_date,       -- дата
    store_address,          -- магазин
    COUNT(DISTINCT customer_id) AS customers  -- количество уникальных посетителей
FROM coffe_shop.sales s 
GROUP BY store_address, transaction_date
ORDER BY store_address , transaction_date ASC; -- сортировка по адресу и дате
