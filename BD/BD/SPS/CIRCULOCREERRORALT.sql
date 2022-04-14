-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CIRCULOCREERRORALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CIRCULOCREERRORALT`;DELIMITER $$

CREATE PROCEDURE `CIRCULOCREERRORALT`(
    Par_SolicitudID         varchar(10),
	Par_Consecutivo			int(11),
	Par_Descripcion			varchar(200),

    Par_Salida				char(1),
    inout	Par_NumErr		int,
    inout	Par_ErrMen		varchar(350)


	)
TerminaStore: BEGIN

DECLARE varControl		varchar(50);
DECLARE varConsecutivo	int(11);


DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;
DECLARE	Fecha_Alta		date;
DECLARE	Salida_SI       char(1);
DECLARE	Var_NO			char(1);


Set Cadena_Vacia		:= '';
Set Entero_Cero			:= 0;
set Salida_SI			:='S';
set Var_NO				:='N';
set varConsecutivo		:= 0;




set varConsecutivo := (select ifnull(Max(Consecutivo),Entero_Cero) + 1 from CIRCULOCREERROR where fk_SolicitudID = Par_SolicitudID);

insert into CIRCULOCREERROR(
	fk_SolicitudID,		Consecutivo,	Descripcion)
values (
	Par_SolicitudID,	varConsecutivo,	Par_Descripcion );

set Par_NumErr  := 000;
set Par_ErrMen  := concat('La Cadena de error se ha insertado correctamente: ',Par_SolicitudID);
set varControl	:= 'fk_SolicitudID';

IF (Par_Salida = Salida_SI) THEN
	SELECT  convert(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
end IF;

END TerminaStore$$