select  
	   
	   T1.CardCode AS 'CodCLiente',				
	   T1.CardName as 'Nome Cliente', 
	   T1.AliasName AS 'Fantasia',
	   T5.GroupName AS 'Ramo Atividade',
	   T1.City  AS 'Cidade',
	   T1.State1 AS 'Estado',
	   T1.Block as 'Bairro',
	   t1.StreetNo as 'Numero',
	   t1.ZipCode as 'Cep',
	   (Select distinct top 20 sum(t10.doctotal) as Total 
				from OINV t10
					where 
					t10.CardCode = t1.CardCode
					and t10.canceled <> 'C' and t10.model = '39' order by 1 desc) as 'TotalFat',

	   case when t1.validFor = 'Y' then 'Ativo' 
			when t1.validFor = 'N' then 'Inativo' 
	        end as 'Situacao'
from ocrd T1
	inner join OSLP T2 ON (T1.SlpCode = T2.SlpCode)
	inner join OTER T3 ON (T1.Territory = T3.territryID)
	inner join CRD7 T4 ON (t4.CardCode = t1.CardCode and t4.Address = '')
	inner join ocrg T5 ON (T5.GroupCode = T1.GroupCode)
	left join crd1 T6 ON (T6.CardCode = T1.CardCode AND  t6.U_RSD_ENDALTER = 'S')  -- endereço entrega 


	where t1.CardCode like ('%CLI%')
	AND t1.validFor = 'Y'


order by 5,10 desc



