-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HIS-CUENTASAHOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HIS-CUENTASAHOALT`;
DELIMITER $$


CREATE PROCEDURE `HIS-CUENTASAHOALT`(

	Par_Fecha DATE
		)

TerminaStore: BEGIN


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE Estatus_Cancela		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Estatus_Activo		CHAR(1);


	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0.00;
	SET Estatus_Cancela		:= 'C';
	SET Estatus_Activo		:= 'A';

	INSERT INTO `HIS-CUENTASAHO` (
		Fecha,				CuentaAhoID,		SucursalID,			ClienteID,		MonedaID,
		TipoCuentaID, 		FechaApertura,		Saldo,				SaldoDispon,	SaldoBloq,
		SaldoSBC,			SaldoIniMes,		CargosMes,			AbonosMes, 		Comisiones,
		SaldoProm,			TasaInteres,		InteresesGen,		ISR, 			TasaISR,
		SaldoIniDia,		CargosDia,			AbonosDia,			Estatus, 		ComApertura,
		IvaComApertura,		ComManejoCta,		IvaComManejoCta,	ComAniversario,	IvaComAniv,
		ComFalsoCobro,		IvaComFalsoCob,		ExPrimDispSeg,		ComDispSeg,		IvaComDispSeg,
		Gat,				ISRReal, 			EmpresaID,			Usuario, 		FechaActual,
		DireccionIP,		ProgramaID, 		Sucursal,			NumTransaccion,	GatReal
		)
		SELECT
		Par_Fecha,				Tmp.CuentaAhoID,		Tmp.SucursalID,			Tmp.ClienteID,		Tmp.MonedaID,
		Tmp.TipoCuentaID,		Tmp.FechaApertura,		Tmp.Saldo,				Tmp.SaldoDispon,	Tmp.SaldoBloq,
		Tmp.SaldoSBC,			Tmp.SaldoIniMes,		Tmp.CargosMes,			Tmp.AbonosMes,		Tmp.Comisiones,
		Tmp.SaldoProm,  		Tmp.TasaInteres,		Tmp.InteresesGen,		Tmp.ISR,  			Tmp.TasaISR,
		Tmp.SaldoIniDia,		Tmp.CargosDia,  		Tmp.AbonosDia,			Tmp.Estatus,		Tmp.ComApertura,
		Tmp.IvaComApertura,		Tmp.ComManejoCta,		Tmp.IvaComManejoCta,	Tmp.ComAniversario,	Tmp.IvaComAniv,
		Tmp.ComFalsoCobro ,		Tmp.IvaComFalsoCob,		Tmp.ExPrimDispSeg,		Tmp.ComDispSeg,		Tmp.IvaComDispSeg,
		Tmp.GatMesAnt,			Tmp.ISRReal,			Tmp.EmpresaID,			Tmp.Usuario,		Tmp.FechaActual,
		Tmp.DireccionIP,		Tmp.ProgramaID,			Tmp.Sucursal,			Tmp.NumTransaccion,	IFNULL(Cue.GatReal, Decimal_Cero)
			FROM 	TMPCUENTASAHOCI AS Tmp
			INNER JOIN CUENTASAHO AS Cue ON Tmp.CuentaAhoID = Cue.CuentaAhoID;


END TerminaStore$$
