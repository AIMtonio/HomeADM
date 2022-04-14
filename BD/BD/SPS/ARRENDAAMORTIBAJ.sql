-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARRENDAAMORTIBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARRENDAAMORTIBAJ`;DELIMITER $$

CREATE PROCEDURE `ARRENDAAMORTIBAJ`(
	-- STORED PROCEDURE PARA DAR DE BAJA LAS AMORTIZACIONES DE ARRENDAMIENTOS
	Par_ArrendaID			BIGINT(12),			-- ID del arrendamiento
	Par_Salida				CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error

	Aud_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Control		VARCHAR(100);       -- Variable de control

	-- Declaracion de constantes
	DECLARE SalidaSI		CHAR(1); 			-- Salida Si

	-- Asignacion de constantes
	SET SalidaSI			:= 'S';				-- Salida Si

	ManejoErrores:BEGIN
			DECLARE EXIT HANDLER FOR SQLEXCEPTION
				BEGIN
					SET Par_NumErr  = 999;
					SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
											 'Disculpe las molestias que esto le ocasiona. Ref: SP-ARRENDAAMORTIBAJ');
					SET Var_Control = 'sqlException';
				END;

		DELETE FROM ARRENDAAMORTI WHERE	ArrendaID = Par_ArrendaID;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen 		:= CONCAT('Amortizaciones Eliminadas');

	END ManejoErrores;

		-- Se muestran los datos
	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr                  AS NumErr,
				Par_ErrMen                  AS ErrMen,
				Var_Control                 AS Control,
				LPAD(Par_ArrendaID, 10, 0) AS Consecutivo;
	END IF;

END TerminaStore$$