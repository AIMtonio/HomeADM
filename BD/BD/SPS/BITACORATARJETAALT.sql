-- BITACORATARJETAALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORATARJETAALT`;
DELIMITER $$

CREATE PROCEDURE `BITACORATARJETAALT`(

	Par_NumTransaccion		BIGINT(20),		-- Numero de la Transaccion
	Par_NumTarjeta          VARCHAR(19),	-- Numero de la Tarjeta
	Par_CVV					CHAR(3),		-- Digito de seguridad
	Par_FechaVen			DATETIME,		-- Fecha de Vencimiento
	Par_FechaHora			DATETIME,		-- Fecha y Hora del Registro

	Par_Salida				CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr		INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN


-- Declaracion de Variables
DECLARE	Var_Control     CHAR(15);        -- Control de Retorno en pantalla
DECLARE	Var_Consecutivo INT(11);         -- Id de la tabla

-- Declaracion de Constantes
DECLARE	Entero_Cero		INT(11);         -- Entero cero
DECLARE	SalidaSI        CHAR(1);         -- Salida SI
DECLARE	Cadena_Vacia	CHAR(1);	     -- Cadena vacia
DECLARE Var_ID			BIGINT(20);		 -- Consecutivo de la Tabla

SET Entero_Cero			:= 0;	         -- Entero cero
SET	SalidaSI        	:= 'S';			 -- Salida SI
SET	Cadena_Vacia	    := '';           -- Cadena vacia


ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BITACORATARJETAALT');
			SET Var_Control:= 'sqlException' ;
		END;

		IF(IFNULL(Par_NumTransaccion,Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr  := 001;
			SET Par_ErrMen  := 'El Numero  de Transaccion esta vacio.';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_NumTarjeta,Cadena_Vacia) = Cadena_Vacia ) THEN
			SET Par_NumErr  := 002;
			SET Par_ErrMen  := 'El Numero de la Tarjeta esta Vacia';
			SET Var_Control	:= Cadena_Vacia;
			LEAVE ManejoErrores;
		END IF;

	   SET Var_ID := (SELECT MAX(BitacoraID) FROM BITACORATARJETA);
	   SET Var_ID := IFNULL(Var_ID, Entero_Cero);
	   SET Var_ID := Var_ID + 1;

	   INSERT INTO BITACORATARJETA(
			BitacoraID,			 Transaccion, 			Fecha, 				NumTarjeta, 		EmpresaID,
			Usuario, 			 FechaActual, 			DireccionIP, 		ProgramaID, 		Sucursal,
			NumTransaccion)
		VALUES
			(Var_ID,	 		Par_NumTransaccion,		Par_FechaHora,		Par_NumTarjeta,		Aud_EmpresaID,
	        Aud_Usuario,		 Aud_FechaActual,		Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
	        Aud_NumTransaccion);

		SET	Par_NumErr := Entero_Cero;
	    SET	Par_ErrMen :=CONCAT('Registro Insertado Correctamente');
	    SET Var_Control:= Cadena_Vacia;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS Control,
			Var_Consecutivo AS Consecutivo;
END IF;

END TerminaStore$$
