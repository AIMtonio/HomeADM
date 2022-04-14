-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISPLAZOSPORPRODUCTOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPLAZOSPORPRODUCTOSALT`;DELIMITER $$

CREATE PROCEDURE `HISPLAZOSPORPRODUCTOSALT`(
/* SP DE ALTA EN  HISTÓRICO DE PLAZOS POR PRODUCTOS */
	Par_TipoInstID				INT(11),		-- ID de la tabla TIPOINSTRUMENTOS.
	Par_TipoProductoID			INT(11),		-- Indica el tipo de Producto (TIPOSCEDES, TIPOSAPORTACIONES).
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),
	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),

	Aud_Sucursal				INT(11),
	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control		VARCHAR(25);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISPLAZOSPORPRODUCTOSALT');
			SET Var_Control:= 'sqlException' ;
		END;
	SET @Var_ConsID := (SELECT MAX(HisPlazoID) FROM HISPLAZOSPORPRODUCTOS);
	SET @Var_ConsID := IFNULL(@Var_ConsID, Entero_Cero);

	INSERT INTO HISPLAZOSPORPRODUCTOS (
		HisPlazoID,
		PlazoID,		Plazo,			TipoInstrumentoID,	TipoProductoID,	EmpresaID,
		Usuario,		FechaActual,	DireccionIP,		ProgramaID,		Sucursal,
		NumTransaccion)
	SELECT
		(@Var_ConsID := @Var_ConsID +1),
		PlazoID,		Plazo,			TipoInstrumentoID,	TipoProductoID,	EmpresaID,
		Usuario,		FechaActual,	DireccionIP,		ProgramaID,		Sucursal,
		NumTransaccion
	 FROM PLAZOSPORPRODUCTOS
		WHERE TipoInstrumentoID = Par_TipoInstID
			AND TipoProductoID = Par_TipoProductoID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Historico Guardado Exitosamente.');
	SET Var_Control:= 'tipoInstrumentoID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_TipoInstID AS Consecutivo;
END IF;

END TerminaStore$$