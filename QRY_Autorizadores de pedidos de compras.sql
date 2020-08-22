create view Registro_Autorizacoes_Compras as


with
AutorizacaoNota as (
select  
a.WddCode as 'CodigoAutorizacao',
a.DocEntry as 'NuDocAutorizador',
e.DocNum as 'NumPedidoCompra', 
b.U_NAME as 'Autor',
convert(varchar,a.CreateDate,103) as 'Criado_em',

case when len(a.CreateTime) = 4 
then SUBSTRING(convert(varchar,a.CreateTime),1,2) + ':' + SUBSTRING(convert(varchar,a.CreateTime),3,4) 
when len(a.CreateTime) = 3 
then SUBSTRING(convert(varchar,a.CreateTime),1,1) + ':' + SUBSTRING(convert(varchar,a.CreateTime),2,3) 
end as 'Hora_criado',
d.U_Name as 'Autorizador',

convert(varchar,c.UpdateDate,103) as 'Autorizado_em',

case when len(c.UpdateTime) = 4 
then SUBSTRING(convert(varchar,c.UpdateTime),1,2) + ':' + SUBSTRING(convert(varchar,c.UpdateTime),3,4) 
when len(c.UpdateTime) = 3 
then SUBSTRING(convert(varchar,c.UpdateTime),1,1) + ':' + SUBSTRING(convert(varchar,c.UpdateTime),2,3) 
end as 'Hora_Autorizado',

CASE when c.Status = 'Y' then 'Autorizado' when c.Status = 'N' then 'Pendente' else 'Cancelado'end 'Status_Autorizador',
c.Remarks as 'Obs'

from owdd a 
join OUSR b on(a.UserSign = b.USERID)
join WDD1 c on(a.WddCode = c.WddCode)
join OUSR d on(c.UserID = d.USERID)
 left join opor e on (e.DocEntry = a.DocEntry) 
 
where a.ObjType = '22' 
and c.UpdateDate <> ''
)
select a.* from AutorizacaoNota a

