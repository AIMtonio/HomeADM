-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ABONOCHEQUESBCACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ABONOCHEQUESBCACT`;DELIMITER $$

CREATE PROCEDURE `ABONOCHEQUESBCACT`(

	Par_ChequeSBCID			int(11),
	Par_Fecha				date,
	Par_NumInstAplica		int(11),
	Par_FormaAplica			varchar(20),
	Par_CuentaAplica	 	varchar(20),
	Par_NumAct				tinyint unsigned,

    Par_Salida				char(1),
out Par_NumErr				int,
out Par_ErrMen				varchar(200),

    Par_EmpresaID			int(11),
    Aud_Usuario				int(11),
    Aud_FechaActual			DateTime,
    Aud_DireccionIP			varchar(15),
    Aud_ProgramaID			varchar(50),
    Aud_Sucursal			int,
    Aud_NumTransaccion		bigint
)
TerminaStore:BEGIN



DECLARE Act_AplicaChequeSBC		int;
DECLARE Act_CancelaChequeSBC	int;
DECLARE Entero_Cero				int;
DECLARE Cadena_Vacia			char;
DECLARE Est_Aplicado			char(1);
DECLARE Est_Cancelado			char(1);
DECLARE SalidaSI				char(1);


set Act_AplicaChequeSBC		:=1;
set Act_CancelaChequeSBC	:=2;
set Entero_Cero				:=0;
set Cadena_Vacia			:='';
set Est_Cancelado			:='C';
set Est_Aplicado			:='A';
set SalidaSI				:='S';
ManejoErrores:BEGIN


	set Par_NumErr  := Entero_Cero;
	set Par_ErrMen  := Cadena_Vacia;
	set Aud_FechaActual := CURRENT_TIMESTAMP();

	if(Par_NumAct = Act_AplicaChequeSBC)then
		update ABONOCHEQUESBC set
			Estatus			=Est_Aplicado,
			FechaAplicacion	=Par_Fecha,
			NumInstAplica	=Par_NumInstAplica,
			FormaAplica		=Par_FormaAplica,
			CuentaAplica	=Par_CuentaAplica,

			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion

			where ChequeSBCID = Par_ChequeSBCID;

			set Par_NumErr :=0;
			set Par_ErrMen := "Cheque abonado Exitosamente .";
	end if;

	if(Par_NumAct = Act_CancelaChequeSBC)then
		update ABONOCHEQUESBC set
			Estatus			=Est_Cancelado,
			FechaAplicacion	=Par_Fecha,

			EmpresaID       = Par_EmpresaID,
			Usuario         = Aud_Usuario,
			FechaActual     = Aud_FechaActual,
			DireccionIP     = Aud_DireccionIP,
			ProgramaID      = Aud_ProgramaID,
			Sucursal        = Aud_Sucursal,
			NumTransaccion  = Aud_NumTransaccion

			where ChequeSBCID = Par_ChequeSBCID;

			set Par_NumErr :=0;
			set Par_ErrMen := "Cheque Cancelado Exitosamente .";
	end if;

END ManejoErrores;
	if (Par_Salida = SalidaSI) then
		select  Par_NumErr as NumErr,
				Par_ErrMen as ErrMen,
				'seguroClienteID' as control,
				Entero_Cero as consecutivo;
	end if;
END TerminaStore$$