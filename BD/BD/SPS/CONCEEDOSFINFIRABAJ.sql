-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCEEDOSFINFIRABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCEEDOSFINFIRABAJ`;DELIMITER $$

CREATE PROCEDURE `CONCEEDOSFINFIRABAJ`(
/* SP DE ALTA EN EL CATALOGO DE CONCEPTOS REPORTES FINANCIEROS PARA FIRA */
	Par_EstadoFinanID			INT(11),			# ID del Reporte Financiero, corresponde a TIPOSESTADOSFINAN.
	Par_NumClien				INT(11),			# Identificador del Cliente
	Par_Salida           		CHAR(1),			# Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr     		INT,				# Numero de Error
	INOUT Par_ErrMen     		VARCHAR(400),		# Mensaje de Error

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
DECLARE	Var_Control     CHAR(15);
DECLARE	Var_ConsecID	INT(11);

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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-CONCEEDOSFINFIRABAJ');
			SET Var_Control:= 'sqlException' ;
		END;

	DELETE FROM CONCEEDOSFINFIRA
		WHERE EstadoFinanID = Par_EstadoFinanID
			AND NumClien = Par_NumClien;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := 'Conceptos Grabados Exitosamente.';
	SET Var_Control:= 'paisID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Par_EstadoFinanID AS Consecutivo;
END IF;

END TerminaStore$$