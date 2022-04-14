-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAINFADICIONALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAINFADICIONALALT`;DELIMITER $$

CREATE PROCEDURE `POLIZAINFADICIONALALT`(
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
	SET Salida_No			:='N';
    SET Decimal_Cero		:= 0.00;	-- Decimal Cero

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									  'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZAINFADICIONALALT');
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



		INSERT INTO POLIZAINFADICIONAL (
			PolizaID,				Movimiento,				InstitucionID,			NumCtaInstit,		TipoMovimiento,
            Folio,					PersonaID,				Importe,				Referencia,     	MetodoPagoID,
            MonedaID,				InstitucionOrigen,		CueClaveOrigen, 		EmpresaID,			Usuario,
            FechaActual,            DireccionIP,		    ProgramaID,				Sucursal,			NumTransaccion)

        VALUES
		   (Par_PolizaID,			Par_Movimiento,			Par_InstitucionID,		Par_NumCtaInstit,	Par_TipoMovimientoID,
			Par_Folio,				Par_PersonaID,			Par_Importe,			Par_Referencia,		Par_MetodoPagoID,
            Par_MonedaID,			Par_InstitucionOrigen,	Par_ClabeOrigen,		Aud_EmpresaID,		Aud_Usuario,
		    Aud_FechaActual,    	Aud_DireccionIP,        Aud_ProgramaID,			Aud_Sucursal,		Aud_NumTransaccion);



		SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Informacion Agregada Exitosamente: ',CONVERT(Par_PolizaID,CHAR));

	END ManejoErrores;  -- End del Handler de Errores

	 IF (Par_Salida = SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'polizaID' AS control,
				Par_PolizaID AS consecutivo;

	END IF;

END TerminaStore$$