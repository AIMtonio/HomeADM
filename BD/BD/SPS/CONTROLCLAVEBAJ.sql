-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTROLCLAVEBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTROLCLAVEBAJ`;DELIMITER $$

CREATE PROCEDURE `CONTROLCLAVEBAJ`(
	Par_ClienteID			varchar(50),
	Par_Anio				char(4),

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN


DECLARE Var_Control		varchar(100);


DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE SalidaSI        char(1);


Set Cadena_Vacia    := '';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';
Set Aud_FechaActual := now();


	DELETE FROM CONTROLCLAVE
	WHERE ClienteID = Par_ClienteID AND Anio = Par_Anio;

	SELECT
		000		as NumErr,
		"Registro Eliminado Exitosamente" as ErrMen,
		'clienteID' as control,
		Entero_Cero as consecutivo;

END TerminaStore$$