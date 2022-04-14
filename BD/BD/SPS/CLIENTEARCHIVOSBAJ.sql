-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIENTEARCHIVOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIENTEARCHIVOSBAJ`;DELIMITER $$

CREATE PROCEDURE `CLIENTEARCHIVOSBAJ`(
	Par_ClienteArID		int(11),
	Par_ClienteID		int(11),
	Par_TipoDocumen		varchar(45),

	Par_Salida			char(1),
	inout Par_NumErr	int,
	inout Par_ErrMen	varchar(400),

	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN


DECLARE Estatus_Activo  char(1);
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Entero_Cero     int;
DECLARE SalidaSI        char(1);


Set Estatus_Activo  := 'A';
Set Cadena_Vacia    := '';
Set Fecha_Vacia     := '1900-01-01';
Set Entero_Cero     := 0;
Set SalidaSI        := 'S';

delete from CLIENTEARCHIVOS
	 where ClienteArchivosID =	Par_ClienteArID;

if(Par_Salida = SalidaSI) then
	select '000' as NumErr ,
		  'Archivo Eliminado' as ErrMen,
		  'clienteID' as control,
		  '0' as consecutivo;
else
	Set Par_NumErr := '0';
	Set Par_ErrMen := 'Archivo Eliminado.' ;
end if;


END TerminaStore$$