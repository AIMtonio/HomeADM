

-- APORTDISPCONSPRO --

DELIMITER ;
DROP PROCEDURE IF EXISTS `APORTDISPCONSPRO`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `APORTDISPCONSPRO`(
/* SP DE ALTA DE DISPERSIONES DE APORTACIONES CONSOLIDADAS. SOLO INTEGRANTES. */
	Par_AportacionID			INT(11),		-- ID de Aportación.
	Par_Estatus					CHAR(1),		-- Estatus de la Aportación como resultado del pago.
	Par_Fecha					DATE,			-- Fecha de cierre.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No.
	INOUT Par_NumErr			INT(11),		-- Numero de Error.

	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error.
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
DECLARE Var_ConsecutivoID	INT(11);			--	Consecutivo ID de tabla temporal.

DECLARE Var_AportID			INT(11);			-- ID de la aportacion.
DECLARE Var_AmortID			INT(11);			-- ID de la amortizacion.
DECLARE Var_AmortMaxID		INT(11);			-- ID de la última amortización.
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
DECLARE Var_ConsolidarSaldos	CHAR(1);		-- Indica si en las condiciones de vencimiento se consolidan saldos. S/N.
DECLARE Var_TipoConsolida	CHAR(1);			-- Tipo de Ingrante en un gpo de consolidación G: Grupo, I:Integrante.
DECLARE Var_AportCondID		INT(11);			-- ID de la aportacion "grupo" del grupo de consolidación.
DECLARE Var_TotalGpoCons	DECIMAL(14,2);		-- Total del grupo de consolidación (Interes - ISR).


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
DECLARE TipoCons_Grupo		CHAR(1);
DECLARE TipoCons_Integ		CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia.
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia.
SET Entero_Cero			:= 0;				-- Entero Cero.
SET	Cons_SI				:= 'S';				-- Constante Si.
SET	Cons_NO				:= 'N'; 			-- Constante No.
SET	EstatusPagado		:= 'P'; 			-- Estatus Pagado.
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
SET TipoCons_Grupo		:= 'G';				-- Tipo Consolidación: Grupo.
SET TipoCons_Integ		:= 'I';				-- Tipo Consolidación: Integrante.
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-APORTDISPCONSPRO');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM TMPDISPENDAPORTCONS WHERE NumTransaccion = Aud_NumTransaccion;

	# SE OBTIENEN LAS APORTACIONES DEL GRUPO DE CONSOLIDACIÓN, SOLO INTEGRANTES.
	INSERT INTO TMPDISPENDAPORTCONS (
		AportacionID, 			AmortizacionID, 		ClienteID, 			CuentaAhoID, 			Capital,
		Interes, 				IntRetener, 			Total, 				FechaVencimiento, 		TipoPagoInt,
		PagoIntCapitaliza, 		OpcionAport,			Reinversion,		Reinvertir,				CantidadReno,
		AportCondID,			EmpresaID,				UsuarioID,			FechaActual,			DireccionIP,
		ProgramaID,				Sucursal,				NumTransaccion)
	SELECT
		AP.AportacionID,		AM.AmortizacionID,		AP.ClienteID,		AP.CuentaAhoID,			AM.Capital,
		AM.SaldoProvision,		(AM.SaldoISR+AM.SaldoIsrAcum), AM.Total,	AM.FechaVencimiento,	AP.TipoPagoInt,
		AP.PagoIntCapitaliza,	AP.OpcionAport,			AP.Reinversion,		AC.Reinvertir,			AP.Monto,
		AC.AportacionID,		Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,		Aud_DireccionIP,
		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion
	FROM APORTACIONES AP
		INNER JOIN AMORTIZAAPORT AM
			ON AP.AportacionID = AM.AportacionID AND AM.FechaPago <= Par_Fecha
				AND AM.Estatus = Par_Estatus AND AP.NumTransaccion = AM.NumTransaccion
		INNER JOIN APORTCONSOLIDADAS AC ON AP.AportacionID = AC.AportConsID
	WHERE AP.Estatus IN (Est_Vigente, Est_Pagado, Est_Cancelado)
		AND AP.ConsolidarSaldos = 'I'
		AND AC.AportacionID = Par_AportacionID
		AND AP.NumTransaccion = Aud_NumTransaccion;

	SET Var_contador := (SELECT COUNT(*) FROM TMPDISPENDAPORTCONS WHERE NumTransaccion = Aud_NumTransaccion);

	-- CICLO QUE RECORRE LAS CUOTAS
	WHILE(Var_contador > 0)DO
		SET Var_ConsecutivoID := (SELECT ConsecutivoID FROM TMPDISPENDAPORTCONS WHERE NumTransaccion = Aud_NumTransaccion ORDER BY ConsecutivoID
						ASC LIMIT 1);

		SELECT
			AportacionID, 		AmortizacionID, 		ClienteID, 		CuentaAhoID, 		Capital,
			Interes, 			IntRetener, 			Total, 			FechaVencimiento,	OpcionAport,
			Reinversion,		PagoIntCapitaliza,		Reinvertir,		CantidadReno,		AportCondID
		INTO
			Var_AportID, 		Var_AmortID, 			Var_ClienteID, 	Var_CuentaAhoID, 	Var_Capital,
			Var_Interes, 		Var_InteresRet, 		Var_Total, 		Var_FechaVenc,		Var_OpcionAport,
			Var_Reinversion,	Var_CapInt,				Var_Reinvertir,	Var_CantReno,		Var_AportCondID
		FROM TMPDISPENDAPORTCONS
		WHERE ConsecutivoID = Var_ConsecutivoID
			AND NumTransaccion = Aud_NumTransaccion;

		SET Var_AmortMaxID := (SELECT MAX(AmortizacionID) FROM AMORTIZAAPORT WHERE AportacionID = Var_AportID );
		SET Var_AmortMaxID := IFNULL(Var_AmortMaxID,Entero_Cero);

		-- SE VALIDA SI TIENE CONDICIONES DE VENCIMIENTO.
		IF(EXISTS(SELECT * FROM CONDICIONESVENCIMAPORT WHERE AportacionID = Var_AportCondID))THEN
			SELECT
				ReinversionAutomatica,	Estatus,			EstatusRenovacion,	Cantidad,		OpcionAportID,
				MontoRenovacion,		ConsolidarSaldos
			INTO
				Var_ReinverAut,			Var_EstatusCond,	Var_EstatusReno,	Var_Cantidad,	Var_OpcionAport,
				Var_MontoRenovacion,	Var_ConsolidarSaldos
			FROM CONDICIONESVENCIMAPORT
			WHERE AportacionID = Var_AportCondID;

			# SE SETEA EL TIPO DE REINVERSION DE LAS CONDICIONES DE VENCIMIENTO.
			SET Var_TipReinvertir := Var_Reinvertir;
			SET Var_Cantidad := IFNULL(Var_Cantidad,Entero_Cero);
			SET Var_ConsolidarSaldos := IFNULL(Var_ConsolidarSaldos,Cons_NO);

			# SI LAS COND ESTAN AUTORIZADAS Y SI SÍ SE RENOVÓ.
			IF(Var_ReinverAut = Cons_SI AND Var_EstatusCond = Estatus_Aut AND Var_EstatusReno = Estatus_Reno)THEN
				# SE SETEA EL VALOR DE QUE LA APORTACIÓN SI REINVERTIÓ DE ACUERDO A LAS CONDICIONES DE LA APORT "PADRE".
				SET Var_Reinversion := Cons_SI;
				# SI REINVIERTE SOLO CAPITAL, ES LA ÚLTIMA AMORTIZACION Y CONSOLIDÓ SALDOS EN LAS COND. DE VENC.
				IF(Var_TipReinvertir = Solo_Capital AND Var_AmortID = Var_AmortMaxID AND Var_ConsolidarSaldos = Cons_SI)THEN # AND Var_OpcionAport IN (Nueva,Renovacion))THEN
					CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Entero_Cero,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
				END IF;
			ELSE
				SET Var_Reinversion := Cons_NO;
			END IF;
		ELSE
		-- en caso de no existir condiciones de vencimiento se toma como no reinvierte.
			SET Var_Reinversion := Cons_NO;
		END IF;

		EnvioSPEI:BEGIN
		# SI REINVIERTEN CAPITAL E INTERESES, NO SE DISPERSA.
		IF(Var_Reinversion = Cons_SI AND Var_Reinvertir = Capital_Interes)THEN
			LEAVE EnvioSPEI;
		END IF;
		CASE
			WHEN(Var_AmortID = Var_AmortMaxID AND Var_Reinversion = Cons_NO)THEN
			-- Cuota de Vencimiento Final, Capital + Intereses de Aportaciones que NO TUVIERON Renovación
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Var_Capital,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
			WHEN(Var_AmortID = Var_AmortMaxID AND Var_Reinversion = Cons_SI AND Var_OpcionAport = Renovacion_ConMenos)THEN
			-- Cuota de Vencimiento Final, Capital + Intereses de Aportaciones que Renovaron etiquetada como “Renovación con Menos”.
				SET Var_Capital := Var_CantReno;
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Var_Capital,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
			WHEN(Var_AmortID < Var_AmortMaxID AND Var_CapInt = Cons_NO)THEN
			-- Cuota de Pago de Intereses No Capitalizables.
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Var_Capital,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
			WHEN(Var_AmortID = Var_AmortMaxID AND Var_Reinversion = Cons_SI AND Var_Reinvertir = Solo_Capital AND Var_ConsolidarSaldos = Cons_NO)THEN
			-- Cuota de Vencimiento Final, Capital + Intereses, con renovacion auto. solo de Capital
				CALL APORTDISPERSIONESALT(
						Var_AportID, 		Var_AmortID, 	Var_ClienteID, 		Var_CuentaAhoID, 	Entero_Cero,
						Var_Interes, 		Var_InteresRet, Var_Total, 			Var_FechaVenc,		Cons_NO,
						Par_NumErr,			Par_ErrMen,		Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
						Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion
						);
			WHEN(Var_AmortID = Var_AmortMaxID AND Var_CapInt = Cons_SI AND Var_Reinversion = Cons_NO)THEN
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

		DELETE FROM TMPDISPENDAPORTCONS WHERE ConsecutivoID = Var_ConsecutivoID AND NumTransaccion = Aud_NumTransaccion;

		SET Var_contador := (SELECT COUNT(*) FROM TMPDISPENDAPORTCONS WHERE NumTransaccion = Aud_NumTransaccion);

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

