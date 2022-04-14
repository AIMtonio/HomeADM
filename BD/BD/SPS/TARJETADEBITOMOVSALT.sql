-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBITOMOVSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETADEBITOMOVSALT`;DELIMITER $$

CREATE PROCEDURE `TARJETADEBITOMOVSALT`(
	Par_TipoOpeID 		char(2),
	Par_TarDebID		char(16),
	Par_MontoOpe 		decimal(12,2),
	Par_FechaHrOpe 		datetime,
	Par_NumeroTran 		bigint(20),

	Par_TerminalID 		varchar(50),
	Par_MontosAdi	 	decimal(12,2),
	Par_MonSurcharge 	decimal(12,2),
	Par_MonLoyaltyfee 	decimal(12,2),
	Par_Referencia		varchar(12),

	Par_TransEnLinea	char(1),
	Par_Salida			char(1),

	Par_EmpresaID		int(11),
	Aud_Usuario			int(11),
	Aud_FechaActual		DateTime,
	Aud_DireccionIP		varchar(15),
	Aud_ProgramaID		varchar(50),
	Aud_Sucursal		int(11),
	Aud_NumTransaccion	bigint(20)

	)
TerminaStore:BEGIN


DECLARE	Cadena_Vacia	char(1);
DECLARE	Entero_Cero		int;
DECLARE	DecimalCero		decimal(12,2);
DECLARE	Nat_Cargo		char(1);
DECLARE	Nat_Abono		char(1);
declare Salida_NO 		char(1);
declare	Var_Si	 		char(1);
DECLARE	EstatusActivo	char(1);


DECLARE	Var_SaldoDisp		decimal(12,2);
DECLARE	Var_EstatusCta		char(1);
DECLARE	Par_NumErr			int(11);
DECLARE Par_ErrMen			varchar(150);
DECLARE Var_TarDebMovID		bigint(20);
DECLARE Est_NOConcilia		char(1);


Set	Cadena_Vacia	:= '';
Set	Entero_Cero		:= 0;
Set	DecimalCero		:= 0.00;
Set	EstatusActivo	:= 'A';
Set	Nat_Cargo		:= 'C';
Set	Nat_Abono		:= 'A';
Set	Salida_NO		:= 'N';
Set	Var_Si			:= 'S';
Set Est_NOConcilia	:= 'N';

	CALL FOLIOSAPLICAACT('TARJETADEBITOMOVS', Var_TarDebMovID);

	INSERT INTO `TARJETADEBITOMOVS`(
		`TarDebMovID`,	`TipoOperacionID`,	`TarjetaDebID`,		`MontoOpe`,			`FechaHrOpe`,
		`NumeroTran`,	`TerminalID`,		`MontosAdiciona`,	`MontoSurcharge`,	`MontoLoyaltyfee`,
		`Referencia`,	`TransEnLinea`,		`EstatusConcilia`,	`EmpresaID`,		`Usuario`,
		`FechaActual`,	`DireccionIP`,		`ProgramaID`,		`Sucursal`,			`NumTransaccion`)
	VALUES(
		Var_TarDebMovID, 	Par_TipoOpeID,		Par_TarDebID, 		Par_MontoOpe,		Par_FechaHrOpe,
		Par_NumeroTran,		Par_TerminalID,		Par_MontosAdi,		Par_MonSurcharge,	Par_MonLoyaltyfee,
		Par_Referencia,		Par_TransEnLinea, 	Est_NOConcilia,		Par_EmpresaID,		Aud_Usuario,
		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion	);

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