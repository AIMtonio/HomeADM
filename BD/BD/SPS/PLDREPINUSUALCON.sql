-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDREPINUSUALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDREPINUSUALCON`;DELIMITER $$

CREATE PROCEDURE `PLDREPINUSUALCON`(
	Par_FechaInicial		varchar(10),
	Par_FechaFinal		varchar(10),
	Par_NumCon			tinyint unsigned,

	Par_EmpresaID			int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE	TipoReporte		int(11);
DECLARE	ClaveEnt			varchar(20);
DECLARE	FechaNomb		char(20);
DECLARE	Organo_Sup		varchar(10);
DECLARE	NumEstRepor		int;

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal		int;
DECLARE	Con_Foranea		int;
DECLARE	Con_NombArch		int;
DECLARE	Con_Arch			int;
DECLARE	Con_GenArch		int;
DECLARE  Con_Genera		int;
DECLARE  Punto			char(1);
DECLARE  FechaI			date;
DECLARE	FechaF			date;

Set	TipoReporte		:= 2;
Set	NumEstRepor		:= 3;

Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal		:= 1;
Set	Con_NombArch		:= 3;
Set	Con_Arch			:= 4;
Set	Con_GenArch		:= 5;

Set	Punto			:= '.';


set FechaNomb := (DATE_FORMAT(Par_FechaFinal,'%y%m%d'));
Set	ClaveEnt	 :=(select ClaveEntCasfim from PARAMETROSPLD );
Set	Organo_Sup:=(select ClaveOrgSupervisorExt from PARAMETROSPLD);

set FechaI :=	(select convert (Par_FechaInicial,date));
set FechaF :=(select convert (Par_FechaFinal,date));

			if(Par_NumCon = Con_NombArch) then
				select convert(concat(TipoReporte,ClaveEnt,FechaNomb,Punto,Organo_Sup),char(30));
			end if;

			if(Par_NumCon = Con_GenArch) then
				if(not exists(select FechaDeteccion
				from PLDOPEINUSUALES
				where FechaDeteccion>=FechaI and FechaDeteccion<=FechaF and Estatus=NumEstRepor)) then
						select concat("Sin datos")as Leyenda;
				end if;
			end if;

			if(Par_NumCon = Con_Arch) then
				if(exists(select PeriodoInicio
						from `PLDHIS-INUSUALES`
						where PeriodoInicio>=FechaI and PeriodoFin<=FechaF)) then
								select concat("datos")as Leyenda;
				end if;
			end if;



END TerminaStore$$