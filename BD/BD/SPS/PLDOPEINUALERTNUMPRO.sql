-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINUALERTNUMPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINUALERTNUMPRO`;DELIMITER $$

CREATE PROCEDURE `PLDOPEINUALERTNUMPRO`(
/*SP para el proceso de alertas automaticas de la operaciones inusuales*/
	Par_CuentaAhoID			BIGINT(12),				-- Cuenta de ahorro
	Par_NumeroMov			BIGINT(20),				-- Numero de movimiento
	Par_Fecha				DATE,					-- FEcha de la operacion
	Par_NatMovimiento		CHAR(1),				-- Naturaleza del movimiento
	Par_CantidadMov			DECIMAL(12,2),			-- Cantidad del movimiento

	Par_DescripcionMov		VARCHAR(150),			-- Descripcion del movimiento
	Par_ReferenciaMov		VARCHAR(50),			-- Referencia del movimiento
	Par_TipoMovAhoID		CHAR(4),				-- Tipo de movimiento de ahorro
	Par_MonedaID			INT,					-- Id de la moneda de la operacion
	Par_ClienteID			INT,					-- Id del cliente

	Par_Salida 				CHAR(1), 				-- Salida S:Si N:No
	INOUT Par_NumErr		INT(11),				-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),			-- Mensaje de error

	Aud_EmpresaID			INT(11),				-- Auditoria
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
)
TerminaStore: BEGIN

	/* Declaracion de Variables */
	DECLARE Var_Control	    			VARCHAR(100);  		-- Variable de control
	DECLARE Var_Consecutivo				BIGINT(20);     	-- Variable consecutivo
	DECLARE	Cliente						INT; 				-- Numero de Cliente
	DECLARE	SaldoDisp					DECIMAL(12,2);		-- Saldo disponible
	DECLARE	MonedaCon					INT;
	DECLARE	EstatusC					CHAR(1);
	DECLARE	Var_TipoMovID				CHAR(4);
	DECLARE Var_EstatusDes				VARCHAR(50);
	DECLARE Var_NumDepParam				DECIMAL(14,2);		-- % Numero de depositos extras de la tabla PLDPARALEOPINUS
	DECLARE Var_NumRetParam				DECIMAL(14,2);		-- % Numero de retiros extras de la tabla PLDPARALEOPINUS
	DECLARE Var_NumDepoMax				INT(11);
	DECLARE Var_NumDepoApli				INT(11);
	DECLARE	Var_NumRetiMax				INT(11);
	DECLARE Var_NumRetiApli				INT(11);
	DECLARE Var_SucursalCli				INT(11);
	DECLARE Var_NomCliente				VARCHAR(200);
	DECLARE Var_TipoOpeCNBV				CHAR(2);
	DECLARE	Var_FormaPago				CHAR(1);
	DECLARE Var_EsEfectivo				CHAR(4);
	DECLARE Var_TipoPersona				CHAR(1);
	DECLARE Var_NivelRiesgo				CHAR(1);

	DECLARE Var_NumDepoApliPerf			INT(11);			# Aplica como contador de numero de operacion para modificar el numero aplicado para el perfil
	DECLARE Var_NumRetiApliPerf			INT(11);			# Aplica como contador de numero de operacion para modificar el numero aplicado para el perfil
	DECLARE Var_NumDepoEfecApliPerf		INT(11);			# Aplica como contador de numero de operacion para modificar el numero aplicado para el perfil
	DECLARE Var_NumDepoCheApliPerf		INT(11);			# Aplica como contador de numero de operacion para modificar el numero aplicado para el perfil
	DECLARE Var_NumDepoTranApliPerf		INT(11);			# Aplica como contador de numero de operacion para modificar el numero aplicado para el perfil
	DECLARE Var_NumRetirosEfecApliPerf	INT(11);			# Aplica como contador de numero de operacion para modificar el numero aplicado para el perfil
	DECLARE Var_NumRetirosCheApliPerf	INT(11);			# Aplica como contador de numero de operacion para modificar el numero aplicado para el perfil
	DECLARE Var_NumRetirosTranApliPerf	INT(11);			# Aplica como contador de numero de operacion para modificar el numero aplicado para el perfil

	DECLARE Var_DeclaradoNumDepositos	DECIMAL(12,2);			# Valores declarados en el lo declarado en el Perfil transaccional
	DECLARE Var_DeclaradoNumRetiros		DECIMAL(12,2);			# Valores declarados en el lo declarado en el Perfil transaccional
	DECLARE Var_DeclaradoNumDepoApli	INT(11);			# Valores declarados en el lo declarado en el Perfil transaccional Aplicadao
	DECLARE Var_DeclaradoNumRetiApli	INT(11);			# Valores declarados en el lo declarado en el Perfil transaccional Aplicadao
	DECLARE	NumConsecutivo					BIGINT(20);

	/* Declaracion de Constantes */
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE PorcentajeCien		INT;
	DECLARE	Entero_Uno			INT;
	DECLARE	Decimal_Cero		DECIMAL(12,2);
	DECLARE	EstatusActual		CHAR(1);
	DECLARE	EstatusActivo		CHAR(1);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Salida_NO			char(1);
	DECLARE	Salida_SI			char(1);
	DECLARE	Var_Si	 			CHAR(1);
	DECLARE Est_Cancelado		CHAR(1)	;
	DECLARE	ParametroVigente	CHAR(1);
	DECLARE TipoTransCtas		CHAR(4);
	DECLARE	TipoDepRef			CHAR(4);
	DECLARE	TipoCheque			CHAR(4);
	DECLARE Efectivo			CHAR(1);
	DECLARE Cheque				CHAR(1);
	DECLARE Transferencia		CHAR(1);
	DECLARE	MovAbonoCuenta		INT(11);
	DECLARE MovRetiroCuenta		INT(11);
	DECLARE MovTraspasoCtaInt	INT(11);
	DECLARE MovDepReferenciado	INT(11);
	DECLARE MovDepSBC			INT(11);

	/* Asignacion de Constantes */
	SET Cadena_Vacia		:= '';				-- Cadena o String Vacio
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero en Cero
	SET PorcentajeCien		:= 100;				-- Porcentaje cien
	SET Entero_Uno			:= 1;				-- Entero Uno
	SET Decimal_Cero		:= 0.0;				-- Decimal Cero
	SET EstatusActivo		:= 'A';				-- Estatus Activo
	SET Nat_Cargo			:= 'C';				-- Cargo
	SET Nat_Abono			:= 'A';				-- Abono
	SET	Salida_NO       	:= 'N';				-- Salida en pantalla NO
	SET Salida_SI       	:= 'S';     		-- Salida si
	SET Var_Si				:= 'S';				-- Valor SI
	SET Est_Cancelado		:= 'C';				-- Estatus Cancelado
	SET	ParametroVigente	:= 'V';				-- Indica Estatus Vigente en pantalla
	SET Efectivo			:= 'E';				-- Forma de pago efectivo --
	SET Cheque				:= 'H';				-- Forma de pago Cheque --
	SET Transferencia		:= 'T';				-- Tipo de deposito Transferencia --
	SET TipoTransCtas		:= '12';			-- Tipo de Movimiento : Transferencia entre Cuentas 	-T
	SET TipoDepRef			:= '14';			-- Tipo de Movimiento : Depositos Referenciados		-T
	SET TipoCheque			:= '27';			-- Tipo de Movimiento : DEPOSITO CHEQUE SBC EN FIRME	-C
	SET NumConsecutivo		:= 0;				-- Guarda el valor del consecutivo para insertar en la tabla de PLD
	SET MovAbonoCuenta		:= 10;				-- Movimiento por abono a cuenta TIPOSMOVSAHO
	SET MovRetiroCuenta		:= 11;				-- Movimiento por retiro a cuenta TIPOSMOVSAHO
	SET MovTraspasoCtaInt	:= 12;				-- Movimiento por TRASPASO CUENTA INTERNA TIPOSMOVSAHO
	SET MovDepReferenciado	:= 14;				-- Movimiento por DEPOSITO REFERENCIADO EFECTIVO TIPOSMOVSAHO
	SET MovDepSBC			:= 27;				-- Movimiento por DEPOSITO SBC EFECTIVO TIPOSMOVSAHO


	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEINUALERTNUMPRO');
			SET Var_Control	:= 'sqlException';
		END;

		IF EXISTS(SELECT NumeroMov FROM PLDOPEINUSALERTNUM
			WHERE ClienteID = Par_ClienteID
			AND NumeroMov = Par_NumeroMov
			AND NatMovimiento = Par_NatMovimiento) THEN
			SET Par_NumErr		:= 000;
			SET Par_ErrMen		:= CONCAT("El movimiento ya esta registrado");
			SET Var_Control		:= 'cuentaAhoID' ;
			SET Var_Consecutivo	:= Par_NumeroMov;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_ClienteID,Entero_Cero)=Entero_Cero) THEN
			SET Par_ClienteID	= (SELECT ClienteID FROM CUENTASAHO WHERE CuentaAhoID = Par_CuentaAhoID);
		END IF;

		SELECT
			CTE.TipoPersona,		CTE.NivelRiesgo,		CTE.SucursalOrigen,			CTE.NombreCompleto
			INTO
			Var_TipoPersona,		Var_NivelRiesgo,		Var_SucursalCli,			Var_NomCliente
			FROM CLIENTES AS CTE
				WHERE CTE.ClienteID = Par_ClienteID;

		# OBTENIENDO LA PARAMETRIZACION DE ACUERDO AL TIPO DE PERSONA Y NIVEL DE RIESGO PARA LA HOLGURA
		SELECT
			VarNumDep,			VarNumRet
			INTO
			Var_NumDepParam,	Var_NumRetParam
			FROM PLDPARALEOPINUS
				WHERE
					Estatus = ParametroVigente
					AND TipoPersona = Var_TipoPersona
					AND NivelRiesgo = Var_NivelRiesgo;

		SET Var_NumDepParam 		:= IFNULL(Var_NumDepParam, Decimal_Cero);
		SET Var_NumRetParam 		:= IFNULL(Var_NumRetParam, Decimal_Cero);
		SET Par_TipoMovAhoID 		:= IFNULL(Par_TipoMovAhoID, Cadena_Vacia);
		SET Var_EsEfectivo			:= (SELECT TipoMovAhoID
											FROM TIPOSMOVSAHO
											WHERE	TipoMovAhoID = Par_TipoMovAhoID AND EsEfectivo = Var_Si);

		/** VALIDANDO EL TIPO DE PAGO DE LA OPERACION */
		SET Var_EsEfectivo	:=IFNULL(Var_EsEfectivo,Cadena_Vacia);

		# TRANSFERENCIAS
		IF(Par_TipoMovAhoID = TipoTransCtas OR Par_TipoMovAhoID = TipoDepRef)THEN
			SET Var_FormaPago := Transferencia;
			# CHEQUE
		  ELSEIF(Par_TipoMovAhoID = TipoCheque OR Par_TipoMovAhoID = TipoCheque)THEN
			SET Var_FormaPago := Cheque;
		  ELSE
			# EFECTIVO
			SET Var_FormaPago := Efectivo;
		END IF;

		IF(Var_FormaPago != Cadena_Vacia) THEN
			-- Obtener Valores de Parametros de PLD
			IF(Par_NatMovimiento = Nat_Abono) THEN
				SET Var_NumDepoApliPerf	:= 1;
			  ELSE
				SET Var_NumRetiApliPerf	:= 1;
			END IF;

			CASE Var_FormaPago
				WHEN  Efectivo	THEN
					CASE Par_NatMovimiento
						WHEN Nat_Abono THEN
							SET Var_NumDepoEfecApliPerf		:= 1;
						WHEN Nat_Cargo THEN
							SET Var_NumRetirosEfecApliPerf	:= 1;
					END CASE;
				WHEN TipoCheque		THEN
					CASE Par_NatMovimiento
						WHEN Nat_Abono THEN
							SET Var_NumDepoCheApliPerf			:= 1;
						WHEN Nat_Cargo THEN
							SET Var_NumRetirosCheApliPerf		:= 1;
					END CASE;
				WHEN Transferencia	THEN
					CASE Par_NatMovimiento
						WHEN Nat_Abono THEN
							SET Var_NumDepoTranApliPerf			:= 1;
						WHEN Nat_Cargo THEN
							SET Var_NumRetirosTranApliPerf		:= 1;
					END CASE;
				ELSE
					CASE Par_NatMovimiento
						WHEN Nat_Abono THEN
							SET Var_NumDepoEfecApliPerf		:= 1;
						WHEN Nat_Cargo THEN
							SET Var_NumRetirosEfecApliPerf	:= 1;
					END CASE;
			END CASE;
		END IF;

		SET Var_NumDepoApliPerf		:= IFNULL(Var_NumDepoApliPerf, Entero_Cero);
		SET Var_NumRetiApliPerf		:= IFNULL(Var_NumRetiApliPerf, Entero_Cero);
		SET Var_NumDepoEfecApliPerf	:= IFNULL(Var_NumDepoEfecApliPerf,Entero_Cero);
		SET Var_NumDepoCheApliPerf	:= IFNULL(Var_NumDepoCheApliPerf,Entero_Cero);
		SET Var_NumDepoTranApliPerf	:= IFNULL(Var_NumDepoTranApliPerf,Entero_Cero);
		SET Var_NumRetirosEfecApliPerf	:= IFNULL(Var_NumRetirosEfecApliPerf,Entero_Cero);
		SET Var_NumRetirosCheApliPerf	:= IFNULL(Var_NumRetirosCheApliPerf,Entero_Cero);
		SET Var_NumRetirosTranApliPerf	:= IFNULL(Var_NumRetirosTranApliPerf,Entero_Cero);

		UPDATE CONOCIMIENTOCTA SET
			NumDepoApli	= IFNULL(NumDepoApli,Entero_Cero) + Var_NumDepoApliPerf,
			NumRetiApli = IFNULL(NumRetiApli,Entero_Cero) + Var_NumRetiApliPerf
			WHERE	CuentaAhoID = Par_CuentaAhoID;

		UPDATE PLDPERFILTRANS SET
			NumDepoApli			= IFNULL(NumDepoApli, Entero_Cero) + Var_NumDepoApliPerf,
			NumRetiApli			= IFNULL(NumRetiApli, Entero_Cero) + Var_NumRetiApliPerf,
			NumDepoEfecApli		= IFNULL(NumDepoEfecApli, Entero_Cero) + Var_NumDepoEfecApliPerf,
			NumDepoCheApli		= IFNULL(NumDepoCheApli, Entero_Cero) + Var_NumDepoCheApliPerf,
			NumDepoTranApli		= IFNULL(NumDepoTranApli, Entero_Cero) + Var_NumDepoTranApliPerf,
			NumRetirosEfecApli	= IFNULL(NumRetirosEfecApli, Entero_Cero) + Var_NumRetirosEfecApliPerf,
			NumRetirosCheApli	= IFNULL(NumRetirosCheApli, Entero_Cero) + Var_NumRetirosCheApliPerf,
			NumRetirosTranApli	= IFNULL(NumRetirosTranApli, Entero_Cero) + Var_NumRetirosTranApliPerf
			WHERE ClienteID = Par_ClienteID;

		# === Tipo Operacion CNBV
		SELECT	TipoOpeCNBV INTO Var_TipoOpeCNBV
			FROM TIPOSMOVSAHO
				WHERE	TipoMovAhoID = Par_TipoMovAhoID;

		# SE OBTIENE LO DECLARADO EN EL PERFIL TRANSACCIONAL
		SELECT
			PERF.NumDepositos,				PERF.NumRetiros,				PERF.NumDepoApli,				PERF.NumRetiApli
			INTO
			Var_DeclaradoNumDepositos,		Var_DeclaradoNumRetiros,		Var_DeclaradoNumDepoApli,		Var_DeclaradoNumRetiApli
			FROM PLDPERFILTRANS AS PERF
				WHERE ClienteID = Par_ClienteID;
		SET Var_DeclaradoNumDepositos		:= IFNULL(Var_DeclaradoNumDepositos, Entero_Cero);
		SET Var_DeclaradoNumRetiros			:= IFNULL(Var_DeclaradoNumRetiros, Entero_Cero);
		SET Var_DeclaradoNumDepoApli		:= IFNULL(Var_DeclaradoNumDepoApli, Entero_Cero);
		SET Var_DeclaradoNumRetiApli		:= IFNULL(Var_DeclaradoNumRetiApli, Entero_Cero);
		/** A LO DECLARADO SE LE SUMA LA HOLGURA PARAMETRIZADA**/
		SET Var_DeclaradoNumDepositos		:= Var_DeclaradoNumDepositos*(1+(Var_NumDepParam/100));
		SET Var_DeclaradoNumRetiros			:= Var_DeclaradoNumRetiros*(1+(Var_NumRetParam/100));
		SET Var_DeclaradoNumDepositos		:= IFNULL(Var_DeclaradoNumDepositos,0);
		SET Var_DeclaradoNumRetiros			:= IFNULL(Var_DeclaradoNumRetiros,0);


		/*EL CLIENTE A SUPERADO LO DECLARADO EN SU PERFIL TRANSACCIONA PARA DNUMERO DE DEPOSITOS*/
		SELECT
			(PERF.NumDepositos*(1+(PAR.VarNumRet/100))),				(PERF.NumRetiros*(1+(PAR.VarNumRet/100))),				PERF.NumDepoApli,				PERF.NumRetiApli
			INTO
			Var_DeclaradoNumDepositos,		Var_DeclaradoNumRetiros,		Var_DeclaradoNumDepoApli,		Var_DeclaradoNumRetiApli
			FROM
				PLDPERFILTRANS AS PERF INNER JOIN
				CLIENTES AS CTE ON PERF.ClienteID = CTE.ClienteID INNER JOIN
				PLDPARALEOPINUS AS PAR ON CTE.TipoPersona = PAR.TipoPersona AND CTE.NivelRiesgo = PAR.NivelRiesgo
				WHERE PERF.ClienteID = Par_ClienteID;

			SET Var_DeclaradoNumDepositos	:= IFNULL(Var_DeclaradoNumDepositos,0);
			SET Var_DeclaradoNumDepoApli	:= IFNULL(Var_DeclaradoNumDepoApli,0);
			SET Var_DeclaradoNumRetiApli	:= IFNULL(Var_DeclaradoNumRetiApli,0);
			SET Var_DeclaradoNumRetiros		:= IFNULL(Var_DeclaradoNumRetiros,0);

			IF(Var_DeclaradoNumDepoApli > Var_DeclaradoNumDepositos AND Par_NatMovimiento = 'A') THEN
				SET NumConsecutivo:= (SELECT IFNULL(MAX(PldOpeInusAlertID),Entero_Cero) + 1
										FROM PLDOPEINUSALERTNUM);

				INSERT INTO PLDOPEINUSALERTNUM(
					PldOpeInusAlertID,	CuentasAhoID,		ClienteID,			NumeroMov,					NombreCliente,
					Fecha,				NatMovimiento,		CantidadMov,		MonedaID,					TipoOpeCNBV,
					FormaPago,			SucursalCli,		Metodo,				EmpresaID,					Usuario,
					FechaActual,		DireccionIP,		ProgramaID,			Sucursal,					NumTransaccion
				  ) VALUES (
					NumConsecutivo,		Par_CuentaAhoID,	Par_ClienteID,		Aud_NumTransaccion,			Var_NomCliente,
					Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,	Par_MonedaID,				Var_TipoOpeCNBV,
					Var_FormaPago,		Var_SucursalCli,	2,					Aud_EmpresaID,				Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion);
			END IF;

			IF(Var_DeclaradoNumRetiApli > Var_DeclaradoNumRetiros AND Par_NatMovimiento = 'C') THEN
				SET NumConsecutivo:= (SELECT IFNULL(MAX(PldOpeInusAlertID),Entero_Cero) + 1
										FROM PLDOPEINUSALERTNUM);

				INSERT INTO PLDOPEINUSALERTNUM(
					PldOpeInusAlertID,	CuentasAhoID,		ClienteID,			NumeroMov,					NombreCliente,
					Fecha,				NatMovimiento,		CantidadMov,		MonedaID,					TipoOpeCNBV,
					FormaPago,			SucursalCli,		Metodo,				EmpresaID,					Usuario,
					FechaActual,		DireccionIP,		ProgramaID,			Sucursal,					NumTransaccion
				  ) VALUES (
					NumConsecutivo,		Par_CuentaAhoID,	Par_ClienteID,		Aud_NumTransaccion,			Var_NomCliente,
					Par_Fecha,			Par_NatMovimiento,	Par_CantidadMov,	Par_MonedaID,				Var_TipoOpeCNBV,
					Var_FormaPago,		Var_SucursalCli,	2,					Aud_EmpresaID,				Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,				Aud_NumTransaccion);
			END IF;

		# DETECCIÓN DE OPERACIONES RELEVANTES.
		CALL PLDOPERELEVPRO(
			Aud_Sucursal,		Par_CuentaAhoID,	Par_CantidadMov,	Par_Fecha,				Aud_NumTransaccion,
			Par_NatMovimiento,	Par_MonedaID,		Par_TipoMovAhoID,	Par_DescripcionMov,		Salida_NO,
			Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= CONCAT("Movimiento Agregado Exitosamente: ", CONVERT(Par_NumeroMov, CHAR));
		SET Var_Control		:= 'cuentaAhoID' ;
		SET Var_Consecutivo	:= Par_NumeroMov;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$