-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CHEQUESREGEMISIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CHEQUESREGEMISIONPRO`;DELIMITER $$

CREATE PROCEDURE `CHEQUESREGEMISIONPRO`(
# ==================================================================================
# ----------- SP PARA REALIZAR EL REGISTRO DE CHEQUES DE VENTANILLA-----------------
# ==================================================================================
	Par_InstitucionID		INT(11),		-- Numero de la institucion bancaria
	Par_CuentaInstitucion	VARCHAR(20),	-- Numero de la cuenta bancaria
	Par_NumeroCheque		INT(10),		-- Numero del Cheque a Emitir
	Par_Monto				DECIMAL(14,2),	-- Monto del cheque
	Par_SucursalID			INT(12),		-- Numero de la sucursal que usa el cheque

	Par_CajaID				INT(11),		-- Numero de la caja que usa el cheque
	Par_UsuarioID			INT(11),		-- Numero del usuario que emite el cheque
	Par_Concepto			VARCHAR(200),	-- Conceto de emicion
	Par_ClienteID 			INT(11),		-- Numero del cliente beneficiario
	Par_Beneficiario		VARCHAR(200),	-- Nombre del cliente beneficiario

	Par_Referencia			VARCHAR(45),	-- Numero de la referencia de emision
	Par_AltaEncPoliza		CHAR(1), 		-- Alta encabezado poliza S.- Si N.- No
	INOUT Par_Poliza		BIGINT(20),		-- Numero de la poliza
    Par_TipoChequera		CHAR(2),		-- Tipo de chequera P - Proforma E - Estandar

	Par_Salida				CHAR(1),		-- Parametro de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),		-- Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Mensaje de Error

	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_FechaEmision	DATE;
	DECLARE Var_MonedaBaseID	INT(11);
	DECLARE Var_CuentaAhoID     BIGINT(12);
	DECLARE Var_RefTeso			VARCHAR(50);
	DECLARE	Var_Consecutivo		BIGINT(12);
	DECLARE Var_EstChequeExis	CHAR(1);
	DECLARE Var_Control         VARCHAR(100);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT(11);
	DECLARE Estatus_Emitido		CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO       		CHAR(1);
	DECLARE AltaPoliza_SI   	CHAR(1);
	DECLARE AltaPoliza_NO   	CHAR(1);
	DECLARE Pol_Automatica  	CHAR(1);
	DECLARE	Nat_Abono			CHAR(1);
	DECLARE	Nat_Cargo			CHAR(1);
	DECLARE	Mov_AhorroNO		CHAR(1);
	DECLARE Conciliado_NO       CHAR(1);
	DECLARE Tip_RegPantalla     CHAR(1);
	DECLARE Tip_ChequeCaja		CHAR(4);
	DECLARE EnVentanilla		CHAR(1);
	DECLARE	Con_ChequeEmi		INT(11);
	DECLARE	Des_ChequeEmi		VARCHAR(100);
	DECLARE TipCheq_Proforma	CHAR(1);
    DECLARE TipCheq_Estandar	CHAR(1);
    DECLARE Ambas				CHAR(1);

	-- Asignacion de constantes
	SET Cadena_Vacia		:= '';		-- Cadena Vacia
	SET Entero_Cero			:= 0;		-- Entero en Cero
	SET Estatus_Emitido		:= 'E';		-- Estatus del Cheque Emitido
	SET SalidaSI			:= 'S';		-- Salida en Pantalla SI
	SET SalidaNO			:= 'N';		-- Salida en Pantalla NO
	SET AltaPoliza_SI		:= 'S';		-- Alta del Encabezado de la Poliza: SI
	SET AltaPoliza_NO		:= 'N';		-- Alta del Encabezado de la Poliza: NO
	SET Pol_Automatica		:= 'A';		-- Tipo de Poliza: Automatica
	SET Nat_Abono			:= 'A';		-- Naturaleza Contable: Abono
	SET Nat_Cargo			:= 'C';		-- Naturaleza Contable: Cargo
	SET Mov_AhorroNO		:= 'N';		-- Movimiento en Cuenta de Ahorro: NO
	SET Conciliado_NO   	:= 'N';		-- Movimiento Sin Conciliar
	SET Tip_RegPantalla 	:= 'P';		-- Tipo de Registro: Por pantalla
	SET Tip_ChequeCaja		:= '32';	-- Tipo de Movimiento de Tesoreria: Emision de Cheque en Caja
	SET Con_ChequeEmi		:= 44;		-- Concepto Contable: Emision de Cheque
	SET Des_ChequeEmi		:= 'EMISION DE CHEQUE';
	SET EnVentanilla		:= 'V';		-- El Cheque fue Emitido en Ventanilla
	SET TipCheq_Proforma	:= 'P';		-- Tipo chequera proforma
    SET TipCheq_Estandar	:= 'E';		-- Tipo chequera estandar
    SET Ambas				:= 'A';		-- Tipo Chequera ambas

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-CHEQUESREGEMISIONPRO');
			SET Var_Control = 'SQLEXCEPTION' ;
		END;

		SELECT FechaSistema, MonedaBaseID INTO Var_FechaEmision, Var_MonedaBaseID
			FROM PARAMETROSSIS;

		SET Aud_FechaActual 	:= NOW();
		SET Par_Referencia		:= IFNULL(Par_Referencia, Par_NumeroCheque);

		SELECT CuentaAhoID  INTO Var_CuentaAhoID
			FROM	CUENTASAHOTESO
			WHERE 	InstitucionID = Par_InstitucionID
			AND 	NumCtaInstit  = Par_CuentaInstitucion;

		IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := '001';
			SET Par_ErrMen      := 'La Institucion esta Vacia.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := '002';
			SET Par_ErrMen      := 'La Cuenta de Tesoreria no existe';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := '003';
			SET Par_ErrMen      := 'El Monto del Cheque esta Vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumeroCheque, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := '004';
			SET Par_ErrMen      := 'El Numero del Cheque esta Vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		SELECT	Estatus INTO Var_EstChequeExis
			FROM 	CHEQUESEMITIDOS
			WHERE 	InstitucionID		= Par_InstitucionID
			AND 	CuentaInstitucion	= Par_CuentaInstitucion
			AND 	NumeroCheque		= Par_NumeroCheque
            AND 	TipoChequera		= Par_TipoChequera;

		SET Var_EstChequeExis	:= IFNULL(Var_EstChequeExis, Cadena_Vacia);

		IF(Var_EstChequeExis != Cadena_Vacia) THEN
			SET Par_NumErr      := '005';
			SET Par_ErrMen      := 'El Numero del Cheque ya fue Emitido';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		-- Alta del Encabezado de la Poliza
		IF(Par_AltaEncPoliza = AltaPoliza_SI) THEN

			CALL MAESTROPOLIZASALT(
                Par_Poliza,		Par_EmpresaID,	Var_FechaEmision,    Pol_Automatica,     Con_ChequeEmi,
                Des_ChequeEmi, 	SalidaNO,       Par_NumErr,          Par_ErrMen,         Aud_Usuario,
                Aud_FechaActual,Aud_DireccionIP,Aud_ProgramaID,      Aud_Sucursal,       Aud_NumTransaccion);

			IF(Par_NumErr>Entero_Cero) THEN
				LEAVE ManejoErrores;
			END IF;

		END IF;

		-- Registro Contable en la Cuenta de Tesoreria
		CALL CONTATESOREPRO(
			Par_SucursalID,     Var_MonedaBaseID,   Par_InstitucionID,  	Par_CuentaInstitucion,	Entero_Cero,
			Entero_Cero,    	Entero_Cero,        Var_FechaEmision,		Var_FechaEmision,       Par_Monto,
			Par_Concepto,       Par_Referencia,		Par_CuentaInstitucion, 	AltaPoliza_NO,     		Par_Poliza,
			Entero_Cero,		Entero_Cero,        Nat_Abono,          	Mov_AhorroNO,     		Entero_Cero,
			Par_ClienteID,      Cadena_Vacia,       Cadena_Vacia,          	SalidaNO,				Par_NumErr,
			Par_ErrMen, 		Var_Consecutivo,    Par_EmpresaID,      	Aud_Usuario,			Aud_FechaActual,
			Aud_DireccionIP,	Aud_ProgramaID,     Aud_Sucursal,			Aud_NumTransaccion);

		IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

		-- Registro Movimiento Operativo de Tesoreria
		SET Var_RefTeso := CONCAT('NO.CHEQUE: ', CONVERT(Par_NumeroCheque, CHAR));

        CALL TESORERIAMOVALT(
            Var_CuentaAhoID,    Var_FechaEmision, 	Par_Monto,       	Des_ChequeEmi, 		Var_RefTeso,
            Conciliado_NO,      Nat_Cargo,         	Tip_RegPantalla,    Tip_ChequeCaja,     Entero_Cero,
            SalidaNO,           Par_NumErr,         Par_ErrMen,         Var_Consecutivo,    Par_EmpresaID,
            Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
            Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		-- Actualizamos el Saldo de la Cuenta de Bancos
		CALL SALDOSCUENTATESOACT(
			Par_CuentaInstitucion,	Par_InstitucionID,		Par_Monto,			Nat_Cargo,			Var_Consecutivo,
			SalidaNO,				Par_NumErr,       		Par_ErrMen,     	Par_EmpresaID,		Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,   		Aud_ProgramaID, 	Aud_Sucursal,     	Aud_NumTransaccion);

		IF(Par_NumErr != Entero_Cero) THEN
			LEAVE ManejoErrores;
		END IF;

		INSERT INTO CHEQUESEMITIDOS (
			InstitucionID,		CuentaInstitucion,		NumeroCheque,		FechaEmision,		Monto,
			SucursalID,			CajaID,					UsuarioID,			Concepto,			ClienteID,
			Beneficiario,		Estatus,				Referencia,			EmitidoEn,			TipoChequera,
            EmpresaID,			Usuario,				FechaActual,		DireccionIP,		ProgramaID,
            Sucursal,			NumTransaccion)
		VALUES(
			Par_InstitucionID,	Par_CuentaInstitucion,	Par_NumeroCheque,	Var_FechaEmision,	Par_Monto,
			Par_SucursalID,		Par_CajaID,				Par_UsuarioID,		Par_Concepto,		Par_ClienteID,
			Par_Beneficiario,	Estatus_Emitido,		Par_Referencia,		EnVentanilla,		Par_TipoChequera,
            Par_EmpresaID,		Aud_Usuario,			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
            Aud_Sucursal,		Aud_NumTransaccion);

		IF(Par_TipoChequera = TipCheq_Proforma)THEN
			-- Actualizar el numero de Cheque, en la Cta de Tesoreria
			UPDATE CUENTASAHOTESO SET
						FolioUtilizar	= Par_NumeroCheque
				WHERE 	InstitucionID 	= Par_InstitucionID
				AND 	NumCtaInstit  	= Par_CuentaInstitucion
				AND 	(TipoChequera	= Par_TipoChequera OR
						TipoChequera	= Ambas);

		ELSEIF(Par_TipoChequera = TipCheq_Estandar)THEN
			-- Actualizar el numero de Cheque, en la Cta de Tesoreria
			UPDATE CUENTASAHOTESO SET
						FolioUtilizarEstan	= Par_NumeroCheque
				WHERE 	InstitucionID 		= Par_InstitucionID
				AND 	NumCtaInstit  		= Par_CuentaInstitucion
				AND 	(TipoChequera		= Par_TipoChequera OR
						TipoChequera		= Ambas);

		END IF;

		-- Actualizar el numero de Cheque, en cajas chequera
		UPDATE CAJASCHEQUERA SET
					FolioUtilizar	= Par_NumeroCheque
			WHERE 	InstitucionID 	= Par_InstitucionID
			AND 	NumCtaInstit  	= Par_CuentaInstitucion
			AND 	SucursalID		= Par_SucursalID
			AND 	CajaID			= Par_CajaID
            AND 	TipoChequera	= Par_TipoChequera
			AND 	Par_NumeroCheque BETWEEN FolioCheqInicial AND FolioCheqFinal;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'Operacion Realizada Exitosamente.';

	END ManejoErrores;  -- END del Handler de Errores

	IF(Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr 		AS NumErr,
				Par_ErrMen 		AS ErrMen,
				'numeroCheque'	AS control,
				Par_Poliza 		AS consecutivo;
	END IF;

END TerminaStore$$