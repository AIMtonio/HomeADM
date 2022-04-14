-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- POLIZAREMESASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `POLIZAREMESASPRO`;
DELIMITER $$

CREATE PROCEDURE `POLIZAREMESASPRO`(



    Par_Poliza          BIGINT,
    Par_Empresa         INT,
    Par_Fecha           DATE,
    Par_Instrumento     VARCHAR(20),
    Par_SucOperacion    INT,

    Par_Cargos          DECIMAL(14,4),
    Par_Abonos          DECIMAL(14,4),
    Par_Moneda          INT,
    Par_Descripcion     VARCHAR(150),
    Par_Referencia      VARCHAR(50),
    OUT Par_Consecutivo BIGINT,

    Par_Salida          CHAR(1),
	OUT Par_NumErr      INT,
	OUT Par_ErrMen      VARCHAR(400),

    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN


	DECLARE Var_Control	    	VARCHAR(100);
	DECLARE Var_Consecutivo		BIGINT(20);
	DECLARE Var_Cuenta          VARCHAR(50);
	DECLARE Var_CentroCostosID  INT(11);
	DECLARE Var_ClabeInst		VARCHAR(18);


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Entero_Cero			INT;
	DECLARE	Salida_SI 			CHAR(1);
	DECLARE	Cuenta_Vacia		CHAR(25);
	DECLARE  Salida_NO  	    CHAR(1);
	DECLARE	Procedimiento   	VARCHAR(20);
	DECLARE TipoInstrumentoID	INT(11);
	DECLARE Decimal_Cero		DECIMAL(14,2);


	SET Cadena_Vacia    	:= '';
	SET Entero_Cero     	:= 0;
	SET Salida_SI       	:= 'S';
	SET Cuenta_Vacia   	 	:= '0000000000000000000000000';
	SET Salida_NO       	:= 'N';
	SET Procedimiento		:= 'POLIZAREMESASPRO';
	SET TipoInstrumentoID 	:= 27;
	SET Decimal_Cero		:= 0.00;

	SET Par_NumErr  		:= Entero_Cero;
	SET Par_ErrMen  		:= Cadena_Vacia;
	SET	Var_Cuenta			:= '0000000000000000000000000';
	SET Var_CentroCostosID	:= Entero_Cero;
	SET	Var_ClabeInst		:= Cadena_Vacia;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-POLIZAREMESASPRO');
				SET Var_Control = 'sqlException';
			END;


		SELECT	CtaDDIESpei		INTO	Var_Cuenta
			FROM PARAMETROSSPEIIE
			WHERE	EmpresaID = Par_Empresa;


		SET Var_Cuenta      := IFNULL(Var_Cuenta, Cuenta_Vacia);
		SET Var_CentroCostosID    := FNCENTROCOSTOS(Par_SucOperacion);


		CALL DETALLEPOLIZASALT(
			Par_Empresa,		Par_Poliza,			Par_Fecha, 			Var_CentroCostosID,	Var_Cuenta,
			Par_Instrumento,	Par_Moneda,			Par_Cargos,			Par_Abonos,			Par_Descripcion,
			Par_Referencia,		Procedimiento,		TipoInstrumentoID,	Cadena_Vacia,		Decimal_Cero,
			Cadena_Vacia,		Salida_NO,			Par_NumErr,			Par_ErrMen,			Aud_Usuario,
			Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,		Aud_NumTransaccion);

		IF (Par_NumErr != Entero_Cero) THEN
			SET Var_Control		:= 'polizaID' ;
			SET Var_Consecutivo := Par_Poliza;
			LEAVE ManejoErrores;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= CONCAT("Poliza Agregada: ", CONVERT(Par_Poliza, CHAR));
		SET Var_Control	:= 'polizaID' ;

	END ManejoErrores;

		IF (Par_Salida = Salida_SI) THEN
			SELECT	Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$