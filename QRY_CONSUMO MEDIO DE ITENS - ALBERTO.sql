select 
--'30dias' as 'periodo',
--t1.U_UPItmCod AS 'CodItem',
--t2.U_UPDatLib,
SUM(t1.U_UPQtdPla*100) / count(distinct day(t2.U_UPDatLib)) as 'MEDIA',
count(distinct day(t2.U_UPDatLib) ) AS DIAS
--t1.U_UPQtdPla


 from "@UPR_WOR1" T1
	INNER JOIN "@UPR_OWOR" T2 ON (T2.DocNum = t1.DocEntry)

	where  t1.U_UPItmCod =    'MAP000006'	--@itemcod
	--and t2.U_UPStatus = 'R'

and cast(t2.U_UPDatLib as date) BETWEEN '2019-02-04' AND '2019-02-08'    --*/ >= cast(getdate()-31 as date)


--order by t1.U_UPItmCod desc
--group by t1.U_UPItmCod,t1.U_UPQtdPla,t2.U_UPDatLib ORDER BY 1 DESC



