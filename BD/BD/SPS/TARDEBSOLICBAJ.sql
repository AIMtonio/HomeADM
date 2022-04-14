-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBSOLICBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBSOLICBAJ`;DELIMITER $$

CREATE PROCEDURE `TARDEBSOLICBAJ`(
	Par_FolioSolicitudID	int,
	Par_Salida              char(1),
    inout Par_NumErr        int,
    inout Par_ErrMen      	varchar(400),

	Aud_EmpresaID			int,
	Aud_Usuario				int,
	Aud_FechaActual			DateTime,
	Aud_DireccionIP			varchar(15),
	Aud_ProgramaID			varchar(50),
	Aud_Sucursal			int,
	Aud_NumTransaccion		bigint
	)
TerminaStore: BEGIN

DECLARE Var_Estatus   char(1);


DECLARE	SalidaNO	 char(1);
DECLARE	SalidaSI	 char(1);
DECLARE Estatus_Canc char(1);
DECLARE Entero_Cero	 int;

Set	SalidaNO 		:='N';
set	SalidaSI		:='S';
set Estatus_Canc	:='C';
set Entero_Cero		:=0;
	select Estatus into Var_Estatus
		from SOLICITUDTARDEB
			where FolioSolicitudID = Par_FolioSolicitudID;

	if (Var_Estatus = Estatus_Canc)then
		if(Par_Salida = SalidaSI)then
			select '001' as NumErr,
				'La Solicitud ya fue Cancelada.' as ErrMen,
				'FolioSolicitudID' as control,
				 Entero_Cero as consecutivo;
			LEAVE TerminaStore;
		end if;
		if(Par_Salida = SalidaNO)then
			set	 Par_NumErr := 1;
			set  Par_ErrMen :='La Solicitud ya fue Cancelada.';
		end if;
	else
	UPDATE SOLICITUDTARDEB SET
			Estatus  		  	   = Estatus_Canc
			WHERE FolioSolicitudID = Par_FolioSolicitudID;

	end if;
	if(Par_Salida =SalidaSI) then
			select '000' as NumErr,
			'Solicitud Cancelada.' as ErrMen,
			'FolioSolicitudID' as control,
			 Entero_Cero as consecutivo;
			 LEAVE TerminaStore;
		end if;
		if(Par_Salida =SalidaNO) then
			set Par_NumErr := 0;
			set	Par_ErrMen := 'Solicitud Cancelada.' ;
			LEAVE TerminaStore;
		end if;

END TerminaStore$$