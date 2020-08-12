-- SQL OFICIAL  
WITH 
-- ########################################### RASTREABILIDADE DE ITEM 1 ###########################################
rastreabilidade_item 
AS (SELECT DISTINCT 1                                    AS num_bloco, 
                    'Entrada PA'                         AS nome_bloco, 
                    T1.docentry                          AS 'NumEntradaPA', 
                    t1.baseref                           AS 'NumOP', 
                    t2.itemcode                          AS 'ItemPai', 
                    t2.prodname                          AS 'NomeProduto', 
                    t1.uomcode                           AS 'UM', 
                    t5.distnumber                        AS 'Lote', 
                    t5.status                            AS 'Status', 
                    t5.mnfdate                           AS 'DataFabricacao', 
                    t5.expdate                           AS 'DataVencimento', 
                    t1.quantity                          AS 'QtdEntradaPA', 
                    (SELECT Sum(TT10.docqty) 
                     FROM   oitl TT10 
                     WHERE  TT10.itemcode = t2.itemcode --'PRD000001'   
                            AND TT10.docnum = T1.docentry 
                            AND TT10.basetype = '202')   AS 'TotalEntradaPA', 
                    t6.itemcode                          AS 'CodMP', 
                    (SELECT tt6.itemname 
                     FROM   oitm tt6 
                     WHERE  tt6.itemcode = t6.itemcode)  AS NomeItem, 
                    T10.distnumber                       AS 'LoteMP', 
                    (SELECT top 1 Max(x1.docentry) AS 'NumFichaLiberacao' 
                     FROM   "@xnet_om_osid" x1 
                     WHERE  x1.u_om_itemcode = t6.itemcode) AS FichaOpen, 
                    t11.docnum                           AS 'NumSaidaInsumo', 
                    t10.sysnumber                        AS 'NumSistema', 
                    t9.quantity                          AS 'QtdSaida', 
                    t7.quantity                          AS 'Total Saida' 
    FROM   ign1 T1 -- linhas entrada de PA  
           INNER JOIN owor T2 WITH(nolock) 
                   ON ( T2.docentry = t1.baseentry 
                        AND t2.objtype = t1.basetype 
                        AND t2.objtype = '202' ) 
           INNER JOIN oitl T3 WITH(nolock) 
                   ON T1.docentry = T3.applyentry 
                      AND T1.linenum = T3.applyline 
                      AND T3.applytype = 59 
                      AND T3.doctype = T1.objtype 
           INNER JOIN itl1 T4 WITH(nolock) 
                   ON T4.logentry = T3.logentry 
           INNER JOIN obtn T5 WITH(nolock) 
                   ON T4.mdabsentry = T5.absentry 
                      AND T3.itemcode = T5.itemcode 
           INNER JOIN wor1 t6 WITH(nolock) 
                   ON ( t6.docentry = t2.docentry 
                        AND t6.docentry = t1.baseentry 
                        AND t6.issuetype = 'M' ) 
           INNER JOIN ige1 t7 WITH(nolock) 
                   ON ( t7.baseref = t2.docentry 
                        AND t7.baseline = t6.linenum ) -- Saida de insumos  
           INNER JOIN oige t11 WITH(nolock) 
                   ON T7.docentry = T11.docentry -- Saida de insumos  
           --Lote MP  
           INNER JOIN oitl T8 WITH(nolock) 
                   ON T7.docentry = T8.docentry 
                      AND T7.linenum = T8.docline 
                      AND T7.objtype = T8.doctype 
           INNER JOIN itl1 T9 WITH(nolock) 
                   ON T9.logentry = T8.logentry 
           INNER JOIN obtn T10 WITH(nolock) 
                   ON T9.mdabsentry = T10.absentry 
                      AND T8.itemcode = T10.itemcode 

    WHERE  t2.itemcode =           -- INFORMAR PARAMETRO CODIGO DO ITEM QUE ESTA PROCURANDO
           AND t5.distnumber =    -- PARAMETRO LOTE  DO ITEM

   ), 
     rastreabilidade_sef_1 
     AS ( 
        -- ########################################### RASTREABILIDADE DE SEF NIVEL 1 ###########################################
        SELECT DISTINCT 2                                    AS num_bloco, 
                        'SEF NIVEL 1'                        AS NOME_BLOCO, 
                        T1.docentry                          AS 'NumEntradaPA', 
                        t1.baseref                           AS 'NumOP', 
                        t2.itemcode                          AS 'ItemPai', 
                        t2.prodname                          AS 'NomeProduto', 
                        t1.uomcode                           AS 'UM', 
                        t5.distnumber                        AS 'Lote', 
                        t5.status                            AS 'Status', 
                        t5.mnfdate                           AS 'DataFabricacao' 
                        , 
                        t5.expdate 
                        AS 'DataVencimento', 
                        t1.quantity                          AS 'QtdEntradaPA', 
                        (SELECT Sum(TT10.docqty) 
                         FROM   oitl TT10 
                         WHERE  TT10.itemcode = t12.codmp 
                                AND TT10.docnum = T1.docentry 
                                AND TT10.basetype = '202')   AS 'TotalEntradaPA' 
                        , 
                        t6.itemcode 
                        AS 'CodMP', 
                        (SELECT tt6.itemname 
                         FROM   oitm tt6 
                         WHERE  tt6.itemcode = t6.itemcode)  AS NomeItem, 
                        T10.distnumber                       AS 'LoteMP', 
                        (SELECT top 1 Max(x1.docentry) AS 'NumFichaLiberacao' 
                         FROM   "@xnet_om_osid" x1 
                         WHERE  x1.u_om_itemcode = t6.itemcode) AS FichaOpen, 
                        t11.docnum                           AS 'NumSaidaInsumo' 
                        , 
                        t10.sysnumber 
                        AS 'NumSistema', 
                        t9.quantity                          AS 'QtdSaida', 
                        t7.quantity                          AS 'Total Saida' 
         FROM   ign1 T1 -- linhas entrada de PA  
                INNER JOIN owor T2 WITH(nolock) 
                        ON ( T2.docentry = t1.baseentry 
                             AND t2.objtype = t1.basetype 
                             AND t2.objtype = '202' ) 
                INNER JOIN oitl T3 WITH(nolock) 
                        ON T1.docentry = T3.applyentry 
                           AND T1.linenum = T3.applyline 
                           AND T3.applytype = 59 
                           AND T3.doctype = T1.objtype 
                INNER JOIN itl1 T4 WITH(nolock) 
                        ON T4.logentry = T3.logentry 
                INNER JOIN obtn T5 WITH(nolock) 
                        ON T4.mdabsentry = T5.absentry 
                           AND T3.itemcode = T5.itemcode 
                INNER JOIN wor1 t6 WITH(nolock) 
                        ON ( t6.docentry = t2.docentry 
                             AND t6.docentry = t1.baseentry 
                             AND t6.issuetype = 'M' ) 
                INNER JOIN ige1 t7 WITH(nolock) 
                        ON ( t7.baseref = t2.docentry 
                             AND t7.baseline = t6.linenum ) -- Saida de insumos  
                INNER JOIN oige t11 WITH(nolock) 
                        ON T7.docentry = T11.docentry -- Saida de insumos  
                --Lote MP  
                INNER JOIN oitl T8 WITH(nolock) 
                        ON T7.docentry = T8.docentry 
                           AND T7.linenum = T8.docline 
                           AND T7.objtype = T8.doctype 
                INNER JOIN itl1 T9 WITH(nolock) 
                        ON T9.logentry = T8.logentry 
                INNER JOIN obtn T10 WITH(nolock) 
                        ON T9.mdabsentry = T10.absentry 
                           AND T8.itemcode = T10.itemcode 
                INNER JOIN rastreabilidade_item t12 
                        ON t12.codmp = t2.itemcode 
                           AND t12.lotemp = t5.distnumber 
                           AND Substring(T12.codmp, 1, 3) = 'SEF') SELECT * 
FROM   rastreabilidade_item 
UNION ALL 
SELECT * 
FROM   rastreabilidade_sef_1 