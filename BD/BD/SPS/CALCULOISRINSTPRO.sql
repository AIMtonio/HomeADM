-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CALCULOISRINSTPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CALCULOISRINSTPRO`;DELIMITER $$

CREATE PROCEDURE `CALCULOISRINSTPRO`(
# ====================================================================
# -------SP ENCARGADO DE INSERTAR LOS VENCIMIENTOS--------
# ====================================================================
	Par_Fecha			DATE,				-- Fecha De Registro
    Par_Cliente 		INT,				-- ID del Cliente
    Par_Proceso			CHAR(1),			-- Nombre del Proceso
    Par_Salida			CHAR(1),			-- Tipo de Salida.
    INOUT Par_NumErr	INT(11),			-- Numero de Error.
    INOUT Par_ErrMen	VARCHAR(400),    	-- Mensaje de Error.

    Par_EmpresaID		INT(11),			-- Parametro de Auditoria
    Aud_Usuario			INT(11),			-- Parametro de Auditoria
    Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP		VARCHAR(20),		-- Parametro de Auditoria
    Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal		INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
					)
TerminaStore : BEGIN

-- Declaracion de variables
DECLARE Var_Control		VARCHAR(50);		-- Control ID

-- Declaracion de constantes
DECLARE Entero_Uno 	 	INT;
DECLARE Entero_Cero	 	INT;
DECLARE SalidaSI	 	CHAR(1);
DECLARE SalidaNO	 	CHAR(1);

-- Asignacion de constantes
SET Entero_Uno			:= 1;					-- Entero en uno
SET Entero_Cero			:= 0;					-- Entero en cero
SET SalidaSI			:= 'S';					-- El Store si regresa una Salida
SET SalidaNO			:= 'N';					-- El Store no regresa una Salida

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CALCULOISRINSTPRO');
			SET Var_Control := 'sqlException';
		END;

    -- ====================== INSERTA UN REGISTRO EN LA TABLA CTESVENCIMIENTOS ======================

		INSERT INTO CTESVENCIMIENTOS(
				Fecha,				ClienteID,		EmpresaID,		UsuarioID,		FechaActual,
				DireccionIP,		ProgramaID,		Sucursal,   	NumTransaccion)
		SELECT	Par_Fecha,			Par_Cliente,	Par_EmpresaID,	Aud_Usuario,	Aud_FechaActual,
				Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,   Aud_NumTransaccion;

    -- ====================== REALIZA EL CALCULO DEL ISR Y DESPUES ELIMINA EL REGISTRO ======================

		CALL CALCULOISRPRO(	Par_Fecha,			Par_Fecha,		Entero_Uno,		Par_Proceso,		Par_Salida,
							Par_NumErr,			Par_ErrMen,		Par_EmpresaID,	Aud_Usuario,		Aud_FechaActual,
                            Aud_DireccionIP,	Aud_ProgramaID,	Aud_Sucursal,	Aud_NumTransaccion);

        DELETE FROM CTESVENCIMIENTOS WHERE NumTransaccion = Aud_NumTransaccion;


	   IF(Par_NumErr <> Entero_Cero)THEN
			LEAVE ManejoErrores;
		END IF;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT
			Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control;
	END IF;

END TerminaStore$$