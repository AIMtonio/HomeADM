-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DETALLEACCESORIOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `DETALLEACCESORIOSBAJ`;DELIMITER $$

CREATE PROCEDURE `DETALLEACCESORIOSBAJ`(
# =====================================================================================
# ----- SP QUE DA DE BAJA LOS ACCESORIOS COBRADOS POR UN CREDITO -----------------
# =====================================================================================
	Par_NumTransacSim	BIGINT(20),		-- Numero de Transaccion
	Par_Salida			CHAR(1),		-- Indica la Salida S:SI  N:NO
	INOUT Par_NumErr	INT(11),		-- Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Mensaje de Error

    # Parametros de Auditoria
    Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

    -- DECLARACION DE VARIABLES
	DECLARE Var_Control			VARCHAR(100);
    DECLARE Var_Consecutivo		VARCHAR(50);

	-- DECLARACION DE CONSTANTES
	DECLARE	Estatus_Activo	CHAR(1);
	DECLARE	Salida_Si		CHAR(1);
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
    DECLARE FormaFinanciada	CHAR(1); 	-- Forma Cobro Financiada

	-- ASIGNACION  DE CONSTANTES
	SET	Estatus_Activo	:= 'A';			-- Estatus Activo
	SET	Salida_Si		:= 'S';			-- Salida Si
	SET	Cadena_Vacia	:= '';			-- Cadena Vacía
	SET	Fecha_Vacia		:= '1900-01-01'; -- Fecha vacía defautl
	SET	Entero_Cero		:= 0;			-- Entero Cero
	SET FormaFinanciada	:= 'F';			-- Forma de cobro: FINANCIADA


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-DETALLEACCESORIOSBAJ');
			SET Var_Control := 'SQLEXCEPTION';
		END;

	IF(NOT EXISTS(SELECT NumTransacSim FROM DETALLEACCESORIOS
					WHERE NumTransacSim = Par_NumTransacSim
                     AND TipoFormaCobro = FormaFinanciada))THEN
		SET Par_NumErr      := 001;
		SET Par_ErrMen      :='No existen Accesorios para el credito indicado.' ;
		SET Var_Control  	:= '';
        SET Var_Consecutivo	:= '';
		LEAVE ManejoErrores;
	END IF;

	# SE ELIMINAN LOS ACCESORIOS DE LA TABLA
	DELETE FROM DETALLEACCESORIOS
	WHERE NumTransacSim = Par_NumTransacSim
    AND TipoFormaCobro = FormaFinanciada;

	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Accesorios con el Numero de Transaccion: ',CONVERT(Par_NumTransacSim, CHAR),' Eliminados Exitosamente.');
	SET Var_Consecutivo := '';

	END ManejoErrores;

	 IF(Par_Salida = Salida_Si) THEN
		SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
				Par_ErrMen 			AS ErrMen,
				Var_Control 		AS control,
				Var_Consecutivo 	AS consecutivo;
	END IF;

END TerminaStore$$