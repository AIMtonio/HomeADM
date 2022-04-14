-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CAJASTRANSFERACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CAJASTRANSFERACT`;DELIMITER $$

CREATE PROCEDURE `CAJASTRANSFERACT`(
	Par_FolioID			int,
	Par_NumAct			int,

	Par_Salida			char(1),

	inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),

	Aud_EmpresaID		int,
	Aud_Usuario			int,
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int,
	Aud_NumTransaccion	bigint
	)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE  Entero_Cero		int;
DECLARE  SalidaSI			char(1);
DECLARE  SalidaNO			char(1);
DECLARE  Cadena_Vacia		char(1);
DECLARE  EstatusRecepcion	char(1);
DECLARE  ActRecepcion		int;


-- Asignacion de constantes
Set	Entero_Cero		:= 0;
Set SalidaSI		:='S';
Set SalidaNO		:='N';
Set	Cadena_Vacia	:= '';
Set	EstatusRecepcion:= 'R';  -- R: Recepcion de Transferencia
Set ActRecepcion	:= 2;  -- trasaccion 2 para la recepcion de transferencia de efectivo


Set Aud_FechaActual := CURRENT_TIMESTAMP();

if(ifnull(Par_FolioID, Entero_Cero))= Entero_Cero then
	if(Par_Salida = SalidaSI)then
		select '001' as NumErr,
			'El Folio esta Vacio.' as ErrMen,
			'foliosRecepcion' as control,
			Entero_Cero as consecutivo;
		LEAVE TerminaStore;
	end if;
	if(Par_Salida = SalidaNO)then
		set	 Par_NumErr := 1;
		set  Par_ErrMen := 'El Folio esta Vacio';
	end if;
end if;

if(Par_NumAct = ActRecepcion) then
	Update CAJASTRANSFER
		set Estatus = EstatusRecepcion
		where CajasTransferID = Par_FolioID;
end if;

if(Par_Salida = SalidaSI)then
	select	'000' as NumErr ,
		  concat("Recepcion Realizada Satisfactoriamente ", convert(Par_FolioID, CHAR))  as ErrMen,
		'foliosRecepcion' as control,
		 Par_FolioID as consecutivo;
end if;

if(Par_Salida = SalidaNO)then
	set	 Par_NumErr := 0;
	set  Par_ErrMen :=  concat("Recepcion Realizada Satisfactoriamente ", convert(Par_FolioID, CHAR));
end if;

END TerminaStore$$