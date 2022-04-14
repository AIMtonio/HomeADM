-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROSXTIPOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGIROSXTIPOBAJ`;DELIMITER $$

CREATE PROCEDURE `TARDEBGIROSXTIPOBAJ`(
    Par_TipoTarjetaDebID	int(11),

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
		)
TerminaStore: BEGIN
	DECLARE	Cadena_Vacia	char(1);
	DECLARE	Entero_Cero		int;
	DECLARE consecutivo		int;

	Set	Cadena_Vacia	:= '';
	Set	Entero_Cero		:= 0;
	Set	consecutivo		:= 0;

	DELETE
	FROM	TARDEBGIROSXTIPO
	WHERE 	TipoTarjetaDebID = Par_TipoTarjetaDebID;


select '000' as NumErr ,
	  'Giro Eliminado Correctamente' as ErrMen,
	  'tipoTarjetaDebID' as control,
		Entero_Cero as consecutivo;

END TerminaStore$$