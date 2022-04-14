-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAINFADICIONALMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAINFADICIONALMOD`;DELIMITER $$

CREATE PROCEDURE `POLIZAINFADICIONALMOD`(
# ==================================================================================
# --------------------- SP PARA REGISTRAR INFORMACION ADICIONAL DE LAS POLIZAS ----------------------
# ==================================================================================
	Par_PolizaID			BIGINT(20),
	Par_Movimiento			CHAR(1),
	Par_InstitucionID		INT(11),
	Par_NumCtaInstit		VARCHAR(20),
	Par_TipoMovimientoID	INT(11),

	Par_Folio				VARCHAR(10),
	Par_PersonaID			INT(11),
	Par_Importe 			DECIMAL(14,4),
	Par_Referencia			VARCHAR(50),
	Par_MetodoPagoID		INT(11),

    Par_MonedaID			INT(11),
	Par_InstitucionOrigen	INT(11),
    Par_ClabeOrigen			CHAR(18),
	Par_Salida				CHAR(1),
	INOUT	Par_NumErr		INT(11),
	INOUT	Par_ErrMen		VARCHAR(400),

    -- Parametros de Auditoria
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)

)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_FechaEmision	DATE;
	DECLARE	Var_Consecutivo		BIGINT(12);
    DECLARE VarControl 			VARCHAR(15);

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT(11);
    DECLARE	Decimal_Cero		DECIMAL(14,2);
	DECLARE SalidaSI			CHAR(1);
	DECLARE SalidaNO       		CHAR(1);
	DECLARE Salida_NO			CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';		-- Cadena Vacia
	SET	Entero_Cero			:= 0;		-- Entero en Cero
	SET SalidaSI			:= 'S';		-- Salida en Pantalla SI
	SET SalidaNO			:= 'N';		-- Salida en Pantalla NO
	SET Salida_No			:= 'N';
    SET Decimal_Cero		:= 0.00;	-- Decimal Cero

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZAINFADICIONALMOD');
				SET VarControl = 'sqlException';
			END;


		SET Aud_FechaActual 	:= NOW();


		IF(IFNULL(Par_PolizaID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 001;
			SET Par_ErrMen      := 'La Poliza esta Vacia.';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Movimiento, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 002;
			SET Par_ErrMen      := 'El Movimiento esta Vacio';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_InstitucionID, Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr      := 003;
			SET Par_ErrMen      := 'La Institucion esta Vacia';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NumCtaInstit, Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr      := 004;
			SET Par_ErrMen      := 'El Numero de Cuenta esta Vacio';
			SET Var_Consecutivo := Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_TipoMovimientoID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:=005;
			SET Par_ErrMEn	:='El Tipo Movimiento esta Vacio';
			SET Var_Consecutivo:=Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Folio,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:=005;
			SET Par_ErrMEn	:='El Folio esta Vacio';
			SET Var_Consecutivo:=Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_PersonaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:=005;
			SET Par_ErrMEn	:='El Cliente esta Vacio';
			SET Var_Consecutivo:=Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Importe,Decimal_Cero)) = Decimal_Cero THEN
			SET Par_NumErr	:=005;
			SET Par_ErrMEn	:='El Importe esta Vacio';
			SET Var_Consecutivo:=Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_Referencia,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:=005;
			SET Par_ErrMEn	:='La Referencia esta Vacia';
			SET Var_Consecutivo:=Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_MetodoPagoID,Cadena_Vacia)) = Cadena_Vacia THEN
			SET Par_NumErr	:=005;
			SET Par_ErrMEn	:='El Metodo de Pago esta Vacio';
			SET Var_Consecutivo:=Entero_Cero;
			LEAVE ManejoErrores;
		END IF;

        IF(IFNULL(Par_MonedaID,Entero_Cero)) = Entero_Cero THEN
			SET Par_NumErr	:=005;
			SET Par_ErrMEn	:='La Moneda esta Vacia';
			SET Var_Consecutivo:=Entero_Cero;
			LEAVE ManejoErrores;
		END IF;


		UPDATE POLIZAINFADICIONAL SET
			Movimiento		= Par_Movimiento,
			InstitucionID	= Par_InstitucionID,
			NumCtaInstit	= Par_NumCtaInstit,
			TipoMovimiento	= Par_TipoMovimientoID,
			Folio			= Par_Folio,

			PersonaID		= Par_PersonaID,
			Importe			= Par_Importe,
			Referencia		= Par_Referencia,
            MetodoPagoID	= Par_MetodoPagoID,
			MonedaID		= Par_MonedaID,
            InstitucionOrigen	= Par_InstitucionOrigen,
            CueClaveOrigen		= Par_ClabeOrigen,

			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
            NumTransaccion	= Aud_NumTransaccion

		WHERE PolizaID 		= Par_PolizaID;


		SET Par_NumErr	:= Entero_Cero;
        SET Par_ErrMen	:= CONCAT('Informacion Modificada Exitosamente: ',CONVERT(Par_PolizaID,CHAR));



	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'polizaID' AS control,
				Par_PolizaID AS consecutivo;

	END IF;

END TerminaStore$$