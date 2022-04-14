-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROVEEDORESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROVEEDORESLIS`;DELIMITER $$

CREATE PROCEDURE `PROVEEDORESLIS`(
	Par_ApellidoPaterno	varchar(50),
	Par_PrimerNombre 	varchar(50),
	Par_NumLis			tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN



DECLARE		Cadena_Vacia	char(1);
DECLARE		Fecha_Vacia		date;
DECLARE		Entero_Cero		int;
DECLARE		Lis_Principal	int;
DECLARE		Lis_Foranea		int;
DECLARE		EstatusActivo	char(1);
DECLARE		PerFisica		char(1);
DECLARE		PerMoral		char(1);


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_Foranea		:= 2;
Set	EstatusActivo	:='A';
Set	PerFisica		:='F';
Set	PerMoral		:='M';


if(Par_NumLis = Lis_Principal) then
	select ProveedorID,	CASE TipoPersona
						WHEN  PerFisica	THEN concat(PrimerNombre, " ",ApellidoPaterno)
						WHEN  PerMoral	THEN RazonSocial
							END as Proveedor
		from PROVEEDORES
		where (
				concat(PrimerNombre,' ',case SegundoNombre
										when null then ''
										when ''   then ''
										else concat(SegundoNombre,' ')
										end,
				ApellidoPaterno,' ',ApellidoMaterno)
				like concat('%',Par_ApellidoPaterno,'%')
				or RazonSocial LIKE concat("%",Par_ApellidoPaterno,"%")) limit 0,15;
end if;
END TerminaStore$$