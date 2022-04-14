-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- RELACIONCLIEMPLEADOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `RELACIONCLIEMPLEADOLIS`;DELIMITER $$

CREATE PROCEDURE `RELACIONCLIEMPLEADOLIS`(
    Par_ClienteID       int,
    Par_NumLis          tinyint unsigned,

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN

DECLARE Cadena_Vacia	char(1);
DECLARE Fecha_Vacia	date;
DECLARE Entero_Cero	int;
DECLARE Lis_Principal	int;
DECLARE Lis_Relaciones int;

Set	Cadena_Vacia	:= '';
Set	Fecha_Vacia	:= '1900-01-01';
Set	Entero_Cero	:= 0;
Set	Lis_Principal:= 1;
Set	Lis_Relaciones:= 3;

	if(Par_NumLis = Lis_Relaciones) then
        SELECT
            rel.ClienteID, rel.RelacionadoID, rel.ParentescoID, rel.TipoRelacion
        FROM
            RELACIONCLIEMPLEADO rel
        WHERE rel.ClienteID = Par_ClienteID;
	end if;

END TerminaStore$$