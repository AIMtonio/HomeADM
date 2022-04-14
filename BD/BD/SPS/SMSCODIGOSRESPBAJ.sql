-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SMSCODIGOSRESPBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SMSCODIGOSRESPBAJ`;DELIMITER $$

CREATE PROCEDURE `SMSCODIGOSRESPBAJ`(
	Par_CampaniaID			int,

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
	DECLARE  	consecutivo		int;

	Set	Cadena_Vacia	:= '';
	Set	Entero_Cero		:= 0;
	Set	consecutivo		:=0;

	Set Aud_FechaActual := CURRENT_TIMESTAMP();

	DELETE
	FROM 		SMSCODIGOSRESP
	WHERE 	CampaniaID	= Par_CampaniaID;


select '000' as NumErr ,
	  'Codigos de respuesta eliminados' as ErrMen,
	  'consecutivo' as control,
		Entero_Cero as consecutivo;

END TerminaStore$$