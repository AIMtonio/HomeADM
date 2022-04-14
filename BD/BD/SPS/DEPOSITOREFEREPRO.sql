
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPOSITOREFEREPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPOSITOREFEREPRO`;

DELIMITER $$
CREATE PROCEDURE `DEPOSITOREFEREPRO`(
	/* SP QUE REGISTRA EL DEPOSITO REFERENCIADO DE UNA CUENTA*/
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit		VARCHAR(20),
	Par_FechaOperacion		DATE,
	Par_ReferenciaMov		VARCHAR(150),
	Par_DescripcionMov		VARCHAR(150),

	Par_NatMovimiento		CHAR(1),
	Par_MontoMov 			DECIMAL(12,2),
	Par_MontoPendApli		DECIMAL(12,2),
	Par_TipoCanal			INT(11),
	Par_TipoDeposito		CHAR(1),

	Par_Moneda				INT(11),
	Par_InsertaTabla		CHAR(1),
	Par_NumIdenArchivo		VARCHAR(20),
	Par_BancoEstandar		CHAR(1),
	Par_Poliza      		BIGINT(20),

	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	INOUT Par_Consecutivo	BIGINT(12),

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),

	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)

TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero 		INT;
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Nat_Abono			CHAR(1);
	DECLARE TipoCanalCred		INT;		-- Corresponde con la tabla TIPOCANAL
	DECLARE TipoCanalCtaAho		INT;		-- Corresponde con la tabla TIPOCANAL
	DECLARE TipoCanalCliente	INT;		-- Corresponde con la tabla TIPOCANAL
	DECLARE EstatusAplicado		CHAR(1);	-- ESTATUS APLICADO
	DECLARE DepRefeEfec			INT;
	DECLARE TipoMovDepRef		CHAR(4); -- corresponde con la tabla TIPOSMOVTESO
	DECLARE FechaDelSistema		DATE;
	DECLARE	Con_AhoCapital		INT;
	DECLARE Str_No				CHAR(1);
	DECLARE Str_Si				CHAR(1);
	DECLARE TipoPolAutomatica	CHAR(1);
	DECLARE TipoEfectivo		CHAR(1);
	DECLARE EstatusNoIdentif	CHAR(2);
	DECLARE Naturaleza_Bloq		CHAR(1);
	DECLARE OrigenPag_Refere	CHAR(1);
	DECLARE TipoBloq			INT(11);
	DECLARE Descrip_Bloq		VARCHAR(200);
	DECLARE Descrip_FecInval	VARCHAR(200);
	DECLARE EstatusActivo		CHAR(1);	-- ESTATUS ACTIVO
	DECLARE Var_Auditoria		VARCHAR(50);
    DECLARE TipoOperacionCTA    INT(11); 		-- Tipo de operacion 1 = Abonos y cargos cuenta,2= Pago de credito


	-- Declaracion de Variables
	DECLARE	Var_Cargos     	 	DECIMAL(12,4);
	DECLARE	Var_Abonos      	DECIMAL(12,4);
	DECLARE Var_FolioOperacion	INT;
	DECLARE Var_Status			CHAR(2);
	DECLARE Par_TipoPago		CHAR(1);
	DECLARE Var_MonedaID		INT;
	DECLARE Var_CreditoID		BIGINT(12);
	DECLARE Var_ClienteID		BIGINT;
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_CuentaTeso		BIGINT(12);
	DECLARE Var_CuentaBancaria	VARCHAR(20);
	DECLARE Fecha_Valida		DATE;
	DECLARE DiaHabil			CHAR(1);
	DECLARE Var_Descripcion		VARCHAR(50);
	DECLARE Var_DescripCre		VARCHAR(50);
	DECLARE Var_DescripCue		VARCHAR(50);
	DECLARE Var_DescripCli		VARCHAR(50);
	DECLARE Var_EmitePoliza		CHAR(1);
	DECLARE Var_ConceptoCon		INT;
	DECLARE Var_NatConta		CHAR(1);
	DECLARE Var_AltaMovAho		CHAR(1);
	DECLARE Var_TipoMovAho		VARCHAR(4);
	DECLARE Var_PrimerDiaMes	DATE;
	DECLARE Var_Poliza			BIGINT(20);
	DECLARE Var_RefereBloq		BIGINT(20);
	DECLARE Var_BloqueaAuto		CHAR(1);
	DECLARE Var_Control			VARCHAR(30);
	DECLARE Var_Instrumento		VARCHAR(20);
	DECLARE Var_FecRegCuenta	DATE;
	DECLARE Var_MontoPago		DECIMAL(14,2);
	DECLARE Var_MontoAplicado	DECIMAL(12,2);
	DECLARE Var_MontoMov 		DECIMAL(12,2);
	DECLARE Var_DepRefMesAnterior	CHAR(1);
	DECLARE Var_FechaSisIni			DATE;
	DECLARE Var_Consecutivo		BIGINT(12);


	-- Asignacion de Constantes
	SET Entero_Cero			:= 0;
	SET Decimal_Cero		:= 0;
	SET EstatusAplicado		:= 'A';
	SET OrigenPag_Refere	:= 'R';
	SET Cadena_Vacia		:= '';
	SET Nat_Abono			:= 'A';
	SET TipoCanalCred		:= 1; -- Corresponde con la tabla TIPOCANAL
	SET TipoCanalCtaAho		:= 2; -- Corresponde con la tabla TIPOCANAL
	SET TipoCanalCliente	:= 3; -- Corresponde con la tabla TIPOCANAL
	SET DepRefeEfec			:= 14;
	SET TipoMovDepRef		:= '1'; -- corresponde con la tabla TIPOSMOVTESO (deposito Referenciado)
	SET	Con_AhoCapital  	:= 1;
	SET Str_No				:= 'N';
	SET Str_Si				:= 'S';
	SET Var_BloqueaAuto		:= 'N';	-- SU VALOR POR DEFAULT DEBE  SER NO (Bloqueo Automatico)
	SET TipoPolAutomatica	:= 'A';
	SET EstatusNoIdentif	:= 'NI';
	SET Descrip_FecInval	:= 'La fecha de los movimientos es menor a la fecha de apertura de la cuenta.';
	SET EstatusActivo       := 'A';

	-- Asignacion de Variables
	SET Aud_FechaActual		:= NOW();
	SET Var_Status			:= 'NI';
	SET TipoEfectivo		:= 'E';
	SET Var_CreditoID		:= 0;
	SET Var_ClienteID		:= 0;
	SET Var_CuentaAhoID		:= 0;
	SET Var_DescripCre		:= 'DEPOSITO A CREDITO';
	SET Var_DescripCue		:= 'DEPOSITO A CUENTA';
	SET Var_DescripCli		:= 'DEPOSITO A CLIENTE';
	SET Var_ConceptoCon		:= 45;	-- CONCEPTO CONTABLE
	SET Var_NatConta		:= 'C';
	SET Var_TipoMovAho		:= '101';
	SET Naturaleza_Bloq		:= 'B';
	SET TipoBloq			:= 13;
	SET Var_Poliza			:= 0;
	SET Descrip_Bloq		:= 'BLOQUEO AUT. DEPOSITO REFERENCIADO';
	SET Par_Consecutivo		:= Entero_Cero;
	SET Var_Consecutivo		:= Entero_Cero;
	SET Var_MonedaID		:= 1;
	SET Var_Auditoria		:='DepositosRefeDAO.altaDepositosRefere';
	SET TipoOperacionCTA	:= 1;
	SET Par_NumErr 			:= 999;
	SET Par_ErrMen			 := CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
										'esto le ocasiona. Ref: SP-DEPOSITOREFEREPRO');

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-DEPOSITOREFEREPRO');
			SET Var_Control:= 'SQLEXCEPTION' ;
		END;

		SET FechaDelSistema			:= (SELECT FechaSistema FROM PARAMETROSSIS);
		SET Var_FolioOperacion		:= (SELECT IFNULL(MAX(FolioCargaID),Entero_Cero)+1 FROM DEPOSITOREFERE);
		SET Par_TipoCanal 			:= (SELECT TipoCanalID FROM TIPOCANAL WHERE TipoCanalID = Par_TipoCanal);
		SET Var_DepRefMesAnterior	:= LEFT(FNPARAMGENERALES('DepRefMesAnterior'),1);
		SET Var_DepRefMesAnterior	:= IFNULL(Var_DepRefMesAnterior,Str_No);
		SET Var_FechaSisIni			:= DATE_FORMAT(FechaDelSistema, '%Y-%m-01');

		-- para obtener primer dia del mes
		SET Var_PrimerDiaMes	:= CONVERT(DATE_ADD(FechaDelSistema, INTERVAL -1*(DAY(FechaDelSistema))+1 DAY),DATE);

		SELECT	NumCtaInstit,		CuentaAhoID
		INTO	Var_CuentaBancaria,	Var_CuentaTeso
		FROM CUENTASAHOTESO
		WHERE NumCtaInstit = Par_NumCtaInstit LIMIT 1;

		IF(IFNULL(Var_CuentaBancaria,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr      := 1;
			SET Par_ErrMen      := 'No Existe el Numero de Cuenta Bancaria.';
			SET Var_Control		:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_TipoCanal,Entero_Cero) = Entero_Cero)THEN
			SET Par_NumErr      := 2;
			SET Par_ErrMen      := 'No existe el Tipo de Canal.';
			SET Var_Control		:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		IF( Par_FechaOperacion > FechaDelSistema) THEN
			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'La Fecha de Operacion no debe ser mayor a la del sistema.';
			SET Var_Control		:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

		# VALIDA SI SE PUEDEN APLICAR O NO LOS DEPÓSITOS EN MESES ANTERIORES AL MES DEL SISTEMA.
		IF(Var_DepRefMesAnterior = Str_No)THEN
			IF(Par_FechaOperacion < Var_FechaSisIni)THEN
				SET Par_NumErr		:= 4;
				SET Par_ErrMen		:= 'No se puede Aplicar Depositos en Meses Anteriores a la Fecha del Sistema.';
				SET Var_Control		:= 'institucionID';
				LEAVE ManejoErrores;
			END IF;
		END IF;

		CALL DIASFESTIVOSCAL(
			Par_FechaOperacion,		Entero_Cero,		Fecha_Valida,		DiaHabil,			Aud_EmpresaID,
			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		-- SE IDENTIFICA EL TIPO DE DEPOSITO
		IF(Par_TipoDeposito = TipoEfectivo)THEN
			SET Par_TipoPago		:= TipoEfectivo;
			SET Var_TipoMovAho		:= 14;
		ELSE
			IF (Par_TipoDeposito = 'T') THEN
				SET Par_TipoPago		:= 'T';
				SET Var_TipoMovAho		:= 16;
				ELSE IF ( Par_TipoDeposito = 'C')THEN
					SET Par_TipoPago		:= 'C';
					SET Var_TipoMovAho		:= 16;
				END IF;
			END IF;
		END IF;

		 --  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
		SET Var_BloqueaAuto	:= Str_No;


		-- *************************************** SI SE TRATA DE UN CANAL DE CREDITO **********************************
		IF(TipoCanalCred = Par_TipoCanal)THEN

			SELECT	CreditoID,		ClienteID, 		CuentaID,			MonedaID
			 INTO	Var_CreditoID,	Var_ClienteID,	Var_CuentaAhoID,	Var_MonedaID
				FROM CREDITOS
				WHERE CreditoID = Par_ReferenciaMov;

			--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
			SET Var_Descripcion	:= Var_DescripCre;
			SET Var_Instrumento	:= Var_CreditoID;
			SET Var_RefereBloq	:= Var_CuentaAhoID;
		END IF;


		-- *********************************************** SI SE TRATA DE UN CANAL DE CUENTA ***************************
		IF(TipoCanalCtaAho = Par_TipoCanal)THEN
			SELECT	C.CuentaAhoID,		C.ClienteID,		T.EsBloqueoAuto,	C.MonedaID,		FechaApertura
			 INTO	Var_CuentaAhoID,	Var_ClienteID,		Var_BloqueaAuto,	Var_MonedaID,	Var_FecRegCuenta
			FROM 	CUENTASAHO C
				INNER JOIN TIPOSCUENTAS T ON C.TipoCuentaID=T.TipoCuentaID
			WHERE	C.CuentaAhoID	= Par_ReferenciaMov;

			IF(Var_FecRegCuenta>Par_FechaOperacion)THEN
				SET Par_NumErr := 1234;
				SET Par_ErrMen := Descrip_FecInval;
				SET Var_Control		:= 'institucionID';
				LEAVE ManejoErrores;
			END IF;
			--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
			SET Var_Descripcion	:= Var_DescripCue;
			SET Var_Instrumento	:= Var_CuentaAhoID;
			SET Var_RefereBloq	:= Var_CuentaAhoID;
		END IF;


		-- ************************************************* SI SE TRATA DE UN CANAL DE CLIENTE ************************
		IF(TipoCanalCliente = Par_TipoCanal)THEN
			SELECT		C.CuentaAhoID, 		C.ClienteID,	T.EsBloqueoAuto,	C.MonedaID
				INTO	Var_CuentaAhoID,	Var_ClienteID,	Var_BloqueaAuto,	Var_MonedaID
				FROM CUENTASAHO C
					INNER JOIN TIPOSCUENTAS T ON C.TipoCuentaID=T.TipoCuentaID
				WHERE C.ClienteID	= Par_ReferenciaMov
					AND C.EsPrincipal	= Str_Si AND C.Estatus=EstatusActivo;

			--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
			SET Var_Descripcion	:= Var_DescripCli;
			SET Var_Instrumento	:= Var_CuentaAhoID;
			SET Var_RefereBloq	:= Var_ClienteID;
		END IF;

		-- SI EL NUMERO DE CUENTAS NO EXISTE, LA BANDERA DE ESTATUS QUEDA CON VALOR NO IDENTIFICADO
		IF(IFNULL(Var_CuentaAhoID, Entero_Cero) <> Entero_Cero)THEN
			SET Var_Status		:= EstatusAplicado;
		ELSE
			SET Var_Status		:= EstatusNoIdentif;
		END IF;

		--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
		SET	Var_Cargos		:= Decimal_Cero;	-- VALOR DE CARGOS
		SET	Var_Abonos		:= Par_MontoMov;	-- VALOR DE ABONOS
		SET Var_EmitePoliza	:= Str_Si;			-- VALOR NO EMITE POLIZA

		-- SI EL ESTATUS ES IDENTIFICADO  ENTONCES SI APLICAN LOS MOVIMIENTOS
		IF(Var_Status = EstatusAplicado)THEN
			IF(Par_FechaOperacion < Var_PrimerDiaMes) THEN /* si la fecha de operacion es del mes anterior se insertan movimientos de ahorro en el historico*/

				--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
				SET Var_AltaMovAho	:= Str_No;	-- VALOR NO DAR DE ALTA MOV DE AHORRO

				CALL CUENTASAHOMOVHIALT(/* inserta movimientos en la tabla del historico .- `HIS-CUENAHOMOV`*/
					Var_CuentaAhoID,	Aud_NumTransaccion,		Par_FechaOperacion,		Nat_Abono,			Par_MontoMov,
					Var_Descripcion,	Par_ReferenciaMov,		Var_TipoMovAho,			Var_BloqueaAuto,	Str_No,
					Par_NumErr,			Par_ErrMen,				Var_Consecutivo,		Aud_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,  	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
					Aud_NumTransaccion
				);
				-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;


				-- GENERA EL ENCABEZADO DE POLIZA SI Par_Poliza ES CERO
				SET Var_Poliza := IFNULL(Par_Poliza, Entero_Cero);
				IF (Var_Poliza = Entero_Cero)THEN
					CALL MAESTROPOLIZASALT(
						Var_Poliza,			Aud_EmpresaID,   		Par_FechaOperacion, 	TipoPolAutomatica,	Var_ConceptoCon,
						Var_Descripcion,	Str_No,      			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
						Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
					-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
					IF (Par_NumErr != Entero_Cero) THEN
						LEAVE ManejoErrores;
					END IF;
				END IF;
				-- GENERA EL DETALLE DE POLIZA
				CALL POLIZASAHORROPRO(
					Var_Poliza,         Aud_EmpresaID,    		Par_FechaOperacion,		Var_ClienteID,	    Con_AhoCapital,
					Var_CuentaAhoID,    Var_MonedaID,   		Var_Cargos,        		Var_Abonos,		    Var_Descripcion,
					Par_ReferenciaMov,	Str_No,      			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
					Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);
				-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

				SET Var_EmitePoliza	:= Str_No;			-- VALOR NO EMITE POLIZA

				CALL CONTATESOREPRO(
					Entero_Cero,        	Var_MonedaID,      	Par_InstitucionID,  	Var_CuentaBancaria,		Entero_Cero,
					Entero_Cero,       		Entero_Cero,       	Par_FechaOperacion,  	Par_FechaOperacion,   	Par_MontoMov,
					Var_Descripcion, 		Par_ReferenciaMov, 	Var_Instrumento, 		Var_EmitePoliza,       	Var_Poliza,
					Var_ConceptoCon,    	Entero_Cero,      	Var_NatConta,			Var_AltaMovAho,  		Var_CuentaAhoID,
					Var_ClienteID,       	Var_TipoMovAho,    	Nat_Abono,      		Str_No,					Par_NumErr,
					Par_ErrMen, 			Var_Consecutivo,    Aud_EmpresaID,     		Aud_Usuario,	        Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion	);
				-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			ELSE
				--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
				SET Var_AltaMovAho	:= Str_Si;	-- VALOR NO DAR DE ALTA MOV DE AHORRO

				/* si la fecha de operacion no es del mes anterior se insertan movimientos de ahorro en lo actual */
				CALL CONTATESOREPRO(
					Entero_Cero,        	Var_MonedaID,		Par_InstitucionID,  	Var_CuentaBancaria,		Entero_Cero,
					Entero_Cero,       		Entero_Cero,       	Par_FechaOperacion,  	Fecha_Valida,   		Par_MontoMov,
					Var_Descripcion, 		Par_ReferenciaMov, 	Var_Instrumento, 		Var_EmitePoliza,     	Var_Poliza,
					Var_ConceptoCon,    	Entero_Cero,      	Var_NatConta,			Var_AltaMovAho,  		Var_CuentaAhoID,
					Var_ClienteID,       	Var_TipoMovAho,    	Nat_Abono,      		Str_No,					Par_NumErr,
					Par_ErrMen, 			Var_Consecutivo,    Aud_EmpresaID,     		Aud_Usuario,	        Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,    	Aud_Sucursal,      		Aud_NumTransaccion);
				-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

			-- SE INSERTAN LOS MOVIMIENTOS DE TESORERIA
			CALL TESORERIAMOVALT(
				Var_CuentaTeso,		Par_FechaOperacion,	Par_MontoMov,		Par_DescripcionMov,	Par_ReferenciaMov,
				Cadena_Vacia,	  	Nat_Abono,			EstatusAplicado,	TipoMovDepRef,		Entero_Cero,
				Str_No, 			Par_NumErr,			Par_ErrMen,			Var_Consecutivo,	Aud_EmpresaID,
				Aud_Usuario, 		Aud_FechaActual, 	Aud_DireccionIP, 	Aud_ProgramaID, 	Aud_Sucursal,
				Aud_NumTransaccion);
			-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			CALL SALDOSCTATESOREACT(
				Par_NumCtaInstit,	Par_InstitucionID,	Par_MontoMov,		Nat_Abono,		 	Str_No,
				Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID, 	Aud_Sucursal, 		Aud_NumTransaccion);
			 -- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			-- Se realiza el Cobro de Comisiones de Saldo Promedio
			-- Se valida que venga de la Pantalla de Deposito Referenciado y que sea por Tipo de Cuenta
			SET Var_MontoAplicado :=  Entero_Cero;
			IF( Par_TipoCanal = TipoCanalCtaAho AND  Aud_ProgramaID = Var_Auditoria)THEN
				CALL COMSALDOPROMCOBPENDPRO(
					Var_CuentaAhoID,	Par_MontoMov,	Var_MontoAplicado,	Var_Poliza,		Str_No,
					Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,		Aud_Usuario,	Aud_FechaActual,
					Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

			END IF;

			-- SI SE TRATA DE UNA CUENTA QUE BLOQUEA DE MANERA AUTOMATICA ***********************************************************************
			IF(Var_BloqueaAuto = Str_Si)THEN
				-- Si se realizo cobro de Comision por Saldo Promedio se actualiza el Monto a Bloquear
				SET Var_MontoMov := Entero_Cero;
				SET Var_MontoAplicado := IFNULL(Var_MontoAplicado,Entero_Cero);
				SET Var_MontoMov := Par_MontoMov - Var_MontoAplicado;

				CALL BLOQUEOSPRO(
					Entero_Cero,	 	Naturaleza_Bloq,		Var_CuentaAhoID, 		Par_FechaOperacion,		Var_MontoMov,
					Aud_FechaActual,	TipoBloq,		 		Descrip_Bloq,	 		Var_RefereBloq,	   		Cadena_Vacia,
					Cadena_Vacia,		Str_No,			 		Par_NumErr,    			Par_ErrMen,				Aud_EmpresaID,
					Aud_Usuario,	 	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
					Aud_NumTransaccion);
				 -- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF; -- **********************************************************************************************************



			-- EJECUTA PROCESO DE DETECCION DE OPERACIONES INUSUALES AL MOMNETO DE LA TRANSACCION POR ABONOS O CARGOS A CUENTA
			CALL PLDOPEINUSALERTTRANSPRO(
				TipoOperacionCTA,	Var_ClienteID,		Var_CuentaAhoID,	Var_TipoMovAho,		Par_NatMovimiento,
				Entero_Cero,
				Str_No,				Par_NumErr,			Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				CALL BITAERRORPLDDETOPETRANALT(
					'PLDOPEINUSALERTTRANSPRO',	Par_NumErr,			Par_ErrMen,		TipoOperacionCTA,	Var_ClienteID,
					Entero_Cero,				Par_NatMovimiento,	Par_MontoMov,
					Str_No,						Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,		Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,		Aud_NumTransaccion);
			END IF;

			-- EJECUTA PROCESO PARA DETECCION DE OPERACIONES FRACCIONADAS
			CALL PLDOPEREELEVANTRANSPRO(
				Var_ClienteID,		Par_NatMovimiento,
				Str_No,				Par_NumErr,				Par_ErrMen,			Aud_EmpresaID,		Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

			IF(Par_NumErr <> Entero_Cero)THEN
				 CALL BITAERRORPLDDETOPETRANALT(
					'PLDOPEREELEVANTRANSPRO',	Par_NumErr,			Par_ErrMen,		Entero_Cero,	Var_ClienteID,
					Entero_Cero,				Par_NatMovimiento,	Par_MontoMov,
					Str_No,						Par_NumErr,			Par_ErrMen,		Aud_EmpresaID,	Aud_Usuario,
					Aud_FechaActual,			Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);
			END IF;


		END IF; -- **************************************************************************************************************



		-- =========================================================================================================================
		-- ************************************ SECCION PARA LOS PAGOS DE CREDITOS AUTOMATICOS *************************************

		IF(TipoCanalCred = Par_TipoCanal AND Var_Status = EstatusAplicado)THEN

				CALL DEPREFPAGAUTOMCREDPRO(
					Var_CreditoID,		Par_InstitucionID,		Par_BancoEstandar,		Par_MontoMov,		Par_Consecutivo,
					Var_MontoPago,		Var_Poliza,				OrigenPag_Refere,		Str_No,				Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion
				);
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;

		END IF;
		-- =========================================================================================================================



		-- SOLO LOS DEPÓSITOS QUE NO FUERON IDENTIFICADOS.
		IF(Var_Status = EstatusNoIdentif)THEN
			-- SE APLICAN LOS DEPOSITOS REFERENCIADOS DONDE LAS REFERENCIAS SE ENCUENTREN EN REFPAGOSXINST
			CALL DEPREFXINSTPRO(
				Par_InstitucionID,		Par_NumCtaInstit,		Par_FechaOperacion,		Par_ReferenciaMov,		Par_DescripcionMov,
				Par_NatMovimiento,		Par_MontoMov,			Par_MontoPendApli,		Par_TipoCanal,			Par_TipoDeposito,
				Var_MonedaID,			Var_Status,				OrigenPag_Refere,		Str_No,					Par_NumErr,
				Par_ErrMen,				Var_FolioOperacion,		Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
				Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,			Aud_NumTransaccion);
			 -- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF(Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		IF(Par_InsertaTabla = Str_Si)THEN
			INSERT INTO DEPOSITOREFERE (
				FolioCargaID,		CuentaAhoID,		NumeroMov,			InstitucionID,		FechaCarga,
				FechaAplica,		NatMovimiento,		MontoMov,			TipoMov,			DescripcionMov,
				ReferenciaMov,		Status,				MontoPendApli,		TipoDeposito,		TipoCanal,
				MonedaId,			NumIdenArchivo,		EmpresaID,			Usuario,			FechaActual,
				DireccionIP,		ProgramaID,			Sucursal,			NumTransaccion)
			VALUES (
				Var_FolioOperacion,	Var_CuentaBancaria,	Entero_Cero,		Par_InstitucionID,	FechaDelSistema,
				Par_FechaOperacion,	Par_NatMovimiento,	Par_MontoMov,		TipoMovDepRef,		Par_DescripcionMov,
				Par_ReferenciaMov,	Var_Status,			Par_MontoPendApli,	Par_TipoDeposito,	Par_TipoCanal,
				Var_MonedaID,		Par_NumIdenArchivo,	Aud_EmpresaID,		Aud_Usuario,		Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);
		END IF;




		-- SI TERMINA CON EXITO SE SETEAN LOS VALORES
		SET Par_NumErr      := 0;
		SET Par_ErrMen      := CONCAT('Deposito referenciado Agregado: ', CONVERT(Var_FolioOperacion, CHAR));
		SET Par_Consecutivo := Var_FolioOperacion;
		SET Var_Control		:= 'institucionID';

	END ManejoErrores;

	-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
	IF (Par_Salida = Str_Si) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control	AS Control,
				Par_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$