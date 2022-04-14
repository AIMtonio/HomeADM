-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESOCONCIMANPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESOCONCIMANPRO`;DELIMITER $$

CREATE PROCEDURE `TESOCONCIMANPRO`(
# ===================================================================
# --SP PARA REALIZAR LA CONCILIACION MANUAL DE MOV. DE TESORERIA ----
# ===================================================================
    Par_InstitucionID   INT(11),
    Par_NumCtaInstit    VARCHAR(20),
    Par_FolioCargaID    BIGINT,
    Par_FechaOperacion  DATE,
    Par_Descripcion     VARCHAR(150),
    Par_Referencia      VARCHAR(150),
    Par_Naturaleza      CHAR(1),
    Par_Monto           DECIMAL(14,2),
    Par_TipMovCon       CHAR(4),
    Par_CuentaConta     CHAR(25),
    Par_PolizaID        BIGINT(12),
	Par_CentroCostos	INT(11),  -- Centro de Costos -- ..

	Par_Salida        	CHAR(1),
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(450),
	OUT	Par_Consecutivo	BIGINT(12),

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

)
TerminaStore: BEGIN

	-- -declaracion de variables
	DECLARE Var_CuentaAhoID     BIGINT(12);
	DECLARE Var_CharCueAhoID    VARCHAR(15);
	DECLARE Var_CuentaBancos    VARCHAR(25);
	DECLARE Var_CuentaCon       VARCHAR(25);
	DECLARE Var_NaturaCon       CHAR(1);
	DECLARE Var_CuentaEdita     CHAR(1);
	DECLARE Var_CentroCosto     INT(11);
	DECLARE Var_MonedaBase      INT(11);
	DECLARE Var_MontoCargo      DECIMAL(14,2);
	DECLARE Var_MontoAbono      DECIMAL(14,2);
	DECLARE Var_FolioMovTeso    BIGINT(12);
	DECLARE Var_Control			VARCHAR(100);
	DECLARE Var_MovConcilFega	CHAR(4);
    DECLARE Var_MovConcilFonaga	CHAR(4);
    DECLARE Var_SaldoFegaDec	DECIMAL(14,2);
    DECLARE Var_SaldoFonagaDec	DECIMAL(14,2);
    DECLARE Var_SaldoFega		VARCHAR(50);
    DECLARE Var_SaldoFonaga		VARCHAR(50);
    DECLARE Var_Consecutivo		INT(11);

	-- -declaracion de constates--
	DECLARE Entero_Cero     	INT(11);
	DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Cadena_Vacia    	CHAR(1);
	DECLARE Fecha_Vacia     	DATE;
	DECLARE Nat_Cargo      		CHAR(1);
	DECLARE Nat_Abono       	CHAR(1);
	DECLARE Des_Cargo       	VARCHAR(10);
	DECLARE Des_Abono       	VARCHAR(10);
	DECLARE Editable_SI     	CHAR(1);
	DECLARE Conciliado_SI   	CHAR(1);
	DECLARE Reg_Automatico  	CHAR(1);
	DECLARE Salida_SI       	CHAR(1);
	DECLARE Salida_NO       	CHAR(1);
	DECLARE ActConciliado   	INT(11);
	DECLARE Sin_Error       	CHAR(3);
	DECLARE Procedimiento   	VARCHAR(50);
	DECLARE VarCuenta			VARCHAR(50);
	DECLARE TipoInstrumentoID 	INT(11);
    DECLARE LlaveMovConFega		VARCHAR(50);
    DECLARE LlaveMovConFonaga	VARCHAR(50);
    DECLARE LlaveSaldoFega		VARCHAR(50);
    DECLARE LlaveSaldoFonaga	VARCHAR(50);

	-- asignacion de constantes
	SET Entero_Cero     		:= 0;
	SET Decimal_Cero     		:= 0.00;
	SET Cadena_Vacia    		:= '';
	SET Fecha_Vacia     		:= '1900-01-01';
	SET Nat_Cargo      			:= 'C';
	SET Nat_Abono       		:= 'A';
	SET Des_Cargo       		:= 'CARGO';
	SET Des_Abono       		:= 'ABONO';
	SET Editable_SI     		:= 'S';
	SET Conciliado_SI   		:= 'C';
	SET Reg_Automatico  		:= 'A';
	SET Salida_NO       		:= 'N';
	SET Salida_SI       		:= 'S';
	SET ActConciliado  			:= 1;
	SET Sin_Error       		:= '000';
	SET TipoInstrumentoID		:= 19; 					-- Tipo Instrumento CUENTA  BANCARIA --
	SET Procedimiento  	 		:= 'TESOCONCIMANPRO';
	SET Aud_FechaActual 		:= CURRENT_TIMESTAMP();
    SET LlaveMovConFega			:= 'ConciliaFega';		-- Llave de movimiento de conciliacion fega
    SET LlaveMovConFonaga		:= 'ConciliaFonaga';	-- Llave de movimiento de conciliacion fonaga
    SET LlaveSaldoFega			:= 'SaldoFega';			-- Llave de parametro para saldo fega
    SET LlaveSaldoFonaga		:= 'SaldoFonaga';		-- Llave de parametro para saldo fonaga
    SET Var_SaldoFegaDec		:= 0.00;				-- Saldo Fega en DECIMAL
    SET Var_SaldoFonagaDec		:= 0.00;				-- Saldo Fonaga en DECIMAL
    SET Var_SaldoFega			:= '0.00';				-- Saldo Fega en VARCHAR
    SET Var_SaldoFonaga			:= '0.00';				-- Saldo Fonaga en VARCHAR
 	SET Var_Consecutivo			:= 0;					-- Consecutivo

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									     'esto le ocasiona. Ref: SP-TESOCONCIMANPRO');

			END;

		SELECT MonedaBaseID INTO Var_MonedaBase
			FROM PARAMETROSSIS;

		SELECT  	CuentaCompletaID, CuentaAhoID, CentroCostoID
			INTO	Var_CuentaBancos, Var_CuentaAhoID, Var_CentroCosto
			FROM 	CUENTASAHOTESO
			WHERE 	InstitucionID	= Par_InstitucionID
			AND 	NumCtaInstit  	= Par_NumCtaInstit;

		SET Var_CuentaBancos := IFNULL(Var_CuentaBancos, Cadena_Vacia);

		IF (Var_CuentaBancos = Cadena_Vacia) THEN
			SET Par_NumErr      := 	1;
			SET Par_ErrMen      := 'La Cuenta de Bancos no Existe';
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;



		IF (Par_Monto <= Entero_Cero) THEN
			SET Par_NumErr      := 2;
			SET Par_ErrMen      := 'Monto Incorrecto';
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF (Par_Naturaleza != Nat_Cargo AND Par_Naturaleza != Nat_Abono) THEN
			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'Naturaleza Incorrecta';
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_PolizaID := IFNULL(Par_PolizaID, Entero_Cero);

		IF (Par_PolizaID <= Entero_Cero) THEN
			SET Par_NumErr      := 4;
			SET Par_ErrMen      := 'Poliza Incorrecta';
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Par_FechaOperacion := IFNULL(Par_FechaOperacion, Fecha_Vacia);

		IF (Par_FechaOperacion = Fecha_Vacia) THEN
			SET Par_NumErr      := 5;
			SET Par_ErrMen      := 'Fecha Incorrecta';
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT CuentaContable, NaturaContable, CuentaEditable INTO
				Var_CuentaCon, Var_NaturaCon,   Var_CuentaEdita
			FROM TIPOSMOVTESO
			WHERE TipoMovTesoID = Par_TipMovCon;

		SET Var_NaturaCon  := IFNULL(Var_NaturaCon, Cadena_Vacia);

		IF (Var_NaturaCon = Cadena_Vacia) THEN
			SET Par_NumErr      := 6;
			SET Par_ErrMen      := 'El tipo de Conciliacion no Existe';
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF (Var_CuentaEdita != Editable_SI) THEN
			SET Par_CuentaConta := Var_CuentaCon;
		END IF;

		SET VarCuenta := (SELECT CuentaCompleta FROM CUENTASCONTABLES WHERE CuentaCompleta = Par_CuentaConta);

		IF(IFNULL( VarCuenta, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'El Numero de Cuenta Contable no Existe.';
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		CALL TESORERIAMOVSALT(
			Var_CuentaAhoID,    Par_FechaOperacion, Par_Monto,          Par_Descripcion,    Par_Referencia,
			Conciliado_SI,      Par_Naturaleza,     Reg_Automatico,     Par_TipMovCon,      Par_FolioCargaID,
			Salida_NO,          Par_NumErr,         Par_ErrMen,         Var_FolioMovTeso,   Aud_EmpresaID,
			Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
			Aud_NumTransaccion  );

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		-- Actualizamos el Saldo de la Cuenta de Bancos
		CALL SALDOSCUENTATESOACT(
			Par_NumCtaInstit,	Par_InstitucionID,		Par_Monto,			Par_Naturaleza,			Var_Consecutivo,
			Salida_NO,			Par_NumErr,         	Par_ErrMen,     	Aud_EmpresaID,  		Aud_Usuario,
			Aud_FechaActual,    Aud_DireccionIP,    	Aud_ProgramaID,     Aud_Sucursal,   		Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			SET Var_Control		:= 'NumCtaInstit';
            SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Var_CharCueAhoID    := CONVERT(Var_CuentaAhoID, CHAR);
		SET Var_MontoCargo  := Decimal_Cero;
		SET Var_MontoAbono  := Decimal_Cero;


		IF(Par_Naturaleza = Nat_Cargo) THEN
			SET Var_MontoCargo  := Decimal_Cero;
			SET Var_MontoAbono  := Par_Monto;
		ELSE
			SET Var_MontoCargo  := Par_Monto;
			SET Var_MontoAbono  := Decimal_Cero;
		END IF;

		CALL DETALLEPOLIZASALT (
			Aud_EmpresaID,			Par_PolizaID,		Par_FechaOperacion, 	Var_CentroCosto,	Var_CuentaBancos,
			Par_NumCtaInstit,		Var_MonedaBase,		Var_MontoCargo,			Var_MontoAbono,		Par_Descripcion,
			Var_CharCueAhoID,		Procedimiento,		TipoInstrumentoID,		Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,			Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal,       Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SET Var_MontoCargo  := Decimal_Cero;
		SET Var_MontoAbono  := Decimal_Cero;

		IF(Var_NaturaCon = Nat_Cargo) THEN
			SET Var_MontoCargo  := Par_Monto;
			SET Var_MontoAbono  := Decimal_Cero;
		ELSE
			SET Var_MontoCargo  := Decimal_Cero;
			SET Var_MontoAbono  := Par_Monto;
		END IF;


		CALL DETALLEPOLIZASALT (
			Aud_EmpresaID,			Par_PolizaID,		Par_FechaOperacion, 	Par_CentroCostos,	Par_CuentaConta,
			Par_NumCtaInstit,		Var_MonedaBase,		Var_MontoCargo,			Var_MontoAbono,		Par_Descripcion,
			Var_CharCueAhoID,		Procedimiento,		TipoInstrumentoID,		Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,			Salida_NO,			Par_NumErr,				Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID, 		Aud_Sucursal,       Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		CALL TESOMOVSCONCILIACT(
			Par_FolioCargaID,   Var_CuentaAhoID,    Conciliado_SI,      Var_FolioMovTeso,   Par_TipMovCon,
			ActConciliado,      Salida_NO,          Par_NumErr,         Par_ErrMen,         Entero_Cero,
			Aud_EmpresaID,      Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,
			Aud_Sucursal,       Aud_NumTransaccion  );

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control		:= 'NumCtaInstit';
			SET Par_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

         SELECT ValorParametro INTO Var_MovConcilFega
			FROM PARAMGENERALES
            WHERE LlaveParametro	= LlaveMovConFega;

        SET Var_MovConcilFega	:= IFNULL(Var_MovConcilFega, Cadena_Vacia);

        SELECT ValorParametro INTO Var_SaldoFega
			FROM PARAMGENERALES
            WHERE LlaveParametro	= LlaveSaldoFega;

		IF(Par_TipMovCon = Var_MovConcilFega)THEN

            SET Var_SaldoFegaDec	:= CAST(Var_SaldoFega AS DECIMAL(14,2)) + Par_Monto;
			SET Var_SaldoFega		:= CAST(Var_SaldoFegaDec AS CHAR);

			UPDATE PARAMGENERALES SET
				ValorParametro		= Var_SaldoFega
			WHERE LlaveParametro	= LlaveSaldoFega;
		END IF;

		SELECT ValorParametro INTO Var_MovConcilFonaga
			FROM PARAMGENERALES
            WHERE LlaveParametro	= LlaveMovConFonaga;

        SET Var_MovConcilFega	:= IFNULL(Var_MovConcilFega, Cadena_Vacia);


		SELECT ValorParametro INTO Var_SaldoFonaga
			FROM PARAMGENERALES
            WHERE LlaveParametro	= LlaveSaldoFonaga;

		IF(Par_TipMovCon = Var_MovConcilFonaga)THEN

			SET Var_SaldoFonagaDec	:= CAST(Var_SaldoFonaga AS DECIMAL(14,2)) + Par_Monto;
			SET Var_SaldoFonaga		:= CAST(Var_SaldoFonagaDec AS CHAR);

			UPDATE PARAMGENERALES SET
				ValorParametro		= Var_SaldoFonaga
			WHERE LlaveParametro	= LlaveSaldoFonaga;
		END IF;


		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'Conciliacion Realizada Exitosamente.';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Par_PolizaID AS consecutivo;
	END IF;

END TerminaStore$$