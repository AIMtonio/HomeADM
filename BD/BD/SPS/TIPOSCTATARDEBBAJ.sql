-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSCTATARDEBBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSCTATARDEBBAJ`;DELIMITER $$

CREATE PROCEDURE `TIPOSCTATARDEBBAJ`(
	Par_TipoTarjetaDebID		char(2),


	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(100),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
		)
TerminaStore: BEGIN
	DECLARE	Cadena_Vacia	char(1);
	DECLARE	Entero_Cero		int;
	DECLARE  	consecutivo		int;

	Set	Cadena_Vacia	:= '';
	Set	Entero_Cero		:= 0;
	Set	consecutivo		:=0;

	Set Aud_FechaActual := CURRENT_TIMESTAMP();
    DELETE FROM TIPOSCUENTATARDEB
    WHERE  TipoTarjetaDebID =Par_TipoTarjetaDebID;



select '000' as NumErr ,
	  'Tipos de Cuenta Eliminados Exitosamente' as ErrMen,
	  'tipoTarjetaDebID' as control,
		Entero_Cero as consecutivo;

END TerminaStore$$