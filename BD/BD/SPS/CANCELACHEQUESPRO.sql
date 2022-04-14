-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CANCELACHEQUESPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CANCELACHEQUESPRO`;DELIMITER $$

CREATE PROCEDURE `CANCELACHEQUESPRO`(
# ==================================================================================
# ----------------- SP PARA REALIZAR EL REEMPLAZO DE CHEQUES------------------------
# ==================================================================================
	Par_InstitucionIDCan	INT(11),		-- Institucion del cheuqe a cancelar --
	Par_NumCtaInstitCan		VARCHAR(20),	-- Cta de la Institucion del cheuqe a cancelar --
	Par_NumChequeCan		VARCHAR(20),	-- Numero de cheque a cancelar --
	Par_InstitucionID		INT(11),		-- InStitucion del nuevo cheque --
	Par_NumCtaInstit		VARCHAR(20),	-- Cta del nuevo cheque --

	Par_NumCheque			VARCHAR(20),	-- Nuevo numero de cheque --
	Par_Beneficiario		VARCHAR(200),	-- Nombre del Beneficiario --
	Par_UsuarioAutoriza		VARCHAR(45),	-- Clave del usuario que autoriza --
	Par_Password			VARCHAR(45),	-- Password del Usuario que autoriza --
	Par_MotivoCancela		VARCHAR(200),	-- Motivo de cancelacion --

	Par_TipoTransaccion		INT(11),		-- Tipo de transaccion --
    Par_SucursalID			INT(11),		-- Numero de la sucursal que usa el cheque
	Par_CajaID				INT(11),		-- Numero de la caja que usa el cheque
    Par_TipoChequeraCan		CHAR(2),		-- Tipo de cheque que se cancela
    Par_TipoChequera		CHAR(2),		-- Tipo de nuevo cheque P-proforma E-Estandar

	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);
	DECLARE Cancelado 				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE FechaVacia				DATE;
	DECLARE Salida_No				CHAR(1);
	DECLARE Salida_SI				CHAR(1);
	DECLARE Tra_CancelaCheque		INT(11);
	DECLARE Entero_Uno				INT(11);
	DECLARE AltaPoliza_SI			CHAR(1);
	DECLARE AltaPoliza_NO			CHAR(1);
	DECLARE Nat_Abono				CHAR(1);
	DECLARE Nat_Cargo				CHAR(1);
	DECLARE Mov_AhorroNO			CHAR(1);
	DECLARE DesMovimientoAbono		VARCHAR(45);
	DECLARE CuentaBancaria			INT(11);
	DECLARE ConContaCancelaCheque	INT(11);
	DECLARE ConCajaCancelaCheque	INT(11);
	DECLARE Conciliado_NO			CHAR(1);
	DECLARE Conciliado_SI			CHAR(1);
	DECLARE Tip_RegPantalla			CHAR(1);
	DECLARE Tip_ChequeCaja			CHAR(4);
	DECLARE EnVentanilla			CHAR(1);
	DECLARE Est_Emitido				CHAR(1);
	DECLARE Esta_Activo				CHAR(1);
	DECLARE ChequeraSi				CHAR(1);
    DECLARE Est_Reempla				CHAR(1);

	-- Declaracion de variables
	DECLARE VarControl 				VARCHAR(15);
	DECLARE Var_Monto  				DECIMAL(14,2);
	DECLARE Var_SucursalID			INT(11);
	DECLARE Var_CajaID 				INT(11);
	DECLARE Var_UsuarioID			INT(11);
	DECLARE Var_Concepto			VARCHAR(200);
	DECLARE Var_ClienteID			INT(11);
	DECLARE Var_Beneficiario		VARCHAR(200);
	DECLARE Var_Referencia			VARCHAR(50);
	DECLARE Var_FechaEmision		DATE;
	DECLARE Var_ChequeCanID			INT(11);
	DECLARE Var_NumTransaccion		BIGINT(20);
	DECLARE Var_FechaCancela		DATE;
	DECLARE Var_MonedaBase			INT(11);
	DECLARE Var_PolizaID			BIGINT(20);
	DECLARE Var_Consecutivo			BIGINT(12);
	DECLARE Var_EmpresaID			INT(11);
	DECLARE Var_SucursalCte			INT(11);
	DECLARE Var_RefTeso				VARCHAR(50);
	DECLARE Var_CuentaAhoTeso		BIGINT(12);
	DECLARE Var_EmitidoEn			CHAR(1);
	DECLARE Var_Estatus				CHAR(1);
	DECLARE Var_CajaLog				INT(11); 		-- Caja del usuario logueado --
	DECLARE Var_Cta					VARCHAR(20); 	-- Se usa para validar si la cuenta no esta asociada a caja y sucursal (cheques emitidos en ventanilla) --
    DECLARE VarTipoChequera			CHAR(2);

	-- Asignacion de constantes
	SET Cancelado					:= 'C';			-- Estatus cancelado del cheque --
	SET Entero_Cero					:= 0;			-- Numero cero --
	SET Cadena_Vacia				:= '';			-- Cadena Vacia --
    SET FechaVacia					:= '1900-01-01';-- Fecha Vacia --
	SET Salida_No					:= 'N';			-- Constate con valor N --
	SET Tra_CancelaCheque 			:= 1;			-- Numero de transaccion en la pantalla de cancelacion de cheques --
	SET Salida_SI					:= 'S';			-- Contante con valor S --
	SET Entero_Uno					:= 1;			-- Numero entero con valor uno --
	SET AltaPoliza_SI				:= 'S';			-- Si se de alta poliza --
	SET AltaPoliza_NO				:= 'N';			-- No se da de alta poliza --
	SET	Nat_Abono					:= 'A';			-- Naturaleza Contable: Abono --
	SET Nat_Cargo					:= 'C';			-- Naturaleza Contable Cargo --
	SET	Mov_AhorroNO				:= 'N';			-- Movimiento en Cuenta de Ahorro: NO --
	SET DesMovimientoAbono			:= 'CANCELACION POR REIMPRESION'; -- Descripcion del movimiento --
	SET CuentaBancaria				:= 19; 			-- Tipo de instrumento Cuenta Bancaria --
	SET ConContaCancelaCheque		:= 807; 		-- concepto contable de cancelacion de cheques corresponde con CONCEPTOSCONTA --
	SET ConCajaCancelaCheque		:= 9;			-- Concepto de cancelacion de cheques internos corresponde con CONCEPTOSCAJA --
	SET Conciliado_NO   			:= 'N';			-- Movimiento Sin Conciliar --
	SET Conciliado_SI				:= 'C';			-- Movimiento Conciliado --
	SET Tip_RegPantalla 			:= 'P';			-- Tipo de Registro: Por pantalla --
	SET	Tip_ChequeCaja				:= '32';		-- Tipo de Movimiento de Tesoreria: Emision de Cheque en Caja --
	SET EnVentanilla				:= 'V';			-- Cheque Emitido en Ventanilla --
	SET Est_Emitido					:= 'E';			-- Cheque con Estatus Emitido --
	SET Esta_Activo					:= 'A';    		-- Estatus Activo --
	SET ChequeraSi					:= 'S';
    SET Est_Reempla					:= 'R';
	SET Aud_FechaActual				:= NOW();

	ManejoErrores:BEGIN 	#bloque para manejar los posibles errores

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = '999';
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CANCELACHEQUESPRO');
			SET VarControl = 'SQLEXCEPTION';
		END;


		SET Var_FechaCancela := IFNULL((SELECT FechaSistema FROM PARAMETROSSIS),FechaVacia);


		SELECT		Monto, 			SucursalID,	 		CajaID, 		UsuarioID, 			Concepto,
					ClienteID, 		Beneficiario, 		Referencia, 	FechaEmision,		NumTransaccion,
					EmitidoEn,		Estatus
			INTO 	Var_Monto, 		Var_SucursalID,		Var_CajaID,		Var_UsuarioID, 		Var_Concepto,
					Var_ClienteID, 	Var_Beneficiario, 	Var_Referencia,	Var_FechaEmision, 	Var_NumTransaccion,
					Var_EmitidoEn,	Var_Estatus
			FROM 	CHEQUESEMITIDOS
			WHERE 	InstitucionID 		= Par_InstitucionIDCan
			AND		CuentaInstitucion 	= Par_NumCtaInstitCan
			AND		NumeroCheque 		= Par_NumChequeCan
            AND		TipoChequera		= Par_TipoChequeraCan;

		SET Var_ClienteID := IFNULL(Var_ClienteID,Entero_Cero);

        SELECT 		E.CajaID INTO Var_CajaLog
			FROM 	CHEQUESEMITIDOS E
			WHERE	E.NumeroCheque  		= Par_NumChequeCan
			AND 	E.InstitucionID 		= Par_InstitucionIDCan
			AND 	E.CuentaInstitucion 	= Par_NumCtaInstitCan
			AND		E.TipoChequera			= Par_TipoChequeraCan;

		SET Var_CajaLog := IFNULL(Var_CajaLog,Entero_Cero);

		SELECT 		CC.NumCtaInstit	INTO Var_Cta
			FROM	CAJASCHEQUERA CC
					INNER JOIN INSTITUCIONES IT ON CC.InstitucionID = IT.InstitucionID
					INNER JOIN CUENTASAHOTESO CA ON IT.InstitucionID = CA.InstitucionID
					AND CC.NumCtaInstit =CA.NumCtaInstit
			WHERE   CC.CajaID	 	 	= Var_CajaLog
			AND 	CC.SucursalID 	 	= Aud_Sucursal
			AND 	CC.Estatus		 	= Esta_Activo
			AND 	CA.Chequera 		= ChequeraSi
			AND 	CA.Estatus			= Esta_Activo
			AND 	IT.InstitucionID	= Par_InstitucionID
			AND 	CC.NumCtaInstit 	= Par_NumCtaInstit
            AND		CC.TipoChequera		= Par_TipoChequera
            GROUP BY CC.NumCtaInstit;

		SET Var_Cta := IFNULL(Var_Cta, Cadena_Vacia);

		IF(IFNULL(Par_InstitucionIDCan, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr   := 01;
			SET Par_ErrMen   := 'El Numero de Institucion Esta Vacio';
			SET VarControl   := 'institucionIDCan';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCtaInstitCan, Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr		:= 02;
			SET Par_ErrMen		:= 'El Numero de Cuenta Esta Vacia';
			SET VarControl		:= 'numCtaBancariaCan';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumChequeCan,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:= 03;
			SET	Par_ErrMen	:= 'El Numero de Cheque Esta Vacio';
			SET VarControl	:= 'numChequeCan';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InstitucionID,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 04;
			SET Par_ErrMen	:= 'El Numero de Institucion Esta Vacio';
			SET VarControl	:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCtaInstit,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 05;
			SET Par_ErrMen	:= 'El Numero de Cuenta Esta Vacia';
			SET VarControl	:= 'numCtaBancaria';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EmitidoEn = EnVentanilla)THEN
			IF(Var_Cta = Cadena_Vacia)THEN
				SET Par_NumErr  := 13;
				SET Par_ErrMen	:= 'El Numero de Cuenta no se Encuentra Asignada a Esta Sucursal';
				SET VarControl	:= 'numCtaBancaria';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_NumCheque,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr	:= 06;
			SET Par_ErrMen	:= 'El Numero de Cheque Esta Vacio';
			SET Varcontrol	:= 'numCheque';
			LEAVE ManejoErrores;
		END IF;
		IF(IFNULL(Par_Beneficiario,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 07;
			SET Par_ErrMen	:= 'El Nombre del Beneficiario Esta Vacio';
			SET VarControl	:= 'beneficiario';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_EmitidoEn = EnVentanilla) THEN
			IF(IFNULL(Par_UsuarioAutoriza,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr	:= 009;
				SET Par_ErrMen	:= 'El Usuario Esta Vacio';
				SET VarControl 	:= 'usuarioAutoriza';
				LEAVE ManejoErrores;
			END IF;
			IF(IFNULL(Par_Password,Cadena_Vacia)=Cadena_Vacia)THEN
				SET Par_NumErr 	:= 10;
				SET Par_ErrMen	:= 'La Contrasena Esta Vacia';
				SET VarControl	:= 'passwdAutoriza';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(IFNULL(Par_MotivoCancela,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr	:= 11;
			SET Par_ErrMen	:= 'El Motivo de Cancelacion Esta Vacio';
			SET VarControl	:= 'motivoCancela';
			LEAVE ManejoErrores;
		END IF;

		IF(Var_Estatus != Est_Emitido)THEN
			SET Par_NumErr	:= 12;
			SET Par_ErrMen	:= 'El Cheque ya Fue Pagado o Cancelado';
			SET VarControl	:= 'numChequeCan';
			LEAVE ManejoErrores;
		END IF;

		IF(Par_TipoTransaccion = Tra_CancelaCheque)THEN

			UPDATE CHEQUESEMITIDOS
				SET 	Estatus 			= Est_Reempla,
						EmpresaID   		= Par_EmpresaID,
						Usuario     		= Aud_Usuario,
						FechaActual     	= Aud_FechaActual,
						DireccionIP     	= Aud_DireccionIP,
						ProgramaID      	= Aud_ProgramaID,
						Sucursal        	= Aud_Sucursal
				WHERE 	InstitucionID 		= Par_InstitucionIDCan
				AND 	CuentaInstitucion	= Par_NumCtaInstitCan
				AND 	NumeroCheque 		= Par_NumChequeCan
                AND 	TipoChequera		= Par_TipoChequeraCan;

			-- Se registra el nuevo cheque
			CALL CHEQUESEMITIDOSALT(
				Par_InstitucionID,		Par_NumCtaInstit,	Par_NumCheque,		Var_Monto, 			Var_SucursalID,
				Var_CajaID,				Var_UsuarioID,		Var_Concepto, 		Var_ClienteID, 		Par_Beneficiario,
				Var_Referencia, 		Var_EmitidoEn,		Par_TipoChequera,	Salida_No,			Par_NumErr,
                Par_ErrMen,				Par_EmpresaID,		Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,
                Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			CALL FOLIOSAPLICAACT('CHEQUESCANCELADOS', Var_ChequeCanID);

			CALL CHEQUESCANCELADOSALT(
				Var_ChequeCanID,	Var_NumTransaccion,		Var_CajaID,		 	Var_SucursalID,	Var_FechaCancela,
				Par_MotivoCancela,	Par_NumChequeCan,		Par_UsuarioAutoriza,Par_Password,	Var_EmitidoEn,
				Salida_No,			Par_NumErr,				Par_ErrMen,			Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,	Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SELECT MonedaBaseID, EmpresaID	INTO Var_MonedaBase, Var_EmpresaID
				FROM PARAMETROSSIS;

			SET Var_MonedaBase := IFNULL(Var_MonedaBase,Entero_Uno);

			-- alta en poliza Contable y CARGO contable a la cuenta de bancos del cheque a cancelar
			CALL CONTATESOREPRO(
				Aud_Sucursal,     		Var_MonedaBase,   	Par_InstitucionIDCan,  	Par_NumCtaInstitCan,	Entero_Cero,
				Entero_Cero,    		Entero_Cero,        Var_FechaCancela,		Var_FechaCancela,       Var_Monto,
				Var_Concepto,       	Par_NumChequeCan,	Par_NumCtaInstitCan, 	AltaPoliza_SI,     		Var_PolizaID,
				ConContaCancelaCheque,	Entero_Cero,        Nat_Cargo,          	Mov_AhorroNO,     		Entero_Cero,
				Var_ClienteID,      	Cadena_Vacia,       Cadena_Vacia,          	Salida_No,				Par_NumErr,
				Par_ErrMEn, 			Var_Consecutivo,    Par_EmpresaID,      	Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_SucursalCte := (SELECT IFNULL(SucursalOrigen,Entero_Cero) FROM CLIENTES WHERE ClienteID = Var_ClienteID);

			-- ABONO a la cuenta puente Por la Cancelacion del cheque
			CALL POLIZACAJAPRO(
				Var_EmpresaID, 			Var_PolizaID,		Var_FechaCancela, 	ConCajaCancelaCheque, 		Par_NumCtaInstitCan,
				Var_MonedaBase,	 		Entero_Cero,		Var_Monto, 			DesMovimientoAbono,			Var_NumTransaccion,
				Var_SucursalCte,		Entero_Cero,		CuentaBancaria,		Salida_No,					Par_NumErr,
				Par_ErrMen,				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,			Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

			-- Alta en poliza Contable y ABONO contable a la Cuenta del nuevo cheque
			CALL CONTATESOREPRO(
				Aud_Sucursal,     		Var_MonedaBase,   	Par_InstitucionID,  	Par_NumCtaInstit,		Entero_Cero,
				Entero_Cero,    		Entero_Cero,        Var_FechaCancela,		Var_FechaCancela,       Var_Monto,
				Var_Concepto,       	Par_NumCheque,		Par_NumCtaInstit, 		AltaPoliza_SI,     		Var_PolizaID,
				ConContaCancelaCheque,	Entero_Cero,        Nat_Abono,          	Mov_AhorroNO,     		Entero_Cero,
				Var_ClienteID,      	Cadena_Vacia,       Cadena_Vacia,          	Salida_No,				Par_NumErr,
				Par_ErrMEn, 			Var_Consecutivo,    Par_EmpresaID,      	Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		-- CARGO a la cuenta Puente por la emision del nuevo cheque
			CALL POLIZACAJAPRO(
				Var_EmpresaID, 			Var_PolizaID,		Var_FechaCancela, 	ConCajaCancelaCheque, 		Par_NumCtaInstit,
				Var_MonedaBase,	 		Var_Monto,			Entero_Cero,		DesMovimientoAbono,		Var_NumTransaccion,
				Var_SucursalCte,		Entero_Cero,		CuentaBancaria,		Salida_No,			Par_NumErr,
				Par_ErrMen,				Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
				Aud_Sucursal,			Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				LEAVE ManejoErrores;
			END IF;

		-- Registro Movimiento Operativo de Tesoreria
			SET	Var_RefTeso := CONCAT('NO.CHEQUE: ', CONVERT(Par_NumChequeCan, CHAR));
			SET Var_CuentaAhoTeso	:=(SELECT 	CuentaAhoID FROM CUENTASAHOTESO
											WHERE	InstitucionID	= Par_InstitucionIDCan
											AND		NumCtaInstit	= Par_NumCtaInstitCan);

		-- Movimiento de Abono  por la Cancelacion del cheque
			CALL TESORERIAMOVALT(
				Var_CuentaAhoTeso,  Var_FechaCancela, 	Var_Monto,       	DesMovimientoAbono, 	Var_RefTeso,
				Conciliado_SI,      Nat_Abono,         	Tip_RegPantalla,    Tip_ChequeCaja,     	Entero_Cero,
				Salida_No,          Par_NumErr,         Par_ErrMen,         Var_Consecutivo,    	Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
				Var_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		-- Actualizamos (+) el Saldo de la Cuenta de Bancos por la cancelacion del cheque
			CALL SALDOSCUENTATESOACT(
				Par_NumCtaInstitCan,	Par_InstitucionIDCan,	Var_Monto,			Nat_Abono,			Var_Consecutivo,
				Salida_No,				Par_NumErr,       		Par_ErrMen,     	Par_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,   		Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET	Var_RefTeso := CONCAT('NO.CHEQUE: ', CONVERT(Par_NumCheque, CHAR));

			SET Var_CuentaAhoTeso	:=(SELECT 	CuentaAhoID FROM CUENTASAHOTESO
											WHERE 	InstitucionID	= Par_InstitucionID
											AND 	NumCtaInstit	= Par_NumCtaInstit);

		-- Movimiento de Cargo por el nuevo cheque
			CALL TESORERIAMOVALT(
				Var_CuentaAhoTeso,  Var_FechaCancela, 	Var_Monto,       	Var_Concepto, 			Var_RefTeso,
				Conciliado_NO,      Nat_Cargo,         	Tip_RegPantalla,    Tip_ChequeCaja,     	Entero_Cero,
				Salida_No,          Par_NumErr,         Par_ErrMen,         Var_Consecutivo,    	Par_EmpresaID,
				Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     	Aud_Sucursal,
				Aud_NumTransaccion);

			IF (Par_NumErr <> Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		-- Actualizamos  (- )el Saldo de la Cuenta de Bancos del nuevo cueque
			CALL SALDOSCUENTATESOACT(
				Par_NumCtaInstit,		Par_InstitucionID,	Var_Monto,			Nat_Cargo,		Var_Consecutivo,
				Salida_No,				Par_NumErr,       	Par_ErrMen,     	Par_EmpresaID,	Aud_Usuario,
				Aud_FechaActual,		Aud_DireccionIP,   	Aud_ProgramaID, 	Aud_Sucursal,   Aud_NumTransaccion);

			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			UPDATE TESORERIAMOVS SET
				Status				= Cancelado,
				EmpresaID   		= Par_EmpresaID,
				Usuario     		= Aud_Usuario,
				FechaActual     	= Aud_FechaActual,
				DireccionIP     	= Aud_DireccionIP,
				ProgramaID      	= Aud_ProgramaID,
				Sucursal        	= Aud_Sucursal
			WHERE NumTransaccion	= Var_NumTransaccion;

			IF(Var_EmitidoEn = EnVentanilla)THEN
				UPDATE CAJASCHEQUERA SET
							FolioUtilizar	= Par_NumCheque
					WHERE 	InstitucionID 	= Par_InstitucionID
					AND 	NumCtaInstit  	= Par_NumCtaInstit
					AND 	SucursalID		= Par_SucursalID
					AND 	CajaID			= Par_CajaID
                    AND		TipoChequera	= Par_TipoChequera
                    AND 	Par_NumCheque BETWEEN FolioCheqInicial AND FolioCheqFinal;

			END IF;

			SET Par_NumErr  := 000;
			SET Par_ErrMen  := CONCAT('Cheque Reemplazado Exitosamente: ', CONVERT(Par_NumChequeCan,CHAR));
			SET varControl	:= 'imprimirCheque';

		END IF;
	END ManejoErrores; -- fin del manejador de errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr 		AS NumErr,
				Par_ErrMen		AS ErrMen,
				varControl		AS control,
				Var_PolizaID	AS consecutivo;
	END IF;

END  TerminaStore$$