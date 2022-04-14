-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PROSPECTOSWSLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PROSPECTOSWSLIS`;DELIMITER $$

CREATE PROCEDURE `PROSPECTOSWSLIS`(
	Par_Nombre				varchar(50),
	Par_InstitNominaID		int,
	Par_NegocioAfiliadoID	int,
	Par_NumLis				tinyint unsigned,

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN




DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;
DECLARE	Fecha_Vacia		date;
DECLARE	Lis_ProspectoIN	int;
DECLARE Lis_ProspectoNA int;


Set	Cadena_Vacia		:= '';
Set	Entero_Cero			:= 0;
Set	Fecha_Vacia			:= '1900-01-01';
Set	Lis_ProspectoIN		:= 1;
Set Lis_ProspectoNA		:= 2;



if(Par_NumLis = Lis_ProspectoIN) then

 Select Pros.ProspectoID, NombreCompleto
 from PROSPECTOS Pros inner join NOMINAEMPLEADOS Nem ON  Pros.ProspectoID=Nem.ProspectoID
 where Pros.NombreCompleto like concat("%",Par_Nombre, "%") and Nem.InstitNominaID=Par_InstitNominaID;

end if;

if(Par_NumLis = Lis_ProspectoNA) then

 Select Pros.ProspectoID, NombreCompleto
 from PROSPECTOS Pros inner join NEGAFILICLIENTE Neg ON  Pros.ProspectoID=Neg.ProspectoID
 where Pros.NombreCompleto like concat("%",Par_Nombre, "%") and Neg.NegocioAfiliadoID=Par_NegocioAfiliadoID;

end if;

END TerminaStore$$