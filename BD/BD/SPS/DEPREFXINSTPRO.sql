-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DEPREFXINSTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DEPREFXINSTPRO`;
DELIMITER $$


CREATE PROCEDURE `DEPREFXINSTPRO`(
/* SP QUE REGISTRA UN DEPOSITO REFERENCIADO BUSCANDO LAS REFERENCIAS EN REFPAGOSXINST */
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit		VARCHAR(20),
	Par_FechaOperacion		DATE,
	INOUT Par_ReferenciaMov	VARCHAR(150),
	Par_DescripcionMov		VARCHAR(150),

	Par_NatMovimiento		CHAR(1),
	Par_MontoMov 			DECIMAL(12,2),
	Par_MontoPendApli		DECIMAL(12,2),
	Par_TipoCanal			INT(11),
	Par_TipoDeposito		CHAR(1),

	Par_Moneda				INT(11),
	INOUT Par_Estatus		CHAR(2),
	Par_OrigenPago			CHAR(1),		# Origen de Pago S: SPEI, V: Ventanilla, C: Cargo A Cta, N: Nomina, D: Domiciliado, R: Depositos Referenciados, W: WebService, O: Otros, Cadena Vacia en caso que no sea un op de pago mov operativos
	Par_Salida				CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),

	Par_Consecutivo			BIGINT(12),
    /* Parametros de Auditoria */
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
DECLARE TipoBloq			INT(11);
DECLARE TipoBloqRef			INT(11);
DECLARE Descrip_Bloq		VARCHAR(200);
DECLARE BloqueoDePagoRef	VARCHAR(200);
DECLARE BancoEstandar		CHAR(1);

-- Declaracion de Variables
DECLARE	Var_Cargos     	 	DECIMAL(12,4);
DECLARE	Var_Abonos      	DECIMAL(12,4);
DECLARE Var_FolioOperacion	BIGINT(12);
DECLARE Var_Status			CHAR(2);
DECLARE Par_TipoPago		CHAR(1);
DECLARE Var_MonedaID		INT;
DECLARE Var_CreditoID		BIGINT(12);
DECLARE Var_ReferenciaPago	VARCHAR(150);
DECLARE Var_ClienteID		BIGINT;
DECLARE Var_CuentaAhoID		BIGINT(12);
DECLARE Var_CuentaTeso		BIGINT(12);
DECLARE Var_CuentaBancaria	VARCHAR(20);
DECLARE Var_FechaValida		DATE;
DECLARE Var_DiaHabil		CHAR(1);
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
DECLARE Var_Contador		BIGINT(11);
DECLARE Var_PagoCredAutom	CHAR(1);
DECLARE Var_MontoPago		DECIMAL(14,2);
DECLARE Var_CteSantaFe		INT(11);
DECLARE Var_CliEsp			INT(11);

-- Asignacion de Constantes
SET Var_CteSantaFe		:= 29;
SET Entero_Cero			:= 0;
SET Decimal_Cero		:= 0;
SET EstatusAplicado		:= 'A';
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
SET BancoEstandar 		:= 'B';

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
SET TipoBloqRef			:= 18;
SET Var_Poliza			:= 0;
SET Descrip_Bloq		:= 'BLOQUEO AUT. DEPOSITO REFERENCIADO';
SET BloqueoDePagoRef	:= 'BLOQUEO DE PAGO POR REFERENCIA';
SET Par_Consecutivo		:= Entero_Cero;
SET Var_MonedaID		:= 1;
SET Var_CliEsp 			:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='CliProcEspecifico');

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-DEPREFXINSTPRO');
		SET Var_Control:= 'sqlException' ;
	END;

	SET FechaDelSistema		:= (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_FolioOperacion	:= IFNULL(Par_Consecutivo,Entero_Cero);
	SET Par_TipoCanal 		:= (SELECT TipoCanalID FROM TIPOCANAL WHERE TipoCanalID = Par_TipoCanal);
	SET Var_Contador 		:= IFNULL((SELECT COUNT(RefPagoID) FROM REFPAGOSXINST),Entero_Cero);
	-- para obtener primer dia del mes
	SET Var_PrimerDiaMes	:= CONVERT(DATE_ADD(FechaDelSistema, INTERVAL -1*(DAY(FechaDelSistema))+1 DAY),DATE);

	SELECT		NumCtaInstit,		CuentaAhoID
		INTO	Var_CuentaBancaria,	Var_CuentaTeso
		FROM CUENTASAHOTESO
		WHERE NumCtaInstit = Par_NumCtaInstit LIMIT 1;

    -- ES UN DEPOSITO APLICADO YA NO SE EJECUTA EL PRCESO
	IF(IFNULL(Par_Estatus,EstatusNoIdentif) = EstatusAplicado)THEN
		SET Par_NumErr      := 0;
		SET Par_ErrMen      := 'El Deposito ya se Encuentra Aplicado.';
		SET Var_Control		:= 'institucionID';
		LEAVE ManejoErrores;
	END IF;

    -- SE VALIDA SI HAY REGISTROS EN REFPAGOSXINST y ES CERO PARA QUE NO SE EJECUTE EL PRCESO
	IF(IFNULL(Var_Contador,Entero_Cero) = Entero_Cero)THEN
		SET Par_NumErr      := 0;
		SET Par_ErrMen      := 'No Existen Registros en Referencias de Pagos.';
		SET Var_Control		:= 'institucionID';
		LEAVE ManejoErrores;
	END IF;

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

	-- ES CERO PARA QUE NO SE EJECUTE EL PRCESO
	IF(IFNULL(Par_TipoCanal,Entero_Cero) = TipoCanalCliente)THEN
		SET Par_NumErr      := 0;
		SET Par_ErrMen      := 'El Tipo de Canal No es Valido.';
		SET Var_Control		:= 'institucionID';
		LEAVE ManejoErrores;
	END IF;

	IF( Par_FechaOperacion > FechaDelSistema) THEN
		SET Par_NumErr      := 3;
		SET Par_ErrMen      := 'La Fecha de Operacion no debe ser mayor a la del sistema.';
		SET Var_Control		:= 'institucionID';
		LEAVE ManejoErrores;
	END IF;

	-- ES CERO PARA QUE NO SE EJECUTE EL PRCESO
    IF(NOT EXISTS(SELECT InstrumentoID FROM REFPAGOSXINST WHERE TipoCanalID = Par_TipoCanal
						AND Referencia = Par_ReferenciaMov AND InstitucionID = Par_InstitucionID))THEN
		SET Par_NumErr      := 0;
		SET Par_ErrMen      := 'No Existen Referencias de Pagos por Instrumentos.';
		SET Var_Control		:= 'institucionID';
		LEAVE ManejoErrores;
    END IF;

	CALL DIASFESTIVOSCAL(
		Par_FechaOperacion,		Entero_Cero,		Var_FechaValida,	Var_DiaHabil,		Aud_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
		Aud_NumTransaccion);

	-- SE IDENTIFICA EL TIPO DE DEPOSITO
	IF(Par_TipoDeposito = TipoEfectivo)THEN
		SET Par_TipoPago		:= TipoEfectivo;
		SET Var_TipoMovAho		:= 14;
	ELSE
		SET Par_TipoPago		:= 'T';
		SET Var_TipoMovAho		:= 16;
	END IF;

	 --  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
	SET Var_BloqueaAuto	:= Str_No;

	-- SE BUSCA LA REFERENCIA Y SE OBTIENE EL NUMERO DE CREDITO O DE CUENTA
	SET Var_ReferenciaPago := ifnull((SELECT InstrumentoID
										FROM REFPAGOSXINST
											WHERE TipoCanalID = Par_TipoCanal
												AND Referencia = Par_ReferenciaMov
												AND InstitucionID = Par_InstitucionID),Entero_Cero);
	-- SE SETEA LA NUEVA REFERENCIA ENCONTRADA.
    SET Par_ReferenciaMov := Var_ReferenciaPago;

	-- SI SE TRATA DE UN CANAL DE CREDITO
	IF(TipoCanalCred = Par_TipoCanal)THEN
        SELECT	CreditoID,		ClienteID, 		CuentaID,			MonedaID
		 INTO	Var_CreditoID,	Var_ClienteID,	Var_CuentaAhoID,	Var_MonedaID
			FROM CREDITOS
			WHERE CreditoID = Var_ReferenciaPago;

		--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTOS/
		SET Var_Descripcion	:= Var_DescripCre;
		SET Var_Instrumento	:= Var_CreditoID;
		SET Var_RefereBloq	:= Var_CuentaAhoID;
	END IF;

	-- SI SE TRATA DE UN CANAL DE CUENTA
	IF(TipoCanalCtaAho = Par_TipoCanal)THEN -- *******************************************************************************************
		SELECT	C.CuentaAhoID,		C.ClienteID,		T.EsBloqueoAuto,	C.MonedaID
		 INTO	Var_CuentaAhoID,	Var_ClienteID,		Var_BloqueaAuto,	Var_MonedaID
		FROM 	CUENTASAHO C
			INNER JOIN TIPOSCUENTAS T ON C.TipoCuentaID=T.TipoCuentaID
		WHERE	C.CuentaAhoID	= Var_ReferenciaPago;

		--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
		SET Var_Descripcion	:= Var_DescripCue;
		SET Var_Instrumento	:= Var_CuentaAhoID;
		SET Var_RefereBloq	:= Var_CuentaAhoID;
	END IF;

	-- SI EL NUMERO DE CUENTAS NO EXISTE, LA BANDERA DE ESTATUS QUEDA CON VALOR NO IDENTIFICADO
	IF(IFNULL(Var_CuentaAhoID, Entero_Cero) <> Entero_Cero)THEN
		SET Var_Status		:= EstatusAplicado;
	ELSE
		SET Var_Status		:= EstatusNoIdentif;
	END IF;

	-- SE SETEA EL ESTATUS AL PARAMETRO INOUT
	SET Par_Estatus 		:= Var_Status;

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
				Var_Descripcion,	Var_ReferenciaPago,		Var_TipoMovAho,			Var_BloqueaAuto,	Str_No,
      			Par_NumErr,			Par_ErrMen,				Par_Consecutivo,		Aud_EmpresaID,		Aud_Usuario,
                Aud_FechaActual,  	Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
                Aud_NumTransaccion
			);
            -- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;


			-- GENERA EL ENCABEZADO DE POLIZA
			CALL MAESTROPOLIZASALT(
				Var_Poliza,			Aud_EmpresaID,   		Par_FechaOperacion, 	TipoPolAutomatica,	Var_ConceptoCon,
				Var_Descripcion,	Str_No,      			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
				Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);
			-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;


			-- GENERA EL DETALLE DE POLIZA
			CALL POLIZASAHORROPRO(
				Var_Poliza,         Aud_EmpresaID,    		Par_FechaOperacion,		Var_ClienteID,	    Con_AhoCapital,
				Var_CuentaAhoID,    Var_MonedaID,   		Var_Cargos,        		Var_Abonos,		    Var_Descripcion,
				Var_ReferenciaPago,	Str_No,      			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
                Aud_FechaActual,	Aud_DireccionIP,		Aud_ProgramaID,			Aud_Sucursal,       Aud_NumTransaccion);
			-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

			SET Var_EmitePoliza	:= Str_No;			-- VALOR NO EMITE POLIZA

			CALL CONTATESOREPRO(
				Entero_Cero,        	Var_MonedaID,      	Par_InstitucionID,  	Var_CuentaBancaria,		Entero_Cero,
				Entero_Cero,       		Entero_Cero,       	Par_FechaOperacion,  	Par_FechaOperacion,   	Par_MontoMov,
				Var_Descripcion, 		Var_ReferenciaPago, Var_Instrumento, 		Var_EmitePoliza,       	Var_Poliza,
				Var_ConceptoCon,    	Entero_Cero,      	Var_NatConta,			Var_AltaMovAho,  		Var_CuentaAhoID,
				Var_ClienteID,       	Var_TipoMovAho,    	Nat_Abono,      		Str_No,					Par_NumErr,
                Par_ErrMen, 			Entero_Cero,        Aud_EmpresaID,     		Aud_Usuario,	        Aud_FechaActual,
                Aud_DireccionIP,		Aud_ProgramaID,     Aud_Sucursal,      		Aud_NumTransaccion);
			-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		ELSE
			--  SE ASIGNA LOS VALORES QUE SE OCUPARAN PARA LOS MOVIMIENTES/
			SET Var_AltaMovAho	:= Str_Si;	-- VALOR NO DAR DE ALTA MOV DE AHORRO

			/* si la fecha de operacion no es del mes anterior se insertan movimientos de ahorro en lo actual */
			CALL CONTATESOREPRO(
				Entero_Cero,        	Var_MonedaID,       Par_InstitucionID,  	Var_CuentaBancaria,		Entero_Cero,
				Entero_Cero,       		Entero_Cero,       	Par_FechaOperacion,  	Var_FechaValida,   		Par_MontoMov,
				Var_Descripcion, 		Var_ReferenciaPago, Var_Instrumento, 		Var_EmitePoliza,     	Var_Poliza,
				Var_ConceptoCon,    	Entero_Cero,      	Var_NatConta,			Var_AltaMovAho,  		Var_CuentaAhoID,
				Var_ClienteID,       	Var_TipoMovAho,    	Nat_Abono,      		Str_No,					Par_NumErr,
                Par_ErrMen, 			Entero_Cero,        Aud_EmpresaID,     		Aud_Usuario,	        Aud_FechaActual,
                Aud_DireccionIP,		Aud_ProgramaID,    	Aud_Sucursal,      		Aud_NumTransaccion);
			-- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF;

		-- SE INSERTAN LOS MOVIMIENTOS DE TESORERIA
		CALL TESORERIAMOVALT(
			Var_CuentaTeso,		Par_FechaOperacion,	Par_MontoMov,		Par_DescripcionMov,	Var_ReferenciaPago,
			Cadena_Vacia,	  	Nat_Abono,			EstatusAplicado,	TipoMovDepRef,		Entero_Cero,
			Str_No, 			Par_NumErr,			Par_ErrMen,			Par_Consecutivo,	Aud_EmpresaID,
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

		-- SI SE TRATA DE UNA CUENTA QUE BLOQUEA DE MANERA AUTOMATICA ***********************************************************************
		IF(Var_BloqueaAuto = Str_Si)THEN
			CALL BLOQUEOSPRO(
				Entero_Cero,	 	Naturaleza_Bloq,		Var_CuentaAhoID, 		Par_FechaOperacion,		Par_MontoMov,
				Aud_FechaActual,	TipoBloq,		 		Descrip_Bloq,	 		Var_RefereBloq,	   		Cadena_Vacia,
				Cadena_Vacia,		Str_No,			 		Par_NumErr,    			Par_ErrMen,				Aud_EmpresaID,
				Aud_Usuario,	 	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
				Aud_NumTransaccion);
			 -- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
			IF (Par_NumErr != Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;
		END IF; -- **********************************************************************************************************************

		SELECT PagoCredAutom INTO Var_PagoCredAutom
		FROM PARAMDEPREFER
		WHERE InstitucionID = Par_InstitucionID;

		SET Var_PagoCredAutom := IFNULL(Var_PagoCredAutom,Cadena_Vacia);


		-- SI SE TRATA DEL CANAL TIPO CREDITO BLOQUEA DE MANERA AUTOMATICA
		IF(Par_TipoCanal = TipoCanalCred)THEN
			IF (Var_CliEsp <> Var_CteSantaFe AND (Var_PagoCredAutom = Cadena_Vacia OR Var_PagoCredAutom = Str_No)) THEN
				CALL BLOQUEOSPRO(
					Entero_Cero,	 	Naturaleza_Bloq,		Var_CuentaAhoID, 		Par_FechaOperacion,		Par_MontoMov,
					Aud_FechaActual,	TipoBloqRef,			BloqueoDePagoRef, 		Var_Instrumento,	   	Cadena_Vacia,
					Cadena_Vacia,		Str_No,			 		Par_NumErr,    			Par_ErrMen,				Aud_EmpresaID,
					Aud_Usuario,	 	Aud_FechaActual,		Aud_DireccionIP,		Aud_ProgramaID,     	Aud_Sucursal,
					Aud_NumTransaccion);
					 -- SE VALIDA QUE NO HAYA DEVUELTO MENSAJE DE ERROR
				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			ELSEIF (Var_PagoCredAutom != Cadena_Vacia OR Var_PagoCredAutom = Str_Si) THEN
				CALL DEPREFPAGAUTOMCREDPRO(
					Var_CreditoID,		Par_InstitucionID,		BancoEstandar,			Par_MontoMov,		Par_Consecutivo,
					Var_MontoPago,		Var_Poliza,				Par_OrigenPago,			Str_No,				Par_NumErr,
					Par_ErrMen,			Aud_EmpresaID,			Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,
					Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);

				IF (Par_NumErr != Entero_Cero) THEN
					LEAVE ManejoErrores;
				END IF;
			END IF;

		END IF;


	END IF; -- **********************************************************************************************************************

	-- SI TERMINA CON EXITO SE SETEAN LOS VALORES
	SET Par_NumErr      := 0;
	SET Par_ErrMen      := CONCAT('Deposito Referenciado Agregado: ', CONVERT(Var_FolioOperacion, CHAR));
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
