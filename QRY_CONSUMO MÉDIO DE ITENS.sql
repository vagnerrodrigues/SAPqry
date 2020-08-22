--QRY OFICIAL 

select 
	  count(distinct day(t2.DocDate)) as 'dias',
	  SUM(t2.Quantity*100) /  count(distinct day(t2.DocDate)) as 'Media',
	  SUM(t2.Quantity) as 'QtdAcumulada',
	   t2.ItemCode as 'CodItem',
	   t2.Dscription as 'NomeItem'


from OIGE T1
	 INNER JOIN IGE1 T2 ON (T2.DocEntry = t1.DocNum)
	 INNER JOIN "@UPR_OWOR" T3 ON (T3.DocNum = T1.Ref2)

where 
		t2.ItemCode = 'MAP000006'

--and cast(t2.DocDate as date) >= cast(getdate()-4 as date)
and t2.docdate between '2019-03-12'  and '2019-03-19' 


group by  
	t2.ItemCode, 
	t2.Dscription 



	--select DISTINCT T1.ItemCode, T1.ItemName from oitm T1 where SUBSTRING (T1.ItemCode, 1, 3) IN ('MAP', 'EMB', 'REV') ORDER BY T1.ItemCode 

