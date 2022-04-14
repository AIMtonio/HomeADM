-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACIONCHEQUESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACIONCHEQUESPRO`;
DELIMITER $$

CREATE PROCEDURE `CANCELACIONCHEQUESPRO`(
# ==================================================================================
# ------------------ SP PARA REALIZAR LA CANCELACION DE CHEQUES---------------------
# ==================================================================================
	Par_InstitucionID			INT(11),		-- Institucion del cheque a cancelar
	Par_NumCtaInstit			VARCHAR(20),	-- Cta de la Institucion del cheque a cancelar
	Par_NumCheque				INT(10),		-- Numero de cheque a cancelar
	Par_SucursalEmision			INT(11),		-- Numero sucursal de emision del cheque a cancelar
	Par_FechaEmision			DATE,			-- Fecha de emision del cheque a cancelar

	Par_NumReqGasID				INT(11),		-- Numero de requisicion del cheque a cancelar
	Par_ProveedorID    			INT(11),		-- Numero de proveedor del cheque a cancelar
	Par_NumFactura     			VARCHAR(20),	-- Numero de factura del cheque a cancelar
	Par_Monto					DECIMAL(14,2),	-- Monto del cheque a cancelar
	Par_Beneficiario			VARCHAR(200),	-- Nombre del Beneficiario

	Par_Concepto				VARCHAR(200),	-- Concepto del cheque a cancelar
	Par_MotivoCancela			INT(11),		-- Motivo de cancelacion del cheque
	Par_Comentario				VARCHAR(500),	-- Comentario de cancelacion del cheque
	Par_TipoCancelacion			INT(11),		-- Tipo de cancelacion 1 Gastos y anticipos, 2 Dispersion S/factura, 3 dispersion C/factura
	Par_PolizaID				BIGINT(20),		-- Numero de poliza
    Par_TipoChequera			CHAR(2),		-- Tipo Chequera P- PROFORMA, E-ESTANDAR

	Par_Salida					CHAR(1),
	INOUT	Par_NumErr			INT(11),
	INOUT	Par_ErrMen			VARCHAR(400),

	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN
	-- Declaracion de constantes --
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE FechaVacia				DATE;
	DECLARE Decimal_Cero			DECIMAL(14,2);
	DECLARE Salida_No				CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE CanGastosAnticipos		INT(11);
	DECLARE CanDisperSinReq			INT(11);
	DECLARE CanDisperConReq	   		INT(11);
	DECLARE Cancelado 				CHAR(1);
	DECLARE Entero_Uno				INT(11);
	DECLARE AltaPoliza_SI			CHAR(1);
	DECLARE AltaPoliza_NO			CHAR(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Mov_AhorroNO			CHAR(1);
	DECLARE Mov_AhorroSI			CHAR(1);
	DECLARE DesMovimientoAbono		VARCHAR(45);
	DECLARE ConContaCancelaCheque	INT(11);
	DECLARE Conciliado_NO			CHAR(1);
	DECLARE Conciliado_SI			CHAR(1);
	DECLARE Tip_RegAutomatico		CHAR(1);
	DECLARE Tip_ChequeCaja			CHAR(4);
	DECLARE FormaPagoCheque			CHAR(1);
	DECLARE NaturalezaEntra			CHAR(1);
	DECLARE Procedimiento			VARCHAR(30);
	DECLARE	For_SucOrigen			CHAR(3);
	DECLARE For_SucEmp				CHAR(3);
	DECLARE Si_Requiere				CHAR(1);
	DECLARE EstatusNoAplicado		CHAR(1);
	DECLARE TipoActEstatus			INT(11);
	DECLARE Tip_MovAhoCHEQ			CHAR(4);
	DECLARE TipoInstrumentoID		INT(11);
	DECLARE Est_Abierto				CHAR(1);
	DECLARE EstatusCancela			CHAR(1);


	-- Declaracion de variables --
	DECLARE Var_FechaCancela		DATE;
	DECLARE VarControl 				VARCHAR(15);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_NumTransaccion		BIGINT(20);
	DECLARE Var_MonedaBase			INT(11);
	DECLARE Var_PolizaID			BIGINT(20);
	DECLARE Var_Consecutivo			BIGINT(20);
	DECLARE Var_ConsecutivoDisp		BIGINT(20);
	DECLARE Var_EmpresaID			INT(11);
	DECLARE Var_RefTeso				VARCHAR(50);
	DECLARE Var_CuentaAhoTeso		BIGINT(12);
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Var_CajaID 				INT(11);
	DECLARE Var_TipoOpe				INT(11);
	DECLARE	Var_Cargos				DECIMAL(14,2);
	DECLARE	Var_Abonos				DECIMAL(14,2);
	DECLARE Var_CtaConGasto			VARCHAR(20);
	DECLARE Var_CenCosto			VARCHAR(20);
	DECLARE Var_ReqEmpleado			CHAR(1);
	DECLARE Var_InstrumentoID		INT(11);
	DECLARE	Var_CentroCostosID		INT(11);
	DECLARE Var_NomenclaturaSO		INT(11);
	DECLARE Var_NomenclaturaSE		INT(11);
	DECLARE Var_Instrumento			VARCHAR(30);
	DECLARE Var_Referencia			VARCHAR(200);
	DECLARE Var_EmpleadoID			VARCHAR(50);
	DECLARE Var_CtaCargo			BIGINT(12);
	DECLARE Var_CtaContable 		VARCHAR(25);
	DECLARE Var_AltaMovAho			CHAR(1);
	DECLARE Var_ClaveDispMov		INT(11);
	DECLARE Var_DispID				INT(11);
	DECLARE Var_TipoMovimiento		INT(11);
	DECLARE Var_FecIniMes			DATE;
	DECLARE Var_EstPeriodo			CHAR(1);
	DECLARE Var_NumReqGasID			INT(11);
	DECLARE Var_CantNumReq			INT(11);
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_FolioUUID			VARCHAR(100);
	DECLARE Var_EmpleadoRec			INT(11);
	DECLARE Var_MontoMovDis			DECIMAL(12,2);
	DECLARE Var_DescripMov			VARCHAR(150);

	-- Asignacion de constantes --
	SET Entero_Cero					:= 0;				-- Numero cero --
	SET Cadena_Vacia				:= '';				-- Cadena Vacia --
	SET FechaVacia					:= '1900-01-01';	-- Fecha Vacia --
	SET Decimal_Cero				:= 0.00;			-- Decimal cero --
	SET Salida_No					:= 'N';				-- Constate con valor N --
	SET Salida_SI					:= 'S';				-- Contante con valor S --
	SET CanGastosAnticipos			:= 1;				-- Tipo cancelacion de gastos y anticipos --
	SET CanDisperSinReq				:= 2;				-- Tipo cancelacion de dispersiones sin requisiciones --
	SET	CanDisperConReq				:= 3;	    		-- Tipo cancelacion de dispersiones con requisiciones --
	SET Cancelado					:= 'C';				-- Estatus cancelado del cheque --
	SET Entero_Uno					:= 1;				-- Numero entero con valor uno --
	SET AltaPoliza_SI				:= 'S';				-- Si se de alta poliza --
	SET AltaPoliza_NO				:= 'N';				-- No se da de alta poliza --
	SET	Nat_Abono					:= 'A';				-- Naturaleza Contable: Abono --
	SET Nat_Cargo					:= 'C';				-- Naturaleza Contable Cargo --
	SET	Mov_AhorroNO				:= 'N';				-- Movimiento en Cuenta de Ahorro: NO --
	SET	Mov_AhorroSI				:= 'S';				-- Movimiento en Cuenta de Ahorro: NO --
	SET DesMovimientoAbono			:= 'CANCELACION DE CHEQUE'; -- Descripcion del movimiento --
	SET ConContaCancelaCheque		:= 807; 			-- concepto contable de cancelacion de cheques corresponde con CONCEPTOSCONTA --
	SET Conciliado_NO   			:= 'N';				-- Movimiento Sin Conciliar --
	SET Conciliado_SI				:= 'C';				-- Movimiento Conciliado --
	SET Tip_RegAutomatico 			:= 'A';				-- Tipo de Registro: Automatico --
	SET	Tip_ChequeCaja				:= '32';			-- Tipo de Movimiento de Tesoreria: Emision de Cheque en Caja --
	SET FormaPagoCheque				:= 'C';				-- Forma de pago cheque --
	SET NaturalezaEntra				:= 'E';				-- Naturaleza entrada --
	SET Procedimiento				:='CANCELACIONCHEQUESPRO';
	SET	For_SucOrigen				:= '&SO';			-- Centro de Costo Sucursal de Origen --
	SET For_SucEmp					:= '&SE';			-- Centro de Costo Sucursal del Empleado --
	SET Si_Requiere					:= 'S';				-- Si requiere empleado --
	SET EstatusNoAplicado			:= 'N';				-- Estatus no aplicado en dispersiones --
	SET TipoActEstatus				:= 1;				-- Tipo actualizacion 1 estatus --
	SET Tip_MovAhoCHEQ      		:= '15';   			-- Tipo de Movimiento de Ahorro: Entrega de Cheque
	SET TipoInstrumentoID			:= 19; 				-- TIPO DE INSTRUMENTO CUENTA BANCARIA --
	SET Est_Abierto					:= 'N';				-- Estatus de periodo contable abierto --
	SET EstatusCancela  			:= 'C';          	-- Estatus (Cancelada) de la tabla ANTICIPOFACTURA Y FACTURAPROV
	SET Var_CentroCostosID			:=0;				-- ID Centro de Costo



	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CANCELACIONCHEQUESPRO');
			SET VarControl = 'sqlException' ;
		END;

	/*-- VALIDACION DE CAMPOS OBLIGATORIOS */
		IF(IFNULL(Par_InstitucionID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=01;
			SET Par_ErrMen	:='El Numero de la Institucion esta Vacio';
			SET Varcontrol	:='institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCtaInstit,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:=02;
			SET Par_ErrMen	:='El Numero de Cuenta Bancaria esta Vacio';
			SET Varcontrol	:='numCtaInstit';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCheque,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=03;
			SET Par_ErrMen	:='El Numero de Cheque Esta Vacio';
			SET Varcontrol	:='numCheque';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_SucursalEmision,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=04;
			SET Par_ErrMen	:='El Numero de Sucursal Esta Vacio';
			SET Varcontrol	:='sucursalEmision';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto,Decimal_Cero)=Decimal_Cero)THEN
			SET Par_NumErr	:=05;
			SET Par_ErrMen	:='El Monto Esta Vacio';
			SET Varcontrol	:='monto';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_MotivoCancela,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=06;
			SET Par_ErrMen	:='El Motivo de Cancelacion Esta Vacio';
			SET Varcontrol	:='motivoCancela';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoCancelacion,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:=07;
			SET Par_ErrMen	:='El Tipo de Cancelacion Esta Vacio';
			SET Varcontrol	:='tipoCancelacion';
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumReqGasID := IFNULL(Par_NumReqGasID, Entero_Cero);
		SET Par_ProveedorID := IFNULL(Par_ProveedorID, Entero_Cero);
		SET Par_NumFactura 	:= IFNULL(Par_NumFactura, Cadena_Vacia);
		SET Par_Comentario 	:= IFNULL(Par_Comentario, Cadena_Vacia);
		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		SELECT   MonedaBaseID,   EmpresaID,		FechaSistema
			INTO Var_MonedaBase, Var_EmpresaID, Var_FechaSistema
		FROM PARAMETROSSIS;

		SET Var_MonedaBase :=IFNULL(Var_MonedaBase,Entero_Uno);

		-- Registro Movimiento Operativo de Tesoreria
		SET	Var_RefTeso := CONCAT('NO.CHEQUE: ', CONVERT(Par_NumCheque, CHAR));

		SET Var_CuentaAhoTeso := ( SELECT CuentaAhoID FROM CUENTASAHOTESO
									WHERE InstitucionID = Par_InstitucionID
									  AND NumCtaInstit  = Par_NumCtaInstit);

		-- ********************* TIPO CANCELACION DE GASTOS Y ANTICIPOS ***************************************+
		IF(Par_TipoCancelacion = CanGastosAnticipos)THEN

			SET Var_FechaCancela :=IFNULL((SELECT FechaSistema FROM PARAMETROSSIS),FechaVacia);

			SELECT 	  	ClienteID, 		NumTransaccion,		Estatus, 		CajaID,		Referencia
				INTO  	Var_ClienteID, 	Var_NumTransaccion,	Var_Estatus,	Var_CajaID, Var_EmpleadoID
				FROM	CHEQUESEMITIDOS
				WHERE	InstitucionID		= Par_InstitucionID
				AND 	CuentaInstitucion	= Par_NumCtaInstit
                AND 	TipoChequera		= Par_TipoChequera
				AND		NumeroCheque		= Par_NumCheque;

			SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);


		   -- Actualiza Estatus de cheque a C (Cancelado) --
			UPDATE 	CHEQUESEMITIDOS	SET
					Estatus 			= Cancelado,

					EmpresaID   		= Par_EmpresaID,
                    Usuario     		= Aud_Usuario,
                    FechaActual     	= Aud_FechaActual,
                    DireccionIP     	= Aud_DireccionIP,
                    ProgramaID      	= Aud_ProgramaID,
                    Sucursal        	= Aud_Sucursal,
                    NumTransaccion  	= Aud_NumTransaccion

			WHERE 	InstitucionID 		= Par_InstitucionID
			AND 	CuentaInstitucion	= Par_NumCtaInstit
            AND		TipoChequera		= Par_TipoChequera
			AND 	NumeroCheque		= Par_NumCheque;

			-- Se registra el cheque cancelado en la tabla de cheques cancelados
			CALL CANCELACHEQUESALT(
				Par_InstitucionID,	Par_NumCtaInstit,		Par_NumCheque,			Aud_Sucursal,		Var_FechaCancela,
				Aud_Usuario,		Par_NumReqGasID,		Par_ProveedorID,		Par_NumFactura,		Par_Monto,
				Par_MotivoCancela,	Par_Comentario, 		Par_TipoCancelacion,	Salida_No,			Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SELECT 		TipoOperacion, 	EmpleadoID
			  INTO 		Var_TipoOpe,		Var_EmpleadoRec
				FROM	MOVSANTGASTOS
				WHERE	CajaID 			= Var_CajaID
			  	AND 	MontoOpe		= Par_Monto
			  	AND 	NumTransaccion	= Var_NumTransaccion;

			SET Var_TipoOpe := IFNULL(Var_TipoOpe,Entero_Cero);
			SET Var_EmpleadoRec := IFNULL(Var_EmpleadoRec,Entero_Cero);

			IF(IFNULL(Var_TipoOpe,Entero_Cero)=Entero_Cero)THEN
				SET Par_NumErr	:=08;
				SET Par_ErrMen	:='Cheque a cancelar no corresponde al tipo de Cancelacion.';
				SET Varcontrol	:='tipoCancelacion';
				LEAVE ManejoErrores;
			END IF;


			/*Se inserta un registro en la tabla de movimientos*/
			INSERT INTO MOVSANTGASTOS(
				SucursalID,     		CajaID,        		Fecha,        		MontoOpe,       FormaPago,
				TipoOperacion,     		Naturaleza,       	EmpleadoID,			EmpresaID,   	Usuario,
				FechaActual,    		DireccionIP,        ProgramaID,         Sucursal,       NumTransaccion)
			VALUES(
				Par_SucursalEmision,	Var_CajaID,			Var_FechaCancela,	Par_Monto,		FormaPagoCheque,
				Var_TipoOpe,			NaturalezaEntra,	Var_EmpleadoRec,	Par_EmpresaID,  Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,  	Aud_ProgramaID,     Aud_Sucursal,  	Aud_NumTransaccion);


			SELECT 		CentroCosto,CtaContable,ReqNoEmp,Instrumento
			  INTO 		Var_CenCosto, Var_CtaConGasto,Var_ReqEmpleado,Var_InstrumentoID
				FROM	TIPOSANTGASTOS
				WHERE 	TipoAntGastoID	= Var_TipoOpe;

			SET Var_CtaConGasto := ifnull(Var_CtaConGasto, Cadena_Vacia);
			SET Var_CenCosto := ifnull(Var_CenCosto, Cadena_Vacia);


			IF LOCATE(For_SucOrigen, Var_CenCosto) > 0 THEN
				SET Var_NomenclaturaSO := Par_SucursalEmision;
				IF (Var_NomenclaturaSO != Entero_Cero) THEN
					SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSO);
				END IF;
			ELSE
				IF LOCATE(For_SucEmp, Var_CenCosto) > 0 THEN
					SET Var_NomenclaturaSE := ( SELECT	SucursalID
													FROM	EMPLEADOS
													WHERE 	EmpleadoID = Var_EmpleadoID);
					IF (Var_NomenclaturaSE != Entero_Cero) THEN
						SET Var_CentroCostosID := FNCENTROCOSTOS(Var_NomenclaturaSE);
					END IF;

				END IF;
			END IF;

			IF(Var_ReqEmpleado=Si_Requiere)THEN
				SET Var_Instrumento	:= Var_EmpleadoID;
				SET Var_Referencia	:= (SELECT NombreCompleto FROM EMPLEADOS WHERE EmpleadoID=Var_EmpleadoID);
			ELSE
				SET Var_Instrumento := (SELECT UsuarioID FROM CAJASVENTANILLA WHERE CajaID=Var_CajaID);
				SET Var_Referencia	:= (SELECT NombreCompleto FROM USUARIOS WHERE UsuarioID=Var_Instrumento);
			END IF;

			-- alta en poliza Contable y CARGO contable a la cuenta de bancos del cheque a cancelar
			CALL CONTATESOREPRO(
				Aud_Sucursal, 			Var_MonedaBase,	 	Par_InstitucionID,		Par_NumCtaInstit, 	Entero_Cero,
				Entero_Cero,       	 	Entero_Cero, 		Var_FechaCancela, 		Var_FechaCancela, 	Par_Monto,
				DesMovimientoAbono, 	Var_EmpleadoID,	 	Par_NumCtaInstit, 		AltaPoliza_NO, 		Par_PolizaID,
				ConContaCancelaCheque,	Entero_Cero,		Nat_Cargo,			 	Mov_AhorroNO,		Entero_Cero,
				Var_ClienteID,		 	Cadena_Vacia, 		Cadena_Vacia,			Salida_No,			Par_NumErr,
				Par_ErrMEn,				Var_Consecutivo, 	Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,  	Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			SET Var_Abonos := Par_Monto;
			SET Var_Cargos := Decimal_Cero;

			CALL DETALLEPOLIZASALT(
				Par_EmpresaID,		Par_PolizaID,			Var_FechaCancela, 		Var_CentroCostosID,		Var_CtaConGasto,
				Var_Instrumento,	Var_MonedaBase,			Var_Cargos,				Var_Abonos,				DesMovimientoAbono,
				Var_Referencia,		Procedimiento,			Var_InstrumentoID,		Cadena_Vacia,			Decimal_Cero,
				Cadena_Vacia,		Salida_NO,				Par_NumErr,				Par_ErrMen,				Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Movimiento de Abono  por la Cancelacion del cheque
			CALL TESORERIAMOVALT(
				Var_CuentaAhoTeso,	Var_FechaCancela, 	Par_Monto,       	DesMovimientoAbono, 	Var_RefTeso,
				Conciliado_SI,      Nat_Abono,			Tip_RegAutomatico,  Tip_ChequeCaja,     	Entero_Cero,
				Salida_No,          Par_NumErr,     	Par_ErrMen,         Var_Consecutivo,    	Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE TESORERIAMOVS SET
					Status			= Cancelado,

					EmpresaID   	= Par_EmpresaID,
					Usuario     	= Aud_Usuario,
					FechaActual     = Aud_FechaActual,
					DireccionIP     = Aud_DireccionIP,
					ProgramaID      = Aud_ProgramaID,
					Sucursal        = Aud_Sucursal,
					NumTransaccion  = Aud_NumTransaccion
            WHERE	NumTransaccion	= Var_NumTransaccion;

			-- Actualizamos (+) el Saldo de la Cuenta de Bancos por la cancelacion del cheque
			CALL SALDOSCUENTATESOACT(
				Par_NumCtaInstit,	Par_InstitucionID,		Par_Monto,			Nat_Abono,			Var_Consecutivo,
				Salida_No,			Par_NumErr,       		Par_ErrMen,     	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,   		Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;


		-- ********************* TIPO CANCELACION DE DISPERSION INDIVIDUAL ***************************************+

		IF(Par_TipoCancelacion = CanDisperSinReq)THEN

			SELECT  	DM.ClaveDispMov,	DM.DispersionID,	DM.FechaEnvio,		C.NumTransaccion,	C.Monto,
						C.Concepto
				INTO  	Var_ClaveDispMov,	Var_DispID,			Var_FechaCancela,	Var_NumTransaccion, Var_MontoMovDis,
						Var_DescripMov
				FROM 	CHEQUESEMITIDOS C
				INNER JOIN DISPERSIONMOV DM ON C.Referencia = DM.Referencia AND C.NumeroCheque=DM.CuentaDestino
				WHERE 	C.CajaID 			= Entero_Cero
				AND 	DM.DetReqGasID		= Entero_Cero
				AND 	C.InstitucionID 	= Par_InstitucionID
				AND 	C.CuentaInstitucion	= Par_NumCtaInstit
                AND		C.TipoChequera		= Par_TipoChequera
				AND 	C.NumeroCheque		= Par_NumCheque;

			SET Var_FechaCancela :=IFNULL(Var_FechaCancela,Var_FechaSistema);
			SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

		   -- Actualiza Estatus de cheque a C (Cancelado) --
			UPDATE 	CHEQUESEMITIDOS	SET
					Estatus 			= Cancelado,

					EmpresaID   		= Par_EmpresaID,
                    Usuario     		= Aud_Usuario,
                    FechaActual     	= Aud_FechaActual,
                    DireccionIP     	= Aud_DireccionIP,
                    ProgramaID      	= Aud_ProgramaID,
                    Sucursal        	= Aud_Sucursal,
                    NumTransaccion  	= Aud_NumTransaccion
			WHERE	InstitucionID 		= Par_InstitucionID
			AND 	CuentaInstitucion	= Par_NumCtaInstit
			AND 	NumeroCheque		= Par_NumCheque
            AND		TipoChequera		= Par_TipoChequera
			AND 	CajaID 				= Entero_Cero;

			SET Var_FechaCancela :=IFNULL((SELECT FechaSistema FROM PARAMETROSSIS),FechaVacia);
				-- Se registra el cheque cancelado en la tabla de cheques cancelados
			CALL CANCELACHEQUESALT(
				Par_InstitucionID,	Par_NumCtaInstit,		Par_NumCheque,			Aud_Sucursal,		Var_FechaCancela,
				Aud_Usuario,		Par_NumReqGasID,		Par_ProveedorID,		Par_NumFactura,		Par_Monto,
				Par_MotivoCancela,	Par_Comentario, 		Par_TipoCancelacion,	Salida_No,			Par_NumErr,
				Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
				Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			--  Se llama SP DISPERSIONCANPRO para cancelar el cheque

			CALL DISPERSIONCANPRO(
				Var_ClaveDispMov,		Var_DispID,			Par_NumCheque,		Var_FechaCancela,	Par_PolizaID,
                Salida_No,				Par_NumErr,			Par_ErrMen,			Var_Consecutivo,	Par_EmpresaID,
                Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
                Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;


			UPDATE 	TESORERIAMOVS SET
						Status			= Cancelado,

						EmpresaID   	= Par_EmpresaID,
						Usuario     	= Aud_Usuario,
						FechaActual     = Aud_FechaActual,
						DireccionIP     = Aud_DireccionIP,
						ProgramaID      = Aud_ProgramaID,
						Sucursal        = Aud_Sucursal,
						NumTransaccion  = Aud_NumTransaccion
				WHERE 	NumTransaccion	= Var_NumTransaccion
				AND 	MontoMov  	   	= Var_MontoMovDis
				AND 	DescripcionMov 	= Var_DescripMov
				LIMIT 1;

		END IF;


		-- ********************* TIPO CANCELACION DE DISPERSION CON REQUESICIONES ***************************************+

		IF(Par_TipoCancelacion = CanDisperConReq)THEN

			SELECT 		FechaFactura,		FolioUUID
				INTO 	Var_FechaCancela,	Var_FolioUUID
				FROM	FACTURAPROV
			   WHERE 	ProveedorID	= Par_ProveedorID
			     AND	NoFactura   = Par_NumFactura;

			SET Var_FecIniMes 	:= CONVERT(DATE_ADD(Var_FechaCancela, INTERVAL -1*(DAY(Var_FechaCancela))+1 DAY),DATE);
			SET Var_FolioUUID	:= IFNULL(Var_FolioUUID,Cadena_Vacia);
			SET Var_ClienteID   := IFNULL(Var_ClienteID,Entero_Cero);
			SET Var_FechaCancela:= IFNULL(Var_FechaCancela,Var_FechaSistema);


			SELECT 		Estatus
			   INTO 	Var_EstPeriodo
				FROM 	PERIODOCONTABLE
				WHERE 	Inicio = Var_FecIniMes
                ORDER BY EjercicioID DESC
                LIMIT 1;


			SET Var_EstPeriodo := IFNULL(Var_EstPeriodo,Cadena_Vacia);

			IF (Var_EstPeriodo = Est_Abierto)THEN

				SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS;

				SELECT		DM.ClaveDispMov,	DM.DispersionID,	C.NumTransaccion,	C.Monto,
							C.Concepto
					INTO  	Var_ClaveDispMov,	Var_DispID,			Var_NumTransaccion,	Var_MontoMovDis,
							Var_DescripMov
					FROM	CHEQUESEMITIDOS C
					INNER JOIN DISPERSIONMOV DM ON C.Referencia = DM.Referencia AND C.NumeroCheque = DM.CuentaDestino
					WHERE 	C.CajaID 			= Entero_Cero
					AND 	DM.DetReqGasID 		!= Entero_Cero
					AND 	C.InstitucionID 	= Par_InstitucionID
					AND 	C.CuentaInstitucion	= Par_NumCtaInstit
                    AND		C.TipoChequera		= Par_TipoChequera
					AND 	C.NumeroCheque 		= Par_NumCheque
					AND 	DM.Referencia 		= Par_NumFactura
					AND 	DM.ProveedorID 		= Par_ProveedorID;

			   -- Actualiza Estatus de cheque a C (Cancelado) --
				UPDATE CHEQUESEMITIDOS SET
						Estatus 		= Cancelado,

						EmpresaID   		= Par_EmpresaID,
						Usuario     		= Aud_Usuario,
						FechaActual     	= Aud_FechaActual,
						DireccionIP    	 	= Aud_DireccionIP,
						ProgramaID     		= Aud_ProgramaID,
						Sucursal       	 	= Aud_Sucursal,
						NumTransaccion  	= Aud_NumTransaccion

				WHERE 	InstitucionID 		= Par_InstitucionID
				AND 	CuentaInstitucion	= Par_NumCtaInstit
				AND 	NumeroCheque 		= Par_NumCheque
				AND 	TipoChequera		= Par_TipoChequera
				AND 	CajaID 				= Entero_Cero
				AND 	Referencia			= Par_NumFactura;

				SET Var_FechaCancela :=IFNULL((SELECT FechaSistema FROM PARAMETROSSIS),FechaVacia);

				-- Se registra el cheque cancelado en la tabla de cheques cancelados
				CALL CANCELACHEQUESALT(
					Par_InstitucionID,	Par_NumCtaInstit,		Par_NumCheque,			Aud_Sucursal,		Var_FechaCancela,
					Aud_Usuario,		Par_NumReqGasID,		Par_ProveedorID,		Par_NumFactura,		Par_Monto,
					Par_MotivoCancela,	Par_Comentario, 		Par_TipoCancelacion,	Salida_No,			Par_NumErr,
					Par_ErrMen,			Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;


			--  Se llama SP DISPERSIONCANPRO para cancelar el cheque

				CALL DISPERSIONCANPRO(
					Var_ClaveDispMov,		Var_DispID,			Par_NumCheque,		Var_FechaCancela,	Par_PolizaID,
					Salida_No,				Par_NumErr,			Par_ErrMen,			Var_Consecutivo,	Par_EmpresaID,
					Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
					Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

				UPDATE 	TESORERIAMOVS SET
						Status			= Cancelado,

                        EmpresaID   	= Par_EmpresaID,
						Usuario     	= Aud_Usuario,
						FechaActual     = Aud_FechaActual,
						DireccionIP     = Aud_DireccionIP,
						ProgramaID      = Aud_ProgramaID,
						Sucursal        = Aud_Sucursal,
						NumTransaccion  = Aud_NumTransaccion
				WHERE 	NumTransaccion 	= Var_NumTransaccion
				AND 	MontoMov  	   	= Var_MontoMovDis
				AND 	DescripcionMov 	= Var_DescripMov;

					-- alta en poliza Contable y CARGO contable a la cuenta de bancos del cheque a cancelar
				CALL CONTATESOREPRO(
					Aud_Sucursal, 			Var_MonedaBase,	 	Par_InstitucionID,		Par_NumCtaInstit, 	Entero_Cero,
					Entero_Cero,       	 	Entero_Cero, 		Var_FechaCancela, 		Var_FechaCancela, 	Par_Monto,
					DesMovimientoAbono, 	Par_NumCheque,	 	Par_NumCtaInstit, 		AltaPoliza_NO, 		Par_PolizaID,
					ConContaCancelaCheque,	Entero_Cero,		Nat_Cargo,			 	Mov_AhorroNO,		Entero_Cero,
					Var_ClienteID,		 	Cadena_Vacia, 		Cadena_Vacia,			Salida_No,			Par_NumErr,
					Par_ErrMEn,				Var_Consecutivo, 	Par_EmpresaID,			Aud_Usuario,		Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,  	Aud_Sucursal,			Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			-- Se actualiza factura a cancelada

				UPDATE 	FACTURAPROV SET
						Estatus          = EstatusCancela,
						MotivoCancela 	 = DesMovimientoAbono,
						FechaCancelacion = Var_FechaSistema,

						EmpresaID        = Par_EmpresaID,
						Usuario          = Aud_Usuario,
						FechaActual      = Aud_FechaActual,
						DireccionIP      = Aud_DireccionIP,
						ProgramaID       = Aud_ProgramaID,
						Sucursal         = Aud_Sucursal,
						NumTransaccion   = Aud_NumTransaccion

				WHERE 	NoFactura     = Par_NumFactura
				  AND 	ProveedorID   = Par_ProveedorID;

				SET Par_NumErr = Entero_Cero;

				-- Cancelacion de la Factura y su Detalle (Parte Contable)
				CALL FACTURACONTACAN(
					Par_ProveedorID,    Par_NumFactura,  	Var_FolioUUID,		Salida_No,          Par_NumErr,
                    Par_ErrMen,			Par_PolizaID,	  	Par_EmpresaID,   	Aud_Usuario,       	Aud_FechaActual,
                    Aud_DireccionIP,    Aud_ProgramaID,		Aud_Sucursal,       Aud_NumTransaccion);

				IF(Par_NumErr <> Entero_Cero)THEN
					LEAVE ManejoErrores;
				END IF;

			-- Se eliminan los registros de REQGASTOSUCURMOV y REQGASTOSUCUR
				SELECT 	NumReqGasID
					INTO 	Var_NumReqGasID
					FROM 	REQGASTOSUCURMOV
					WHERE	NoFactura 	= Par_NumFactura
					AND 	ProveedorID	= Par_ProveedorID
				LIMIT 1;

				DELETE FROM REQGASTOSUCURMOV WHERE	NoFactura     = Par_NumFactura
												AND ProveedorID   = Par_ProveedorID;
				SELECT 	COUNT(NumReqGasID)
					INTO 	Var_CantNumReq
					FROM 	REQGASTOSUCURMOV
					WHERE	NumReqGasID = Var_NumReqGasID;

				IF(Var_CantNumReq = Entero_Cero)THEN
					DELETE FROM REQGASTOSUCUR  WHERE NumReqGasID     = Var_NumReqGasID;
				END IF;

			ELSE

				SET Par_NumErr := 8;
				SET Par_ErrMen :='El periodo contable esta cerrado, el cheque no puede cancelarse.';
				SET VarControl := 'tipoCancelacion';
				LEAVE ManejoErrores;

			END IF;
		END IF;

		SET Par_NumErr  := 000;
		SET Par_ErrMen  := CONCAT('Cheque  Cancelado Exitosamente: ', CONVERT(Par_NumCheque,CHAR));
		SET VarControl	:= 'tipoCancelacion';

	END ManejoErrores; #fin del manejador de errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr		AS NumErr,
				Par_ErrMen	 	AS ErrMen,
				VarControl	 	AS control,
				Par_PolizaID	AS consecutivo;
	END IF;

END  TerminaStore$$