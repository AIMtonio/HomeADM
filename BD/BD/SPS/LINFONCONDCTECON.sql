-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINFONCONDCTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINFONCONDCTECON`;DELIMITER $$

CREATE PROCEDURE `LINFONCONDCTECON`(
	Par_LineaFondID		int,
	Par_Sexo			char(1),
	Par_EstadoCivil		varchar(200),
	Par_NumCon			tinyint unsigned,
	Par_EmpresaID		int,

	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	Con_Principal	int;
DECLARE	Con_Foranea		int;


Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Con_Principal	:= 1;
Set	Con_Foranea		:= 2;



if(Par_NumCon = Con_Principal) then
	SELECT	LineaFondeoID,  Sexo,           EstadoCivil,    MontoMinimo,    MontoMaximo,
			MonedaID,       DiasGraIngCre,  ProductosCre,   MaxDiasMora, 	Clasificacion
		FROM LINFONCONDCTE
		WHERE LineaFondeoID = Par_LineaFondID
		and 	Sexo = Par_Sexo;
end if;

if(Par_NumCon = Con_Foranea) then
    SELECT  LineaFondeoID,  Sexo,   		EstadoCivil,    MontoMinimo,    MontoMaximo,
            MonedaID,       DiasGraIngCre,  ProductosCre,	MaxDiasMora,	Clasificacion
		FROM LINFONCONDCTE
		WHERE LineaFondeoID = Par_LineaFondID;
end if;
END TerminaStore$$