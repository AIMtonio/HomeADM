-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INSTITUTFONDEOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INSTITUTFONDEOLIS`;
DELIMITER $$


CREATE PROCEDURE `INSTITUTFONDEOLIS`(
	Par_NombInstFon	varchar(20),
	Par_NumLis		tinyint unsigned,
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
DECLARE	Lis_Principal 	int;
DECLARE	Lis_Combo	 	int;

DECLARE Lis_Foranea		INT;
DECLARE Var_EstActivo	CHAR(1);

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia		:= '1900-01-01';
Set	Entero_Cero		:= 0;
Set	Lis_Principal	:= 1;
Set	Lis_Combo		:= 2;

SET Lis_Foranea		:= 3;
SET Var_EstActivo	:= 'A';

if(Par_NumLis = Lis_Principal) then
	select	`InstitutFondID`,		`NombreInstitFon`
	from INSTITUTFONDEO
	where  NombreInstitFon like concat("%", Par_NombInstFon, "%")
	limit 0, 15;
end if;


if(Par_NumLis=Lis_Combo) then
select	`InstitutFondID`,		`NombreInstitFon`
	from INSTITUTFONDEO;
end if;

IF(Par_NumLis = Lis_Foranea) THEN
	SELECT	`InstitutFondID`,		`NombreInstitFon`
	FROM INSTITUTFONDEO
	WHERE  NombreInstitFon LIKE concat("%", Par_NombInstFon, "%")
	AND Estatus = Var_EstActivo
	LIMIT 0, 15;
END IF;

END TerminaStore$$