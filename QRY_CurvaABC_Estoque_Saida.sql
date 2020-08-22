

Declare 
	@DateI DateTime, 
	@DateF DateTime
set @DateI = '2019-05-01'
set @DateF = '2019-07-22';

with CurvaAbcEstoque as (

SELECT 
@DateI as 'Data Inicio',
@DateF as 'Data Fim',
DATEDIFF (MONTH, @DateI , @DateF) as DiferençaMeses,
ROW_NUMBER() OVER (ORDER BY Sum(NullIf(T1.[Quantity],0)) DESC) as Seq,
(Select  Cast(Sum(V1.Quantity) as Int)
from IGE1 V1 Inner Join OIGE V0 on V1.DocEntry = V0.DocEntry and V0.CANCELED = 'N'  
Inner Join OITM M0 on V1.ItemCode = M0.ItemCode And M0.ItemCode Like ('P%') 

where v1.DocDate BETWEEN  @DateI /*data incio*/ 
and						  @DateF /*Data inicio*/
) AS QtdMovimentaTotal,   -- no periodo 

T1.[ItemCode], 
M0.ItemName,
Sum(Cast(T1.[Quantity] as Numeric(10,2))) as 'QtdSaida', 
Sum(Cast(T1.[Quantity] as Numeric(10,2)))/
(Select Cast(Sum(V1.Quantity) as Numeric(10,2))
	from IGE1 V1 Inner Join OIGE V0 on V1.DocEntry = V0.DocEntry and V0.CANCELED = 'N'
	
	Inner Join OITM M0 on V1.ItemCode = M0.ItemCode And M0.ItemCode Like ('P%') 
)*100 as 'Percentual%',


  CASE   
     WHEN ROW_NUMBER() OVER (ORDER BY (Sum(NullIf(T1.[Quantity],0)) ) DESC) <= ROUND(ROWCOUNT_BIG() * 20,0) THEN 'A'  
     WHEN ROW_NUMBER() OVER (ORDER BY (Sum(NullIf(T1.[Quantity],0)) ) DESC) 
	      Between ROUND(ROWCOUNT_BIG() * 21,0) and ROUND(ROWCOUNT_BIG() * 50,0) THEN 'B'  
     ELSE 'C'  
   END AS CurvaABC 

from IGE1 T1 
Inner Join OIGE T0 on T1.DocEntry = T0.DocEntry and T0.CANCELED = 'N'
Inner Join OITM M0 on T1.ItemCode = M0.ItemCode and M0.ItemCode Like ('P%') 

Group By 
T1.[ItemCode],
M0.ItemName
)


select t1.*, 
sum(t1.[Percentual%]) over (partition by t1.[Data Inicio] order by t1.[seq]  rows UNBOUNDED PRECEDING) as 'PercentAcumulado%' 
from CurvaAbcEstoque t1 
