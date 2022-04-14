-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLBUROCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLBUROCREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `SOLBUROCREDITOLIS`(
	Par_Descripcion 	varchar(50),
	Par_Usuario		 	varchar(50),
	Par_NumLis			int,

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

DECLARE Lis_Principal	int;
DECLARE Lis_Circulo		int;
DECLARE Lis_Buro		int(11);
DECLARE Entero_Cero		int(11);
DECLARE Cadena_Null		varchar(6);

Set	Lis_Principal	:= 1;
Set	Lis_Circulo		:= 3;
Set Lis_Buro		:=4;
Set Entero_Cero		:=0;
Set Cadena_Null		:='null';

if (Lis_Principal = Par_NumLis ) then
	SELECT FolioConsulta, NombreCompleto, RFC, FechaConsulta
		from
			(SELECT FolioConsulta,
					Concat(PrimerNombre,' ',SegundoNombre,' ',TercerNombre,' ',ApellidoPaterno,' ',ApellidoMaterno) as NombreCompleto,
					RFC,
					FechaConsulta
				from SOLBUROCREDITO
				HAVING NombreCompleto like concat("%", Par_Descripcion, "%") AND  FolioConsulta !='0'
			) as SOL
		group BY RFC, FolioConsulta, NombreCompleto, FechaConsulta ORDER BY FolioConsulta;
end if;

if (Lis_Circulo = Par_NumLis ) then
	SELECT FolioConsultaC, NombreCompleto, RFC, FechaConsulta
		from
			(SELECT FolioConsultaC,
					Concat(PrimerNombre,' ',SegundoNombre,' ',TercerNombre,' ',ApellidoPaterno,' ',ApellidoMaterno) as NombreCompleto, RFC
					RFC,
					FechaConsulta
				from SOLBUROCREDITO
				where FolioConsultaC <> Cadena_Null
				and FolioConsultaC <> Entero_Cero
				HAVING NombreCompleto like concat("%", Par_Descripcion, "%")
				Order by FechaConsulta desc
				limit 0, 15
			) as SOL
		group BY RFC, FolioConsultaC, NombreCompleto, FechaConsulta ORDER BY FechaConsulta desc;
end if;

if(Lis_Buro = Par_NumLis) then
SELECT FolioConsulta, NombreCompleto, RFC, FechaConsulta
		from
			(SELECT FolioConsulta,
					Concat(PrimerNombre,' ',SegundoNombre,' ',TercerNombre,' ',ApellidoPaterno,' ',ApellidoMaterno) as NombreCompleto, RFC
					RFC,
					FechaConsulta
				from SOLBUROCREDITO
				where FolioConsulta <> Cadena_Null
				and FolioConsulta <> Entero_Cero
				having  NombreCompleto like concat("%", Par_Descripcion, "%")
				Order by FechaConsulta desc
				limit 0, 15
			) as SOL
		group BY RFC, FolioConsulta, NombreCompleto, FechaConsulta Order by FechaConsulta desc ;
end if;

END TerminaStore$$