-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- APLICAPAGOINSTMASIVOPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `APLICAPAGOINSTMASIVOPRO`;
DELIMITER $$

CREATE PROCEDURE `APLICAPAGOINSTMASIVOPRO`(
	-- ========================================================================================================
	-- ----------------- SP PARA APLICACION DE PAGOS INSTITUCIONES MASIVO (NOMINA)-----------------------------
	-- ========================================================================================================
	Par_FolioCargaID		INT(11),			-- Folio de la aplicacion del pago
	Par_EmpresaNominaID		INT(11),			-- ID de la empresa de nomina
	Par_InstitucionID		INT(11),			-- ID de la institucion bancaria
	Par_FechaPagoDesc		DATE,				-- Fecha de aplicaion del pago de credito
	Par_NumCuenta			VARCHAR(30),		-- Numero de cuenta de la institucion bancaria
	Par_MovConciliado		BIGINT(20),			-- Movimiento conciliado

	Par_Salida				CHAR(1),			-- Indica si espera select de salida
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT,				-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT				-- Parametro de auditoria
	)
TerminaStore: BEGIN
    -- Declaracion de Variables
	DECLARE Var_Control         VARCHAR(100);		-- Variable de control
	DECLARE Var_NumRegistros	INT(11);			-- Contador de Registros
	DECLARE ContadorAux         INT(11);            -- Contador Aux
	DECLARE Var_Consecutivo		BIGINT;				-- Variable Consecutivo
	DECLARE Var_FolioNominaID	INT(11);			-- Variable Folio de Nomina
	DECLARE	Var_FolioCargaID	INT(11);			-- Variable Folio de Carga
	DECLARE	Var_CreditoID		BIGINT(12);			-- Variable Credito ID
	DECLARE Var_ClienteID		INT(11);			-- Variable Cliente ID
	DECLARE Var_MontoPago		DECIMAL(18,2);		-- Variable Monto de Pago
	DECLARE var_Frecuencia		CHAR(2);		-- Frecuancia del credito
	DECLARE Var_FechaExigible	DATE;			-- Fecha exigible de la cuota
	DECLARE Var_FechaSistema	DATE;			-- Fecha del sistema


    -- Declaracion de Constantes
   	DECLARE SalidaSI        	CHAR(1);			-- Constante salida SI
	DECLARE SalidaNO			CHAR(1);			-- Constante Salida NO
	DECLARE Entero_Cero         INT(11);            -- Constante entero cero
	DECLARE Estatus_Activo  	CHAR(1);			-- Constante estatus activo 'A'
	DECLARE Cadena_Vacia    	CHAR(1);			-- Constante cadena vacia
	DECLARE Decimal_Cero    	DECIMAL(12,2);		-- Constante Decimal Cero
	DECLARE Fecha_Vacia     	DATE;				-- Constante Fecha Vacia
	DECLARE Est_Pagado		CHAR(1);			-- Estatus pagado
	DECLARE Est_Procesado	CHAR(1);			-- Estatus procesado
	DECLARE Est_Aplicado	CHAR(1);			-- Estatus Aplicado
	DECLARE Cons_Mensual	CHAR(1);			-- Constante frecuencia mensual
	DECLARE Cons_Quincena	CHAR(1);			-- Constante frecuencia quincenal
	DECLARE Cons_Catorcena	CHAR(1);			-- Constante frecuencia catorcenal
	DECLARE Cons_Semanal	CHAR(1);			-- Constante frecuencia Semanal
	DECLARE Entero_Uno      INT(11);			-- Constante entero uno
	DECLARE Estatus_Vigente	CHAR(1);			-- Estatus vigente 'V'


	-- Seteo de Constantes
	SET SalidaSI 				:= 'S';
	SET SalidaNO				:= 'N';
	SET Entero_Cero             :=  0;
	SET Estatus_Activo			:= 'A';
	SET Cadena_Vacia			:= '';
	SET Decimal_Cero			:= 0.0;
	SET Fecha_Vacia     		:= '1900-01-01';    -- Fecha Vacia
	SET Est_Pagado				:= 'P';
	SET Est_Procesado			:= 'P';
	SET Est_Aplicado			:= 'A';
	SET Cons_Mensual		:= 'M';
	SET Cons_Quincena		:= 'Q';
	SET Cons_Catorcena		:= 'C';
	SET Cons_Semanal		:= 'S';
	SET Entero_Uno			:= 1;
	SET Estatus_Vigente		:= 'V';



	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr := 999;
					SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-APLICAPAGOINSTMASIVOPRO');
							SET Var_Control := 'SQLEXCEPTION' ;
				END;

		SET Var_Consecutivo := Entero_Cero;
		SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

		DELETE FROM CARGAPAGODESCNOMINAREAL WHERE NumTransaccion = Aud_NumTransaccion;

		SET @Contador := 0;

		-- Se realiza el Respaldo de las Tablas Reales
		CALL RESPAGOINSTPRO(
			Par_FolioCargaID,	Entero_Cero,		Entero_Cero, 			Entero_Cero,			Par_MovConciliado,
			SalidaNO, 			Par_NumErr,			Par_ErrMen,				Par_EmpresaID,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;


		INSERT INTO CARGAPAGODESCNOMINAREAL(
			CargaID,	FolioNominaID,		FolioCargaID,	CreditoID, DomiciliaPagos,
			TieneTabla,	FechaExigible,		Frecuencia,		AplicaTabla,NumTransaccion)
		SELECT
			(@Contador := @Contador + 1), 	Entero_Cero,		FolioCargaID,	CreditoID, 'N',
			'N',		Fecha_Vacia,		Cadena_Vacia,	'N', Aud_NumTransaccion
		FROM DESCNOMINAREAL
		WHERE FolioProcesoID = Par_FolioCargaID
			AND Estatus = Estatus_Activo
            GROUP BY FolioCargaID,CreditoID;


		UPDATE CARGAPAGODESCNOMINAREAL nom,CREDITOS cre, CONVENIOSNOMINA con
			SET nom.DomiciliaPagos = con.DomiciliacionPagos,
				nom.Frecuencia = cre.FrecuenciaCap
		WHERE nom.CreditoID = cre.CreditoID
		AND cre.ConvenioNominaID = con.ConvenioNominaID
		AND cre.InstitNominaID = con.InstitNominaID
		AND nom.NumTransaccion = Aud_NumTransaccion;

		UPDATE CARGAPAGODESCNOMINAREAL nom,CREDITOS cre, INSTITNOMINA con
			SET nom.AplicaTabla = con.AplicaTabla
		WHERE nom.CreditoID = cre.CreditoID
		AND cre.InstitNominaID = con.InstitNominaID
		AND nom.NumTransaccion = Aud_NumTransaccion;

		DELETE FROM CARGAPAGODESCNOMINAREAL
		WHERE DomiciliaPagos = 'S'
		AND NumTransaccion = Aud_NumTransaccion;

		DELETE FROM CARGAPAGODESCNOMINAREAL
		WHERE AplicaTabla = 'N'
		AND NumTransaccion = Aud_NumTransaccion;


		UPDATE CARGAPAGODESCNOMINAREAL nom
			INNER JOIN AMORTCRENOMINAREAL amo
			SET nom.TieneTabla = 'S'
		WHERE nom.CreditoID = amo.CreditoID
		AND nom.NumTransaccion = Aud_NumTransaccion;


		-- Actualizamos los que si tienen tabla real

		UPDATE AMORTCRENOMINAREAL REL
		INNER JOIN CARGAPAGODESCNOMINAREAL PAG ON REL.CreditoID = PAG.CreditoID
		INNER JOIN DESCNOMINAREAL DET ON  REL.CreditoID = DET.CreditoID  AND REL.AmortizacionID = DET.AmortizacionID
		INNER JOIN AMORTICREDITO AMO ON DET.CreditoID = AMO.CreditoID AND DET.AmortizacionID = AMO.AmortizacionID
										AND DET.NumTransaccion = AMO.NumTransaccion  AND AMO.Estatus = Est_Pagado
		SET
			REL.FechaPagoIns = Var_FechaSistema,
					REL.Estatus 	= Est_Pagado,
					REL.EstatusPagoBan 	= Est_Aplicado,
					REL.NumTransaccion	= DET.NumTransaccion
		WHERE DET.FolioProcesoID = Par_FolioCargaID
		AND PAG.TieneTabla = 'S'
		AND PAG.NumTransaccion = Aud_NumTransaccion;

		-- Actualizamos los que no tienen tabla real


		SET Var_NumRegistros := (SELECT MAX(CargaID) FROM CARGAPAGODESCNOMINAREAL
									WHERE TieneTabla = 'N' AND NumTransaccion = Aud_NumTransaccion);
		SET Var_NumRegistros := IFNULL(Var_NumRegistros,Entero_Cero);

		IF Var_NumRegistros > Entero_Cero THEN
			SET Var_Consecutivo := (SELECT MIN(CargaID) FROM CARGAPAGODESCNOMINAREAL
										WHERE TieneTabla = 'N' AND NumTransaccion = Aud_NumTransaccion);

			WHILE Var_Consecutivo <= Var_NumRegistros DO
				SEC_CREA_TABLAS:BEGIN

					SELECT CreditoID , Frecuencia
					 INTO  Var_CreditoID,var_Frecuencia
					FROM CARGAPAGODESCNOMINAREAL
					WHERE CargaID = Var_Consecutivo
					AND NumTransaccion = Aud_NumTransaccion;

					-- Frecuencia mensual
					IF (var_Frecuencia = Cons_Mensual)THEN
						SET Var_FechaExigible := (LAST_DAY(Var_FechaSistema));
					END IF;

					-- frecuencia quincenal
					IF (var_Frecuencia = Cons_Quincena)THEN
						IF(DAY( Var_FechaSistema ) <= 15 )THEN
							SET Var_FechaExigible := CAST(CONCAT( YEAR (Var_FechaSistema),'-',
																MONTH(Var_FechaSistema),'-',15) AS DATE);
						ELSE
							SET Var_FechaExigible := LAST_DAY(Var_FechaSistema);
						END IF;
					END IF;

					-- frecuencia catorcenal
					IF (var_Frecuencia = Cons_Catorcena)THEN
						IF(DAY( Var_FechaSistema ) <= 14 )THEN
							SET Var_FechaExigible := CAST(CONCAT( YEAR (Var_FechaSistema),'-',
																MONTH(Var_FechaSistema),'-',14) AS DATE);
						ELSE
							SET Var_FechaExigible := LAST_DAY(Var_FechaSistema);
						END IF;
					END IF;

					-- frecuencia semanal
					IF (var_Frecuencia = Cons_Semanal)THEN
						SET Var_FechaExigible := DATE_ADD(Var_FechaSistema, INTERVAL (4 - WEEKDAY(Var_FechaSistema) ) DAY);
					END IF;

					-- INICIO DEL CICLO PARA REGISTRAR EN LA TABLA REAL
					SET @Par_FolioNominaID	:= (SELECT IFNULL(MAX(FolioNominaID),Entero_Cero)  FROM AMORTCRENOMINAREAL);

					INSERT INTO AMORTCRENOMINAREAL (
						FolioNominaID,		CreditoID,		AmortizacionID,		FechaVencimiento,	FechaExigible,
						FechaPagoIns,		Estatus,		EstatusPagoBan,		EmpresaID,			Usuario,
						FechaActual,		DireccionIP,	ProgramaID,			Sucursal,			NumTransaccion)
					SELECT @Par_FolioNominaID := @Par_FolioNominaID + Entero_Uno,
												amo.CreditoID, 	amo.AmortizacionID,	Var_FechaExigible, 	IF(var_Frecuencia = Cons_Semanal,Var_FechaExigible,FUNCIONDIAHABIL(Var_FechaExigible,Entero_Uno,Entero_Uno)),
							Par_FechaPagoDesc, 	IF(amo.Estatus = Est_Pagado,Est_Pagado,Estatus_Activo),
												IF(amo.Estatus = Est_Pagado,Est_Aplicado,Estatus_Vigente),	Par_EmpresaID,		Aud_Usuario,
							Aud_FechaActual,	Aud_DireccionIP,Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion
							FROM AMORTICREDITO amo
							WHERE amo.CreditoID = Var_CreditoID;


					SET @fechaTemp = Var_FechaExigible;

					UPDATE AMORTCRENOMINAREAL
						SET FechaVencimiento = @fechaTemp:= FNSUMAFECHAXFRECUENCIA(@fechaTemp,var_Frecuencia),
							FechaExigible 	=	FUNCIONDIAHABIL(@fechaTemp,Entero_Uno,Entero_Uno),
							FechaPagoIns 	= Fecha_Vacia
					WHERE CreditoID = Var_CreditoID
					AND AmortizacionID > Entero_Uno;


				END SEC_CREA_TABLAS;


				SET Var_Consecutivo := (SELECT MIN(CargaID) FROM CARGAPAGODESCNOMINAREAL
											WHERE CargaID > Var_Consecutivo
											AND TieneTabla = 'N'
											AND NumTransaccion = Aud_NumTransaccion);

			END WHILE;

		END IF;

		-- FIN Actualizamos los que no tienen tabla real

		-- ACTUALIZA EL ESTATUS A PROCESADO DE LA TABLA DESCNOMINAREAL
		UPDATE DESCNOMINAREAL des,CARGAPAGODESCNOMINAREAL pag
		 SET des.EstatPagBanco  = Est_Aplicado,
		 	 des.Estatus 		= Est_Procesado
		WHERE des.FolioCargaID = pag.FolioCargaID
		AND des.FolioProcesoID = Par_FolioCargaID
		AND pag.NumTransaccion = Aud_NumTransaccion;


		-- Se actualiza el Movimienot de Conciliacion
		UPDATE TESOMOVSCONCILIA SET
			EstAplicaInst=Est_Aplicado
		WHERE InstitucionID = Par_InstitucionID
		AND NumCtaInstit = Par_NumCuenta
		AND NumeroMov = Par_MovConciliado;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := 'Pago(s) Aplicado(s) con Exito.';

		DELETE FROM CARGAPAGODESCNOMINAREAL WHERE NumTransaccion = Aud_NumTransaccion;


	END ManejoErrores; -- fin del manejador de errores


		IF (Par_Salida = SalidaSI) THEN
			SELECT Par_NumErr AS NumErr,
				   Par_ErrMen AS ErrMen,
				   'institNominaID' AS control,
				   Par_EmpresaNominaID AS consecutivo;
		END IF;

END TerminaStore$$