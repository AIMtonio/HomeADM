-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COBRANZAAUTREFEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `COBRANZAAUTREFEPRO`;
DELIMITER $$


CREATE PROCEDURE `COBRANZAAUTREFEPRO`(
	-- SP QUE REALIZA LA COBRANZA AUTOMATICA DE LOS CREDITOS POR PAGO POR REFERENCIA
	Par_Fecha				DATE,			-- Fecha de Aplicacion
	Par_Salida				CHAR(1),		-- Par_Salida
	INOUT	Par_NumErr		INT(11),		-- Numero de Error
	INOUT	Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	-- Parametros de Auditoria
	Aud_EmpresaID       INT(11),
	Aud_Usuario         INT(11),
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
)

TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_AmortizacionID	INT(11);
	DECLARE Var_Contador		INT(11);
	DECLARE Var_CreditoID		BIGINT(12);
	DECLARE Var_CreditoStr		VARCHAR(30);	-- Numero de Credito
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_DiasAtraso		INT(11);
	DECLARE Var_MonedaID		INT(11);
	DECLARE Var_MontoPago		DECIMAL(12,2);
	DECLARE Var_NumRegistros	INT(11);
	DECLARE Var_PagoAplica      DECIMAL(14,2);
	DECLARE Var_Poliza 			BIGINT(20);		-- Numero de Poliza
	DECLARE Var_ProcedePago		CHAR(1);
	DECLARE Var_Consecutivo		VARCHAR(50);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_PagoXReferencia	VARCHAR(1);
	DECLARE Var_Exitosos		INT(11);
	DECLARE Var_Error			INT(11);
	DECLARE Var_MontoBloq		DECIMAL(18,2);
	DECLARE Var_RemitenteID		INT(11);		-- Identificador del Remitente
	DECLARE Var_Destinatario	VARCHAR(200);	-- Correo a Enviar el Mensaje
	DECLARE	Con_Asunto			VARCHAR(150);	-- Descripcion del Asunto
	DECLARE	Con_MensajeEnviar	TEXT;			-- Descripcion del Mensaje a Enviar en el Correo
	DECLARE	Var_NumErr			INT(11);		-- Numero de Error
	DECLARE	Var_ErrMen			VARCHAR(400);	-- Mensaje de Error

	-- DECLARACION DE CONSTANTES
	DECLARE AltaPoliza_NO		CHAR(1);
	DECLARE AltaPoliza_SI		CHAR(1);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE CargoCuenta			CHAR(1);
	DECLARE Con_Origen			CHAR(1);
	DECLARE Con_PagoCred    	INT(11);
	DECLARE Cons_NO				CHAR(1);
	DECLARE Cons_SI    			CHAR(1);
	DECLARE Decimal_Cero   		DECIMAL(12,2);
	DECLARE Des_ErrorCallSP		VARCHAR(100);
	DECLARE Des_ErrorGral		VARCHAR(100);
	DECLARE Des_ErrorLlavDup	VARCHAR(100);
	DECLARE Des_ErrorValNulos	VARCHAR(100);
	DECLARE Desc_PagoCred		VARCHAR(50);
	DECLARE Entero_Cero    	 	INT(11);
	DECLARE Error_Key			INT(11);		-- Numero de Error
	DECLARE EstPagado			CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Finiquito_NO		CHAR(1);
	DECLARE ForCobroProg		CHAR(1);
	DECLARE Par_Consecutivo	 	BIGINT(20);
	DECLARE PrePago_NO          CHAR(1);
	DECLARE Pro_CobCreAut		INT(11);
	DECLARE SalidaSi			CHAR(1);
	DECLARE SalidaNO			CHAR(1);
	DECLARE TipoCancela			CHAR(1);
	DECLARE TipoPoliza			CHAR(1);
	DECLARE Origen_Aut			CHAR(1);
	DECLARE RespaldaCredSI		CHAR(1);
	DECLARE OrigenPago			CHAR(1);
	DECLARE	RemitentePagoCre	VARCHAR(50);
	DECLARE CorreoPagoCre		VARCHAR(50);

	-- ASIGNACION DE CONSTANTES
	SET AltaPoliza_NO		:= 'N';					-- Alta del Encabezado de la Poliza: NO
	SET AltaPoliza_SI		:= 'S';					-- Alta del Encabezado de la Poliza: SI
	SET Cadena_Vacia    	:= '';        			-- Constante Cadena Vacia
	SET CargoCuenta			:= 'C';					-- Cargo a Cuenta
	SET Con_Origen			:= 'S';					-- Constante Origen donde se llama el SP (S= safy, W=WS)
	SET Con_PagoCred		:= 54;					-- Concepto Pago de Credito
	SET Cons_NO	        	:= 'N'; 				-- Constante No
	SET Cons_SI    			:= 'S';    				-- Constante SI
	SET Decimal_Cero      	:= 0.00;				-- Constante Decimal Cero
	SET Des_ErrorCallSP		:= 'ERROR AL LLAMAR A STORE PROCEDURE';
	SET Des_ErrorGral		:= 'ERROR DE SQL GENERAL';
	SET Des_ErrorLlavDup	:= 'ERROR EN ALTA, LLAVE DUPLICADA';
	SET Des_ErrorValNulos	:= 'ERROR VALORES NULOS';
	SET Desc_PagoCred    	:= 'PAGO DE CREDITO';	-- Descripcion del Concepto, Pago de Credito
	SET Entero_Cero     	:= 0;               	-- Constante Entero Cero
	SET EstPagado			:= 'P';					-- Estatus Pagado
	SET Fecha_Vacia     	:= '1900-01-01';		-- Constante Fecha Vacia
	SET Finiquito_NO		:= 'N';					-- Indica si es finiquito
	SET ForCobroProg		:= 'P'; 				-- Forma de Cobro de la comision P:Programado
	SET PrePago_NO         	:= 'N';            		-- El Tipo de Pago No es PrePago
	SET Pro_CobCreAut		:= 210;					-- Proceso Batch para realizar el pago a programaciones automaticas de credito
	SET SalidaSi			:= 'S';
	SET SalidaNO			:= 'N';					-- Constante SALIDA:NO
	SET TipoCancela        	:= 'C'; 				-- Tipo de Pase al Histórico por Cancelación Incumplimiento
	SET TipoPoliza			:= 'A';					-- Poliza Automatica
	SET Origen_Aut			:= 'A';					-- Cobranza automatica
	SET RespaldaCredSI		:= 'S';
	SET OrigenPago			:= 'B';					-- Origen del Pago
	SET RemitentePagoCre	:= 'RemitentePagoCredito';
	SET CorreoPagoCre		:= 'CorreoPagoCredito';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-COBRANZAAUTREFEPRO');
		END;

		SET Var_RemitenteID 	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = RemitentePagoCre);
		SET Var_RemitenteID		:= IFNULL(Var_RemitenteID, Entero_Cero);
		SET Var_Destinatario	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = CorreoPagoCre);
		SET Var_Destinatario	:= IFNULL(Var_Destinatario, Cadena_Vacia);

		SET Var_PagoXReferencia := (SELECT ValorParametro
										FROM PARAMGENERALES WHERE LlaveParametro = 'PagosXReferencia');
		SET Var_PagoXReferencia := IFNULL(Var_PagoXReferencia, Cadena_Vacia);

		IF(Var_PagoXReferencia = 'S') THEN

			-- INSERTAMOS TODOS LOS REGISTROS DE LOS CRÉDITOS CON SALDO BLOQUEADO A PAGAR POR PAGO POR REFERENCIA
			TRUNCATE TMPPAGOXREFERENCIA;
			INSERT INTO TMPPAGOXREFERENCIA(
				NReg,					CreditoID,			CuentaID,				MontoExigible,						MontoBloq,
                MonedaID,
				EmpresaID,				Usuario,			FechaActual,			DireccionIP,						ProgramaID,
                Sucursal,				NumTransaccion)
			SELECT 	Entero_Cero,		CRED.CreditoID,		CRED.CuentaID, 			FUNCIONEXIGIBLE(CRED.CreditoID),	SUM(BLOQ.MontoBloq),
                    CRED.MonedaID,
					Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,					Aud_ProgramaID,
					Aud_Sucursal,		Aud_NumTransaccion
			FROM BLOQUEOS AS BLOQ
				INNER JOIN CREDITOS AS CRED
					ON BLOQ.Referencia = CRED.CreditoID
			WHERE BLOQ.NatMovimiento = 'B'
				AND BLOQ.TiposBloqID = 18
				AND CRED.Estatus IN('V','B')
				AND BLOQ.FolioBloq = 0
			GROUP BY BLOQ.Referencia;

            DELETE FROM TMPPAGOXREFERENCIA
            WHERE MontoExigible <= Entero_Cero;

			SET @Contador := 0;
			UPDATE TMPPAGOXREFERENCIA SET
				NReg = (@Contador:= @Contador+1);

			SET Var_Contador 	:= 1;
			SET Var_Exitosos	:= 0;
			SET Var_Error		:= 0;
			-- CICLO PARA RECORRER LA TABLA Y REALIZAR EL PAGO DE LOS CREDITOS
			SET Var_NumRegistros := (SELECT MAX(NReg) FROM TMPPAGOXREFERENCIA);

			WHILE(Var_Contador <= Var_NumRegistros) DO
				CALL TRANSACCIONESPRO(Aud_NumTransaccion);
	 			START TRANSACTION;
					TransaccionN: BEGIN
						DECLARE EXIT HANDLER FOR SQLEXCEPTION SET Error_Key := 1;
						DECLARE EXIT HANDLER FOR SQLSTATE '23000' SET Error_Key := 2;
						DECLARE EXIT HANDLER FOR SQLSTATE '42000' SET Error_Key := 3;
						DECLARE EXIT HANDLER FOR SQLSTATE '22004' SET Error_Key := 4;
						SET Error_Key		:= Entero_Cero;
						SET Var_PagoAplica  := IFNULL(Var_PagoAplica, Decimal_Cero);
						SET Var_CreditoID 	:= IFNULL(Var_CreditoID, Entero_Cero);
						SET Var_CuentaAhoID	:= IFNULL(Var_CuentaAhoID, Entero_Cero);
						SET Var_MontoPago	:= IFNULL(Var_MontoPago, Decimal_Cero);
						SET Var_MontoBloq	:= IFNULL(Var_MontoBloq, Entero_Cero);
						SET Var_MonedaID	:= IFNULL(Var_MonedaID, Entero_Cero);
						SET Var_Poliza		:= -1;
						ProcesoPago:BEGIN
							DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
								SET Error_Key := 999;
								SET Var_Contador := Var_Contador + 1;
							END;

							SELECT
								CRED.CreditoID,		CRED.CuentaID,		FUNCIONEXIGIBLE(CRED.CreditoID),
								CRED.MonedaID
								INTO
								Var_CreditoID,		Var_CuentaAhoID,	Var_MontoPago,
								Var_MonedaID
								FROM TMPPAGOXREFERENCIA AS TMP
								INNER JOIN CREDITOS AS CRED ON TMP.CreditoID = CRED.CreditoID
								WHERE TMP.NReg = Var_Contador;
							SET Var_MontoBloq := (SELECT SUM(BLOQ.MontoBloq)
													FROM BLOQUEOS AS BLOQ
														WHERE  NatMovimiento = 'B'
															AND TiposBloqID = 18
															AND Referencia = Var_CreditoID
															AND FolioBloq = 0);
							SET Var_MontoBloq := IFNULL(Var_MontoBloq,Entero_Cero);
							IF(Var_MontoBloq<Var_MontoPago) THEN
								SET Var_MontoPago := Var_MontoBloq;
							END IF;
							-- Se realiza el proceso del pago del crédito
							IF(Var_MontoPago>Entero_Cero) THEN
								CALL PAGOCREDITOPRO(
									Var_CreditoID,		Var_CuentaAhoID,	Var_MontoPago,		Var_MonedaID,		PrePago_NO,
									Finiquito_NO,		Aud_EmpresaID,		Cons_NO,			AltaPoliza_SI,		Var_PagoAplica,
									Var_Poliza,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	CargoCuenta,
									Origen_Aut,			RespaldaCredSI,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
									Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

								IF(Par_NumErr != Entero_Cero)THEN
									SET Error_Key := 99;
									LEAVE ProcesoPago;
								ELSE
									SET Var_Exitosos := Var_Exitosos + 1;
								END IF;
							 ELSE
							 	SET Par_ErrMen := CONCAT('El Crédito No Tiene Exigible.');
							 	SET Par_NumErr := 0;
							END IF;
						END ProcesoPago;

						SET Var_Contador := Var_Contador + 1; -- Incrementa el contador
						-- Finaliza el proceso del pago de crédito
						IF(Error_Key = 0) THEN
							INSERT IGNORE INTO BITACORACOBRANZAXREFE
							VALUES(
								Aud_NumTransaccion,	Par_Fecha, NOW(), Var_CreditoID, Par_NumErr, Par_ErrMen,
								Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion
							);
							COMMIT;
						  ELSE
							ROLLBACK ;
							SET Var_Error 	:= Var_Error + 1;
							INSERT IGNORE INTO BITACORACOBRANZAXREFE
							VALUES(
								Aud_NumTransaccion,	Par_Fecha, 			NOW(), 					Var_CreditoID, 		Par_NumErr, 	Par_ErrMen,
								Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,
								Aud_NumTransaccion
							);

							SET Var_NumErr 	:= Par_NumErr;
							SET Var_ErrMen	:= (SUBSTRING(Par_ErrMen,1,400));
							SET Con_Asunto 			:= CONCAT('ERROR AL REALIZAR EL PAGO DEL CR&Eacute;DITO: ', Var_CreditoID);
							SET Con_MensajeEnviar	:= CONCAT('Ha ocurrido un error al realizar el Pago del Cr&eacute;dito: ',Var_CreditoID, ' - ',Var_ErrMen);

							CALL MAESTROPOLIZABAJ(
								Var_Poliza,				Aud_NumTransaccion,		1,				Par_NumErr,			Par_ErrMen,
								'COBRANZAAUTREFEPRO',	SalidaNO,				Par_NumErr,		Par_ErrMen,			Aud_Usuario,
								Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
							);

							-- SE REGISTRA EN LA BITACORA EN CASO DE HABER UN ERROR
							CALL BITAERRORPAGOCREDITOALT(
		                        'COBRANZAAUTREFEPRO',       Var_NumErr,             Var_ErrMen,				Var_CreditoID,          Var_MontoPago,
		                        SalidaNO,                  	Par_NumErr,             Par_ErrMen,             Aud_EmpresaID,          Aud_Usuario,
		                        Aud_FechaActual,            Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

							IF(Var_RemitenteID > Entero_Cero) THEN
								-- SE ENVIA CORREO EN CASO DE HABER UN ERROR
								CALL TARENVIOCORREOALT(
									Var_RemitenteID,	Var_Destinatario,		Con_Asunto, 			Con_MensajeEnviar,			Entero_Cero,
									Par_Fecha,			Fecha_Vacia,			'COBRANZAAUTREFEPRO',	Cadena_Vacia, 				SalidaNO,
									Par_NumErr,			Par_ErrMen,				Aud_EmpresaID,			Aud_Usuario ,				Aud_FechaActual,
									Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal, 			Aud_NumTransaccion);
							END IF;

							COMMIT;
						END IF;
				END;-- Fin de START TRANSACTION
			END WHILE;-- Fin de WHILE
		END IF;-- Fin de Pagos x Referencia
		TRUNCATE TMPPAGOXREFERENCIA;

		SET	Par_NumErr := Entero_Cero;
		IF(Var_NumRegistros!=0) THEN
			SET	Par_ErrMen := CONCAT('Proceso Realizado Exitosamente.Creditos por Procesar: ',Var_NumRegistros,'<br> Total Aplicados:',Var_Exitosos,'<br>Total Fallidos:',Var_Error);
		  ELSE
			SET Par_ErrMen := 'No Existen Creditos para Procesar.';
		END IF;

	END ManejoErrores;

	IF(Par_Salida=SalidaSi)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Consecutivo AS Consecutivo,
				Var_Control AS Control;
	END IF;
END TerminaStore$$