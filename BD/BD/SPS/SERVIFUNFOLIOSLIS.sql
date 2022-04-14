-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SERVIFUNFOLIOSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SERVIFUNFOLIOSLIS`;DELIMITER $$

CREATE PROCEDURE `SERVIFUNFOLIOSLIS`(
	Par_ServiFunFolioID		int(11),
	Par_NombreCompleto		varchar(100),
	Par_ClienteID			int(11),
	Par_NumLis				tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario         	int,
	Aud_FechaActual     	DateTime,
	Aud_DireccionIP     	varchar(15),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)

	)
TerminaStore:BEGIN



DECLARE Lis_Principal		int;
DECLARE EstatusRechazado	char(1);
DECLARE EstatusPagado		char(1);
DECLARE EstatusAutorizado	char(1);
DECLARE EstatusCapturado	char(1);
DECLARE VarFamiliar			char(1);
DECLARE Lis_Autorizados		int;
DECLARE Entero_Cero 		int;

set Lis_Principal		:=1;
set EstatusRechazado	:='R';
set EstatusPagado		:='P';
set EstatusAutorizado	:='A';
set EstatusCapturado	:='C';
set VarFamiliar			:='F';
set Lis_Autorizados		:=2;
set Entero_Cero			:=0;

if(Par_NumLis = Lis_Principal)then
	select ServiFunFolioID,		Cli.NombreCompleto,
			case Ser.Estatus
				when EstatusCapturado then "CAPTURADO"
				when EstatusRechazado then "RECHAZADO"
				when EstatusAutorizado then "AUTORIZADO"
				when EstatusPagado then "PAGADO"
				end as  EstatusDescripcion
	from SERVIFUNFOLIOS Ser,
			CLIENTES Cli
	where  Cli.NombreCompleto like concat("%", Par_NombreCompleto, "%")
	and Ser.ClienteID = Cli.ClienteID
	order by Ser.Estatus=EstatusRechazado ,Ser.Estatus=EstatusPagado ,
			Ser.Estatus=EstatusAutorizado,Ser.Estatus=EstatusCapturado
	limit 15;

end if;

if(Par_NumLis = Lis_Autorizados)then
	IF IFNULL(Par_ClienteID,Entero_Cero)>Entero_Cero THEN
		select ServiFunFolioID,		Cli.NombreCompleto,
				case Ser.Estatus
					when EstatusCapturado then "CAPTURADO"
					when EstatusRechazado then "RECHAZADO"
					when EstatusAutorizado then "AUTORIZADO"
					when EstatusPagado then "PAGADO"
					end as  EstatusDescripcion
		from SERVIFUNFOLIOS Ser,
				CLIENTES Cli
		where  Cli.ClienteID=Par_ClienteID
		and Cli.NombreCompleto like concat("%", Par_NombreCompleto, "%")
		and Ser.ClienteID = Cli.ClienteID
		and Ser.Estatus =EstatusAutorizado
		and Ser.TipoServicio = VarFamiliar
		limit 15;
	ELSE
		select ServiFunFolioID,		Cli.NombreCompleto,
				case Ser.Estatus
					when EstatusCapturado then "CAPTURADO"
					when EstatusRechazado then "RECHAZADO"
					when EstatusAutorizado then "AUTORIZADO"
					when EstatusPagado then "PAGADO"
					end as  EstatusDescripcion
		from SERVIFUNFOLIOS Ser,
				CLIENTES Cli
		where  Cli.NombreCompleto like concat("%", Par_NombreCompleto, "%")
		and Ser.ClienteID = Cli.ClienteID
		and Ser.Estatus =EstatusAutorizado
		and Ser.TipoServicio = VarFamiliar
		limit 15;
	END IF;
end if;

END TerminaStore$$