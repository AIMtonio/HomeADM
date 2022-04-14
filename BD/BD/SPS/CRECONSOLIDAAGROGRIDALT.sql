-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECONSOLIDAAGROGRIDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECONSOLIDAAGROGRIDALT`;

DELIMITER $$
CREATE PROCEDURE `CRECONSOLIDAAGROGRIDALT`(
	-- =======================================================================================
	-- ----------SP PARA DAR DE ALTA EL DETALLE GRID DE LOS CREDITOS CONSOLIDADOS -----------
	-- --------------- PROCESO ESPEJO PARA LA FUNCIONALIDAD DEL GRID ------------------------
	-- =======================================================================================
	Par_FolioConsolida          BIGINT(12),         -- ID o Referencia de Consolidacion
	Par_CreditoID 				BIGINT(12),         -- Credito ID a Consiliar
	Par_SolicitudCreditoID      BIGINT(20),         -- ID de la Solicitud
	Par_Transaccion				BIGINT(20),     	-- Numero de Transaccion de la tabla en sesion
	Par_FechaProyeccion			DATE,				-- Fecha de Proyeccion

	Par_Salida					CHAR(1),			-- Indica si se muestra mensaje de exito o no
	INOUT Par_NumErr			INT(11),			-- Numero de error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de error

	Par_EmpresaID				INT(11),			-- Parametro de auditoria
	Aud_Usuario					INT(11),			-- Parametro de auditoria
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal				INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaSistema		DATE;				-- Variable Fecha del Sistema
	DECLARE Var_DetConsolidaID		INT(11);			-- Nuevo ID del Detalle de Consolida
	DECLARE Var_SucursalOrigen		INT(11);			-- Sucursal del cliente
	DECLARE Var_CobraIVAInteres		CHAR(1);			-- Iva de Interes Ordinario
	DECLARE Var_CliPagIVA			CHAR(1);			-- Si el cliente Paga IVA

	DECLARE Var_EstSolicitud		CHAR(1);			-- Estatus de Solicitud de Credito
	DECLARE Var_Control				VARCHAR(100);		-- Control de Salida
	DECLARE Var_CreditoID 			BIGINT(12);			-- Variable Credito ID
	DECLARE Var_CredConsolidado		BIGINT(12);			-- Variable Credito ID Consolidado
	DECLARE Var_SolicitudCreditoID	BIGINT(20);			-- Variable Solicitud de Credito

	DECLARE Var_FolioCons			BIGINT(12);			-- Folio de Consolidacion
	DECLARE Var_IVASucursal			DECIMAL(8, 4);		-- IVA de sucursal
	DECLARE Var_IVAIntOrdinario		DECIMAL(12,2);		-- IVA Interes Ordinario
	DECLARE Var_MontoCred			DECIMAL(14,2);		-- Monto de Credito
	DECLARE Var_MontoProyeccion		DECIMAL(14,2);		-- Monto de Interes Proyectado

	-- Declaracion de constantes
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT(11);
	DECLARE Entero_Uno				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE SalidaSI				CHAR(1);

	DECLARE SalidaNO				CHAR(1);
	DECLARE Cons_SI					CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE Est_Pagado				CHAR(1);
	DECLARE Est_Inactiva			CHAR(1);

	DECLARE Decimal_Cero			DECIMAL(12,2);

	-- Asignacion de constantes
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Entero_Uno					:= 1;				-- Entero Uno
	SET Cadena_Vacia				:= '';				-- String Vacio
	SET SalidaSI					:= 'S';				-- Salida SI

	SET SalidaNO					:= 'N';				-- Salida NO
	SET Cons_SI						:= 'S';				-- Constante SI
	SET Cons_NO						:= 'N';				-- Constante NO
	SET Est_Pagado					:= 'P';				-- Estatus Pagado
	SET Est_Inactiva				:= 'I';				-- Estatus Inactiva

	SET Decimal_Cero				:= 0.0;				-- Decimal Cero

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							  'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECONSOLIDAAGROGRIDALT');
			SET Var_Control := 'sqlexception';
		END;

		SELECT CreditoID
		INTO Var_CreditoID
		FROM CREDITOS
		  WHERE CreditoID = Par_CreditoID;

		SET Var_CreditoID := IFNULL(Var_CreditoID, Entero_Cero);

		IF(Var_CreditoID = Entero_Cero)THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Credito No Existe.';
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FolioConsolida
		INTO Var_FolioCons
		FROM CRECONSOLIDAAGROENC
			  WHERE FolioConsolida = Par_FolioConsolida;

		SET Var_FolioCons := IFNULL(Var_FolioCons, Entero_Cero);

		IF(Var_FolioCons = Entero_Cero)THEN
			SET Par_NumErr  := 2;
			SET Par_ErrMen  := 'El Folio de Consolidacion No Existe.';
			SET Var_Control := 'folioConsolida';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoID
		INTO Var_CredConsolidado
		FROM CREDCONSOLIDAAGROGRID
			WHERE CreditoID = Par_CreditoID
			AND FolioConsolida = Par_FolioConsolida
			AND Transaccion = Par_Transaccion;
		SET Var_CredConsolidado := IFNULL(Var_CredConsolidado, Entero_Cero);

		IF(Var_CredConsolidado != Entero_Cero)THEN
			SET Par_NumErr  := 3;
			SET Par_ErrMen  := 'El Credito a Consolidar se encuentra Registrado.';
			SET Var_Control := 'folioConsolida';
			LEAVE ManejoErrores;
		END IF;

		/* Par_SolicitudCreditoID VALIDACION */
		IF(Par_SolicitudCreditoID != Entero_Cero)THEN

			SELECT SolicitudCreditoID,		Estatus
			INTO Var_SolicitudCreditoID,	Var_EstSolicitud
			FROM SOLICITUDCREDITO
			WHERE SolicitudCreditoID = Par_SolicitudCreditoID;

			IF(Var_EstSolicitud != Est_Inactiva)THEN
				SET Par_NumErr  := 4;
				SET Par_ErrMen  := 'La solicitud no se encuentra Inactiva.';
				SET Var_Control := 'solicitudCreditoID';
				LEAVE ManejoErrores;
			END IF;

		END IF;

		SET Par_FechaProyeccion := IFNULL(Par_FechaProyeccion, Fecha_Vacia) ;

		IF( Par_FechaProyeccion = Fecha_Vacia ) THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := 'La fecha de Proyeccion esta Vacia.';
			SET Var_Control := 'fechaDesembolso';
			LEAVE ManejoErrores;
		END IF;

		SELECT  Cli.PagaIVA,	Pro.CobraIVAInteres,	Cli.SucursalOrigen
		INTO	Var_CliPagIVA,	Var_CobraIVAInteres,	Var_SucursalOrigen
		FROM CREDITOS Cre
		INNER JOIN CLIENTES Cli	ON Cre.ClienteID = Cli.ClienteID
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		WHERE Cre.CreditoID = Par_CreditoID;

		SET Var_SucursalOrigen := IFNULL(Var_SucursalOrigen, Entero_Cero);

		SELECT IVA
		INTO Var_IVASucursal
		FROM SUCURSALES
		WHERE SucursalID = Var_SucursalOrigen;

		SET Var_IVASucursal		:= IFNULL(Var_IVASucursal, Decimal_Cero);
		SET Var_CliPagIVA 		:= IFNULL(Var_CliPagIVA, Cadena_Vacia);
		SET Var_CobraIVAInteres	:= IFNULL(Var_CobraIVAInteres, Cadena_Vacia);
		SET Var_IVAIntOrdinario := Entero_Cero;

		IF( Var_CliPagIVA = Cons_SI ) THEN
			IF (Var_CobraIVAInteres = Cons_SI) THEN
				SET Var_IVAIntOrdinario := Var_IVASucursal;
			END IF;
		END IF;

		SET Var_MontoCred := (
			SELECT ROUND(
						SUM(ROUND(IFNULL(Amo.SaldoCapVigente, Entero_Cero),2) + ROUND(IFNULL(Amo.SaldoCapAtrasa, Entero_Cero),2) +
							ROUND(IFNULL(Amo.SaldoCapVencido, Entero_Cero),2) + ROUND(IFNULL(Amo.SaldoCapVenNExi, Entero_Cero),2)) +-- Capital
						SUM(ROUND(IFNULL(Amo.SaldoInteresOrd, Entero_Cero) + IFNULL(Amo.SaldoInteresAtr, Entero_Cero) +
								  IFNULL(Amo.SaldoInteresVen, Entero_Cero) + IFNULL(Amo.SaldoInteresPro, Entero_Cero) +
								  IFNULL(Amo.SaldoIntNoConta, Entero_Cero),2) +
							ROUND(ROUND(IFNULL(Amo.SaldoInteresOrd, Entero_Cero) * Var_IVAIntOrdinario, 2) +
								  ROUND(IFNULL(Amo.SaldoInteresAtr, Entero_Cero) * Var_IVAIntOrdinario, 2) +
								  ROUND(IFNULL(Amo.SaldoInteresVen, Entero_Cero) * Var_IVAIntOrdinario, 2) +
								  ROUND(IFNULL(Amo.SaldoInteresPro, Entero_Cero) * Var_IVAIntOrdinario, 2) +
								  ROUND(IFNULL(Amo.SaldoIntNoConta, Entero_Cero) * Var_IVAIntOrdinario, 2), 2)),2) -- Interes
			FROM AMORTICREDITO Amo
			WHERE Amo.CreditoID = Par_CreditoID
			  AND Amo.Estatus <> Est_Pagado);

		SET Var_MontoCred := IFNULL(Var_MontoCred, Decimal_Cero);

		IF( Var_MontoCred = Decimal_Cero)THEN
			SET Par_NumErr  := 5;
			SET Par_ErrMen  := CONCAT('El Monto del Credito ',Par_CreditoID ,' a Consolidar es Cero.');
			SET Var_Control := 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT FechaSistema
		INTO Var_FechaSistema
		FROM PARAMETROSSIS
		LIMIT Entero_Uno;

		SET Var_MontoProyeccion := Entero_Cero;
		IF( Par_FechaProyeccion > Var_FechaSistema ) THEN

			-- Store Procedure de Proyeccion de Interes
			CALL PROYECCIONINTAGROCONSOLIDAPRO (
				Par_CreditoID,		Par_FechaProyeccion,	Var_MontoProyeccion,
				SalidaNO,			Par_NumErr,				Par_ErrMen,
				Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
			SET Var_MontoProyeccion := IFNULL(Var_MontoProyeccion, Decimal_Cero);
		END IF;

		SET Aud_FechaActual := NOW();

		SELECT IFNULL(MAX(DetGridID), Entero_Cero) + Entero_Uno
		INTO Var_DetConsolidaID
		FROM CREDCONSOLIDAAGROGRID
		WHERE FolioConsolida = Par_FolioConsolida
		  AND Transaccion = Par_Transaccion
		FOR UPDATE;

		INSERT INTO CREDCONSOLIDAAGROGRID(
			DetGridID,			FolioConsolida,			SolicitudCreditoID,			CreditoID,			Transaccion,
			MontoCredito,		MontoProyeccion,		EmpresaID,					Usuario,			FechaActual,
			DireccionIP,		ProgramaID,				Sucursal,					NumTransaccion)
		VALUES(
			Var_DetConsolidaID, Par_FolioConsolida, 	Par_SolicitudCreditoID,		Par_CreditoID,		Par_Transaccion,
			Var_MontoCred,		Var_MontoProyeccion,	Par_EmpresaID,				Aud_Usuario,		Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,			Aud_Sucursal,				Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Credito Consolidado Agregado Exitosamente';
		SET Var_Control	:= 'solicitudCreditoID';

	END ManejoErrores;

	IF (Par_Salida = SalidaSI ) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$