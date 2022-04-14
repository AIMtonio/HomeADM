-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FIRMASIMPRESIONFITALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `FIRMASIMPRESIONFITALT`;DELIMITER $$

CREATE PROCEDURE `FIRMASIMPRESIONFITALT`(
# ==================================================================================
# ---------- PROCEDIMIENTO PARA DAR DE ALTA A LA TABLA FIRMASIMPRESIONFIT ----------
# ==================================================================================
	Par_CuentaAhoID				BIGINT(12),		-- ID de la cuenta de Ahorro
	Par_Fecha 					DATE,			-- Fecha de Impresion

	Par_Salida    				CHAR(1), 		-- Manejo de Errores
	INOUT	Par_NumErr 			INT(11),		-- Manejo de Errores
	INOUT	Par_ErrMen  		VARCHAR(400),	-- Manejo de Errores

    Par_EmpresaID       		INT,			-- Parametro de Auditoria
    Aud_Usuario         		INT,			-- Parametro de Auditoria
    Aud_FechaActual     		DATETIME,		-- Parametro de Auditoria
    Aud_DireccionIP     		VARCHAR(15),	-- Parametro de Auditoria
    Aud_ProgramaID      		VARCHAR(50),	-- Parametro de Auditoria
    Aud_Sucursal        		INT(11),		-- Parametro de Auditoria
    Aud_NumTransaccion  		BIGINT			-- Parametro de Auditoria
	)
TerminaStore: BEGIN

# Declaracion de variables
DECLARE Var_Control             VARCHAR(200);   -- Manejo de Errores
DECLARE Var_Consecutivo         INT(11);        -- Manejo de Errores


# Declaracion de Constantes
DECLARE Cadena_Vacia 			CHAR(1);
DECLARE Str_SI                  CHAR(1);


#Asignacion Constantes
SET Cadena_Vacia := '';
SET Str_SI              :=  'S';



ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = '999';
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operación. Disculpe las molestias que ',
									'esto le ocasiona. Ref: SP-FIRMASIMPRESIONFITALT ');
				SET Var_Control = 'SQLEXCEPTION' ;
			END;
	/*-- VALIDACION DE CAMPOS OBLIGATORIOS */

	IF(Par_CuentaAhoID = Cadena_Vacia) THEN
		SET Par_NumErr   := 01;
		SET Par_ErrMen   := 'La Cuenta Esta Vacia';
		SET Var_Control   := 'clienteID';
		LEAVE ManejoErrores;
	END IF;



	INSERT INTO FIRMASIMPRESIONFIT(
		CuentaAhoID,			FechaImpresion,			FechaModificacion,			EmpresaID,
		Usuario,				FechaActual,			DireccionIP,				ProgramaID,
		Sucursal,				NumTransaccion)
	VALUES(Par_CuentaAhoID,		Par_Fecha,				Par_Fecha,					Par_EmpresaID,
		Aud_Usuario,			Aud_FechaActual,		Aud_DireccionIP,			Aud_ProgramaID,
		Aud_Sucursal,			Aud_NumTransaccion);



	SET Par_NumErr      := 0;
	SET Par_ErrMen      := CONCAT('Registro de Frimas Exitoso');
	SET Var_Control     := 'CuentaAhoID';
	SET Var_Consecutivo := 0;
END ManejoErrores; #fin del manejador de errores


IF (Par_Salida = Str_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			Var_Control	 AS control,
			Entero_Cero	 AS consecutivo;
END IF;

END TerminaStore$$