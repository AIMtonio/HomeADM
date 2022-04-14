
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINTERPREOBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINTERPREOBAJ`;

DELIMITER $$
CREATE PROCEDURE `PLDOPEINTERPREOBAJ`(
/* DA DE BAJA LAS OPERACIONES INTERNAS PREOCUPANTES. */
	Par_PeriodoInicio			DATE,			-- Fecha de Inicio del Periodo a Reportar.
	Par_PeriodoFin				DATE,			-- Fecha Final del Periodo a Reportar.
	Par_Salida           		CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,			-- Numero de Validación.
	INOUT Par_ErrMen     		VARCHAR(400),	-- Mensaje de Validación.

	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

# DECLARACIÓN DE CONSTANTES.
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Str_SI			CHAR(1);
DECLARE	Str_NO			CHAR(1);
DECLARE Estatus_Rep		INT(11);

# ASIGNACIÓN DE CONSTANTES.
SET Entero_Cero  := 0;			-- Entero Cero.
SET Decimal_Cero := 0.00;		-- Decimal Cero.
SET Cadena_Vacia := '';			-- Cadena Vacia.
SET Str_SI		 := 'S';		-- Constante SI.
SET Str_NO		 := 'N';		-- Constante NO.
SET Estatus_Rep	 := 3;			-- Estatus de la operación: Reportado.

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		GET DIAGNOSTICS condition 1
		@Var_SQLState = RETURNED_SQLSTATE, @Var_SQLMessage = MESSAGE_TEXT;
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEINTERPREOBAJ[',@Var_SQLState,'-' , @Var_SQLMessage,']');
		END;

	DELETE FROM PLDOPEINTERPREO
	WHERE Estatus = Estatus_Rep
		AND Fecha BETWEEN Par_PeriodoInicio AND Par_PeriodoFin;

	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Registros Eliminados Correctamente.');

END ManejoErrores;

IF(Par_Salida = Str_SI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			'bajaControl' AS control,
			Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$

