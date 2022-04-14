-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LINEASCREDITOAGROACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `LINEASCREDITOAGROACT`;

DELIMITER $$
CREATE PROCEDURE `LINEASCREDITOAGROACT`(
	-- Store Procedure para reactivar o actualizar las condiciones de Lineas de Credito Agro
	-- Modulo: Solicitud Credito Agro --> Registro --> Condiciones de Lineas Agro
	Par_LineaCreditoID			BIGINT(12),			-- Numero de Linea de Credito
	Par_ManejaComAdmon			CHAR(1),			-- Maneja comision
	Par_PorcentajeComAdmon		DECIMAL(6,2),		-- Porcentaje de comision por administracion
	Par_ForCobComAdmon			CHAR(1),			-- Forma de cobro por comision de administracion
	Par_ManejaComGarantia		CHAR(1),			-- Maneja comision por garantia

	Par_PorcentajeComGarantia	DECIMAL(6,2),		-- Porcentaje por comisiion de garantia
	Par_ForCobComGarantia		CHAR(1),			-- Forma de cobro por comision de garantia
	Par_FechaVencimiento		DATE,				-- Fecha de Vencimiento
	Par_IncrementoLinea			DECIMAL(12,2),		-- Monto Incrementado a la linea
	Par_NumAct					TINYINT UNSIGNED,	-- Numero de Actualizacion

	Par_Salida					CHAR(1),			-- Parametro de Salida
	INOUT Par_NumErr			INT(11),			-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),		-- Mensaje de Error

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_MontoMaxTipoLinea	DECIMAL(12,2);	-- Indica el monto maximo en base al tipo de linea
	DECLARE Var_FechaLimite			DATE;			-- Fecha Limite por Tipo de Linea
	DECLARE Var_MontoIncreTotal		DECIMAL(12,2);	-- Monto de Incremento Total
	DECLARE Var_Autorizado			DECIMAL(12,2);	-- Monto Autorizado de la Linea de Credito
	DECLARE Var_PlazoLimite			INT(11);		-- Plazo Limite de Linea

	DECLARE Var_Estatus				CHAR(1);		-- Estatus de Linea
	DECLARE Var_EstatusTipoLinAgro	CHAR(1);		-- Estatus del Tipo de Linea Agro
	DECLARE Var_FechaSistema		DATE;			-- Fecha Sistema
	DECLARE Var_Control				VARCHAR(50);	-- Control de Retorno en Pantalla
	DECLARE Var_MontoLinea			DECIMAL(12,2);	-- Monto de la Linea

	DECLARE Var_Descripcion			VARCHAR(100);	-- Descripcion
	DECLARE Var_MonedaID			INT(11);		-- Numero de Moneda
	DECLARE Var_SucursalID			INT(11);		-- Numero de Sucursal
	DECLARE Var_ProductoCreditoID	INT(11);		-- Numero de Producto de Crédito
	DECLARE Par_PolizaID			BIGINT(20);		-- Numero de Poliza

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;			-- Constante Fecha Vacia
	DECLARE	Entero_Cero				INT(11);		-- Constante Entero Vacio
	DECLARE	Decimal_Cero			DECIMAL(12,2);	-- Constante Decimal Vacio
	DECLARE Con_NO					CHAR(1);		-- Constante NO

	DECLARE Con_SI					CHAR(1);		-- Constante SI
	DECLARE	SalidaNO				CHAR(1);		-- Constante Salida NO
	DECLARE	SalidaSI				CHAR(1);		-- Constante Salida SI
	DECLARE Tip_Disposicion			CHAR(1);		-- Constante Tipo Dispocision
	DECLARE Tip_Total				CHAR(1);		-- Constante Total en primera Disposicion

	DECLARE Tip_Cuota				CHAR(1);		-- Constante Cada Cuota
	DECLARE Con_DecimalCien			DECIMAL(12,2);	-- Constante Decimal Cien
	DECLARE Est_Activa				CHAR(1);		-- Constante Estatus Activa
	DECLARE Est_TipLinInactiva		CHAR(1);		-- Constante Estatus Inactivo de Tipo de Linea
	DECLARE Est_TipLinActiva		CHAR(1);		-- Constante Estatus Activo de Tipo de Linea
	DECLARE Est_TipLinRechazada		CHAR(1);		-- Constante Estatus Rechazada de Tipo de Linea

	DECLARE AltaEncPolizaSI			CHAR(1);		-- Alta de Encabezado de Poliza SI
	DECLARE AltaEncPolizaNO			CHAR(1);		-- Alta de Encabezado de Poliza NO
	DECLARE ConcepCtaOrdenDeuAgro	INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
	DECLARE ConcepCtaOrdenCorAgro	INT(11);		-- Concepto Cuenta Ordenante Corte Agro
	DECLARE ConceptoContaLinea		INT(11);		-- Concepto Contable Linea de Credito tabla CONCEPTOSCONTA

	DECLARE AltaDetPolizaSI			CHAR(1);		-- Alte de Detalle Poliza SI
	DECLARE	Nat_Cargo				CHAR(1);		-- Naturaleza de Cargo
	DECLARE	Nat_Abono				CHAR(1);		-- Naturaleza de Abono

	-- Declaracion de Actualizaciones
	DECLARE	Act_Condiciones			TINYINT UNSIGNED;	-- Numero de Actualizacion por Autorizacion
	DECLARE	Act_Reactiva			TINYINT UNSIGNED;	-- Numero de Actualizacion por Autorizacion

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
	SET	Con_NO				:= 'N';

	SET	Con_SI				:= 'S';
	SET	SalidaSI			:= 'S';
	SET	SalidaNO			:= 'N';
	SET Tip_Disposicion		:= 'D';
	SET Tip_Total			:= 'T';

	SET Tip_Cuota			:= 'C';
	SET Con_DecimalCien		:= 100.00;
	SET Est_Activa			:= 'A';
	SET Est_TipLinInactiva	:= 'I';
	SET Est_TipLinActiva	:= 'A';
	SET Est_TipLinRechazada := 'R';

	SET	AltaEncPolizaSI		:= 'S';
	SET	AltaEncPolizaNO		:= 'N';
	SET ConcepCtaOrdenDeuAgro	:= 138;
	SET ConcepCtaOrdenCorAgro	:= 139;
	SET ConceptoContaLinea		:= 65;

	SET	AltaDetPolizaSI		:= 'S';
	SET	Nat_Cargo			:= 'C';
	SET	Nat_Abono			:= 'A';

	-- Asignacion de Constantes
	SET	Act_Condiciones		:= 8;
	SET Act_Reactiva		:= 9;

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-LINEASCREDITOAGROACT');
			SET Var_Control = 'SQLEXCEPTION';
		END;

		SET Var_FechaSistema			:= (SELECT FechaSistema FROM PARAMETROSSIS LIMIT 1);
		SET Par_LineaCreditoID			:= IFNULL(Par_LineaCreditoID,Entero_Cero);
		SET Par_ManejaComAdmon			:= IFNULL(Par_ManejaComAdmon,Cadena_Vacia);
		SET Par_PorcentajeComAdmon		:= IFNULL(Par_PorcentajeComAdmon,Decimal_Cero);
		SET Par_ForCobComAdmon			:= IFNULL(Par_ForCobComAdmon,Cadena_Vacia);
		SET Par_ManejaComGarantia		:= IFNULL(Par_ManejaComGarantia,Cadena_Vacia);
		SET Par_PorcentajeComGarantia	:= IFNULL(Par_PorcentajeComGarantia,Decimal_Cero);
		SET Par_ForCobComGarantia		:= IFNULL(Par_ForCobComGarantia,Cadena_Vacia);
		SET Par_FechaVencimiento		:= IFNULL(Par_FechaVencimiento,Fecha_Vacia);
		SET Par_IncrementoLinea			:= IFNULL(Par_IncrementoLinea,Decimal_Cero);

		IF(NOT EXISTS(SELECT LineaCreditoID
					FROM LINEASCREDITO
					WHERE LineaCreditoID = Par_LineaCreditoID)) THEN
			SET Par_NumErr  := 1;
			SET Par_ErrMen  := 'El Numero de Linea de Credito no existe.';
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		-- Obtiene los parametros de la linea de crédito parametrizada con el tipo de linea
		SELECT LI.Estatus,	TI.MontoLimite,			LI.Solicitado,	TI.PlazoLimite,		LI.Autorizado,	TI.Estatus
		INTO   Var_Estatus, Var_MontoMaxTipoLinea, 	Var_MontoLinea,	Var_PlazoLimite, 	Var_Autorizado,	Var_EstatusTipoLinAgro
		FROM LINEASCREDITO LI
		INNER JOIN TIPOSLINEASAGRO TI ON LI.TipoLineaAgroID = TI.TipoLineaAgroID
		WHERE LI.LineaCreditoID = Par_LineaCreditoID;

		SET Var_EstatusTipoLinAgro := IFNULL(Var_EstatusTipoLinAgro, Est_TipLinActiva);

		IF(Par_NumAct = Act_Condiciones) THEN
			IF( Par_ManejaComAdmon = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'El Tipo de Comision por Administracion esta vacio.';
				SET Var_Control	:= 'manejaComAdmon';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComAdmon NOT IN (Con_SI, Con_NO)) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= 'El Tipo de Comision por Administracion no es valido.';
				SET Var_Control	:= 'manejaComAdmon';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComAdmon = Con_SI ) THEN

				IF( Par_ForCobComAdmon = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 003;
					SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion esta vacio.';
					SET Var_Control	:= 'forCobComAdmon';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ForCobComAdmon NOT IN (Tip_Disposicion, Tip_Total)) THEN
					SET Par_NumErr	:= 004;
					SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Administracion no es valido.';
					SET Var_Control	:= 'forCobComAdmon';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_PorcentajeComAdmon <= Decimal_Cero ) THEN
					SET Par_NumErr	:= 005;
					SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es menor o igual a cero.';
					SET Var_Control	:= 'porcentajeComAdmon';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_PorcentajeComAdmon > Con_DecimalCien ) THEN
					SET Par_NumErr	:= 006;
					SET Par_ErrMen	:= 'El Porcentaje de Comision por Administracion es mayor al 100%.';
					SET Var_Control	:= 'porcentajeComAdmon';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_ForCobComAdmon		:= Cadena_Vacia;
				SET Par_PorcentajeComAdmon	:= Decimal_Cero;
			END IF;

			IF( Par_ManejaComGarantia = Cadena_Vacia ) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= 'El Tipo de Comision por Servicio de Garantia esta vacio.';
				SET Var_Control	:= 'manejaComAdmon';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComGarantia NOT IN (Con_SI, Con_NO)) THEN
				SET Par_NumErr	:= 008;
				SET Par_ErrMen	:= 'El Tipo de Comision por Servicio de Garantia no es valido.';
				SET Var_Control	:= 'manejaComAdmon';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_ManejaComGarantia = Con_SI ) THEN

				IF( Par_ForCobComGarantia = Cadena_Vacia ) THEN
					SET Par_NumErr	:= 009;
					SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia esta vacio.';
					SET Var_Control	:= 'forCobComGarantia';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_ForCobComGarantia NOT IN (Tip_Cuota)) THEN
					SET Par_NumErr	:= 010;
					SET Par_ErrMen	:= 'El Tipo de cobro de Comision por Servicio de Garantia no es valido.';
					SET Var_Control	:= 'forCobComGarantia';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_PorcentajeComGarantia <= Decimal_Cero ) THEN
					SET Par_NumErr	:= 011;
					SET Par_ErrMen	:= 'El Porcentaje de Comision por Servicio de Garantia es menor o igual a cero.';
					SET Var_Control	:= 'porcentajeComGarantia';
					LEAVE ManejoErrores;
				END IF;

				IF( Par_PorcentajeComGarantia > Con_DecimalCien ) THEN
					SET Par_NumErr	:= 012;
					SET Par_ErrMen	:= 'El Porcentaje de Comision por Servicio de Garantia es mayor al 100%.';
					SET Var_Control	:= 'porcentajeComGarantia';
					LEAVE ManejoErrores;
				END IF;
			ELSE
				SET Par_ForCobComGarantia		:= Cadena_Vacia;
				SET Par_PorcentajeComGarantia	:= Decimal_Cero;
			END IF;

			IF( Par_IncrementoLinea  <= Decimal_Cero ) THEN
				SET Par_NumErr	:= 013;
				SET Par_ErrMen	:= 'El Incremento de linea es menor o igual a Cero.';
				SET Var_Control	:= 'montoUltimoIncremento';
				LEAVE ManejoErrores;
			END IF;

			SET Var_Autorizado:= IFNULL(Var_Autorizado,Decimal_Cero);
			SET Var_MontoIncreTotal:= (Var_Autorizado + Par_IncrementoLinea);

			IF( Var_MontoIncreTotal  > Var_MontoMaxTipoLinea ) THEN
				SET Par_NumErr	:= 014;
				SET Par_ErrMen	:= 'El Incremento de linea mas la suma de lo autorizado excede la cantidad permitida por tipo de linea de credito.';
				SET Var_Control	:= 'montoUltimoIncremento';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FechaVencimiento < Var_FechaSistema) THEN
				SET Par_NumErr  := 015;
				SET Par_ErrMen  := 'La Fecha de Vencimiento es menor a la del sistema.';
				SET Var_Control := 'fechaNuevoVenci';
				LEAVE ManejoErrores;
			END IF;

			SET Var_FechaLimite:=(SELECT  DATE(DATE_ADD(Var_FechaSistema, INTERVAL Var_PlazoLimite MONTH)));
			IF(Par_FechaVencimiento > Var_FechaLimite) THEN
				SET Par_NumErr  := 016;
				SET Par_ErrMen  := 'La Fecha de Vencimiento supera el Limite de Plazo Por Tipo de Linea de Credito.';
				SET Var_Control := 'fechaNuevoVenci';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_EstatusTipoLinAgro IN (Est_TipLinInactiva, Est_TipLinRechazada)) THEN
				SET Par_NumErr  := 17;
				SET Par_ErrMen  := 'El Estatus de la Linea de Credito no es Valido';
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;


			SET Aud_FechaActual 	:= NOW();
			UPDATE LINEASCREDITO SET
				ManejaComAdmon			= Par_ManejaComAdmon,
				PorcentajeComAdmon		= Par_PorcentajeComAdmon,
				ForCobComAdmon			= Par_ForCobComAdmon,
				ManejaComGarantia		= Par_ManejaComGarantia,
				PorcentajeComGarantia	= Par_PorcentajeComGarantia,

				ForCobComGarantia		= Par_ForCobComGarantia,
				MontoUltimoIncremento	= Par_IncrementoLinea,
				FechaVencimiento		= Par_FechaVencimiento,
				Autorizado				= Autorizado + Par_IncrementoLinea,
				SaldoDisponible			= SaldoDisponible + Par_IncrementoLinea,

				EmpresaID				= Aud_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual				= Aud_FechaActual,
				DireccionIP				= Aud_DireccionIP,
				ProgramaID				= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal,
				NumTransaccion			= Aud_NumTransaccion
			WHERE LineaCreditoID = Par_LineaCreditoID;

			-- SE REALIZARAN LAS AFECTACIONES CONTABLES CORRESPONDIENTES
			SELECT	ProductoCreditoID,		MonedaID,		SucursalID
			INTO	Var_ProductoCreditoID,	Var_MonedaID,	Var_SucursalID
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Par_LineaCreditoID;

			SET Var_Descripcion		:= "INCREMENTO DE LINEA DE CREDITO AGRO.";

			-- se manda a llamar a sp que genera los detalles contables de lineas de credito.
			-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
			CALL CONTALINEASCREPRO(
				Par_LineaCreditoID,	Entero_Cero,			Var_FechaSistema,	Var_FechaSistema,	Par_IncrementoLinea,
				Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
				AltaEncPolizaSI,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenDeuAgro,
				Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,
				SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_PolizaID,
				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
			CALL CONTALINEASCREPRO(
				Par_LineaCreditoID,	Entero_Cero,			Var_FechaSistema,	Var_FechaSistema,	Par_IncrementoLinea,
				Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalID,		Var_Descripcion,	Par_LineaCreditoID,
				AltaEncPolizaNO,	ConceptoContaLinea,		AltaDetPolizaSI,	SalidaNO,			ConcepCtaOrdenCorAgro,
				Cadena_Vacia,		Nat_Abono,				Nat_Abono,
				SalidaNO,			Par_NumErr,				Par_ErrMen,			Par_PolizaID,
				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT("Linea de Credito Agro Modificada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR))  ;
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_NumAct = Act_Reactiva) THEN

			IF(Var_Estatus = Est_Activa) THEN
				SET Par_NumErr  := 017;
				SET Par_ErrMen  := 'La Linea de Credito ya esta Activa.' ;
				SET Var_Control := 'lineaCreditoID';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_FechaVencimiento < Var_FechaSistema) THEN
				SET Par_NumErr  := 018;
				SET Par_ErrMen  := 'La Fecha de Vencimiento es menor a la del sistema.';
				SET Var_Control := 'fechaNuevoVenci';
				LEAVE ManejoErrores;
			END IF;

			SET Var_FechaLimite:=(SELECT  DATE(DATE_ADD(NOW(), INTERVAL Var_PlazoLimite MONTH)));
			IF(Par_FechaVencimiento > Var_FechaLimite) THEN
				SET Par_NumErr  := 019;
				SET Par_ErrMen  := 'La Fecha de Vencimiento supera el Limite de Plazo Por Tipo de Linea de Credito.';
				SET Var_Control := 'fechaNuevoVenci';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_EstatusTipoLinAgro IN (Est_TipLinInactiva,Est_TipLinRechazada) ) THEN
				SET Par_NumErr  := 020;
				SET Par_ErrMen  := 'El Tipo de Linea Agro asociada a la Linea de Credito esta en estatus de Baja, por tal motivo no se puede realizar la Operacion.';
				SET Var_Control := 'fechaNuevoVenci';
				LEAVE ManejoErrores;
			END IF;

			SET Aud_FechaActual 	:= NOW();
			UPDATE LINEASCREDITO SET
				FechaReactivacion	= Var_FechaSistema,
				UsuarioReactivacion	= Aud_Usuario,
				Estatus				= Est_Activa,
				FechaVencimiento	= Par_FechaVencimiento,

				EmpresaID			= Aud_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE LineaCreditoID = Par_LineaCreditoID;

			SET Par_NumErr  := 0;
			SET Par_ErrMen  := CONCAT("Linea de Credito Activada Exitosamente: ", CONVERT(Par_LineaCreditoID, CHAR)) ;
			SET Var_Control := 'lineaCreditoID';
			LEAVE ManejoErrores;
		END IF;

	END ManejoErrores;

	IF Par_Salida = SalidaSI THEN
		SELECT	Par_NumErr		  AS NumErr,
				Par_ErrMen		  AS ErrMen,
				Var_Control		  AS control,
				Par_LineaCreditoID AS consecutivo;
	END IF;

END TerminaStore$$