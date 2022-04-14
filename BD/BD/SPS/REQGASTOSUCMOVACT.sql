-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQGASTOSUCMOVACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQGASTOSUCMOVACT`;DELIMITER $$

CREATE PROCEDURE `REQGASTOSUCMOVACT`(
	Par_DetReqGasID      	int(11),
	Par_NumReqGasID      	int(11),
	Par_TipoGastoID      	int(11),
	Par_Observaciones		varchar(50),
	Par_PartPresupuesto		decimal(12,2),

	Par_FolioPresupID		int(11),
	Par_MontPresupuest		decimal(12,2),
	Par_NoPresupuestado  	decimal(12,2),
	Par_MontoAutorizado  	decimal(12,2),
	Par_Estatus          	char(1),

	Par_TipoDeposito		char(1),
	Par_ClaveDispMov 		int(11),
	Par_UsuarioAutoID		int(11),
	Par_ProveedorID			int(11),
	Par_NumAct  			tinyint unsigned,

	Par_Salida			char(1),
	inout Par_NumErr		int,
	inout Par_ErrMen		varchar(400),

	Par_EmpresaID        	int(11),
	Aud_Usuario       	int(11),
	Aud_FechaActual     	datetime,
	Aud_DireccionIP     	varchar(20),
	Aud_ProgramaID      	varchar(50),
	Aud_Sucursal        	int(11),
	Aud_NumTransaccion  	bigint(20)
	)
TerminaStore: BEGIN


DECLARE Entero_Cero		int(1);
DECLARE Cadena_Vacia 		char(1);
DECLARE Decimal_Cero  	decimal(14,2);

DECLARE SalidaSi			char(1);
DECLARE SalidaNo 			char(1);
DECLARE Est_Cancelado		char(1);

DECLARE Act_Principal 	int;
DECLARE Act_FolioDisper 	int;
DECLARE Act_MontoDispon 	int;
DECLARE Act_CancelaReq 	int;
DECLARE Var_MotivCancela	varchar(150);

DECLARE Var_MontoDisp 	decimal(12,2);
DECLARE Var_Disponible	decimal(12,2);
DECLARE Var_PartPreAnt	decimal(12,2);
DECLARE Var_MontoAut 		decimal(12,2);
DECLARE Var_NoFactura		varchar(20);
DECLARE Var_ProveedorID	int;


Set Cadena_Vacia		:= '';
Set Entero_Cero 		:= 0;
Set Decimal_Cero 		:= 0.00;

Set SalidaSi			:= 'S';
Set SalidaNo 			:= 'N';
Set Est_Cancelado		:= 'C';
Set Var_MotivCancela	:= 'CANCELADA EN PROCESO DE REQUISICION';

Set Act_Principal		:= 1;
Set Act_FolioDisper	:= 2;
Set Act_MontoDispon	:= 3;
Set Act_CancelaReq  	:= 5;


if(Par_NumAct = Act_Principal) then

	select NoFactura, ProveedorID into Var_NoFactura, Var_ProveedorID from REQGASTOSUCURMOV where DetReqGasID	=Par_DetReqGasID;
	if(ifnull(Var_NoFactura,Cadena_Vacia) <> Cadena_Vacia && Par_Estatus = Est_Cancelado)then
		call FACTURAPROVACT(
			Var_ProveedorID,	Var_NoFactura,		Cadena_Vacia, 		Cadena_Vacia,		Var_MotivCancela,
			Decimal_Cero,		Act_CancelaReq,		Cadena_Vacia,		SalidaNo,			Par_NumErr,
			Par_ErrMen,	        Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID, 	Aud_Sucursal,		Aud_NumTransaccion);
	end if;

	if (Par_FolioPresupID <> Entero_Cero)then


		Set Var_MontoDisp  :=	(select MontoDispon from PRESUCURDET where FolioID = Par_FolioPresupID);
		Set Var_Disponible := ifnull(Var_MontoDisp,Decimal_Cero) - ifnull(Par_MontoAutorizado,Decimal_Cero);
		if( ifnull(Var_Disponible,Decimal_Cero) <= Decimal_Cero)then
			Set Var_MontoAut := ifnull(Var_MontoDisp,Decimal_Cero) ;
		else
			Set Var_MontoAut := Par_MontoAutorizado;
		end if;

		call PRESUCURDETACT(
			Par_FolioPresupID,	Entero_Cero,		Entero_Cero,		Cadena_Vacia,			Cadena_Vacia,
			Var_MontoAut,		Cadena_Vacia,		Act_MontoDispon,	SalidaNo,		Par_NumErr,
			Par_ErrMen,			Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
			Aud_ProgramaID,		Aud_Sucursal,	    Aud_NumTransaccion
		);
	end if;


	update REQGASTOSUCURMOV set
		Observaciones		= Par_Observaciones,
		PartPresupuesto		= Par_PartPresupuesto,
		MontPresupuest		= Par_MontPresupuest,
		NoPresupuestado		= Par_NoPresupuestado,
		MontoAutorizado		= Par_MontoAutorizado,
		Estatus				= Par_Estatus,
		ClaveDispMov 		= Par_ClaveDispMov,
		TipoDeposito		= Par_TipoDeposito,
		UsuarioAutoID		= Par_UsuarioAutoID,

		EmpresaID			= Par_EmpresaID,
		Usuario				= Aud_Usuario,
		FechaActual			= Aud_FechaActual,
		DireccionIP			= Aud_DireccionIP,
		ProgramaID			= Aud_ProgramaID,
		Sucursal			= Aud_Sucursal,
		NumTransaccion		= Aud_NumTransaccion
	 where DetReqGasID		= Par_DetReqGasID;

	if(Par_Salida = SalidaSi)then
		select '000' as NumErr,
			"Requisición de Gastos Autorizada"  as ErrMen,
			'DetReqGasID' as control,
			Par_DetReqGasID as consecutivo_mov;
	else
		Set Par_NumErr := 0;
		Set Par_ErrMen := "Requisición de Gastos Autorizada";
	end if;
end if;


if(Par_NumAct = Act_FolioDisper) then
	Set Var_NoFactura := (select NoFactura from REQGASTOSUCURMOV where DetReqGasID	= Par_DetReqGasID);
	if(ifnull(Var_NoFactura,Cadena_Vacia)=Cadena_Vacia) then
		update REQGASTOSUCURMOV set
			ClaveDispMov		= Par_ClaveDispMov,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		where DetReqGasID	= Par_DetReqGasID;
	else
		update REQGASTOSUCURMOV set
			ClaveDispMov		= Par_ClaveDispMov,

			EmpresaID		= Par_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal			= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		where NoFactura		= Var_NoFactura
		 and ProveedorID	= Par_ProveedorID;
	end if;



	if(Par_Salida = SalidaSi)then
		select '000' as NumErr,
		  "Folio de Requisición de Gastos Actualizado"  as ErrMen,
		  'numReqGasID' as control,
		  Par_DetReqGasID as consecutivo_mov;
	else
		Set Par_NumErr := 0;
		Set Par_ErrMen := "Folio de Requisición de Gastos Actualizado";
	end if;

end if;

END TerminaStore$$