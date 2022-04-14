-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ORDENPAGODESCREDALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ORDENPAGODESCREDALT`;DELIMITER $$

CREATE PROCEDURE `ORDENPAGODESCREDALT`(
# ============================================================
# ----- SP PARA REGISTRAR ORDENES DE PAGO DE DISPERSIONES-----
# ============================================================
	Par_ClienteID			INT(11),		-- Numero de cliente
	Par_InstitucionID		INT(11),		-- Numero de institucion
	Par_NumCtaInstit		VARCHAR(20),	-- Numero de cuenta de la institucion
	Par_NumOrdenPago		VARCHAR(50),	-- Numero de orden de pago
	Par_Monto				DECIMAL(14,2),	-- Monto de la orden de pago

	Par_Beneficiario		VARCHAR(200),	-- Nombre del beneficiario
	Par_Referencia			VARCHAR(50), 	-- Referencia de la orden de pago
	Par_Concepto			VARCHAR(200),	-- Concepto de la orden de pago
	Par_MotivoRenov			VARCHAR(150),	-- Motivo de renovacion de la orden de pago

	Par_Salida				CHAR(1),	 	-- Parametro de salida
	INOUT	Par_NumErr		INT(11),     	-- Numero de error
	INOUT	Par_ErrMen		VARCHAR(400),	-- Mensaje de error

	Par_EmpresaID			INT(11),     	-- Parametro de auditoria
	Aud_Usuario				INT(11),	 	-- Parametro de auditoria
	Aud_FechaActual			DATETIME,    	-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15), 	-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50), 	-- Parametro de auditoria
	Aud_Sucursal			INT(11),     	-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)   	-- Parametro de auditoria
)
TerminaStore:BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaEmision	DATE;    	-- Fecha de emision de la orden de pago
	DECLARE Var_CuentaAhoID     BIGINT(12);	-- Numero de cuenta
	DECLARE	Var_Consecutivo		BIGINT;		-- Consecutivo
    DECLARE Var_Control 		VARCHAR(15);-- Variable de control
    DECLARE Var_ValOrdDisp		CHAR(2);	-- Variable que guarda el valor para validar las ordenes de pago en las dispersiones
	DECLARE VarNumOrdPagoCad	VARCHAR(50);-- Variable para guardar el numero de orden de pago tipo cadena
    DECLARE VarNumOrdenPagoInt	BIGINT(20);	-- Variable para guardar el numero de orden de pago tipo entero

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
    DECLARE Decimal_Cero		DECIMAL(14,2);
	DECLARE Estatus_Emitido		CHAR(1);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO       		CHAR(1);
	DECLARE LlaveValOrdDisp		VARCHAR(50);
    DECLARE ConstanteNo			VARCHAR(2);
    DECLARE ConstanteSi			VARCHAR(2);

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';		-- Cadena Vacia
	SET	Entero_Cero				:= 0;		-- Entero en Cero
    SET Decimal_Cero			:= 0.0;		-- Decimal Cero
	SET Estatus_Emitido			:= 'E';		-- Estatus de orden Emitido
	SET SalidaSI				:= 'S';		-- Salida en Pantalla SI
	SET SalidaNO				:= 'N';		-- Salida en Pantalla NO
    SET LlaveValOrdDisp			:= 'ValidaOrdPagoDisp';	-- Llave de parametro para saldo fega
    SET ConstanteNo				:= 'N';		-- Constante NO
	SET ConstanteSi				:= 'S';		-- Constante SI

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr 	= 999;
				SET Par_ErrMen 	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-ORDENPAGODESCREDALT');
				SET Var_Control = 'sqlException';
			END;


		SELECT FechaSistema INTO Var_FechaEmision
			FROM PARAMETROSSIS;

		SET Aud_FechaActual 	:= NOW();

		SELECT CuentaAhoID  INTO Var_CuentaAhoID
			FROM CUENTASAHOTESO
			WHERE InstitucionID = Par_InstitucionID
			  AND NumCtaInstit  = Par_NumCtaInstit;

		IF(IFNULL(Par_ClienteID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 1;
			SET Par_ErrMen      := 'El Numero del Cliente esta Vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 2;
			SET Par_ErrMen      := 'La Institucion esta Vacia.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Var_CuentaAhoID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 3;
			SET Par_ErrMen      := 'La Cuenta de Tesoreria no existe';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Monto, Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr      := 5;
			SET Par_ErrMen      := 'El Monto esta Vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Beneficiario, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 6;
			SET Par_ErrMen      := 'El Beneficiario esta vacio.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		SELECT ValorParametro INTO Var_ValOrdDisp
			FROM PARAMGENERALES
            WHERE LlaveParametro	= LlaveValOrdDisp;

		SET Var_ValOrdDisp	:= IFNULL(Var_ValOrdDisp,ConstanteNo);

        IF (Var_ValOrdDisp = ConstanteSi)THEN

			IF(IFNULL(Par_NumOrdenPago, Cadena_Vacia)) = Cadena_Vacia THEN
				SET Par_NumErr      := 4;
				SET Par_ErrMen      := 'El Numero del Orden de Pago esta Vacio.';
				SET Var_Consecutivo := Entero_Cero;
				LEAVE ManejoErrores;
			END IF;

			IF EXISTS(SELECT  NumOrdenPago
						FROM 	ORDENPAGODESCRED
						WHERE	InstitucionID 	= Par_InstitucionID
						AND		NumOrdenPago	= Par_NumOrdenPago)THEN
				SET	Par_NumErr 	:= 7;
				SET	Par_ErrMen	:= 'La Orden de Pago ya fue Emitida';
				LEAVE ManejoErrores;
			END IF;

            SET VarNumOrdPagoCad	:= Par_NumOrdenPago;
		ELSE
			SET VarNumOrdenPagoInt	:= (SELECT IFNULL(MAX(CAST(NumOrdenPago AS UNSIGNED)),Entero_Cero) + 1
											FROM ORDENPAGODESCRED);
			SET VarNumOrdPagoCad	:=(CAST(VarNumOrdenPagoInt AS CHAR(50)));
        END IF;

		SET Par_Referencia 	:= IFNULL(Par_Referencia,Cadena_Vacia);
		SET Par_Concepto 	:= IFNULL(Par_Concepto,Cadena_Vacia);
		SET Par_MotivoRenov := IFNULL(Par_MotivoRenov,Cadena_Vacia);

		INSERT INTO ORDENPAGODESCRED (
			ClienteID,			InstitucionID,		NumCtaInstit,	NumOrdenPago,		Monto,
            Fecha,				Beneficiario,		Estatus,		Referencia,			Concepto,
            MotivoRenov,		EmpresaID,			Usuario,		FechaActual,		DireccionIP,
            ProgramaID,			Sucursal,			NumTransaccion)

        VALUES(
			Par_ClienteID,		Par_InstitucionID,	Par_NumCtaInstit,VarNumOrdPagoCad,	Par_Monto,
			Var_FechaEmision,	Par_Beneficiario,	Estatus_Emitido, Par_Referencia,	Par_Concepto,
            Par_MotivoRenov,	Par_EmpresaID,		Aud_Usuario,	 Aud_FechaActual,	Aud_DireccionIP,
            Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= 'Orden de Pago Registrada Exitosamente.';


	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'numOrdenPago' AS control,
				Par_NumOrdenPago AS consecutivo;

	END IF;

END TerminaStore$$