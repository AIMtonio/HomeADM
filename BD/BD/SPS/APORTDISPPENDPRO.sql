

-- APORTDISPPENDPRO --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPPENDPRO`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTDISPPENDPRO`(
/* SP DE ALTA DE DISPERSIONES PARA APORTACIONES */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_Estatus					CHAR(1),		-- Estatus de la Aportación como resultado del pago.
	Par_Fecha					DATE,			-- Fecha de la operacion
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error

	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),

	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control			CHAR(15);
DECLARE Var_contador		INT(11);			--	Contador para el ciclo while.

DECLARE Var_AportID			INT(11);			-- ID de la aportacion.
DECLARE Var_AmortID			INT(11);			-- ID de la amortizacion.
DECLARE Var_ClienteID		INT(11);			-- ID del cliente.
DECLARE Var_CuentaAhoID		BIGINT(12);			-- ID de la cuenta.
DECLARE Var_Capital			DECIMAL(14,2);		-- Capital de la aportacion.
DECLARE Var_Interes			DECIMAL(14,2);		-- ID de la aportacion.
DECLARE Var_InteresRet		DECIMAL(14,2);		-- Interes a retener.
DECLARE Var_Total			DECIMAL(14,2);		-- Total de la aportacion Capital + Interes - ISR.
DECLARE Var_FechaVenc		DATE;				-- Fecha de vencimiento de la aportacion.
DECLARE Var_OpcionAport 	INT(11);			-- Opcion de la aportacion, referencia a la tabla APORTACIONOPCIONES
DECLARE Var_Reinversion		CHAR(1);			-- Tipo de reinversion, N: No reinvierte \n S:Reinversion automatica, F:Posterior
DECLARE Var_CapInt			CHAR(1);			-- Indica si capitaliza interes S:SI \nN:NO \nI:Indistinto
DECLARE Var_Reinvertir		CHAR(2);			-- Indica que reinvierte C:Capital\n CI:Capital mas intereses\n E:Especificacion Posterior
DECLARE	Var_CantReno 		DECIMAL(18,2);		-- Cantidad de renovacion cuando la paortacion renueva con mas o con menos
DECLARE Var_ReinverAut		CHAR(1);			-- Reinversión Automatica de condiciones
DECLARE Var_EstatusCond		CHAR(1);			-- Estatus de las condiciones
DECLARE Var_EstatusReno		CHAR(1);			-- Estatus de la renovación
DECLARE Var_Cantidad		DECIMAL(18,2);		-- Monto de renovacion para aportaciones con condiciones
DECLARE Var_TipReinvertir	CHAR(2);			-- reinvertir C: Capital, CI: Capital + intereses
DECLARE Var_MontoRenovacion	DECIMAL(18,2);		-- Monto de renovacion para aportaciones con condiciones
DECLARE Var_ConsolidarSaldos	CHAR(1);		-- Indica si en las condiciones de vencimiento se consolidaron saldos.


-- Declaracion de Constantes
DECLARE	Cadena_Vacia		VARCHAR(1);
DECLARE	Fecha_Vacia			DATE;
DECLARE	Entero_Cero			INT(11);
DECLARE	Cons_SI				CHAR(1);
DECLARE	Cons_NO				CHAR(1);
DECLARE	EstatusPagado		CHAR(1);
DECLARE Renovacion_ConMenos INT(11);
DECLARE Solo_Capital		CHAR(1);
DECLARE Capital_Interes		CHAR(2);
DECLARE Reinversion_Post	CHAR(1);
DECLARE Renovacion_ConMas	CHAR(1);
DECLARE Estatus_Aut			CHAR(1);
DECLARE Estatus_Reno		CHAR(1);
DECLARE Est_Vigente			CHAR(1);
DECLARE Est_Pagado			CHAR(1);
DECLARE Est_Cancelado		CHAR(1);
DECLARE Renovacion 			CHAR(1);
DECLARE Nueva 				CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET	EstatusPagado		:= 'P'; 			-- Estatus Pagado.
SET Aud_FechaActual 	:= NOW();
SET Renovacion_ConMenos := '3';				-- Opcion para Renovacion con Menos corresponde a ID de tabla APORTACIONOPCIONES
SET Renovacion_ConMas 	:= '2';				-- Renovacion con mas
SET Renovacion 		 	:= '4';				-- Renovacion
SET Nueva 				:= '1';				-- Nueva
SET Solo_Capital		:= 'C';				-- Reinvierte solo capital
SET Capital_Interes		:= 'CI';			-- Reinvertir capital mas interes
SET Reinversion_Post	:= 'F';				-- Reinversion posterior
SET Estatus_Aut			:= 'A';				-- Estatus de condiciones autorizadas
SET Estatus_Reno		:= 'R';				-- Estatus de la renovación "RENOVADA"
SET Est_Vigente			:= 'N';				-- Estatus Vigente de la aportación
SET Est_Pagado			:= 'P';				-- Estatus Pagado
SET Est_Cancelado		:= 'C';				-- Estatus cancelado


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTDISPPENDPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM TMPDISPENDAPORT WHERE NumTransaccion = Aud_NumTransaccion;

	# SI LA APORTACIÓN SE VENCIÓ ANTICIPADAMENTE, SE OBTIENE UNA DISPERSIÓN CON EL ACUMULADO DE TODAS LAS AMORT. CANCELADAS.
	IF(IFNULL(Par_Estatus, Cadena_Vacia)=Est_Cancelado)THEN
		INSERT INTO TMPDISPENDAPORT (
			AportacionID, 				AmortizacionID, 				ClienteID,	 			CuentaAhoID, 			Capital,
			Interes, 					IntRetener, 					Total,	 				FechaVencimiento, 		TipoPagoInt,
			PagoIntCapitaliza, 			OpcionAport,					Reinversion,			Reinvertir,				CantidadReno,
			EmpresaID,					UsuarioID,						FechaActual,			DireccionIP,			ProgramaID,
			Sucursal,					NumTransaccion)
		SELECT
			Ap.AportacionID,			MAX(amo.AmortizacionID),		MAX(Ap.ClienteID),		MAX(Ap.CuentaAhoID),	SUM(amo.Capital),
			SUM(amo.SaldoProvision),	SUM(amo.SaldoISR+amo.SaldoIsrAcum),SUM(amo.Total),		Par_Fecha,				MAX(Ap.TipoPagoInt),
			MAX(Ap.PagoIntCapitaliza),	MAX(Ap.OpcionAport),			MAX(Ap.Reinversion),	MAX(Ap.Reinvertir),		MAX(Ap.Monto),
			Par_EmpresaID,				Aud_Usuario,					Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,				Aud_NumTransaccion
		FROM APORTACIONES Ap
			INNER JOIN AMORTIZAAPORT amo
				ON Ap.AportacionID = amo.AportacionID
					AND amo.Estatus = Par_Estatus AND Ap.NumTransaccion = amo.NumTransaccion
		WHERE Ap.Estatus IN (Est_Vigente, Est_Pagado, Est_Cancelado)
			AND Ap.AportacionID = Par_AportacionID
			AND Ap.NumTransaccion = Aud_NumTransaccion
		GROUP BY Ap.AportacionID;
	ELSE
		INSERT INTO TMPDISPENDAPORT (
			AportacionID, 			AmortizacionID, 		ClienteID, 			CuentaAhoID, 			Capital,
			Interes, 				IntRetener, 			Total, 				FechaVencimiento, 		TipoPagoInt,
			PagoIntCapitaliza, 		OpcionAport,			Reinversion,		Reinvertir,				CantidadReno,
			EmpresaID,				UsuarioID,				FechaActual,		DireccionIP,			ProgramaID,
			Sucursal,				NumTransaccion)
		SELECT
			Ap.AportacionID,		amo.AmortizacionID,		Ap.ClienteID,		Ap.CuentaAhoID,			amo.Capital,
			amo.SaldoProvision,		(amo.SaldoISR+amo.SaldoIsrAcum), amo.Total,	amo.FechaVencimiento,	Ap.TipoPagoInt,
			Ap.PagoIntCapitaliza,	Ap.OpcionAport,			Ap.Reinversion,		Ap.Reinvertir,			Ap.Monto,
			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,
			Aud_Sucursal,			Aud_NumTransaccion
		FROM APORTACIONES Ap
			INNER JOIN AMORTIZAAPORT amo
				ON Ap.AportacionID = amo.AportacionID AND amo.FechaPago <= Par_Fecha
					AND amo.Estatus = Par_Estatus AND Ap.NumTransaccion = amo.NumTransaccion
		WHERE Ap.Estatus IN (Est_Vigente, Est_Pagado, Est_Cancelado)
			AND Ap.AportacionID = Par_AportacionID
			AND Ap.NumTransaccion = Aud_NumTransaccion;
	END IF;

	SET Var_contador := (SELECT COUNT(*) FROM TMPDISPENDAPORT WHERE NumTransaccion = Aud_NumTransaccion);

	-- CICLO QUE RECORRE LAS CUOTAS
	WHILE Var_contador > 0 DO
		SET @idAmort := (SELECT ConsecutivoID FROM TMPDISPENDAPORT WHERE NumTransaccion = Aud_NumTransaccion ORDER BY ConsecutivoID
						ASC LIMIT 1);

		SELECT 		AportacionID, 		AmortizacionID, 		ClienteID, 		CuentaAhoID, 		Capital,
					Interes, 			IntRetener, 			Total, 			FechaVencimiento,	OpcionAport,
					Reinversion,		PagoIntCapitaliza,		Reinvertir,		CantidadReno
			INTO 	Var_AportID, 		Var_AmortID, 			Var_ClienteID, 	Var_CuentaAhoID, 	Var_Capital,
					Var_Interes, 		Var_InteresRet, 		Var_Total, 		Var_FechaVenc,		Var_OpcionAport,
					Var_Reinversion,	Var_CapInt,				Var_Reinvertir,	Var_CantReno
		FROM TMPDISPENDAPORT
		WHERE ConsecutivoID=@idAmort
			AND NumTransaccion = Aud_NumTransaccion;

		SET @maxAmort := (SELECT MAX(AmortizacionID) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportID );

		-- VALIDACIONES PARA REINVERSION POSTERIOR
		IF(Var_Reinversion = Reinversion_Post)THEN
			IF EXISTS (SELECT * FROM CONDICIONESVENCIMAPORT WHERE AportacionID = Var_AportID)THEN

				SELECT
					ReinversionAutomatica,	Estatus,			EstatusRenovacion,	Cantidad,		TipoReinversion,
					OpcionAportID,			MontoRenovacion,	ConsolidarSaldos
				INTO
					Var_ReinverAut,			Var_EstatusCond,	Var_EstatusReno,	Var_Cantidad,	Var_TipReinvertir,
					Var_OpcionAport,		Var_MontoRenovacion,Var_ConsolidarSaldos
				FROM CONDICIONESVENCIMAPORT
				WHERE AportacionID = Var_AportID;

				# SE SETEA EL TIPO DE REINVERSION DE LAS CONDICIONES DE VENCIMIENTO.
				SET Var_Reinvertir			:= Var_TipReinvertir;
				SET Var_ConsolidarSaldos	:= IFNULL(Var_ConsolidarSaldos,Cons_NO);
				SET Var_Cantidad			:= IFNULL(Var_Cantidad,Entero_Cero);

				# SI LAS COND ESTAN AUTORIZADAS Y SI SÍ SE RENOVÓ.
				IF(Var_ReinverAut = Cons_SI AND Var_EstatusCond = Estatus_Aut AND Var_EstatusReno = Estatus_Reno)THEN
					# REINVERTIR SOLO CAP, ULTIMA AMORTIZACION Y FUE DE TIPO NUEVA Y RENOVACION NORMAL
					IF( Var_TipReinvertir = Solo_Capital AND Var_AmortID = @maxAmort AND Var_OpcionAport IN (Nueva,Renovacion))THEN
						CALL APORTDISPERSIONESALT(
							Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Entero_Cero,
							Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
							Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
							);
					END IF;

					# SI ES LA ÚLTIMA AMORT Y ES RENOVACION CON MENOS.
					IF(Var_AmortID = @maxAmort AND Var_OpcionAport = Renovacion_ConMenos)THEN
						/** SI CAPITALIZA INTERESES, SE TOMA EL TOTAL DE LA AMORTIZACIÓN PAGADA
						 ** QUE INCLUYE EL CAPITAL Y LOS INTERESES (INTERES GENERADO - INTERES A RETENER).*/
						IF(Var_CapInt = Cons_SI) THEN
							SET Var_CantReno   := ROUND((Var_Capital + Var_Total),2);
							SET Var_Interes    := Entero_Cero;
							SET Var_InteresRet := Entero_Cero;
						END IF;

						IF(Var_CantReno >= Var_MontoRenovacion ) THEN
							SET Var_MontoRenovacion := IFNULL(Var_CantReno, Entero_Cero) - IFNULL(Var_MontoRenovacion, Entero_Cero);
						ELSE
							SET Var_MontoRenovacion := IFNULL(Var_MontoRenovacion, Entero_Cero) - IFNULL(Var_CantReno, Entero_Cero);
						END IF;

						CALL APORTDISPERSIONESALT(
							Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Var_MontoRenovacion,
							Var_Interes, 		Var_InteresRet,	Var_Total, 			Var_FechaVenc,		Cons_NO,
							Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
							Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
							);
					END IF;

					# SI ES LA ÚLTIMA AMORT Y ES RENOVACIÓN CON MÁS Y NO REINVIERTE CAPITAL MAS INTERES.
					IF(Var_AmortID = @maxAmort AND Var_OpcionAport = Renovacion_ConMas AND Var_TipReinvertir != Capital_Interes)THEN
						-- Se setea si reinvierte automáticamente de las condiciones pactadas.
						SET Var_Reinversion := Var_ReinverAut;
					END IF;

					# SI ES LA ÚLTIMA AMORT Y REINVIERTE CAPITAL MAS INTERES.
					IF(Var_AmortID = @maxAmort AND Var_TipReinvertir = Capital_Interes AND Var_OpcionAport NOT IN (Renovacion_ConMenos,Renovacion_ConMas) )THEN
						-- Se setea si reinvierte automáticamente de las condiciones pactadas.
						SET Var_Reinversion := Var_ReinverAut;
					END IF;

				ELSE
					SET Var_Reinversion := Cons_NO;
				END IF;

			ELSE
			-- en caso de no existir condiciones de vencimiento se toma como no reinvierte.
				SET Var_Reinversion := Cons_NO;
			END IF;
		END IF;

		EnvioSPEI:BEGIN
		# SI REINVIERTEN CAPITAL E INTERESES, NO SE DISPERSA.
		IF(Var_Reinversion = Cons_SI AND Var_Reinvertir = Capital_Interes)THEN
			LEAVE EnvioSPEI;
		END IF;
		CASE
			WHEN(Var_AmortID = @maxAmort AND Var_Reinversion = Cons_NO)THEN
			-- Cuota de Vencimiento Final, Capital + Intereses de Aportaciones que NO TUVIERON Renovación
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Var_Capital,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);


			WHEN(Var_AmortID = @maxAmort AND Var_Reinversion = Cons_SI AND Var_OpcionAport = Renovacion_ConMenos)THEN
			-- Cuota de Vencimiento Final, Capital + Intereses de Aportaciones que Renovaron etiquetada como “Renovación con Menos”.
			SET Var_Capital := Var_CantReno;
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Var_Capital,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
			WHEN(Var_AmortID < @maxAmort AND Var_CapInt = Cons_NO)THEN
			-- Cuota de Pago de Intereses No Capitalizables.
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Var_Capital,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
			WHEN(Var_AmortID = @maxAmort AND Var_Reinversion = Cons_SI AND Var_Reinvertir = Solo_Capital)THEN
			-- Cuota de Vencimiento Final, Capital + Intereses, con renovacion auto. solo de Capital
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Entero_Cero,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
			WHEN(Var_AmortID = @maxAmort AND Var_CapInt = Cons_SI AND Var_Reinversion = Cons_NO)THEN
			-- capitalizan interes, no reinvierten y es su ultima cuota
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Var_Capital,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
			ELSE
				LEAVE EnvioSPEI;
		END CASE;
		END EnvioSPEI;

		/** SI EN LAS CONDICIONES DE VENCIMIENTO SE PACTÓ CONSOLIDAR SALDOS, Y ES LA ÚLTIMA AMORTIZACIÓN,
		 ** SE HACE LA DISPERSIÓN DE LAS APORTACIONES QUE INTEGRAN EL GRUPO DE CONSOLIDACIÓN,
		 ** INDEPENDIENTEMENTE SI LAS CONDICIONES ESTAN AUTORIZADAS O SI RENOVÓ UNA NUEVA APORTACIÓN. */
		IF(IFNULL(Var_ConsolidarSaldos,Cons_NO) = Cons_SI AND Var_AmortID = @maxAmort)THEN
			CALL APORTDISPCONSPRO(
				Par_AportacionID,	Par_Estatus,	Par_Fecha,			Cons_NO,			Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		DELETE FROM TMPDISPENDAPORT WHERE ConsecutivoID=@idAmort AND NumTransaccion = Aud_NumTransaccion;

		SET Var_contador := (SELECT COUNT(*) FROM TMPDISPENDAPORT WHERE NumTransaccion = Aud_NumTransaccion);

	END WHILE;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Dispersiones Grabadas Exitosamente: ',Par_AportacionID,'.');
	SET Var_Control:= 'aportacionID' ;

END ManejoErrores;

IF (Par_Salida = Cons_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_AportacionID AS Consecutivo;
END IF;

END TerminaStore$$

