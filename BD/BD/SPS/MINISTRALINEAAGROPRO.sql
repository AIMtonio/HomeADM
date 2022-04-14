-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRALINEAAGROPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRALINEAAGROPRO`;

DELIMITER $$
CREATE PROCEDURE `MINISTRALINEAAGROPRO`(
	/*Realiza el desembolso de una Linea de  credito agropecuario*/
	Par_CreditoID		BIGINT(12),		-- ID de credito a desembolsar
	INOUT Par_PolizaID	BIGINT(20),		-- Numero de poliza para registrar los detalles contables
	Par_MontoCredito	DECIMAL(14,2),	-- Monto de Desembolso

	Par_Salida			CHAR(1),		-- Parametro de Salida
	INOUT Par_NumErr	INT(11),		-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechVencCred		DATE;			-- Fecha de Vencimiento del Credito
	DECLARE Var_FechaSistema		DATE;			-- Fecha del Sistema
	DECLARE Var_FechaVencimientoLin	DATE;			-- Fecha de Vencimiento de la Linea de Credito
	DECLARE Var_MonedaLinea			INT(11);		-- Numero de Moneda de la Linea de Credito
	DECLARE Var_SucursalLin			INT(11);		-- Sucursal de la Linea de Credito

	DECLARE Var_MonedaID			INT(11);		-- Moneda del Credito
	DECLARE Var_ProductoCreditoID	INT(11);		-- Clave del Producto de Credito
	DECLARE Var_EstatusLinea		CHAR(1);		-- Estatus de la Linea de Credito
	DECLARE Var_EsAgropecuario		CHAR(1);		-- Es Agropecuario
	DECLARE Var_LineaCreditoID		BIGINT(20);		-- Numero de Linea de Credito

	DECLARE Var_Control				VARCHAR(100);	-- Variable de Control
	DECLARE Var_SaldoDisponible		DECIMAL(14,2);	-- Saldo disponible de la Linea de Credito
	DECLARE Var_Dispuesto			DECIMAL(14,2);	-- Saldo Dispuesto de la Linea de Credito
	DECLARE Var_MontoCredito		DECIMAL(12,2);	-- Variables para el Simulador

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia			CHAR(1);		-- Constante Cadena Vacia
	DECLARE Con_NO					CHAR(1);		-- Constante NO
	DECLARE Con_SI					CHAR(1);		-- Constante SI
	DECLARE Estatus_Activo			CHAR(1);		-- Estatus Activo
	DECLARE Salida_SI				CHAR(1);		-- Indica una salida en pantalla SI
	DECLARE Salida_NO				CHAR(1);		-- Indica una salida en pantalla NO

	DECLARE Nat_Abono				CHAR(1);		-- Naturaleza de Abono.
	DECLARE Nat_Cargo				CHAR(1);		-- Naturaleza de Cargo
	DECLARE AltaMovAho_NO			CHAR(1);		-- Alta de Movimiento de Ahorro: NO
	DECLARE AltaMovAho_SI			CHAR(1);		-- Alta de Movimiento de Ahorro: SI
	DECLARE AltaMovCre_NO			CHAR(1);		-- Alta de Movimiento de Credito: NO

	DECLARE AltaMovCre_SI 			CHAR(1);		-- Alta de Movimiento de Credito: SI
	DECLARE AltaPolCre_NO			CHAR(1);		-- Alta de Poliza Contable de Credito: NO
	DECLARE AltaPolCre_SI			CHAR(1);		-- Alta de Poliza Contable de Credito: SI
	DECLARE AltaPoliza_NO			CHAR(1);		-- Alta de Poliza Contable General: NO
	DECLARE AltaPoliza_SI			CHAR(1);		-- Alta de Poliza Contable General: SI

	DECLARE Entero_Cero				INT(11);		-- Constante  Entero en Cero
	DECLARE ConcepCtaOrdenDeuAgro	INT(11);		-- Concepto Cuenta Ordenante Deudor Agro
	DECLARE ConcepCtaOrdenCorAgro	INT(11);		-- Concepto Cuenta Ordenante Corte Agro
	DECLARE Con_ContDesem			INT(11);		-- Concepto Contable de Desembolso (CONCEPTOSCONTA)
	DECLARE DescripcionLinea		VARCHAR(100);	-- Descripcion de Disposicion
	DECLARE Fecha_Vacia				DATE;			-- Contante Fecha Vacia

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';
	SET Con_NO						:= 'N';
	SET Con_SI						:= 'S';
	SET Estatus_Activo				:= 'A';
	SET Salida_SI					:= 'S';
	SET Salida_NO					:= 'N';

	SET Nat_Abono					:= 'A';
	SET Nat_Cargo					:= 'C';
	SET AltaMovAho_NO				:= 'N';
	SET AltaMovAho_SI				:= 'S';
	SET AltaMovCre_NO				:= 'N';

	SET AltaMovCre_SI 				:= 'S';
	SET AltaPolCre_NO				:= 'N';
	SET AltaPolCre_SI				:= 'S';
	SET AltaPoliza_NO				:= 'N';
	SET AltaPoliza_SI				:= 'S';

	SET Entero_Cero					:= 0;
	SET Con_ContDesem				:= 50;
	SET ConcepCtaOrdenDeuAgro		:= 138;
	SET ConcepCtaOrdenCorAgro		:= 139;
	SET DescripcionLinea			:= 'DISPOSICION DE LINEA DE CREDITO';
	SET Fecha_Vacia					:= '1900-01-01';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRALINEAAGROPRO');
			SET Var_Control	:= 'SQLEXCEPTION';
		END;

		SELECT	Cre.LineaCreditoID,	Cre.MontoCredito,	Cre.FechaVencimien,	Cre.MonedaID,	Cre.ProductoCreditoID
		INTO	Var_LineaCreditoID,	Var_MontoCredito,	Var_FechVencCred,	Var_MonedaID,	Var_ProductoCreditoID
		FROM CREDITOS Cre
		INNER JOIN PRODUCTOSCREDITO Pro ON Cre.ProductoCreditoID = Pro.ProducCreditoID
		WHERE Cre.CreditoID	= Par_CreditoID;

		# Sacamos el monto del credito de las ministraciones del credito
		SET Var_MontoCredito 		:= IFNULL(Var_MontoCredito, Entero_Cero);
		SET Var_LineaCreditoID		:= IFNULL(Var_LineaCreditoID, Entero_Cero);

		SELECT	FechaSistema
		INTO	Var_FechaSistema
		FROM PARAMETROSSIS
		WHERE EmpresaID = Aud_EmpresaID;


		IF( Var_LineaCreditoID > Entero_Cero ) THEN

			SELECT	MonedaID,			FechaVencimiento,			SaldoDisponible,		Dispuesto,		Estatus,
					SucursalID,			EsAgropecuario
			INTO	Var_MonedaLinea,	Var_FechaVencimientoLin,	Var_SaldoDisponible,	Var_Dispuesto,	Var_EstatusLinea,
					Var_SucursalLin,	Var_EsAgropecuario
			FROM LINEASCREDITO
			WHERE LineaCreditoID = Var_LineaCreditoID;

			SET Var_MonedaLinea			 := IFNULL(Var_MonedaLinea, Entero_Cero);
			SET Var_FechaVencimientoLin  := IFNULL(Var_FechaVencimientoLin, Fecha_Vacia);
			SET Var_SaldoDisponible		 := IFNULL(Var_SaldoDisponible, Entero_Cero);
			SET Var_Dispuesto			 := IFNULL(Var_Dispuesto, Entero_Cero);
			SET Var_EstatusLinea		 := IFNULL(Var_EstatusLinea, Cadena_Vacia);

			SET Var_SucursalLin			 := IFNULL(Var_SucursalLin, Entero_Cero);
			SET Var_EsAgropecuario		 := IFNULL(Var_EsAgropecuario, Con_NO);

			IF( Var_EsAgropecuario = Con_NO ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'La Linea de Credito no es Agropecuaria.';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_MonedaLinea = Entero_Cero ) THEN
				SET Par_NumErr	:= 001;
				SET Par_ErrMen	:= 'La Moneda de la Linea de Credito No Existe.';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_SaldoDisponible < Par_MontoCredito ) THEN
				SET Par_NumErr	:= 002;
				SET Par_ErrMen	:= CONCAT('La Linea de Credito ',Var_LineaCreditoID,' No tiene Saldo Disponible para el monto del Credito.');
				LEAVE ManejoErrores;
			END IF;

			IF( Var_EstatusLinea <> Estatus_Activo ) THEN
				SET Par_NumErr	:= 003;
				SET Par_ErrMen	:= 'La Linea de Credito No esta Activa.';
				LEAVE ManejoErrores;
			END IF;

			IF( DATEDIFF(Var_FechaVencimientoLin, Var_FechVencCred) < Entero_Cero ) THEN
				SET Par_NumErr	:= 004;
				SET Par_ErrMen	:= 'El Credito No esta Dentro de la Vigencia de la Linea.';
				LEAVE ManejoErrores;
			END IF;

			IF( Var_MonedaID != Var_MonedaLinea ) THEN
				SET Par_NumErr	:= 19;
				SET Par_ErrMen	:= 'La Moneda del Credito No Coincide con la Moneda de la Linea de Credito.';
				LEAVE ManejoErrores;
			END IF;

			IF( Par_MontoCredito > Var_SaldoDisponible ) THEN
				SET Par_NumErr	:= 24;
				SET Par_ErrMen	:= CONCAT('El Monto debe de ser Menor o Igual al Monto Disponible de la Linea de Credito: ',Var_LineaCreditoID);
				LEAVE ManejoErrores;
			END IF;

			UPDATE LINEASCREDITO SET
				Dispuesto 			= IFNULL(Dispuesto,Entero_Cero) + Par_MontoCredito,
				SaldoDisponible		= IFNULL(SaldoDisponible,Entero_Cero) - Par_MontoCredito,
				SaldoDeudor			= IFNULL(SaldoDeudor,Entero_Cero) + Par_MontoCredito,
				NumeroCreditos		= NumeroCreditos + 1,
				UltFechaDisposicion = Var_FechaSistema,
				UltMontoDisposicion = Par_MontoCredito,

				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE LineaCreditoID = Var_LineaCreditoID;

			-- se manda a llamar a sp que genera los detalles contables de lineas de credito.
			-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
			CALL CONTALINEASCREPRO(
				Var_LineaCreditoID,	Entero_Cero,			Var_FechaSistema,	Var_FechaSistema,	Par_MontoCredito,
				Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalLin,	DescripcionLinea,	Var_LineaCreditoID,
				AltaPoliza_NO,		Con_ContDesem,			AltaPolCre_SI,		AltaMovCre_NO,		ConcepCtaOrdenDeuAgro,
				Cadena_Vacia,		Nat_Abono,				Nat_Abono,
				Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_PolizaID,
				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- SP QUE DA DE ALTA LOS MOVIMIENTOS CONTABLES, DENTRO MANDA A LLAMAR A POLIZALINEACREPRO
			CALL CONTALINEASCREPRO(
				Var_LineaCreditoID,	Entero_Cero,			Var_FechaSistema,	Var_FechaSistema,	Par_MontoCredito,
				Var_MonedaID,		Var_ProductoCreditoID,	Var_SucursalLin,	DescripcionLinea,	Var_LineaCreditoID,
				AltaPoliza_NO,		Con_ContDesem,			AltaPolCre_SI,		AltaMovCre_NO,		ConcepCtaOrdenCorAgro,
				Cadena_Vacia,		Nat_Cargo,				Nat_Cargo,
				Salida_NO,			Par_NumErr,				Par_ErrMen,			Par_PolizaID,
				Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr != Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		SET Par_NumErr := Entero_Cero;
		SET Par_ErrMen := CONCAT('La Disposicion de la Linea de Credito: ', CONVERT(Var_LineaCreditoID, CHAR), ' Realizada con exito.');

	END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen		AS ErrMen,
				Cadena_Vacia	AS control,
				Var_LineaCreditoID	AS consecutivo;
	END IF;

END TerminaStore$$