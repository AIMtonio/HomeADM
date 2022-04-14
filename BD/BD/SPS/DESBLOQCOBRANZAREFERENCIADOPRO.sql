-- DESBLOQCOBRANZAREFERENCIADOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESBLOQCOBRANZAREFERENCIADOPRO`;
DELIMITER $$

CREATE PROCEDURE `DESBLOQCOBRANZAREFERENCIADOPRO`(
	-- SP PARA APLICAR AUTOMATICAMENTE EL DESBLOQUEO DE SALDO POR MOTIVO DE COBRANZA REFERENCIADA
	Par_Fecha				DATE,					-- Parametro de fecha

	Par_Salida				CHAR(1),				-- Parametro de Salida SI o NO
	INOUT Par_NumErr		INT(11),				-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de error

	Aud_EmpresaID			INT(11),				-- Parametro de Auditoria
	Aud_Usuario				INT(11),				-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal			INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de Auditoria
)TerminaStore: BEGIN


	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(30);	-- Variable de Control
	DECLARE Var_CantConsecutivoID	INT(11);
	DECLARE Var_ContConsecutivoID	INT(11);
	DECLARE Var_CreditoID			BIGINT(12);
	DECLARE Var_CuentaID			BIGINT(12);
	DECLARE Var_SaldoExigible		DECIMAL(14,2);
	DECLARE Var_SaldoTotalAdeudo	DECIMAL(14,2);
	DECLARE Var_MontoBloqueado		DECIMAL(14,2);
	DECLARE Var_CantTmpBloqDesbloqueoID	INT(11);
	DECLARE Var_ContTmpBloqDesbloqueoID	INT(11);
	DECLARE Var_SaldoDesbloqueado		DECIMAL(12,2);
	DECLARE Var_BloqueoID			INT(11);
	DECLARE Var_CuentaAhoID			BIGINT(12);		-- ID de la cuenta de ahorro
	DECLARE Var_MontoBloq			DECIMAL(12,2);
	DECLARE Var_Referencia			BIGINT(20);
	DECLARE Var_MontoPago			DECIMAL(12,2);
	DECLARE Var_Poliza				BIGINT(20);
	DECLARE Var_Consecutivo			BIGINT(20);
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Var_MontoBloquear		DECIMAL(12,2);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Var_MontoPagar			DECIMAL(12,2);
    DECLARE Var_MinutosBit   		INT(11);
    DECLARE Var_FecBitaco			DATETIME;

	-- DECLARACION DE CONSTANTES
	DECLARE Constante_SI			CHAR(1);		-- Constante SI
	DECLARE Constante_NO			CHAR(1);		-- Constante NO
	DECLARE Decimal_Cero			DECIMAL(12,2);	-- Constante DECIMAL Cero
	DECLARE Entero_Cero				TINYINT;		-- Constante Entero Cero
	DECLARE Entero_UNO				TINYINT;		-- Constante ENtero 1

	DECLARE Naturaleza_DesBloq	CHAR(1);
	DECLARE Naturaleza_Bloq		CHAR(1);
	DECLARE TipoBloq			INT(11);
	DECLARE TipoDesBloq			INT(11);
	DECLARE FechaDelSistema		DATE;
	DECLARE Descrip_Bloq		VARCHAR(200);
	DECLARE Descrip_DesBloq		VARCHAR(200);
	DECLARE Cons_ExigibleAbono	CHAR(1);			-- Constante en caso de no tener exigible Abono a cuenta
	DECLARE Cons_SobranteAbono	CHAR(1);			-- En caso de tener sobrante realizar Abono a cuenta

	DECLARE Finiquito_SI		CHAR(1);
	DECLARE Finiquito_NO		CHAR(1);			-- No para finiquito del credito
	DECLARE PrePago_NO			CHAR(1);			-- No para prepago de credito
	DECLARE RespalCred_NO		CHAR(1);			-- Valor NO para Respaldo de credito
	DECLARE RespalCred_SI		CHAR(1);			-- Valor SI para respaldo del credito
	DECLARE Var_AltaEncPoliza	CHAR(1);			-- Variable para alta de Poliza
	DECLARE Var_OrigenC			CHAR(1);			-- Origen define de donde viene la peticion  C = Cargo A cuenta
	DECLARE Var_OrigenR			CHAR(1);			-- Origen define de donde viene la peticion R =Cobranza Referenciada
	DECLARE Var_MonedaID		INT(11);
	DECLARE Estatus_Vigente		CHAR(1);
	DECLARE Estatus_Vencido		CHAR(1);
    DECLARE Pro_CobranzaRef		INT(11);

	-- ASIGNACION DE CONSTANTES
	SET Constante_SI			:= 'S';
	SET Constante_NO			:= 'N';
	SET Decimal_Cero			:= 0.0;
	SET Entero_Cero				:= 0;
	SET Entero_UNO				:= 1;

	SET Naturaleza_Bloq		:= 'B';
	SET Naturaleza_DesBloq	:= 'D';
	SET TipoBloq			:= 26;
	SET TipoDesBloq			:= 26;
	SET FechaDelSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Descrip_Bloq		:= 'BLOQUEO AUT. COBRANZA REFERENCIADO';
	SET Descrip_DesBloq		:= 'DESBLOQUEO AUT. COBRANZA REFERENCIADO';
	SET Cons_ExigibleAbono	:= 'A';			-- Constante en caso de no tener exigible Abono a cuenta
	SET Cons_SobranteAbono	:= 'A';			-- En caso de tener sobrante realizar Abono a cuenta

	SET Var_OrigenR			:= 'R';		-- Origen define de donde viene la peticion R = Cobranza Referenciada
	SET PrePago_NO			:= 'N';		-- NO es un PrePago
	SET Finiquito_SI		:= 'S';		-- SI es un Finiquito o Liquidacion Total Anticipada
	SET Finiquito_NO		:= 'N';		-- NO es un Finiquito o Liquidacion Total Anticipada
	SET RespalCred_NO		:= 'N';		-- Valor NO para Respaldo de credito
	SET RespalCred_SI		:= 'S';		-- Valor SI para respaldo del credito
	SET Var_AltaEncPoliza	:= 'S';		-- Variable para alta de Poliza
	SET Var_OrigenC			:= 'C';		-- Origen define de donde viene la peticion C = Cargo A cuenta
	SET Var_MonedaID		:= 1;
	SET Cadena_Vacia		:= '';
	SET Var_MontoPagar		:= Decimal_Cero;
	SET Estatus_Vigente		:= 'V';
	SET Estatus_Vencido		:= 'B';
	SET Pro_CobranzaRef		:= 10002;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  := 999;
			SET Par_ErrMen  := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DESBLOQCOBRANZAREFERENCIADOPRO');
			SET Var_Control := 'SQLEXCEPTION' ;
		END;

		-- BORRAMOS EL REGISTRO DE LA TABLA TEMPORAL DE PASO A LLENAR
		DELETE FROM TMPDESBLOQCOBRANZAREF;
		DELETE FROM TMPBLOQDESBLOQUEO;

		SET @NumeroID	:= Entero_Cero;

		-- CONSULTAMOS TODOS LOS CREDITOS QUE PRESENTAN SALDOS EXIGIBLE A FECHA SISTEMA PARA PODER EVALUARLO SI CUENTAN CON UN SALDO BLOQUEADO
		-- DE COBRANZA REFERENCIADA PARA SER DESBLOQUEADO.
		INSERT INTO TMPDESBLOQCOBRANZAREF(DesbloqCobranzaRefID,	CreditoID,	CuentaID,	SaldoExigible,		MontoBloqueado)
			SELECT	(@NumeroID:=@NumeroID+Entero_Uno),	CRED.CreditoID,		CRED.CuentaID,	FUNCIONEXIGIBLE(CRED.CreditoID) AS SaldoExigible,	SUM(BLOQ.MontoBloq) AS MontoBloqueado
				FROM BLOQUEOS BLOQ
				INNER JOIN CREDITOS CRED ON BLOQ.Referencia = CRED.CreditoID
				INNER JOIN PRODUCTOSCREDITO PROD ON PROD.ProducCreditoID = CRED.ProductoCreditoID
					WHERE BLOQ.NatMovimiento = Naturaleza_Bloq
						AND BLOQ.TiposBloqID = TipoBloq
						AND CRED.Estatus IN(Estatus_Vigente,Estatus_Vencido)
						AND BLOQ.FolioBloq = Entero_Cero
						AND PROD.ProductoNomina = Constante_NO
						AND PROD.EsAgropecuario = Constante_NO
						GROUP BY BLOQ.Referencia;

		-- REALIZAMOS EL CONTEO DE LOS REGISTRO DE LA TABLA DE PASO
		SELECT COUNT(DesbloqCobranzaRefID),	Entero_Uno
			INTO Var_CantConsecutivoID,		Var_ContConsecutivoID
			FROM TMPDESBLOQCOBRANZAREF;

		-- Hacemos un loop while para ir procesando cada unas de los registro
		WHILE (Var_ContConsecutivoID <= Var_CantConsecutivoID) DO
			SET Var_CreditoID			:= Entero_Cero;
			SET Var_CuentaID			:= Entero_Cero;
			SET Var_SaldoExigible		:= Decimal_Cero;
			SET Var_MontoBloqueado		:= Decimal_Cero;
			SET Var_SaldoDesbloqueado	:= Decimal_Cero;
			SET Var_Estatus				:= Cadena_Vacia;
			SET Var_MontoBloquear		:= Decimal_Cero;
			SET Par_NumErr				:= Entero_Cero;
			SET Par_ErrMen				:= Entero_Cero;
			SET Var_SaldoTotalAdeudo	:= Entero_Cero;

			-- Consultamos la Informacion a realizar la busqueda para desbloqueo del saldo
			SELECT CreditoID,	CuentaID,	SaldoExigible,	MontoBloqueado
				INTO Var_CreditoID,	Var_CuentaID,	Var_SaldoExigible,	Var_MontoBloqueado
				FROM TMPDESBLOQCOBRANZAREF
				WHERE DesbloqCobranzaRefID = Var_ContConsecutivoID;

			-- BORRAMOS LOS REGISTRO DE LA TABLA DE PASO
			DELETE FROM TMPBLOQDESBLOQUEO ;
			SET @NumeroID2	:= Entero_Cero;

			-- VALIDAMOS SI EL CREDITO CUENTA CON EXIGIBILIDAD Y SALDO BLOQUEADO
			IF (Var_CreditoID > Entero_Cero AND Var_SaldoExigible > Decimal_Cero AND Var_MontoBloqueado > Decimal_Cero) THEN
				-- INSERTAMOS TODOS LOS DEL FOLIO DE BLOQUEO REGISTRADO PARA EL CREDITO
				INSERT INTO TMPBLOQDESBLOQUEO(TmpBloqDesbloqueoID,	BloqueoID,		CuentaAhoID,		MontoBloq,		Referencia)
					SELECT (@NumeroID2:=@NumeroID2+Entero_Uno),BloqueoID,		CuentaAhoID,		MontoBloq,		Referencia
						FROM BLOQUEOS
						WHERE Referencia = Var_CreditoID
							AND CuentaAhoID = Var_CuentaID
							AND TiposBloqID = TipoBloq
							AND FolioBloq = Entero_Cero
							AND NatMovimiento = Naturaleza_Bloq
							ORDER BY FechaMov ASC;

				-- CONSULTAMOS EL SALDO TOTAL ADEUDO DEL CREDITO
				SET Var_SaldoTotalAdeudo	:= (SELECT FNTOTALADEUDO(Var_CreditoID));
				SET Var_SaldoTotalAdeudo	:= IFNULL(Var_SaldoTotalAdeudo,Decimal_Cero);

				-- REALIZAMOS EL CONTEO DE LOS REGISTRO DE LA TABLA DE PASO
				SELECT COUNT(TmpBloqDesbloqueoID),	Entero_Uno
					INTO Var_CantTmpBloqDesbloqueoID,	Var_ContTmpBloqDesbloqueoID
					FROM TMPBLOQDESBLOQUEO;

				-- Hacemos un loop while para ir procesando cada unas de las transaciones pendientes.
				WHILE (Var_ContTmpBloqDesbloqueoID <= Var_CantTmpBloqDesbloqueoID) DO
					SET Var_BloqueoID	:= Entero_Cero;
					SET Var_CuentaAhoID := Entero_Cero;
					SET Var_MontoBloq	:= Decimal_Cero;
					SET Var_Referencia	:= Entero_Cero;

					SELECT BloqueoID,		CuentaAhoID,		MontoBloq,		Referencia
						INTO Var_BloqueoID,		Var_CuentaAhoID,		Var_MontoBloq,		Var_Referencia
						FROM TMPBLOQDESBLOQUEO
						WHERE TmpBloqDesbloqueoID = Var_ContTmpBloqDesbloqueoID
						AND CuentaAhoID = Var_CuentaID;

					-- EJECUTAMOS EL SP DE DESBOQUEO DE SALDO
					CALL BLOQUEOSPRO(	Var_BloqueoID,		Naturaleza_DesBloq,		Var_CuentaAhoID,	FechaDelSistema,	Var_MontoBloq,
										Aud_FechaActual,	TipoDesBloq,			Descrip_DesBloq,	Var_CreditoID,		Cadena_Vacia,
										Cadena_Vacia,		Constante_NO,			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
										Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
										Aud_NumTransaccion);

					-- VALIDAMOS LA RESPUESTA
					IF(Par_NumErr <> Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;

					-- SUMAMOS LA VARIABLE DEL MONTO  DESBLOQUEADO
					SET Var_SaldoDesbloqueado	:= Var_SaldoDesbloqueado + Var_MontoBloq;

					-- VALIDAMOS QUE EL MONTO DESBLOQUEADO ALCANCE PARA COBRAR LO EXIGIBLE DEL CREDITO
					-- PARA SACARLO DEL CICLO Y PROCEDER AL PAGO DEL CREDITO
					IF (Var_SaldoDesbloqueado >= Var_SaldoExigible AND Var_SaldoExigible <> Var_SaldoTotalAdeudo ) THEN
						SET Var_ContTmpBloqDesbloqueoID := Var_CantTmpBloqDesbloqueoID + 1;
					ELSE
						SET Var_ContTmpBloqDesbloqueoID := Var_ContTmpBloqDesbloqueoID + 1;
					END IF;
				END WHILE;

				-- Validamos el monto a pagar del  credito
				IF(Var_SaldoDesbloqueado >= Var_SaldoExigible) THEN
					SET Var_MontoPagar	:= Var_SaldoExigible;
				ELSE
					SET Var_MontoPagar	:= Var_SaldoDesbloqueado;
				END IF;

				IF(Var_SaldoExigible = Var_SaldoTotalAdeudo)THEN
					SET Finiquito_NO	:= Constante_SI;
				ELSE
					SET Finiquito_NO	:= Constante_NO;
				END IF;

				-- REALIZAMOS EL PAGO DEL CREDITO CON EL SALDO DESBLOQUEADO PARA CUBRIR LO EXIGIBLE
				CALL PAGOCREDITOPRO(	Var_CreditoID,	Var_CuentaAhoID,	Var_MontoPagar,			Var_MonedaID,		PrePago_NO,
										Finiquito_NO,	Aud_EmpresaID,		Constante_NO,			Var_AltaEncPoliza,	Var_MontoPago,
										Var_Poliza,		Par_NumErr,			Par_ErrMen,				Var_Consecutivo,	Var_OrigenC,
										Var_OrigenR,	RespalCred_SI,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
										Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion );

				IF Par_NumErr <> Entero_Cero THEN
					LEAVE ManejoErrores;
				END IF;

				-- Validamos que el credito no se haya liquidado y asi poder realizar el bloqueo del saldo remnente despues de aplicar el pago exigible
				SELECT Estatus
					INTO Var_Estatus
					FROM CREDITOS
					WHERE CreditoID = Var_CreditoID;

				IF (Var_Estatus <> 'P' AND Var_SaldoDesbloqueado >= Var_SaldoExigible) THEN
					SET Var_MontoBloquear	:= Var_SaldoDesbloqueado - Var_SaldoExigible;
					-- VOLVEMOS A BLOQUEAR LA DIFERENCIA DEL SALDO DESPUES DE APLICAR LO EXIGIBLE
					CALL BLOQUEOSPRO(	Entero_Cero,		Naturaleza_Bloq,	Var_CuentaAhoID,	FechaDelSistema,	Var_MontoBloquear,
										Aud_FechaActual,	TipoBloq,			Descrip_Bloq,		Var_CreditoID,		Cadena_Vacia,
										Cadena_Vacia,		Constante_NO,		Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,
										Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
										Aud_NumTransaccion);

					-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
				
			END IF;

			SET Var_ContConsecutivoID := Var_ContConsecutivoID + 1;
		END WHILE;

		SET Var_FecBitaco   := NOW();
		SET Var_MinutosBit  := TIMESTAMPDIFF(MINUTE, Var_FecBitaco, NOW());

		CALL BITACORABATCHALT(	Pro_CobranzaRef,	Par_Fecha,			Var_MinutosBit,		Aud_EmpresaID,		Aud_Usuario,
								Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		DELETE FROM TMPDESBLOQCOBRANZAREF;
		DELETE FROM TMPBLOQDESBLOQUEO;

		SET Par_NumErr := 0;
		SET Par_ErrMen := CONCAT('Proceso Realizado Exitosamente');

	END ManejoErrores;


	-- Si la salida es SI devuelve mensaje de exito
	IF (Par_Salida = Constante_SI) THEN
		SELECT	Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control	AS Control;
	END IF;

END TerminaStore$$
