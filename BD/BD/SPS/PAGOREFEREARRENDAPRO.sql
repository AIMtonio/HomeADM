-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOREFEREARRENDAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOREFEREARRENDAPRO`;DELIMITER $$

CREATE PROCEDURE `PAGOREFEREARRENDAPRO`(
	-- SP DE PROCESO PARA EL PAGO REFERENCIADO DE ARRENDAMIENTO
	Par_ArrendaID					BIGINT(12),			-- ID del arrendamiento
	Par_MontoPagar					DECIMAL(14,4),		-- Monto a pagar
	Par_MonedaID					INT(11),			-- Identificador de moneda
	Par_AltaEncPoliza				CHAR(1),			-- Alta de encabezado de poliza
	INOUT Var_MontoPago				DECIMAL(14,4), 		-- Monto del pago
	INOUT Var_Poliza				BIGINT,				-- Poliza
	INOUT Par_Consecutivo			BIGINT,				-- Consecutivo
	Par_ModoPago					CHAR(1),			-- Modo de pago Efectivo o Cuenta

	Par_Salida						CHAR(1),			-- Salida
	INOUT Par_NumErr				INT(11),			-- Numero de error
	INOUT Par_ErrMen				VARCHAR(400),		-- Mensaje de Error

	Par_EmpresaID					INT(11),			-- Numero de empresa
	Aud_Usuario						INT(11),			-- Numero de usuario
	Aud_FechaActual					DATETIME,			-- Fecha del sistema
	Aud_DireccionIP					VARCHAR(15),		-- Direccion IP
	Aud_ProgramaID					VARCHAR(50),		-- Numero de programa
	Aud_Sucursal					INT(11),			-- Numero de sucursal
	Aud_NumTransaccion				BIGINT(20)			-- Numero de transaccion
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(100);		-- Variable de control
	DECLARE Var_NumRecPago			INT(11);			-- Variable para evitar hacer un pago si no ha pasado el tiempo
	DECLARE Var_ArrendaID 			BIGINT(12);			-- Numero del arrendamiento
	DECLARE Var_ArrendaAmortiID		INT(4);				-- Numero de amortizacion
	DECLARE Var_EstatusArrenda		CHAR(1);			-- Estatus del arrendamiento
	DECLARE Var_FechaSis			DATE;				-- Fecha del sistema
	DECLARE Var_NumVencidos			INT(11);			-- Numero de arrendamientos vencidos
	DECLARE Var_NumAtrasados		INT(11);			-- Numero de arrendamientos atrasados
	DECLARE Var_TotalAmorti			INT(11);			-- Total de amortizaciones
	DECLARE Var_TotalPagados		INT(11);			-- Total pagados
	DECLARE	Var_MontoPago			DECIMAL(14,4); 		-- Monto pago
	DECLARE Mon_MinPago				DECIMAL(14,2);		-- Valor monto minimo


	-- Declaracion de constantes
	DECLARE	Par_SalidaSI			CHAR(1);			-- Salida SI
	DECLARE	Par_SalidaNO			CHAR(1);			-- Salida NO
	DECLARE AltaPoliza_NO			CHAR(1);			-- Alta poliza NO
	DECLARE AltaPolArrenda_SI		CHAR(1);			-- Alta poliza SI
	DECLARE AltaMovsArrenda_SI		CHAR(1);			-- Alta movimientos SI
	DECLARE AltaMovsArrenda_NO		CHAR(1);			-- Alta movimientos NO
	DECLARE Cadena_Vacia			CHAR(1);			-- Cadena vacia
	DECLARE Fecha_Vacia				DATE;				-- Fecha vacia
	DECLARE Entero_Cero				INT(11);			-- Entero cero
	DECLARE Decimal_Cero			DECIMAL(14,2);		-- Decimal cero

	DECLARE	Est_Cancelado			CHAR(1);			-- Estatus Cancelado
	DECLARE	Est_Inactivo			CHAR(1);			-- Estatus Inactivo
	DECLARE	Est_Vigente				CHAR(1);			-- Estatus Vigente
	DECLARE	Est_Vencido				CHAR(1);			-- Estatus Vencido
	DECLARE Est_Pagado				CHAR(1);			-- Estatus Pagado
	DECLARE Est_Autorizado			CHAR(1);			-- Estatus autorizado
	DECLARE	Est_Atrasado			CHAR(1);			-- Estatus Atrasado

	DECLARE Con_Minuto				TIME;				-- Constante un minuto
	DECLARE Con_MontoMin			CHAR(20);			-- Concepto del monto minimo

	-- DECLARACION DE CURSORES
	DECLARE CURSORAMORTI CURSOR FOR
		SELECT	Amo.ArrendaID,				Amo.ArrendaAmortiID
			FROM	ARRENDAMIENTOS	Arrenda,
					ARRENDAAMORTI	Amo
			WHERE	Arrenda.ArrendaID	= Par_ArrendaID
			  AND	Amo.ArrendaID 		= Arrenda.ArrendaID
			  AND	(Arrenda.Estatus	= Est_Vigente
			   OR		Arrenda.Estatus	= Est_Vencido)
			  AND	(Amo.Estatus	= Est_Vigente
			   OR		Amo.Estatus	= Est_Vencido
			   OR		Amo.Estatus	= Est_Atrasado)
			ORDER BY FechaExigible;

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';						-- String Vacio
	SET	Fecha_Vacia					:= '1900-01-01'; 			-- Fecha Vacia
	SET	Entero_Cero					:= 0;						-- Entero en Cero
	SET	Decimal_Cero				:= 0.00;					-- Decimal Cero
	SET	Con_Minuto					:= '00:01:00';				-- Valor de un minuto
	SET	Con_MontoMin				:= 'MontoMinPago';			-- Valor concepto monto minimo
	SET	Par_SalidaNO				:= 'N';						-- Ejecutar Store sin Regreso o Mensaje de Salida
	SET	Par_SalidaSI				:= 'S';						-- Ejecutar Store Con Regreso o Mensaje de Salida
	SET	AltaPoliza_NO				:= 'N';						-- Constante para poliza NO
	SET	AltaPolArrenda_SI			:= 'S';						-- Poliza SI
	SET	AltaMovsArrenda_SI			:= 'S';						-- Alta de movimientos SI
	SET	AltaMovsArrenda_NO			:= 'N';						-- Alta de movimientos NO

	SET	Est_Cancelado				:= 'C';						-- Estatus Cancelado
	SET	Est_Inactivo				:= 'I';						-- Estatus Inactivo
	SET	Est_Vencido					:= 'B';						-- Estatus Vencido
	SET	Est_Vigente					:= 'V';						-- Estatus Vigente
	SET	Est_Pagado					:= 'P';						-- Estatus Pagado
	SET	Est_Autorizado				:= 'A';						-- Estatus autorizado
	SET	Est_Atrasado				:= 'A';						-- Estatus Atrasado

	SET	Var_NumRecPago				:= 0;						-- Numero de arrendamientos

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET	Par_NumErr	:= 999;
				SET	Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										  'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOREFEREARRENDAPRO');
				SET Var_Control = 'sqlException' ;
		END;

		SET	Var_Control			:= Cadena_Vacia;
		SET Par_ArrendaID		:= IFNULL(Par_ArrendaID,Entero_Cero);
		SET Par_MonedaID		:= IFNULL(Par_MonedaID,Entero_Cero);
		SET Par_MontoPagar		:= IFNULL(Par_MontoPagar,Decimal_Cero);
		SET Par_ModoPago		:= IFNULL(Par_ModoPago,Cadena_Vacia);
		SET Par_AltaEncPoliza	:= IFNULL(Par_AltaEncPoliza,Entero_Cero);
		SET Par_Consecutivo		:= IFNULL(Par_Consecutivo,Entero_Cero);

		SELECT	FechaSistema
			INTO	Var_FechaSis
			FROM	PARAMETROSSIS;

		SELECT	ValorParametro
			INTO	Mon_MinPago
			FROM	PARAMGENERALES
			WHERE	LlaveParametro	= Con_MontoMin;

		SET	Aud_FechaActual		:= NOW();

		-- SE VALIDA QUE NO SE HAYA RECIBIDO UN PAGO DE ARRENDAMIENTO SI AUN NO PASA MAS DE UN MINUTO
		SET Var_NumRecPago	:= (SELECT	COUNT(ArrendaID)
									FROM DETALLEPAGARRENDA
									WHERE	ArrendaID = Par_ArrendaID
									  AND	TIMEDIFF(Aud_FechaActual,FechaActual) <= Con_Minuto
									  AND	FechaPago = Var_FechaSis);

		SET	Var_NumRecPago	:= IFNULL(Var_NumRecPago, Entero_Cero);

		IF(Var_NumRecPago > Entero_Cero) THEN
				SET Par_NumErr		:= '001';
				SET Par_ErrMen		:= 'Ya se realizo un pago de arrendamiento para el cliente indicado, favor de intentarlo nuevamente en un minuto.';
				SET Par_Consecutivo	:= 0;
				SET Var_Control		:= 'arrendamientoID';
			LEAVE ManejoErrores;
		END IF;


		SELECT		arrenda.Estatus
			INTO	Var_EstatusArrenda
			FROM	ARRENDAMIENTOS arrenda
			WHERE	arrenda.ArrendaID	= Par_ArrendaID;

		IF(IFNULL(Var_EstatusArrenda, Cadena_Vacia)) = Cadena_Vacia THEN
				SET	Par_NumErr		:= '002';
				SET	Par_ErrMen		:= 'El Arrendamiento No Existe.';
				SET	Par_Consecutivo	:= 0;
				SET	Var_Control		:= 'arrendamientoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Var_EstatusArrenda	!= Est_Vigente AND
			Var_EstatusArrenda	!= Est_Vencido AND
			Var_EstatusArrenda	!= Est_Autorizado) THEN
				SET	Par_NumErr		:= '003';
				SET	Par_ErrMen		:= 'Estatus del Arrendamiento Incorrecto.';
				SET	Par_Consecutivo	:= 0;
				SET	Var_Control		:= 'montoPagarArrendamiento';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EstatusArrenda	= Est_Autorizado) THEN
		-- ----------------------- PAGO INICIAL ------------------------------------------
			IF(Par_MontoPagar	>= Mon_MinPago) THEN
				-- llamado al sp: ARRPAGOINICIALPRO
				CALL ARRPAGOINICIALPRO (Par_ArrendaID,		Par_MontoPagar,		Par_ModoPago,		Var_Poliza,		 	Par_SalidaNO,
										Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Par_EmpresaID,		Aud_Usuario,
										Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
					-- si se produce un error en el sp
					IF(Par_NumErr <> Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;


			END IF;
		ELSE
			-- -----------------------------------------------  PAGO DE AMORTIZACIONES ---------------------------------------------
			OPEN CURSORAMORTI;
			BEGIN
				DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
				CICLO:LOOP

				FETCH CURSORAMORTI INTO
					Var_ArrendaID,			Var_ArrendaAmortiID;

					-- Inicializaciones
					SET Par_NumErr		:= Entero_Cero;
					SET Par_ErrMen		:= Cadena_Vacia;
					SET Var_MontoPago	:= Decimal_Cero;
					SET Par_Consecutivo	:= Entero_Cero;

					-- Se hace llamado al sp: PAGOAMORTIZACIONPRO
					CALL ARRPAGOAMORTIPRO (Var_ArrendaID,	Var_ArrendaAmortiID,	Par_MontoPagar,		Par_ModoPago,		Var_Poliza,
										   Par_SalidaNO,	Par_NumErr,				Par_ErrMen,			Var_MontoPago,		Par_Consecutivo,
										   Par_EmpresaID,	Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
										   Aud_Sucursal,	Aud_NumTransaccion);
					-- si se produce un error en el sp
					IF(Par_NumErr <> Entero_Cero) THEN
						LEAVE CICLO;
					END IF;

					SET Par_MontoPagar	:= Var_MontoPago;

				END LOOP CICLO;
			END;
			CLOSE CURSORAMORTI;

			-- Se actualiza el estatus del arrendamiento cuando han sido pagados
			IF((Var_EstatusArrenda	= Est_Vencido)|| (Var_EstatusArrenda	= Est_Vigente))THEN
				SELECT	COUNT(ArrendaAmortiID)
					INTO	Var_NumVencidos
					FROM	ARRENDAAMORTI
					WHERE	Estatus		= Est_Vencido
					AND		ArrendaID	= Par_ArrendaID;

				SELECT	COUNT(ArrendaAmortiID)
					INTO	Var_NumAtrasados
					FROM	ARRENDAAMORTI
					WHERE	Estatus		= Est_Atrasado
					AND		ArrendaID	= Par_ArrendaID;

				SELECT	COUNT(ArrendaID)
					INTO	Var_TotalAmorti
					FROM	ARRENDAAMORTI
					WHERE	ArrendaID	= Par_ArrendaID;

				SELECT	COUNT(Estatus)
					INTO	Var_TotalPagados
					FROM	ARRENDAAMORTI
					WHERE	ArrendaID	= Par_ArrendaID
					AND		Estatus		= Est_Pagado;

				-- Cuando ya no existan amortizaciones vencidas o atrasadas el estatus del arrendamiento pasa a Vigente
				IF((Var_NumVencidos	= Entero_Cero) && (Var_NumAtrasados	= Entero_Cero))THEN
					UPDATE ARRENDAMIENTOS
						SET	Estatus	= Est_Vigente
						WHERE	ArrendaID	= Par_ArrendaID;
				END IF;

				-- Cuando todas las amortizaciones han sido pagadas el arrendamiento pasa a estatus pagado
				IF(Var_TotalAmorti	= Var_TotalPagados)THEN
					UPDATE ARRENDAMIENTOS
						SET		Estatus		= Est_Pagado
						WHERE	ArrendaID	= Par_ArrendaID;
				END IF;
			END IF; -- fin de actualizacion de estatus del arrendamiento
		END IF; -- fin de pago

		SET Par_NumErr		:= '000';
		SET Par_ErrMen		:= 'Pago Aplicado Exitosamente';
		SET Var_Control		:= 'arrendamientoID';
	END ManejoErrores;

	IF (Par_Salida	= Par_SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$