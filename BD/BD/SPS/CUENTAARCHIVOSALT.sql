-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTAARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTAARCHIVOSALT`;DELIMITER $$

CREATE PROCEDURE `CUENTAARCHIVOSALT`(
	Par_CuentaAhoID		bigint(12),
	Par_TipoDocumen		varchar(45),
	Par_Observacion		varchar(200),
	Par_Recurso			varchar(500),
	Par_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
		)
TerminaStore: BEGIN


DECLARE	NumeroArchivo	int;
DECLARE	Estatus_Activo	char(1);
DECLARE	Cadena_Vacia	char(1);
DECLARE	Fecha_Vacia		date;
DECLARE	Entero_Cero		int;
DECLARE	RecursoA		varchar(500);


DECLARE	noConsecutivo	int;


Set	Estatus_Activo		:= 'A';
Set	Cadena_Vacia		:= '';
Set	Fecha_Vacia			:= '1900-01-01';
Set	Entero_Cero			:= 0;
Set	NumeroArchivo		:= 0;
Set	RecursoA			:= '';


Set	noConsecutivo		:= 0;

if(not exists(select CuentaAhoID
			from CUENTASAHO
			where CuentaAhoID = Par_CuentaAhoID)) then
	select '001' as NumErr,
		 'El Numero de Cuenta no existe.' as ErrMen,
		 'cuentaAhoID' as control,
		 '0' as consecutivo;
	LEAVE TerminaStore;
end if;


set	NumeroArchivo	:= (select Max(ArchivoCtaID)
				    from CUENTAARCHIVOS
			          where CuentaAhoID = Par_CuentaAhoID );
set	NumeroArchivo :=ifnull(NumeroArchivo,Entero_Cero)+1;

Set	noConsecutivo	:=(select Max(Consecutivo)
				   from CUENTAARCHIVOS
				   where CuentaAhoID = Par_CuentaAhoID and TipoDocumento = Par_TipoDocumen);
set	noConsecutivo :=ifnull(noConsecutivo,Entero_Cero)+1;


Set	RecursoA		:= Par_Recurso;
Set Aud_FechaActual := CURRENT_TIMESTAMP();


insert into CUENTAARCHIVOS
	(	CuentaAhoID, 		ArchivoCtaID, 	EmpresaID, 		TipoDocumento, 	Consecutivo,
		Observacion, 		Recurso, 		Usuario, 		FechaActual,		DireccionIP,
		ProgramaID, 		Sucursal, 		NumTransaccion)
values (	Par_CuentaAhoID,	NumeroArchivo, 	Par_EmpresaID,	Par_TipoDocumen, 	noConsecutivo,
 		Par_Observacion,	RecursoA,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);


select '000' as NumErr,
	  concat("Archivo Adjuntado Correctamente:  ", convert(NumeroArchivo, CHAR))  as ErrMen,
	  'cuentaAhoID' as control,
	  convert(noConsecutivo, CHAR) as consecutivo;

END TerminaStore$$