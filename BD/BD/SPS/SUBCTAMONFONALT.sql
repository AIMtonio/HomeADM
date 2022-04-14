-- SUBCTAMONFONALT
DELIMITER ;
DROP PROCEDURE IF EXISTS SUBCTAMONFONALT;
DELIMITER $$


CREATE PROCEDURE SUBCTAMONFONALT(
	/*Sp para alta de credito pasivo */
	Par_ConceptoFonID		INT(11),
	Par_TipoFondeo			CHAR(1),
	Par_MonedaID	        INT(11),
	Par_SubCuenta           VARCHAR(6),
	
	Par_Salida		      	CHAR(1),
	INOUT Par_NumErr		INT(11),
	INOUT Par_ErrMen		VARCHAR(400),
	
	Par_EmpresaID			INT(11),
	Aud_Usuario			   	INT(11),
	Aud_FechaActual			DATETIME,

	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)

TerminaStore: BEGIN

	/* DECLARACION DE CONSTANTES*/
	DECLARE	Cadena_Vacia		CHAR(1);		/* Cadena Vacia*/
	DECLARE	Entero_Cero			INT;			/* Entero en Cero*/
	DECLARE	Decimal_Cero		DECIMAL(12,2);	/* Decimal en Cero*/
	DECLARE Var_SI				CHAR(1);		/* valor si */
	DECLARE Var_NO				CHAR(1);		/* valor no */
	DECLARE	Fecha_Vacia			DATE;			/* Fecha Vacia*/
	DECLARE	Salida_SI			CHAR(1);		/* Valor para devolver una Salida */
	DECLARE	Salida_NO			CHAR(1);		/* Valor para no devolver una Salida */

	/* DECLARACION DE VARIABLES */
	DECLARE Var_Control			VARCHAR(50);
	
	/* ASIGNACION DE CONSTANTES */
	SET	Cadena_Vacia		:= '';				/* Cadena Vacia	 */
	SET	Entero_Cero			:= 0;				/* Entero en Cero */
	SET	Salida_SI			:= 'S';				/* Valor para devolver una Salida */
	SET	Salida_NO			:= 'N';				/* Valor para no devolver una Salida */
	SET	Decimal_Cero		:= 0.00;			/* Valor para devolver una Salida */
	SET Var_SI				:= 'S';				/* Valor SI */
	SET Var_NO				:= 'N';				/* Valor SI */
	SET	Fecha_Vacia			:= '1900-01-01';	/* Fecha Vacia */

	/* ASIGNACION DE VARIABLES */
	SET Aud_FechaActual		:=NOW();			-- Toma fecha actual --



	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operación. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTAMONFONALT');
			SET Var_Control := 'sqlException';
		END;

		-- Validacion de Campos Requeridos
		
		IF(IFNULL(Par_TipoFondeo, Cadena_Vacia) = Cadena_Vacia) THEN
			SET	Par_NumErr := 1;
			SET	Par_ErrMen := 'El tipo de fondeo esta Vacia.';
			SET Var_Control := 'tipoFondeo';
			LEAVE ManejoErrores;
		END IF;
		
		IF(IFNULL(Par_MonedaID, Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr := 2;
			SET	Par_ErrMen := 'El numero de la moneda esta Vacia.';
			SET Var_Control := 'monedaID';
			LEAVE ManejoErrores;
		END IF;
		
		IF(IFNULL(Par_SubCuenta, Cadena_Vacia) = Cadena_Vacia) THEN
			SET	Par_NumErr := 3;
			SET	Par_ErrMen := 'La sub cuenta esta Vacia.';
			SET Var_Control := 'subCuenta';
			LEAVE ManejoErrores;
		END IF;

		-- Se insertan los valores en la tabla de SUBCTAMONFON
		INSERT INTO SUBCTAMONFON(	ConceptoFonID,		TipoFondeo,			MonedaID,			SubCuenta,			EmpresaID,
									Usuario,			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
									NumTransaccion)
						VALUES(		Par_ConceptoFonID,	Par_TipoFondeo,		Par_MonedaID,		Par_SubCuenta,		Par_EmpresaID,
									Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
									Aud_NumTransaccion);


		SET Par_NumErr		:= 0;
		SET Par_ErrMen		:= 'SubCuenta Agregada Correctamente';
		SET Var_Control		:= 'ConceptoFonID' ;

	END ManejoErrores;  -- End del Handler de Errores

	IF (Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr 	AS NumErr,
				Par_ErrMen	AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$
