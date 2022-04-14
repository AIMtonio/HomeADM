-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORAMOVSTARALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAMOVSTARALT`;DELIMITER $$

CREATE PROCEDURE `BITACORAMOVSTARALT`(

	Par_TipoOpeID 		char(2),
	Par_TarDebID		char(16),
	Par_OrigenInst 		char(2),
	Par_MontoOpe 		decimal(12,2),
	Par_FechaHrOpe 	datetime,

	Par_NumeroTran 	bigint(20),
	Par_GiroNegocio 	varchar(5),
	Par_PuntoEntrada 	char(2),
	Par_TerminalID 		varchar(50),
	Par_NombreUbiTer 	varchar(50),

	Par_NIP 			varchar(256),
	Par_CodigoMonOpe 	varchar(10),
	Par_MontosAdi	 	decimal(12,2),
	Par_MonSurcharge 	decimal(12,2),
	Par_MonLoyaltyfee 	decimal(12,2),

	Par_Salida			char(1),
	inout Par_NumErr    int,
	inout Par_ErrMen    varchar(400),

	Par_EmpresaID			int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal			int(11),
	Aud_NumTransaccion	bigint(20)

		)
TerminaStore:BEGIN


DECLARE	Cadena_Vacia		char(1);
DECLARE	Entero_Cero		int;
DECLARE	DecimalCero		decimal(12,2);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
declare Salida_NO 			char(1);
declare	Var_Si	 		char(1);
DECLARE	EstatusActivo		char(1);


DECLARE	Var_SaldoDisp		decimal(12,2);
DECLARE	Var_CuentaAhoID	bigint(12);
DECLARE	Var_EstatusCta		char(1);


Set	Cadena_Vacia		:= '';
Set	Entero_Cero		:= 0;
Set	DecimalCero		:= 0.00;
Set	EstatusActivo		:= 'A';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set	Salida_NO			:= 'N';
Set	Var_Si			:= 'S';



insert into BITACORAMOVSTAR (
	TipoOperacionID,	TarjetaDebID,		OrigenInst,		MontoOpe,		FechaHrOpe,
	NumeroTran,		GiroNegocio,		PuntoEntrada,		TerminalID,		NombreUbicaTer,
	NIP,				CodigoMonOpe,	MontosAdiciona,	MontoSurcharge,	MontoLoyaltyfee,
	EmpresaID,		Usuario,			FechaActual,		DireccionIP,		ProgramaID,
	Sucursal,			NumTransaccion)
values (
	Par_TipoOpeID, 	Par_TarDebID, 		Par_OrigenInst, 	Par_MontoOpe,		Par_FechaHrOpe,
	Par_NumeroTran,	Par_GiroNegocio,	Par_PuntoEntrada,	Par_TerminalID,		Par_NombreUbiTer,
	Par_NIP,			Par_CodigoMonOpe,	Par_MontosAdi,		Par_MonSurcharge,	Par_MonLoyaltyfee,
	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
	Aud_Sucursal,		Aud_NumTransaccion
);


if(Par_Salida =  Var_Si) then
	select '00' as CodigoRespuesta,
			'Operacion Registrada .' as MensajeRespuesta,
			'numero' as SaldoActualizado,
			Entero_Cero as NumeroTransaccion;
else
	set Par_NumErr	:= 0;
	set Par_ErrMen	:= 'Operacion Registrada.';
end if;

END TerminaStore$$