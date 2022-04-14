-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCTASAHOMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCTASAHOMOVALT`;

DELIMITER $$
CREATE PROCEDURE `TMPCTASAHOMOVALT`(
	/*- sp usado en el CIERRE DEL MES
	genera los movimientos de las operaciones generadas en el fin
	de mes incluyendo los cobros pendientes.,*/
	Par_FechaOperacion	DATE,			-- Fecha de Operacion
	Par_Movimiento		VARCHAR(5),		-- Naturaleza del Movimiento
	Par_CuentaAhoID		BIGINT(12),		-- Cuenta de Ahorro
	Par_MonedaID		INT(11),		-- Numero de Moneda

	Par_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	/* Declaracion de Constantes*/
	DECLARE Entero_Cero		INT(11);	-- Constante Entero Cero

	DECLARE Var_MovComAper	VARCHAR(4);	-- Constante Movimiento Comision por Apertura
	DECLARE Var_MovComAniv	VARCHAR(4);	-- Constante Movimiento Comision por Aniversario o Anualidad
	DECLARE Var_MovComDisS	VARCHAR(4);	-- Constante Movimiento Comision por Disposicion de Seguridad
	DECLARE Var_MovComManC	VARCHAR(4);	-- Constante Movimiento Comision por Manejo de Cuenta
	DECLARE Var_MovComFalC	VARCHAR(4);	-- Constante Movimiento Comision por Flaso Cobro
	DECLARE Var_MovRendGra	VARCHAR(4);	-- Constante Movimiento Pago de Rendimiento Cuenta Gravado
	DECLARE Var_MovRendExc	VARCHAR(4);	-- Constante Movimiento Pago de Rendimiento Cuenta Excento

	DECLARE Var_MovIvaAper	VARCHAR(4);	-- Constante Movimiento IVA Comision por Apertura
	DECLARE Var_MovIvaAniv	VARCHAR(4);	-- Constante Movimiento IVA Comision por Aniversario o Anualidad
	DECLARE Var_MovIvaDisS	VARCHAR(4);	-- Constante Movimiento IVA Comision por Disposicion de Seguridad
	DECLARE Var_MovIvaManC	VARCHAR(4);	-- Constante Movimiento IVA Comision por Manejo de Cuenta
	DECLARE Var_MovIvaFalC	VARCHAR(4);	-- Constante Movimiento IVA Comision por Flaso Cobro
	DECLARE Var_MovRetISR	VARCHAR(4);	-- Constante Movimiento Retencion ISR

	DECLARE Nat_Cargo		CHAR(1);	-- Constante Naturaleza Cargo
	DECLARE Nat_Abono		CHAR(1);	-- Constante Naturaleza Abono
	DECLARE Var_Si			CHAR(1);	-- Constante SI
	DECLARE Var_No			CHAR(1);	-- Constante NO

	DECLARE Var_MovComSaldoProm	VARCHAR(4);	-- Constante Movimiento Comision Saldo Promedio
	DECLARE Var_MovIVAComSaldoProm	VARCHAR(4);	-- Constante Movimiento IVA Comision Saldo Promedio
	DECLARE Var_NumError	INT(11);		-- Numero de Error
	DECLARE Var_MenError	VARCHAR(400);	-- Mensaje de Error

	-- corresponde con la tabla TIPOSMOVSAHO
	DECLARE Var_ConComAper	VARCHAR(45);	-- Descripcion Movimiento Comision por Apertura
	DECLARE Var_ConComAniv	VARCHAR(45);	-- Descripcion Movimiento Comision por Aniversario o Anualidad
	DECLARE Var_ConComDisS	VARCHAR(45);	-- Descripcion Constante Movimiento Comision por Disposicion de Seguridad
	DECLARE Var_ConComManC	VARCHAR(45);	-- Descripcion Movimiento Comision por Manejo de Cuenta
	DECLARE Var_ConComFalC	VARCHAR(45);	-- Descripcion Movimiento Comision por Flaso Cobro
	DECLARE Var_ConRendGra	VARCHAR(45);	-- Descripcion Movimiento Pago de Rendimiento Cuenta Gravado
	DECLARE Var_ConRendExc	VARCHAR(45);	-- Descripcion Movimiento Pago de Rendimiento Cuenta Excento

	DECLARE Var_ConIvaAper	VARCHAR(45);	-- Descripcion Movimiento IVA Comision por Apertura
	DECLARE Var_ConIvaAniv	VARCHAR(45);	-- Descripcion Movimiento IVA Comision por Aniversario o Anualidad
	DECLARE Var_ConIvaDisS	VARCHAR(45);	-- Descripcion Movimiento IVA Comision por Disposicion de Seguridad
	DECLARE Var_ConIvaManC	VARCHAR(45);	-- Descripcion Movimiento IVA Comision por Manejo de Cuenta
	DECLARE Var_ConIvaFalC	VARCHAR(45);	-- Descripcion Movimiento IVA Comision por Flaso Cobro
	DECLARE Var_ConRetISR	VARCHAR(45);	-- Descripcion Movimiento Retencion ISR
	DECLARE Var_ConComSalProm	VARCHAR(45);	-- Descripcion Movimiento Comision por Saldo Promedio
	DECLARE Var_ConIVAComSalProm	VARCHAR(45);	-- Descripcion Movimiento IVA Comision por Saldo Promedio
	DECLARE Var_ComCabecera	CHAR(1);
	DECLARE Var_IVACabecera	CHAR(1);

	/* Asignacion de Constantes*/
	SET Entero_Cero		:= 0;

	-- corresponde con la tabla TIPOSMOVSAHO
	SET Var_MovComAper	:= '206';
	SET Var_MovComAniv	:= '208';
	SET Var_MovComDisS	:= '214';
	SET Var_MovComManC	:= '202';
	SET Var_MovComFalC	:= '204';
	SET Var_MovRendGra	:= '200';
	SET Var_MovRendExc	:= '201';

	SET Var_MovIvaAper	:= '207';
	SET Var_MovIvaAniv	:= '209';
	SET Var_MovIvaDisS	:= '215';
	SET Var_MovIvaManC	:= '203';
	SET Var_MovIvaFalC	:= '205';
	SET Var_MovRetISR	:= '220';
	SET Var_MovComSaldoProm := '230';
	SET Var_MovIVAComSaldoProm := '231';

	SET Nat_Cargo		:= 'C';
	SET Nat_Abono		:= 'A';
	SET Var_Si			:= 'S';
	SET Var_No			:= 'N';
	SET Var_ComCabecera	:= 'C';
	SET Var_IVACabecera := 'I';

	SET Var_NumError := Entero_Cero;
	SET Var_MenError	:= '';

	CASE Par_Movimiento
		/* Movimientos de Comision por Apertura */
		WHEN Var_MovComAper THEN
			SET Var_ConComAper := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovComAper);

			-- Se inserta el Movimiento de Comision por Apertura
			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Cargo,	CASE WHEN (SaldoDispon >= ComApertura) THEN
																							  ComApertura
																						 WHEN ((ComApertura-SaldoDispon )>0 ) THEN
																							  ROUND(( SaldoDispon - ((SaldoDispon/(1+Iva))*Iva)) ,2)
																					END AS ComApertura,
				Var_ConComAper,	CuentaAhoID,	Var_MovComAper,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE ComApertura > Entero_Cero
			  AND SaldoDispon > Entero_Cero;

			-- Si existe un cobro pendiente se Registra
			CALL COBROSPENDCIEALT(
				Par_FechaOperacion,	Var_MovComAper,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovComAper);

			/* Iva Comision por Apertura*/
			SET Var_ConIvaAper:= (SELECT  Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovIvaAper);

			-- Se inserta el Movimiento de IVA Comision por Apertura
			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Cargo,	CASE WHEN (SaldoDispon >= IvaComApertura) THEN
																							  IvaComApertura
																						 WHEN ((IvaComApertura-SaldoDispon )>0 ) THEN
																							  SaldoDispon
																					END AS IvaComApertura,
				Var_ConIvaAper,	CuentaAhoID,	Var_MovIvaAper,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE IvaComApertura > Entero_Cero
			  AND SaldoDispon > Entero_Cero;

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovIvaAper);
			/* fin Iva Comision por Apertura*/
			/* fin Movimientos de Comision por Apertura */

		/* movimientos de Comision por Anualidad */
		WHEN Var_MovComAniv THEN
			SET Var_ConComAniv := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovComAniv);

			-- Se inserta el Movimiento de Comision por Anualidad
			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Cargo,	CASE WHEN (SaldoDispon >= ComAniversario)  THEN
																							  ComAniversario
																						WHEN ((ComAniversario - SaldoDispon )>0 ) THEN
																							  ROUND(( SaldoDispon - ((SaldoDispon/(1+Iva))*Iva)) ,2)
																					END AS ComAniversario,
				Var_ConComAniv,	CuentaAhoID,	Var_MovComAniv,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE ComAniversario > Entero_Cero
			  AND SaldoDispon > Entero_Cero;

			-- Si existe un cobro pendiente se Registra
			CALL COBROSPENDCIEALT(
				Par_FechaOperacion,	Var_MovComAniv,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovComAniv);

			/*  movimientos de Iva Comision por Anualidad*/
			SET Var_ConIvaAniv := (SELECT  Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovIvaAniv);

			-- Se inserta el Movimiento de IVA Comision por Anualidad
			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Cargo,	CASE WHEN (SaldoDispon >= IvaComAniv) THEN
																							  IvaComAniv
																						 WHEN ((IvaComAniv - SaldoDispon )>0 ) THEN
																							  SaldoDispon END AS IvaComAniv,
				Var_ConIvaAniv,	CuentaAhoID,	Var_MovIvaAniv,	MonedaID,		Usuario,
				FechaActual,	 DireccionIP,	ProgramaID,		Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE IvaComAniv > Entero_Cero
			  AND  SaldoDispon > Entero_Cero;

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovIvaAniv);
			/* fin de  movimientos de Iva Comision por Anualidad*/
			/* fin de  movimientos de  Comision por Anualidad */

		/* Movimientos  Comision por Manejo de Cuenta */
		WHEN Var_MovComManC THEN

			SET Var_ConComManC := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovComManC);

			-- Considerar iva en la comision de manejo de cuenta
			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Cargo,	CASE WHEN (SaldoDispon >= (ComManejoCta + IvaComManejoCta)) THEN
																							  ComManejoCta
																						 WHEN (( (ComManejoCta + IvaComManejoCta)-SaldoDispon )>0 ) THEN
																							  ROUND(( SaldoDispon - ((SaldoDispon/(1+Iva))*Iva)),2) END AS ComManejoCta,


				Var_ConComManC,	CuentaAhoID,	Var_MovComManC,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE ComManejoCta > Entero_Cero
			  AND SaldoDispon > Entero_Cero;


			-- Si existe un cobro pendiente se Registra
			CALL COBROSPENDCIEALT(
				Par_FechaOperacion,	Var_MovComManC,	Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovComManC);

			/* Iva Comision por Manejo de Cuenta*/
			SET Var_ConIvaManC := (SELECT  Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovIvaManC);

			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Cargo,	CASE WHEN (SaldoDispon >= IvaComManejoCta) THEN
																							  IvaComManejoCta
																						 WHEN (( IvaComManejoCta-SaldoDispon )>0 ) THEN
																							  SaldoDispon
																					END AS IvaComManejoCta,
				Var_ConIvaManC,	CuentaAhoID,	Var_MovIvaManC,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE IvaComManejoCta > Entero_Cero
			  AND SaldoDispon > Entero_Cero;

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovIvaManC);
			/* Fin de   Movimientos IVA Comision por Manejo de Cuenta */
			/* Fin  Movimientos  Comision por Manejo de Cuenta */

		/* Movimientos por Rendimiento Gravado*/
		WHEN Var_MovRendGra THEN

			SET Var_ConRendGra := (SELECT  Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovRendGra);


			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,			Fecha,				NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,		TipoMovAhoID,		MonedaID,		Usuario,
				FechaActual,	DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Abono,		InteresesGen,
				Var_ConRendGra,	CuentaAhoID,		Var_MovRendGra,		MonedaID,		Usuario,
				FechaActual,	DireccionIP,		ProgramaID,			Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE InteresesGen > Entero_Cero
			  AND PagaISR = Var_Si;

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Abono,Var_MovRendGra);
			/* Fin  Movimientos por Rendimiento Gravado*/

		/* Movimientos Rendimiento Excento  */
		WHEN Var_MovRendExc THEN

			SET Var_ConRendExc := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovRendExc);

			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,			Fecha,				NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,		TipoMovAhoID,		MonedaID,		Usuario,
				FechaActual,	DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Abono,		InteresesGen,
				Var_ConRendExc,	CuentaAhoID,		Var_MovRendExc,		MonedaID,		Usuario,
				FechaActual,	DireccionIP,		ProgramaID,			Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE InteresesGen > Entero_Cero
			  AND PagaISR = Var_No;

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Abono,Var_MovRendExc);
			/* Fin  Movimientos Rendimiento Excento */

		/* Movmientos por  Retencion ISR  */
		WHEN Var_MovRetISR THEN

			SET Var_ConRetISR := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovRetISR);

			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,			Fecha,				NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,		TipoMovAhoID,		MonedaID,		Usuario,
				FechaActual,	DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,	Nat_Cargo,		ISR,
				Var_ConRetISR,	CuentaAhoID,		Var_MovRetISR,		MonedaID,		Usuario,
				FechaActual,	DireccionIP,		ProgramaID,			Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM  TMPCUENTASAHOCI
			WHERE ISR > Entero_Cero
			  AND InteresesGen > Entero_Cero
			  AND PagaISR = Var_Si;

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovRetISR);

			-- Se actualiza el valor del ISR en la tabla CALCULOINTERESREAL
			UPDATE CALCULOINTERESREAL Cal
			INNER JOIN TMPCUENTASAHOCI Tmp SET
				Cal.ISR = Tmp.ISR
			WHERE Cal.InstrumentoID = Tmp.CuentaAhoID
			  AND Cal.ClienteID = Tmp.ClienteID
			  AND Tmp.ISR > Entero_Cero
			  AND Tmp.InteresesGen > Entero_Cero
			  AND Tmp.PagaISR = Var_Si
			  AND Cal.Fecha = Par_FechaOperacion;
			/*Fin Movmientos por  Retencion ISR */

			/* INICIO COMISION SALDO PROMEDIO  */

		WHEN Var_MovComSaldoProm THEN
			UPDATE TMPCUENTASAHOCI
				SET ComSalPromCob = CASE  WHEN SaldoDispon >= (ComSalProm + IVAComSalProm)
										THEN ComSalProm ELSE ROUND(( SaldoDispon - ((SaldoDispon/(1+Iva))*Iva)),2) END ,
					IVAComSalPromCob = CASE WHEN SaldoDispon >= (ComSalProm + IVAComSalProm)
										THEN IVAComSalProm ELSE ROUND(((SaldoDispon/(1+Iva))*Iva),2) END
			WHERE ComSalProm > Entero_Cero;

			SET Var_ConComSalProm := (SELECT Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovComSaldoProm);

			-- Se inserta el Movimiento de Comision por Apertura
			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,	Par_FechaOperacion,		Nat_Cargo,		ComSalPromCob,
				Var_ConComSalProm,	CuentaAhoID,	Var_MovComSaldoProm,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE ComSalProm > Entero_Cero
			AND SaldoDispon > Entero_Cero;

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovComSaldoProm);

			/* Iva Comision por Apertura*/
			SET Var_ConIVAComSalProm:= (SELECT  Descripcion FROM TIPOSMOVSAHO WHERE TipoMovAhoID = Var_MovIVAComSaldoProm);

			-- Se inserta el Movimiento de IVA Comision por Saldo Promedio
			INSERT INTO TMPCTASAHOMOV (
				CuentaAhoID,	NumeroMov,		Fecha,			NatMovimiento,	CantidadMov,
				DescripcionMov,	ReferenciaMov,	TipoMovAhoID,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		NumTransaccion,
				EmpresaID)
			SELECT
				CuentaAhoID,	Aud_NumTransaccion,		Par_FechaOperacion,		Nat_Cargo,		IVAComSalPromCob,
				Var_ConIVAComSalProm,	CuentaAhoID,	Var_MovIVAComSaldoProm,	MonedaID,		Usuario,
				FechaActual,	DireccionIP,	ProgramaID,		Sucursal,		Aud_NumTransaccion,
				EmpresaID
			FROM TMPCUENTASAHOCI
			WHERE IVAComSalProm > Entero_Cero
			AND SaldoDispon > Entero_Cero;

			-- Se realiza La Actualizacion de Registro de Cobro de Saldo Promedio
			CALL COMISIONESSALPROAHOCIEPRO(
				Var_No,				Var_NumError,		Var_MenError,		Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual, 	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			-- Se actualiza el Saldo de la cuenta
			CALL TMPSALDOSAHORROACT(Nat_Cargo,Var_MovIVAComSaldoProm);
			/* fin Iva Comision por Apertura*/
			/* FIN COMISION SALDO PROMEDIO */

	END CASE;

END TerminaStore$$