-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBARCHACLARABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBARCHACLARABAJ`;DELIMITER $$

CREATE PROCEDURE `TARDEBARCHACLARABAJ`(
    Par_ReporteID       bigint(20),

	Aud_Empresa         int,
	Aud_Usuario         int,
	Aud_FechaActual     DateTime,
	Aud_DireccionIP     varchar(15),
	Aud_ProgramaID      varchar(50),
	Aud_Sucursal        int,
	Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN

    DECLARE	Cadena_Vacia	char(1);
    DECLARE	Fecha_Vacia		date;
    DECLARE	Entero_Cero		int;

    Set	Cadena_Vacia	:= '';
    Set	Fecha_Vacia		:= '1900-01-01';
    Set	Entero_Cero		:= 0;

    DELETE
        FROM TARDEBARCHACLARA
        WHERE ReporteID = Par_ReporteID;

    SELECT '000' as NumErr ,
        'Archivos Adjuntos Eliminados Correctamente' as ErrMen,
        Cadena_Vacia as control,
        Entero_Cero as consecutivo;

END TerminaStore$$