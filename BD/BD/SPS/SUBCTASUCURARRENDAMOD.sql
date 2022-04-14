-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCTASUCURARRENDAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCTASUCURARRENDAMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCTASUCURARRENDAMOD`(
	-- SP para MODIFICACION de subcuenta de moneda DE ARRENDAMIENTO
	Par_ConceptoArrendaID	INT(5),			-- Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento',
	Par_SucursalID			INT(11),		-- Indica la SucursalID de arrendamiento
	Par_SubCuenta			VARCHAR(6),		-- Nomenclatura de la Arrendamiento'
	Par_Salida				CHAR(1),		-- Salida Si o No
	INOUT Par_NumErr		INT(11),		-- Control de Errores: Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Control de Errores: Descripcion del Error
	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),		-- Id de la empresa
	Aud_Usuario				INT(11),		-- Usuario
    Aud_FechaActual			DATETIME,	 	-- Fecha actual
	Aud_DireccionIP			VARCHAR(15), 	-- Direccion IP
	Aud_ProgramaID			VARCHAR(50), 	-- Id del programa
	Aud_Sucursal			INT(11),	 	-- Numero de sucursal
	Aud_NumTransaccion		BIGINT(20)   	-- Numero de transaccion
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE	Var_Control		VARCHAR(100);		-- Variable de control

	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);			-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;				-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);			-- Entero cero
	DECLARE	Var_SI			CHAR(1);			-- Valor si
	DECLARE	Var_NO			CHAR(1);			-- Valor no

	-- ASIGNACION DE CONSTANTES
	SET	Cadena_Vacia	:= '';				-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero		:= 0;				-- Entero en Cero
	SET	Var_SI			:= 'S';				-- Permite Salida SI
	SET	Var_NO			:= 'N';				-- Permite Salida NO


	-- ASIGNACION DE VARIABLES
	SET	Aud_FechaActual	:= NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET	Par_NumErr	= 999;
				SET	Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
														'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCTASUCURARRENDAMOD');
				SET	Var_Control	= 'sqlException';
			END;

		-- **************************************************************************************
		-- SE INSERTAN LOS VALORES EN LA TABLA DE SUBCTATIPROARRENDA  *******************
		-- **************************************************************************************

		UPDATE  SUBCTASUCURARRENDA SET
				SubCuenta		= Par_SubCuenta,
				EmpresaID		= Aud_EmpresaID,
				Usuario			= Aud_Usuario,
				FechaActual		= Aud_FechaActual,
				DireccionIP		= Aud_DireccionIP,
				ProgramaID		= Aud_ProgramaID,
				Sucursal		= Aud_Sucursal,
				NumTransaccion	= Aud_NumTransaccion
			WHERE	ConceptoArrendaID	= Par_ConceptoArrendaID
			  AND	SucursalID			= Par_SucursalID;

		SET	Par_NumErr	:= 000;
		SET	Var_Control	:= 'conceptoArrendaID';
		SET	Par_ErrMen	:= CONCAT('Sub Cuenta Modificada Exitosamente: ',Par_SubCuenta);

	END ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida	= Var_SI) THEN
		SELECT 	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control,
				Par_ConceptoArrendaID	AS Consecutivo;
	END IF;

END TerminaStore$$