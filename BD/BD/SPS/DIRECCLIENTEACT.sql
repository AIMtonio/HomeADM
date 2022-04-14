-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DIRECCLIENTEACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `DIRECCLIENTEACT`;DELIMITER $$

CREATE PROCEDURE `DIRECCLIENTEACT`(
	Par_ClienteID   		int(11),
	Par_NumDirec	        int(11),
	Par_Latitud				varchar(45),
	Par_Longitud			varchar(45),
	Par_TipoAct				int(11),

	Aud_EmpresaID        	int,
	Aud_Usuario         	int,
	Aud_FechaActual      	Datetime,
	Aud_DireccionIP      	varchar(20),
	Aud_ProgramaID       	varchar(50),
	Aud_Sucursal         	int,
	Aud_NumTransaccion   	bigint(20)
	)
TerminaStore: BEGIN

-- DECLARACION DE CONSTANTES

DECLARE	Cadena_Vacia		char(1);
DECLARE	Fecha_Vacia			date;
DECLARE	Entero_Cero			int;
DECLARE TipoAct_Coord   	int(11);
-- VALORES A CONSTATES
Set	Cadena_Vacia			:= '';			-- Cadena Vacia
Set	Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
Set	Entero_Cero				:= 0;			-- Entero Cero
Set TipoAct_Coord			:= 4;			-- ActualizaciÃ³n de Coordenadas



if (Par_TipoAct=TipoAct_Coord)then
	if(ifnull(Par_ClienteID, Entero_Cero)) = Entero_Cero then
		select '001' as NumErr,
			'El Numero de Cliente esta Vacio.' as ErrMen,
			'clienteID' as control;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_NumDirec, Entero_Cero)) = Entero_Cero then
		select '002' as NumErr,
			'El Numero de Direccion esta Vacio.' as ErrMen,
			'direccionID' as control;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_Latitud, Cadena_Vacia)) = Cadena_Vacia then
		select '003' as NumErr,
			'Especificar Latitud' as ErrMen,
			'latitud' as control;
		LEAVE TerminaStore;
	end if;

	if(ifnull(Par_Longitud, Cadena_Vacia)) = Cadena_Vacia then
		select '004' as NumErr,
			'Especificar Longitud.' as ErrMen,
			'longitud' as control;
		LEAVE TerminaStore;
	end if;

	update DIRECCLIENTE set
		Latitud		  =	Par_Latitud,
		Longitud	  =	Par_Longitud,

		EmpresaID     = Aud_EmpresaID,
		Usuario       = Aud_Usuario,
		FechaActual   = Aud_FechaActual,
		DireccionIP   = Aud_DireccionIP,
		ProgramaID    = Aud_ProgramaID,
		Sucursal      = Aud_Sucursal,
		NumTransaccion= Aud_NumTransaccion

		where ClienteID    = Par_ClienteID and
			  DireccionID  = Par_NumDirec;

		select '000' as NumErr,
		"Coordenadas Actualizadas Exitosamente "  as ErrMen,
		'direccionID' as control;
end if;

END TerminaStore$$