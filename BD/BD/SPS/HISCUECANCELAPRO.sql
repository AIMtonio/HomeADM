-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISCUECANCELAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISCUECANCELAPRO`;DELIMITER $$

CREATE PROCEDURE `HISCUECANCELAPRO`(

	Par_Fecha DATE
		)
TerminaStore: BEGIN


DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Entero_Cero		INT;
DECLARE Estatus_Cancela	CHAR(1);
DECLARE Decimal_Cero	DECIMAL(12,2);
DECLARE Estatus_Activo	CHAR(1);


SET	Cadena_Vacia	:= '';
SET	Entero_Cero		:= 0;
SET Decimal_Cero	:= 0.00;
SET Estatus_Cancela	:= 'C';
SET Estatus_Activo	:= 'A';




INSERT INTO TMPCUENTASAHOCI (
		CuentaAhoID,		SucursalID,			ClienteID,			MonedaID,			TipoCuentaID,
		FechaApertura,		Saldo,				SaldoDispon,		SaldoBloq,			SaldoSBC,
		SaldoIniMes,		CargosMes,			AbonosMes,			Comisiones,			SaldoProm,
 		TasaInteres,		InteresesGen,		ISR,  				TasaISR,			SaldoIniDia,
		CargosDia,  		AbonosDia,			Estatus,			ComApertura,		IvaComApertura,
		ComManejoCta,		IvaComManejoCta,	ComAniversario,		IvaComAniv,			ComFalsoCobro ,
		IvaComFalsoCob,		ExPrimDispSeg,		ComDispSeg,			IvaComDispSeg,		GatMesAnt,
		EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
		Sucursal,			NumTransaccion)
SELECT 	cue.CuentaAhoID,	cue.SucursalID, 	cue.ClienteID ,		cue.MonedaID,		cue.TipoCuentaID,
		cue.FechaReg,		cue.Saldo,			cue.SaldoDispon,    cue.SaldoBloq,		cue.SaldoSBC,
		cue.SaldoIniMes, 	cue.CargosMes, 		cue.AbonosMes,		cue.Comisiones,		cue.SaldoProm,
		cue.TasaInteres,	cue.InteresesGen,	cue.ISR,			cue.TasaISR,		cue.SaldoIniDia,
		cue.CargosDia,		cue.AbonosDia,		cue.Estatus, 		Decimal_Cero,		Decimal_Cero,
 		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
 		Decimal_Cero,		Cadena_Vacia,		Decimal_Cero,		Decimal_Cero,		Decimal_Cero,
		cue.EmpresaID,		cue.Usuario,  		cue.FechaActual,	cue.DireccionIP,	cue.ProgramaID,
		cue.Sucursal,		cue.NumTransaccion
FROM	CUENTASAHO cue
WHERE	cue.Estatus = Estatus_Cancela
	AND cue.FechaCan >= DATE_ADD(Par_Fecha, INTERVAL -1*(DAY(Par_Fecha))+1 DAY)
	AND cue.FechaCan <= Par_Fecha
	GROUP BY cue.CuentaAhoID;

END TerminaStore$$