-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BENEFICIARIOSINVERLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BENEFICIARIOSINVERLIS`;DELIMITER $$

CREATE PROCEDURE `BENEFICIARIOSINVERLIS`(
    Par_InversionID     int (11),
    Par_NombreComp      varchar(100),
    Par_NumLis          tinyint unsigned ,

	Aud_EmpresaID       int,
	Aud_Usuario         int,
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int,
	Aud_NumTransaccion  bigint

)
TerminaStore: BEGIN

DECLARE		Cadena_Vacia        char(1);
DECLARE		Fecha_Vacia         date;
DECLARE		Entero_Cero         int;
DECLARE		Lis_Principal       int;
DECLARE		Lis_Beneficiarios   int;
DECLARE 	Lis_Inversiones		int;
DECLARE		Esta_Vigente		char(1);

Set	Cadena_Vacia        := '';
Set	Fecha_Vacia         := '1900-01-01';
Set	Entero_Cero         := 0;
Set	Lis_Principal       := 1;
Set	Lis_Beneficiarios   := 2;
set Lis_Inversiones		:= 3;
set Esta_Vigente		:= 'N';


if(Par_NumLis = Lis_Principal) then
	select Ben.BenefInverID, case when Ben.NombreCompleto is null
									then Cli.NombreCompleto
								else Ben.NombreCompleto end as NombreCompleto
	from    BENEFICIARIOSINVER Ben
		left join 	CLIENTES Cli on Cli.ClienteID = Ben.ClienteID
	where  Ben.InversionID = Par_InversionID
	and case when Ben.ClienteID  >0 then
			Cli.NombreCompleto like concat("%", Par_NombreComp, "%")
		else
			Ben.NombreCompleto like concat("%", Par_NombreComp, "%")
		end
	limit 0, 15;
end if;

if(Par_NumLis = Lis_Beneficiarios) then
		Select	Ben.BenefInverID,	Ben.InversionID,	Ben.ClienteID, case when ifnull(Ben.ClienteID,Entero_Cero)  > Entero_Cero then
					Cli.NombreCompleto else Ben.NombreCompleto end as NombreCompleto,
				Ben.TipoRelacionID, Rel.Descripcion as 	DescripParentesco,
				Ben.Porcentaje
	from		BENEFICIARIOSINVER Ben
	left  join TIPORELACIONES Rel	on 	Rel.TipoRelacionID = Ben.TipoRelacionID
	left Join CLIENTES Cli on Cli.ClienteID = Ben.ClienteID
	where		Ben.InversionID =Par_InversionID;
end if;


if(Par_NumLis = Lis_Inversiones)then
	drop table if exists TMPINVER;
	create temporary  table TMPINVER(ClienteID int(11), NombreCompleto varchar(200), InversionID int(11), Porcentaje  decimal(12,2), Monto decimal(14,2));
		insert into TMPINVER( ClienteID, NombreCompleto, InversionID, Porcentaje, Monto)
			select inv.ClienteID, cli.NombreCompleto, ben.InversionID,ben.Porcentaje, inv.Monto as Monto
				from  INVERSIONES inv
				inner join CLIENTES cli on inv.ClienteID = cli.ClienteID
				inner join BENEFICIARIOSINVER  ben on inv.InversionID = ben.InversionID and inv.Estatus = Esta_Vigente
				inner join CLIENTES cli2 on ben.ClienteID = cli2.ClienteID and cli2.NombreCompleto = Par_NombreComp;
		insert into TMPINVER( ClienteID, NombreCompleto, InversionID, Porcentaje, Monto)
			select inv.ClienteID, cli.NombreCompleto, ben.InversionID,ben.Porcentaje, inv.Monto as Monto
				from  INVERSIONES inv
				inner join CLIENTES cli on inv.ClienteID = cli.ClienteID
				inner join BENEFICIARIOSINVER  ben on inv.InversionID = ben.InversionID and inv.Estatus = Esta_Vigente and  ben.NombreCompleto = Par_NombreComp;
	select ClienteID, NombreCompleto, InversionID, Porcentaje, format(Monto,2) as Monto  from TMPINVER;

end if;

END TerminaStore$$