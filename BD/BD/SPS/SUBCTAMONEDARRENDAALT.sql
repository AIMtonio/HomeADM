-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTAMONEDARRENDAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTAMONEDARRENDAALT`;DELIMITER $$

CREATE PROCEDURE `SUBCTAMONEDARRENDAALT`(
	-- SP para alta de subcuenta de moneda DE ARRENDAMIENTO
	Par_ConceptoArrendaID	INT(5),				-- Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
	Par_MonedaID			INT(11),			-- Indica la moneda de arrendamiento
	Par_SubCuenta			VARCHAR(6),			-- Nomenclatura de la Arrendamiento'
	Par_Salida				CHAR(1),			-- Salida Si o No
	INOUT Par_NumErr		INT(11),			-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),		-- Control de Errores: Descripcion del Error
	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),			-- Id de la empresa
	Aud_Usuario				INT(11),			-- Usuario
    Aud_FechaActual			DATETIME,	 		-- Fecha actual
	Aud_DireccionIP			VARCHAR(15), 		-- Direccion IP
	Aud_ProgramaID			VARCHAR(50), 		-- Id del programa
	Aud_Sucursal			INT(11),	 		-- Numero de sucursal
	Aud_NumTransaccion		BIGINT(20)   		-- Numero de transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(100);	-- Variable de control
	DECLARE Var_ConceptoArrendaID	INT(11);		-- concepto de arrendamiento


	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);	-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;		-- Fecha vacia
	DECLARE Entero_Cero			INT(11);	-- Entero cero
	DECLARE Var_SI				CHAR(1);	-- Variable SI
	DECLARE Var_NO				CHAR(1);	-- Variable NO


	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia	:= '';				-- Cadena Vacia
	SET Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero		:= 0;				-- Entero en Cero
	SET Var_SI			:= 'S';				-- Permite Salida SI
	SET Var_NO			:= 'N';				-- Permite Salida NO


	-- ASIGNACION DE VARIABLES
	SET Aud_FechaActual         := NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr 	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
														'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTAMONEDARRENDAALT');
				SET Var_Control	= 'sqlException';
			END;

		SET	Par_ConceptoArrendaID	= IFNULL(Par_ConceptoArrendaID,Entero_Cero);
		IF (Par_ConceptoArrendaID	= Entero_Cero) THEN
			SET Par_NumErr		:= 001;
			SET Var_Control		:= 'conceptoArrendaID';
			SET Par_ErrMen		:= CONCAT('El Concepto de Arrendamiento esta Vacio ');
			LEAVE ManejoErrores;
		END IF;

		SET	Var_ConceptoArrendaID	:= (SELECT	ConceptoArrendaID
											FROM	CONCEPTOSARRENDA
											WHERE	ConceptoArrendaID	= Par_ConceptoArrendaID);
		IF (Var_ConceptoArrendaID	= Entero_Cero) THEN
			SET Par_NumErr	:= 002;
			SET Var_Control	:= 'conceptoArrendaID';
			SET Par_ErrMen	:= CONCAT('El Concepto de Arrendamiento no Existe ');
			LEAVE ManejoErrores;
		END IF;

		IF (Par_MonedaID	= Entero_Cero) THEN
			SET Par_NumErr	:= 003;
			SET Var_Control	:= 'monedaID';
			SET Par_ErrMen	:= CONCAT('La Moneda esta vacia ');
			LEAVE ManejoErrores;
		END IF;

		-- **************************************************************************************
		-- SE INSERTAN LOS VALORES EN LA TABLA DE SUBCTATIPROARRENDA  *******************
		-- **************************************************************************************

		INSERT	INTO	SUBCTAMONEDARRENDA(
			ConceptoArrendaID,		MonedaID,			SubCuenta,		EmpresaID,		Usuario,
			FechaActual,			DireccionIP,		ProgramaID,		Sucursal,		NumTransaccion
		)
		VALUES (
			Par_ConceptoArrendaID,	Par_MonedaID,		Par_SubCuenta,	Aud_EmpresaID,	Aud_Usuario,
			Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion
		);


		SET	Par_NumErr	:= 000;
		SET	Var_Control	:= 'conceptoArrendaID';
		SET	Par_ErrMen	:= CONCAT('SubCuenta MonedaAgregada Exitosamente: ',Par_SubCuenta);

	END	ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida	= Var_SI) THEN
		SELECT 	Par_NumErr				AS NumErr,
				Par_ErrMen 				AS ErrMen,
				Var_Control				AS Control,
				Par_ConceptoArrendaID	AS Consecutivo;
	END IF;

END TerminaStore$$