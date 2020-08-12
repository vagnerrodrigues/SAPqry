SELECT     Min(b.logentry)   AS logentry, 
           Min(b.itemcode)   AS [ItemCode], 
           Min(c.distnumber) AS [BatchNum], 
           Min(b.loccode)    AS [WhsCode], 
           Min(b.itemname)   AS [ItemName], 
           Min(b.applytype)  AS [BaseType], 
           Min(b.applyentry) AS [BaseEntry], 
           Min(d.docentry)   AS [NF], 
           Min(b.appdocnum)  AS [BaseNum], 
           Min(b.applyline)  AS [BaseLinNum], 
           Min(b.docdate)    AS [DocDate], ( 
           CASE 
                      WHEN Abs(Sum(a.quantity)) = 0 THEN Sum(a.allocqty) 
                      ELSE Abs(Sum(a.quantity)) 
           END )           AS [Quantity], 
           Min(a.allocqty) AS qtdsaida, 
           Min(b.cardcode) AS [CardCode], 
           Min(b.cardname) AS [CardName], ( 
           CASE 
                      WHEN Sum(a.quantity) > 0 THEN 0 
                      WHEN Sum(a.quantity) < 0 THEN 1 
                      ELSE 2 
           END )             AS [Direction], 
           Min(b.createdate) AS [CreateDate], 
           Min(b.basetype)   AS [BsDocType], 
           Min(b.baseentry)  AS [BsDocEntry], 
           Min(b.baseline)   AS [BsDocLine], 
           'N'               AS [DataSource], 
           NULL              AS [UserSign] 
FROM       itl1 a 
INNER JOIN oitl b 
ON         a.logentry = b.logentry 
INNER JOIN obtn c 
ON         a.itemcode = c.itemcode 
AND        a.sysnumber = c.sysnumber 
AND        c.absentry = a.mdabsentry 
INNER JOIN inv1 d 
ON         d.baseentry = b.applyentry 
WHERE      b.itemcode =   -- INFORMAR PARAMETRO CODIGO DO ITEM QUE ESTA PROCURANDO 
and        c.distnumber = -- PARAMETRO LOTE  DO ITEM 
AND        b.stockeff = 2 
GROUP BY   b.itemcode, 
           a.sysnumber, 
           b.applytype, 
           b.applyentry, 
           b.applyline, 
           b.loccode, 
           b.stockeff 
HAVING     ( 
                      sum(b.docqty) <> 0)