-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORARRENDAMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORARRENDAMOD`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORARRENDAMOD`(
	-- SP para ALTA DE ARRENDAMIENTO
	Par_ConceptoArrendaID		INT(5),			-- Identificador de la cuenta mayor, debe corresponder con un concepto de arrendamiento
	Par_Cuenta					CHAR(4),		-- Capital de la cuenta de Arrendamiento
	Par_Nomenclatura			VARCHAR(30),	-- Nomenclatura de Arrendamiento
	Par_NomenclaturaCR			VARCHAR(30),	-- Nomenclatura de Arrendamiento DE CENTRO DE COSTOS

	Par_Salida					CHAR(1),		-- Salida Si o No
	INOUT Par_NumErr			INT(11),		-- Control de Errores: Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Control de Errores: Descripcion del Error

	Aud_EmpresaID				INT(11),		-- Parametro de Auditoria
	Aud_Usuario					INT(11),		-- Parametro de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal				INT(11),		-- Parametro de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(100);	-- Variable de control

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);		-- Cadena vacia
	DECLARE Fecha_Vacia			DATE;			-- Fecha vacia
	DECLARE Entero_Cero			INT(11);		-- Entero cero
	DECLARE Var_SI				CHAR(1);		-- Permite Salida Si
	DECLARE Var_NO				CHAR(1);		-- Permite Salida No

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia			:= '';				-- Cadena Vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero				:= 0;				-- Entero en Cero
	SET Var_SI					:= 'S';				-- Permite Salida SI
	SET Var_NO					:= 'N';				-- Permite Salida NO


	-- ASIGNACION DE VARIABLES
	SET Aud_FechaActual			:= NOW();

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASMAYORARRENDAMOD');
			SET Var_Control = 'sqlException';
		END;

		-- Se actualizan los valores en la tabla de CUENTASMAYORARRENDA
		UPDATE CUENTASMAYORARRENDA SET
			Cuenta			= Par_Cuenta,
			Nomenclatura	= Par_Nomenclatura,
			NomenclaturaCR	= Par_NomenclaturaCR,
			EmpresaID		= Aud_EmpresaID,
			Usuario			= Aud_Usuario,
			FechaActual		= Aud_FechaActual,
			DireccionIP		= Aud_DireccionIP,
			ProgramaID		= Aud_ProgramaID,
			Sucursal		= Aud_Sucursal,
			NumTransaccion	= Aud_NumTransaccion
		WHERE	ConceptoArrendaID = Par_ConceptoArrendaID;

		SET Par_NumErr	:= 000;
		SET Var_Control	:= 'conceptoArrendaID';
		SET Par_ErrMen	:= CONCAT('Cuenta Mayor Modificada Exitosamente: ',Par_ConceptoArrendaID);

	END ManejoErrores;

	-- Se muestran los datos
	IF (Par_Salida = Var_SI) THEN
		SELECT	Par_NumErr				AS NumErr,
				Par_ErrMen				AS ErrMen,
				Var_Control				AS Control,
				Par_ConceptoArrendaID	AS Consecutivo;
	END IF;

END TerminaStore$$