    SELECT s.PRODUTO AS "reference_code",
           s.ESTOQUE AS "store_reference_code", -- loja do pedido 
           s.ESTOQUE_ATUAL AS "stock", -- estoque da loja do pedido 
           CASE
             WHEN s.ESTOQUE = 2 THEN
              ((SELECT ESTOQUE_ATUAL * 0.8
                  FROM produtos_estoques
                 WHERE PRODUTO = s.PRODUTO
                   AND ESTOQUE = 1) +
              (SELECT ESTOQUE_ATUAL * 0.8
                  FROM produtos_estoques
                 WHERE PRODUTO = s.PRODUTO
                   AND ESTOQUE = 5) +
              (SELECT ESTOQUE_ATUAL * 0.8
                  FROM produtos_estoques
                 WHERE PRODUTO = s.PRODUTO
                   AND ESTOQUE = 18))
             WHEN s.ESTOQUE = 12 THEN
              ((SELECT ESTOQUE_ATUAL * 0.8
                  FROM produtos_estoques
                 WHERE PRODUTO = s.PRODUTO
                   AND ESTOQUE = 1) +
              (SELECT ESTOQUE_ATUAL * 0.8
                  FROM produtos_estoques
                 WHERE PRODUTO = s.PRODUTO
                   AND ESTOQUE = 2) +
              (SELECT ESTOQUE_ATUAL * 0.8
                  FROM produtos_estoques
                 WHERE PRODUTO = s.PRODUTO
                   AND ESTOQUE = 5) +
              (SELECT ESTOQUE_ATUAL * 0.8
                  FROM produtos_estoques
                 WHERE PRODUTO = s.PRODUTO
                   AND ESTOQUE = 18))
             ELSE
              0
           END AS "warehouse_stock",
           MAX(r.DATA_PROC) AS dt_ultima_atualizacao
      FROM produtos_estoques s
      LEFT JOIN logestoques r
        ON r.PRODUTO = s.PRODUTO
       AND r.ESTOQUE = s.ESTOQUE
    --WHERE s.produto = 21938
     WHERE r.data_proc >= sysdate - INTERVAL '17' HOUR
     GROUP BY s.PRODUTO, s.ESTOQUE, s.ESTOQUE_ATUAL
     ORDER BY 2 ASC
