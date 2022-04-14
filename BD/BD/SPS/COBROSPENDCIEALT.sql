-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBROSPENDCIEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBROSPENDCIEALT`;

DELIMITER $$
CREATE PROCEDURE `COBROSPENDCIEALT`(
	-- Store Procedure para el Alta de cobro Pendientes al cierre de Mes
	-- Modulo: Cuentas de Ahorro
	Par_FechaOperacion	DATE,			-- Fecha de Operacion
	Par_Movimiento		VARCHAR(5),		-- Naturaleza del Movimiento

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Entero_Cero		INT(11);	-- Constante Entero Cero
	DECLARE Nat_Cargo		CHAR(1);	-- Constante Naturaleza Cargo
	DECLARE Nat_Abono		CHAR(1);	-- Constante Naturaleza Abono
	DECLARE	Est_Pendiente	CHAR(1);	-- Constante Estatus Pendiente

	DECLARE Var_MovComAper	VARCHAR(4);	-- Constante Movimiento Comision por Apertura
	DECLARE Var_MovComAniv	VARCHAR(4);	-- Constante Movimiento Comision por Aniversario o Anualidad
	DECLARE Var_MovComDisS	VARCHAR(4);	-- Constante Movimiento Comision por Disposicion de Seguridad
	DECLARE Var_MovComManC	VARCHAR(4);	-- Constante Movimiento Comision por Manejo de Cuenta
	DECLARE Var_MovComFalC	VARCHAR(4);	-- Constante Movimiento Comision por Flaso Cobro

	DECLARE Var_MovIvaAper	VARCHAR(4);	-- Constante Movimiento IVA Comision por Apertura
	DECLARE Var_MovIvaAniv	VARCHAR(4);	-- Constante Movimiento IVA Comision por Aniversario o Anualidad
	DECLARE Var_MovIvaDisS	VARCHAR(4);	-- Constante Movimiento IVA Comision por Disposicion de Seguridad
	DECLARE Var_MovIvaManC	VARCHAR(4);	-- Constante Movimiento IVA Comision por Manejo de Cuenta
	DECLARE Var_MovIvaFalC	VARCHAR(4);	-- Constante Movimiento IVA Comision por Flaso Cobro

	DECLARE	Var_ConMov		VARCHAR(150);-- Descripcion Movimiento

	-- Asignacion de Constantes
	SET	Entero_Cero		:= 0;
	SET	Nat_Cargo		:= 'C';
	SET	Nat_Abono		:= 'A';
	SET	Est_Pendiente	:= 'P';
	SET	Var_MovComAper	:= '206';
	SET	Var_MovComAniv	:= '208';
	SET	Var_MovComDisS	:= '214';
	SET	Var_MovComManC	:= '202';
	SET	Var_MovComFalC	:= '204';

	SET	Var_MovIvaAper	:= '207';
	SET	Var_MovIvaAniv	:= '209';
	SET	Var_MovIvaDisS	:= '215';
	SET	Var_MovIvaManC	:= '203';
	SET	Var_MovIvaFalC	:= '205';

	CASE Par_Movimiento
		/* Movimientos de Comision por Apertura */
		WHEN Var_MovComAper	THEN

			SET Var_ConMov := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovComAper);

			-- Insercion de los Cobros pendientes por Comision por Apertura
			INSERT INTO COBROSPEND (
					ClienteID,		CuentaAhoID,		Fecha,				CantPenOri,			CantPenAct,
					Estatus,		TipoMovAhoID,		Descripcion,		Transaccion,		EmpresaID,
					Usuario,		FechaActual,		DireccionIP,		ProgramaID, 		Sucursal,
					NumTransaccion,	IVA)
			SELECT	C.ClienteID,	C.CuentaAhoID,		Par_FechaOperacion,	CASE WHEN ((C.ComApertura-C.SaldoDispon )> Entero_Cero)
																					 THEN ROUND( C.ComApertura - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)) ,2)
																			END AS CantPenOri,
																			CASE WHEN ((C.ComApertura-C.SaldoDispon )> Entero_Cero)
																					 THEN ROUND( C.ComApertura - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)) ,2)
																			END AS CantPenAct,
					Est_Pendiente,	Var_MovComAper,		Var_ConMov,			C.NumTransaccion,	C.EmpresaID,
					C.Usuario,		C.FechaActual,		C.DireccionIP,		C.ProgramaID,		C.Sucursal,
					C.NumTransaccion,		CASE WHEN ((C.ComApertura-C.SaldoDispon )> Entero_Cero)
													 THEN ROUND( C.ComApertura - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)),2) *C.Iva
											END AS IvaComApertura
			FROM TMPCUENTASAHOCI C
			WHERE (C.ComApertura-C.SaldoDispon) > Entero_Cero
			  AND C.ComApertura > Entero_Cero
			  AND C.SaldoDispon < C.ComApertura;

			-- Actualizacion de IVA de Comision por Apertura a Cobrar
			UPDATE 	TMPCUENTASAHOCI TCA,
					COBROSPEND CP SET
				TCA.IvaComApertura = TCA.SaldoDispon - ROUND( (TCA.SaldoDispon - ((TCA.SaldoDispon/(1+TCA.Iva))*TCA.Iva)),2)
			WHERE TCA.ClienteID = CP.ClienteID
			  AND (TCA.ComApertura-TCA.SaldoDispon) > Entero_Cero
			  AND TCA.ComApertura > Entero_Cero
			  AND TCA.SaldoDispon < TCA.ComApertura
			  AND CP.TipoMovAhoID = Var_MovComAper;

			-- Actualizacion de Comision por Apertura a Cobrar
			UPDATE 	TMPCUENTASAHOCI TCA,
					COBROSPEND CP SET
				TCA.ComApertura = ROUND( (TCA.SaldoDispon - ((TCA.SaldoDispon/(1+TCA.Iva))*TCA.Iva)) ,2)
			WHERE TCA.ClienteID = CP.ClienteID
			  AND (TCA.ComApertura-TCA.SaldoDispon) > Entero_Cero
			  AND TCA.ComApertura > Entero_Cero
			  AND TCA.SaldoDispon < TCA.ComApertura
			  AND CP.TipoMovAhoID = Var_MovComAper;

		/* movimientos de Comision por Anualidad */
		WHEN Var_MovComAniv THEN
			SET Var_ConMov := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovComAniv);

			-- Insercion de los Cobros pendientes por Comision por Anualidad
			INSERT INTO COBROSPEND (
					ClienteID,		CuentaAhoID,		Fecha,				CantPenOri,			CantPenAct,
					Estatus,		TipoMovAhoID,		Descripcion,		Transaccion,		EmpresaID,
					Usuario,		FechaActual,		DireccionIP,		ProgramaID, 		Sucursal,
					NumTransaccion,	IVA)
			SELECT 	C.ClienteID,	C.CuentaAhoID,		Par_FechaOperacion,	CASE WHEN ((C.ComAniversario-C.SaldoDispon )> Entero_Cero)
																					 THEN ROUND( C.ComAniversario - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)) ,2)
																			END AS CantPenOri,
																			CASE WHEN ((C.ComAniversario-C.SaldoDispon )> Entero_Cero)
																					 THEN ROUND( C.ComAniversario - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)) ,2)
																			END AS CantPenAct,
					Est_Pendiente,	Var_MovComAniv,		Var_ConMov,			C.NumTransaccion,	C.EmpresaID,
					C.Usuario,		C.FechaActual,		C.DireccionIP,		C.ProgramaID,		C.Sucursal,
					C.NumTransaccion,	CASE WHEN ((C.ComAniversario-C.SaldoDispon )> Entero_Cero)
												 THEN ROUND( C.ComAniversario - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)),2)*C.Iva
										END AS IvaComAniversario
			FROM TMPCUENTASAHOCI C
			WHERE (C.ComAniversario-C.SaldoDispon) > Entero_Cero
			  AND C.ComAniversario > Entero_Cero
			  AND C.SaldoDispon <	C.ComAniversario;

			-- Actualizacion de IVA de Comision por Anualidad
			UPDATE 	TMPCUENTASAHOCI TCA,
					COBROSPEND CP SET
				TCA.IvaComAniv = TCA.SaldoDispon - ROUND( (TCA.SaldoDispon - ((TCA.SaldoDispon/(1+TCA.Iva))*TCA.Iva)),2)
			WHERE TCA.ClienteID = CP.ClienteID
			 AND (TCA.ComAniversario-TCA.SaldoDispon) > Entero_Cero
			 AND TCA.ComAniversario > Entero_Cero
			 AND TCA.SaldoDispon < TCA.ComAniversario
			 AND CP.TipoMovAhoID = Var_MovComAniv;

			-- Actualizacion de Comision por Anualidad
			UPDATE 	TMPCUENTASAHOCI TCA,
					COBROSPEND CP SET
				TCA.ComAniversario = ROUND( (TCA.SaldoDispon - ((TCA.SaldoDispon/(1+TCA.Iva))*TCA.Iva)) ,2)
			WHERE TCA.ClienteID = CP.ClienteID
			  AND (TCA.ComAniversario-TCA.SaldoDispon) > Entero_Cero
			  AND TCA.ComAniversario > Entero_Cero
			  AND TCA.SaldoDispon <	TCA.ComAniversario
			  AND CP.TipoMovAhoID = Var_MovComAniv;

		/* Movimientos  Comision por Manejo de Cuenta */
		WHEN Var_MovComManC	THEN
			SET Var_ConMov := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovComManC);

			-- Insercion de los Cobros pendientes por Manejo de Cuenta
			INSERT INTO COBROSPEND (
					ClienteID,		CuentaAhoID,		Fecha,				CantPenOri,			CantPenAct,
					Estatus,		TipoMovAhoID,		Descripcion,		Transaccion,		EmpresaID,
					Usuario,		FechaActual,		DireccionIP,		ProgramaID, 		Sucursal,
					NumTransaccion,	IVA)
			SELECT 	C.ClienteID,	C.CuentaAhoID,		Par_FechaOperacion,	CASE WHEN (( (C.ComManejoCta + C.IvaComManejoCta)-C.SaldoDispon )> Entero_Cero)
																					 THEN ROUND(  C.ComManejoCta - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)) ,2)
																			END AS CantPenOri,
																				CASE WHEN (( (C.ComManejoCta + C.IvaComManejoCta)-C.SaldoDispon )> Entero_Cero)
																					 THEN ROUND(  C.ComManejoCta - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)) ,2)
																			END AS CantPenAct,
					Est_Pendiente,	Var_MovComManC,		Var_ConMov,			C.NumTransaccion,	C.EmpresaID,
					C.Usuario,		C.FechaActual,		C.DireccionIP,		C.ProgramaID,		C.Sucursal,
					C.NumTransaccion,	CASE WHEN (( (C.ComManejoCta + C.IvaComManejoCta)-C.SaldoDispon )> Entero_Cero)
												 THEN ROUND(  C.ComManejoCta - (C.SaldoDispon - ((C.SaldoDispon/(1+C.Iva))*C.Iva)),2)*C.Iva
										END AS IvaComManejoCta
			FROM TMPCUENTASAHOCI C
			WHERE ((C.ComManejoCta + C.IvaComManejoCta)-C.SaldoDispon) > Entero_Cero
			  AND C.ComManejoCta > Entero_Cero
			  AND C.SaldoDispon < (C.ComManejoCta + C.IvaComManejoCta);

			-- Actualizacion de IVA de Comision por Manejo de Cuenta
			UPDATE 	TMPCUENTASAHOCI TCA,
					COBROSPEND CP SET
				TCA.IvaComManejoCta = TCA.SaldoDispon - ROUND( (TCA.SaldoDispon - ((TCA.SaldoDispon/(1+TCA.Iva))*TCA.Iva)),2)
			WHERE TCA.ClienteID = CP.ClienteID
			  AND ((TCA.ComManejoCta + TCA.IvaComManejoCta)-TCA.SaldoDispon) > Entero_Cero
			  AND TCA.ComManejoCta > Entero_Cero
			  AND TCA.SaldoDispon > Entero_Cero
			  AND CP.TipoMovAhoID = Var_MovComManC;

			-- Actualizacion de Comision por Manejo de Cuenta
			UPDATE 	TMPCUENTASAHOCI TCA,
					COBROSPEND CP SET
				TCA.ComManejoCta = ROUND( (TCA.SaldoDispon - ((TCA.SaldoDispon/(1+TCA.Iva))*TCA.Iva)) ,2)
			WHERE TCA.ClienteID = CP.ClienteID
			 AND ((TCA.ComManejoCta + TCA.IvaComManejoCta)-TCA.SaldoDispon) > Entero_Cero
			 AND TCA.ComManejoCta > Entero_Cero
			 AND TCA.SaldoDispon < TCA.ComManejoCta
			 AND CP.TipoMovAhoID = Var_MovComManC;
	END CASE;

END TerminaStore$$