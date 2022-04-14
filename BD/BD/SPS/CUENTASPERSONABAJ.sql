-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASPERSONABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASPERSONABAJ`;DELIMITER $$

CREATE PROCEDURE `CUENTASPERSONABAJ`(
	Par_CuentaAhoID			BIGINT(12),
	Par_PersonaID			INT(13),
	Par_Salida				CHAR(1),
    INOUT	Par_NumErr		INT,
    INOUT	Par_ErrMen		VARCHAR(350),

	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT
	)
TerminaStore:BEGIN

# Declaracion de variables
DECLARE Var_EsFirmante	CHAR(1);		-- Si la persona dada de baja Es/No firmante

# Declaracion de Constantes
DECLARE Constante_No	CHAR(1);
DECLARE Num_Actualizar	TINYINT;
DECLARE Cancelado		CHAR(1);
DECLARE Cancelar		INT(11);
DECLARE Cadena_Vacia 	CHAR(1);
DECLARE VarControl		CHAR(15);		/* almacena el elemento que es incorrecto*/
DECLARE Str_SI			CHAR(1);
DECLARE Entero_Cero		INT(11);


#Asignacion Constantes
SET Cancelado			:='C';
SET Cancelar			:=3;
SET Cadena_Vacia		:= '';
SET Str_SI				:='S';
SET Entero_Cero			:=0;
SET Constante_No		:='N';
SET Num_Actualizar		:= 2;		-- opcion de Actualizacion del registro de firmas


ManejoErrores:BEGIN 	#bloque para manejar los posibles errores
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que',
								' esto le ocasiona. Ref: SP-CUENTASPERSONABAJ');
				SET VarControl = 'SQLEXCEPTION' ;
			END;
	/*-- VALIDACION DE CAMPOS OBLIGATORIOS */

	IF(Par_CuentaAhoID = Cadena_Vacia) THEN
		SET Par_NumErr   := 01;
		SET Par_ErrMen   := 'La Cuenta Esta Vacia';
		SET VarControl   := 'clienteID';
		LEAVE ManejoErrores;
	END IF;

IF(Par_PersonaID = Cadena_Vacia) THEN
		SET Par_NumErr   := 02;
		SET Par_ErrMen   := 'La Persona Esta Vacia';
		SET VarControl   := 'personaID';
		LEAVE ManejoErrores;
	END IF;

SELECT
	CP.EsFirmante
INTO
	Var_EsFirmante
FROM CUENTASPERSONA CP
WHERE CP.CuentaAhoID = Par_CuentaAhoID
AND CP.PersonaID = Par_PersonaID;

IF(Var_EsFirmante = Str_SI) THEN
	CALL FIRMASIMPRESIONFITPRO(Par_CuentaAhoID, Num_Actualizar, Constante_No, Par_NumErr, Par_ErrMen, Par_EmpresaID, Aud_Usuario, Aud_FechaActual,
    Aud_DireccionIP, Aud_ProgramaID, Aud_Sucursal, Aud_NumTransaccion );

	IF(Par_NumErr != Entero_Cero) THEN
		LEAVE ManejoErrores;
	END IF;

END IF;

UPDATE CUENTASPERSONA
	SET EstatusRelacion = Cancelado
	WHERE CuentaAhoID = Par_CuentaAhoID
	AND PersonaID = Par_PersonaID;

SET Par_NumErr  := 000;
	SET Par_ErrMen  := CONCAT('Persona Relacionada Eliminada Exitosamente');
	SET varControl	:= 'personaID';
END ManejoErrores; #fin del manejador de errores


IF (Par_Salida = Str_SI) THEN
	SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
			Par_ErrMen	 AS ErrMen,
			varControl	 AS control,
			Entero_Cero	 AS consecutivo;
END IF;

END TerminaStore$$