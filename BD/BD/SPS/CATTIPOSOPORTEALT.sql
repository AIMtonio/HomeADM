-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATTIPOSOPORTEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATTIPOSOPORTEALT`;DELIMITER $$

CREATE PROCEDURE `CATTIPOSOPORTEALT`(
	-- Registro de Tipos de Soporte
	Par_TipoSoporteID		INT(11),			-- Numero de Tipo de Soporte
    Par_Descripcion			VARCHAR(200),		-- Descripcion del Tipo de Soporte

	Par_Salida 				CHAR(1),			-- Indica si espera un SELECT de Salida
	INOUT Par_NumErr 		INT(11),			-- Numero de Error
	INOUT Par_ErrMen 		VARCHAR(400), 		-- Descripcion de Error

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

    -- Declaracion de Variables
	DECLARE Var_Control 		VARCHAR(100); 			-- Control de Errores
    DECLARE Var_Descripcion     VARCHAR(200);			-- Descripcion del Tipo de Soporte
    DECLARE Var_TipoSoporteID	INT(11);				-- Tipo de Soporte

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Fecha_Vacia 		DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Decimal_Cero 		DECIMAL(12,2);
	DECLARE Salida_SI 			CHAR(1);

	DECLARE Salida_NO 			CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia 			:= '';				-- Cadena vacia
	SET Fecha_Vacia 			:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero 			:= 0;				-- Entero cero
	SET Decimal_Cero 			:= 0.0;				-- Decimal cero
	SET Salida_SI 				:= 'S'; 			-- Salida: SI

	SET Salida_NO 				:= 'N'; 			-- Salida: NO

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					 'esto le ocasiona. Ref: SP-CATTIPOSOPORTEALT');

				SET Var_Control = 'SQLEXCEPTION' ;

			END;

            -- Se obtien la Descripcion del Tipo de Soporte para verificar si ya existe
            SET Var_Descripcion	:= (SELECT Descripcion FROM CATTIPOSOPORTE WHERE Descripcion = Par_Descripcion);

			IF (IFNULL(Par_Descripcion,Cadena_Vacia) = Cadena_Vacia)THEN
				SET Par_NumErr 	:= 001;
				SET Par_ErrMen 	:= 'La Descripcion del Soporte esta Vacia.';
				SET Var_Control	:= 'descripcion';
				LEAVE ManejoErrores;
			END IF;

			IF(Par_Descripcion = Var_Descripcion)THEN
				SET Par_NumErr 	:= 002;
				SET Par_ErrMen 	:= 'La Descripcion de Soporte ya Existe.';
				SET Var_Control	:= 'descripcion';
				LEAVE ManejoErrores;
			END IF;

             SET Aud_FechaActual := NOW();

            -- Se registra un nuevo Tipo de Soporte
            IF(Par_TipoSoporteID = Entero_Cero) THEN
				SET Var_TipoSoporteID      := (SELECT IFNULL(MAX(TipoSoporteID),Entero_Cero)+1 FROM CATTIPOSOPORTE);

				INSERT INTO CATTIPOSOPORTE (
					TipoSoporteID,			Descripcion,		EmpresaID,				Usuario,				FechaActual,
					DireccionIP,			ProgramaID,			Sucursal,				NumTransaccion)
				VALUES (
					Var_TipoSoporteID,		Par_Descripcion,	Par_EmpresaID,			Aud_Usuario,			Aud_FechaActual,
					Aud_DireccionIP,		Aud_ProgramaID,		Aud_Sucursal,			Aud_NumTransaccion);
			END IF;

			-- Se actualiza un Tipo de Soporte
            IF(Par_TipoSoporteID > Entero_Cero) THEN
				UPDATE CATTIPOSOPORTE SET
					Descripcion				= Par_Descripcion,

					EmpresaID				= Par_EmpresaID,
					Usuario					= Aud_Usuario,
					FechaActual				= Aud_FechaActual,
					DireccionIP				= Aud_DireccionIP,
					ProgramaID				= Aud_ProgramaID,
					Sucursal				= Aud_Sucursal,
					NumTransaccion			= Aud_NumTransaccion
				WHERE TipoSoporteID = Par_TipoSoporteID;
			END IF;

			IF(Par_TipoSoporteID = Entero_Cero)THEN
				SET Par_NumErr  := Entero_Cero;
				SET Par_ErrMen  := CONCAT("Tipo de Soporte Agregado Exitosamente: ",CONVERT(Var_TipoSoporteID, CHAR));
				SET Var_Control	:= 'tipoSoporteID';
                SET Par_TipoSoporteID := Var_TipoSoporteID;
			ELSE
				SET Par_NumErr  := Entero_Cero;
				SET Par_ErrMen  := CONCAT("Tipo de Soporte Modificado Exitosamente: ",CONVERT(Par_TipoSoporteID, CHAR));
				SET Var_Control	:= 'tipoSoporteID';
            END IF;

        END ManejoErrores;

        IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_TipoSoporteID AS consecutivo;
		END IF;

END TerminaStore$$