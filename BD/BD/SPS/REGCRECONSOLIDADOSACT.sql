-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REESTRUCCREDITOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGCRECONSOLIDADOSACT`;

DELIMITER $$
CREATE PROCEDURE `REGCRECONSOLIDADOSACT`(
	-- Store Procedure para la regularizacion de creditos consolidados
	-- Modulo Cartera Agro
	Par_CreditoID			BIGINT(12),		-- Credito ID
	Par_NumPagoSoste		INT(11),		-- Numero de Pago sostenidos

	Par_Poliza				BIGINT(20),		-- Poliza ID
	Par_ModoPago			CHAR(1),		-- Modo de Pago
	Par_TipoAct				INT(11),		-- Tipo de Actualizacion

	Par_Salida				CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaRegistro 	DATE;			-- Fecha de Sistema
	DECLARE Var_NumPagoSoste	INT(11);		-- Numero de Pagos Sostenidos
	DECLARE Var_NumPagoActual	INT(11);		-- Numero de Pagos Actuales
	DECLARE Var_MonedaID		INT(11);		-- Moneda ID
	DECLARE Var_ProdCreID		INT(11);		-- Producto de Credito

	DECLARE Var_SucCliente		INT(11);		-- Sucursal del Cliente
	DECLARE Var_NumAmoExi		INT(11);		-- Numero de Amortizaciones exigibles
	DECLARE Var_SubClasifID		INT(11);		-- Subclasificacion
	DECLARE Var_NumAmorti		INT(11);		-- Numero de Amortizaciones
	DECLARE Var_EstCreacion		CHAR(1);		-- Estatus de Creacion

	DECLARE Var_Regularizado	CHAR(1);		-- Es Regularizado
	DECLARE Var_ClasifCre		CHAR(1);		-- Clasificacion de Credito
	DECLARE Var_Control			VARCHAR(50);	-- Control de Retorno a Pantalla
	DECLARE Par_Consecutivo		BIGINT;			-- Consecutivo
	DECLARE Var_CreditoID		BIGINT(12);		-- ID De Credito Consolidado

	DECLARE Var_Reserva			DECIMAL(14,2);	-- Reserva expuesta

	-- Declaracion de Constantes
	DECLARE Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE Entero_Cero			INT(11);		-- Constante Entero Vacio
	DECLARE Con_EstBalance		INT(11);		-- Constante Balance General
	DECLARE Con_EstResultados	INT(11);		-- Constante Estatus Resultados
	DECLARE Cadena_Vacia		CHAR(1);		-- Constante Cadena Vacia

	DECLARE Con_SI				CHAR(1);		-- Constante SI
	DECLARE Con_NO				CHAR(1);		-- Constante NO
	DECLARE Salida_SI			CHAR(1);		-- Constante Salida SI
	DECLARE Salida_NO			CHAR(1);		-- Constante Salida NO
	DECLARE NO_Regulariza		CHAR(1);		-- Constante Regulariza NO

	DECLARE SI_Regulariza		CHAR(1);		-- Constante Regulariza SI
	DECLARE Esta_Vencido		CHAR(1);		-- Constante Estatus Vencido
	DECLARE AltaPoliza_NO		CHAR(1);		-- Constante Alta Poliza NO
	DECLARE Est_Desemb			CHAR(1);		-- Constante Estatus Desembolso
	DECLARE AltaPolCre_SI		CHAR(1);		-- Constante Alta Poliza Credito SI

	DECLARE AltaMovCre_NO		CHAR(1);		-- Constante Alta Movimiento Credito NO
	DECLARE AltaMovAho_NO		CHAR(1);		-- Constante Alta Movimiento Ahorro NO
	DECLARE Nat_Cargo			CHAR(1);		-- Constante Naturaleza Cargo
	DECLARE Nat_Abono			CHAR(1);		-- Constante Naturaleza Abono
	DECLARE Esta_Pagado			CHAR(1);		-- Constante Estatus Pagado

	DECLARE Des_Reserva			VARCHAR(100);	-- Constante Descripcion Reserva
	DECLARE Ref_Regula			VARCHAR(100);	-- Constante Referencia Regulacion

	-- Declaracion de Actualizacion
	DECLARE Act_PagoSostenido	INT(11);		-- Actualizacion de Pago Sostenido

	-- Asignacion de Constantes
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET Con_EstBalance		:= 17;
	SET Con_EstResultados	:= 18;
	SET Cadena_Vacia		:= '';

	SET Con_SI				:= 'S';
	SET Con_NO				:= 'N';
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET NO_Regulariza		:= 'N';

	SET SI_Regulariza		:= 'S';
	SET Esta_Vencido		:= 'B';
	SET AltaPoliza_NO		:= 'N';
	SET Est_Desemb			:= 'D';
	SET AltaPolCre_SI		:= 'S';

	SET AltaMovCre_NO		:= 'N';
	SET AltaMovAho_NO		:= 'N';
	SET Nat_Cargo			:= 'C';
	SET Nat_Abono			:= 'A';
	SET Esta_Pagado			:= 'P';

	SET Des_Reserva			:= 'CANC.ESTIM.CAPITALIZACION INTERES';
	SET Ref_Regula			:= 'REGULARIZACION PAGO SOSTENIDO';

	-- Asignacion de Constantes
	SET Act_PagoSostenido	:= 1;
	-- SET Act_ReiniciaPago := 2;
	-- SET Act_Desembolso  := 1;

	-- Inicio del Manejo de Errores
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-REGCRECONSOLIDADOSACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SELECT FechaSistema
		INTO Var_FechaRegistro
		FROM PARAMETROSSIS;

		IF( IFNULL(Par_CreditoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 1;
			SET Par_ErrMen	:= 'El Credito esta Vacio.' ;
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SELECT CreditoID
		INTO Var_CreditoID
		FROM CREDITOS
		WHERE CreditoID = Par_CreditoID;

		IF( IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 2;
			SET Par_ErrMen	:= 'El Credito no Existe.' ;
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		SET Var_CreditoID := Entero_Cero;

		SELECT CreditoID
		INTO Var_CreditoID
		FROM REGCRECONSOLIDADOS
		WHERE CreditoID = Par_CreditoID;

		IF( IFNULL(Var_CreditoID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 3;
			SET Par_ErrMen	:= 'El Credito no Existe.' ;
			SET Var_Control	:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_TipoAct = Act_PagoSostenido) THEN

			UPDATE REGCRECONSOLIDADOS SET

				NumPagoActual	= IFNULL(Par_NumPagoSoste, Entero_Cero),

				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE CreditoID = Par_CreditoID;


			SELECT	NumPagoSoste,		NumPagoActual,		EstatusCreacion,	Regularizado, 		ReservaInteres
			INTO	Var_NumPagoSoste,	Var_NumPagoActual,	Var_EstCreacion,	Var_Regularizado,	Var_Reserva
			FROM REGCRECONSOLIDADOS
			WHERE CreditoID = Par_CreditoID;

			SET Var_NumPagoSoste	:= IFNULL(Var_NumPagoSoste, Entero_Cero);
			SET Var_NumPagoActual	:= IFNULL(Var_NumPagoActual, Entero_Cero);
			SET Var_EstCreacion		:= IFNULL(Var_EstCreacion, Cadena_Vacia);
			SET Var_Regularizado	:= IFNULL(Var_Regularizado, Cadena_Vacia);
			SET Var_Reserva			:= IFNULL(Var_Reserva, Entero_Cero);

			SELECT  COUNT(AmortizacionID)
			INTO Var_NumAmoExi
			FROM AMORTICREDITO
			WHERE CreditoID = Par_CreditoID
			  AND Estatus = Esta_Pagado;

			SELECT  NumAmortizacion
			INTO  Var_NumAmorti
			FROM CREDITOS
			WHERE CreditoID = Par_CreditoID;

			SET Var_NumAmoExi := IFNULL(Var_NumAmoExi, Entero_Cero);

			IF( (Var_NumPagoActual >= Var_NumPagoSoste AND
				Var_EstCreacion = Esta_Vencido AND Var_Regularizado = NO_Regulariza) OR
				Var_NumAmoExi   = IFNULL(Var_NumAmorti, Entero_Cero) ) THEN

				CALL REGULARIZACREDPRO (
					Par_CreditoID,			Var_FechaRegistro,	AltaPoliza_NO,		Par_Poliza,		Aud_EmpresaID,
					Salida_NO,				Par_NumErr,			Par_ErrMen,			Par_ModoPago,	Aud_Usuario,
					Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

				IF( Par_NumErr <> Entero_Cero ) THEN
					LEAVE ManejoErrores;
				END IF;

				UPDATE REGCRECONSOLIDADOS SET
					Regularizado		= SI_Regulariza,
					FechaRegularizacion	= Var_FechaRegistro,

					EmpresaID			= Aud_EmpresaID,
					Usuario				= Aud_Usuario,
					FechaActual			= Aud_FechaActual,
					DireccionIP			= Aud_DireccionIP,
					ProgramaID			= Aud_ProgramaID,
					Sucursal			= Aud_Sucursal,
					NumTransaccion		= Aud_NumTransaccion
				WHERE CreditoID = Par_CreditoID;

				IF( Var_Reserva > Entero_Cero ) THEN

					SELECT	Cre.MonedaID,	Cre.ProductoCreditoID,	Des.Clasificacion,	Cli.SucursalOrigen,		Des.SubClasifID
					INTO	Var_MonedaID,	Var_ProdCreID,			Var_ClasifCre,		Var_SucCliente,			Var_SubClasifID
					FROM CREDITOS Cre
					INNER JOIN DESTINOSCREDITO Des ON Cre.DestinoCreID = Des.DestinoCreID
					INNER JOIN CLIENTES Cli ON Cre.ClienteID = Cli.ClienteID
					WHERE CreditoID = Par_CreditoID;

					SET Var_SubClasifID := IFNULL(Var_SubClasifID, Entero_Cero);

					CALL CONTACREDITOPRO (
						Par_CreditoID,			Entero_Cero,		Entero_Cero,		Entero_Cero,		Var_FechaRegistro,
						Var_FechaRegistro,		Var_Reserva,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,		Des_Reserva,		Ref_Regula,			AltaPoliza_NO,
						Entero_Cero,			Par_Poliza,			AltaPolCre_SI,		AltaMovCre_NO,		Con_EstBalance,
						Entero_Cero,			Nat_Cargo,			AltaMovAho_NO,		Cadena_Vacia,		Nat_Cargo,
						Cadena_Vacia,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Aud_EmpresaID,
						Par_ModoPago,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

					CALL CONTACREDITOPRO (
						Par_CreditoID,			Entero_Cero,		Entero_Cero,		Entero_Cero,		Var_FechaRegistro,
						Var_FechaRegistro,		Var_Reserva,		Var_MonedaID,		Var_ProdCreID,		Var_ClasifCre,
						Var_SubClasifID,		Var_SucCliente,		Des_Reserva,		Ref_Regula,			AltaPoliza_NO,
						Entero_Cero,			Par_Poliza,			AltaPolCre_SI,		AltaMovCre_NO,		Con_EstResultados,
						Entero_Cero,			Nat_Abono,			AltaMovAho_NO,		Cadena_Vacia,		Nat_Abono,
						Cadena_Vacia,			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Aud_EmpresaID,
						Par_ModoPago,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
						Aud_Sucursal,			Aud_NumTransaccion);

					IF( Par_NumErr <> Entero_Cero ) THEN
						LEAVE ManejoErrores;
					END IF;

				END IF;

			END IF;

			SET Par_NumErr := Entero_Cero;
			SET Par_ErrMen := CONCAT('Credito Consolidado Actualizado: ', CONVERT(Par_CreditoID, CHAR), '.');
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;
	-- Fin del Manejo de Errores

	IF (Par_Salida = Salida_SI ) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Entero_Cero AS control,
				Entero_Cero AS consecutivo;

	END IF;

END TerminaStore$$