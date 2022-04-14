-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PARAMETROSPDMMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `PARAMETROSPDMMOD`;
DELIMITER $$

CREATE PROCEDURE `PARAMETROSPDMMOD`(
-- Modificacion Parametros Pademobile
	Par_EmpresaID			INT(11),			-- Numero de Empresa
    Par_NombreServicio		VARCHAR(50),		-- Nombre de Servicio
    Par_NumeroPreguntas		INT(11),			-- Numero de Preguntas
    Par_NumeroRespuestas	INT(11),			-- Numero de Respuestas

    Par_Salida 				CHAR(1),			-- Indica si espera un SELECT de Salida
	INOUT Par_NumErr 		INT(11),			-- Numero de Error
	INOUT Par_ErrMen 		VARCHAR(400), 		-- Descripcion de Error

	Aud_Usuario				INT(11),			-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control 		VARCHAR(100); 		-- Control de Errores
    DECLARE Var_NumPreguntas	INT(11);			-- Numero de Preguntas Registradas
    DECLARE Var_DesRegistroPDM 	VARCHAR(50);		-- Desplegado Registro PDM
	DECLARE Var_DesConsultaPDM 	VARCHAR(50);		-- Desplegado Consulta PDM
	DECLARE Var_DesParametroPDM	VARCHAR(50);		-- Desplegado Parametro PDM
    DECLARE Var_DesSeguimientoPDM VARCHAR(50);		-- Desplegado para Seguimiento
    DECLARE Var_DesRepSeguimientoPDM VARCHAR(50);	-- Desplegado para el reporte de seguimientos
	-- Declaracion de Constantes
	DECLARE Cadena_Vacia 		CHAR(1);
	DECLARE Fecha_Vacia 		DATE;
	DECLARE Entero_Cero			INT(11);
	DECLARE Salida_SI 			CHAR(1);
	DECLARE Salida_NO 			CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia 			:= '';				-- Cadena vacia
	SET Fecha_Vacia 			:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero 			:= 0;				-- Entero cero
	SET Salida_SI 				:= 'S'; 			-- Salida: SI
	SET Salida_NO 				:= 'N'; 			-- Salida: NO

	ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
					 'esto le ocasiona. Ref: SP-PARAMETROSPDMMOD');

				SET Var_Control = 'SQLEXCEPTION' ;

			END;

            -- Se obtien el Numero de Preguntas Registradas
            SET Var_NumPreguntas	:= (SELECT COUNT(PreguntaID) FROM CATPREGUNTASSEG);

			SET Aud_FechaActual := NOW();

            IF(Par_NumeroPreguntas > Var_NumPreguntas)THEN
				SET Par_NumErr 	:= 001;
				SET Par_ErrMen 	:= 'El Numero de Preguntas es Mayor a las Preguntas Registradas.';
				SET Var_Control	:= 'numeroPreguntas';
				LEAVE ManejoErrores;
            END IF;

            -- Se modifican los Parametros de Pademobile
            UPDATE PARAMETROSPDM SET
				NombreServicio		= Par_NombreServicio,
				NumeroPreguntas		= Par_NumeroPreguntas,
				NumeroRespuestas	= Par_NumeroRespuestas,

				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion
			WHERE EmpresaID = Par_EmpresaID;

			-- Se obtienen los deplegados: Registros, Consultas y Parametros PDM para actualizar el desplegado con el nombre del Servicio Definido.
            SET Var_DesRegistroPDM 	:= (SELECT SUBSTR(Desplegado,1,8) FROM OPCIONESMENU WHERE OpcionMenuID = 639);
			SET Var_DesConsultaPDM 	:= (SELECT SUBSTR(Desplegado,1,19) FROM OPCIONESMENU WHERE OpcionMenuID = 642);
			SET Var_DesParametroPDM := (SELECT SUBSTR(Desplegado,1,7) FROM OPCIONESMENU WHERE OpcionMenuID = 838);
			SET Var_DesSeguimientoPDM := (SELECT SUBSTR(Desplegado,1,22) FROM OPCIONESMENU WHERE OpcionMenuID = 1060);
            SET Var_DesRepSeguimientoPDM := (SELECT SUBSTR(Desplegado,1,20) FROM OPCIONESMENU WHERE OpcionMenuID = 1061);
            -- Actualiza el desplegado del Registro PDM
            UPDATE OPCIONESMENU SET
				Desplegado = CONCAT(Var_DesRegistroPDM,Par_NombreServicio)
			WHERE OpcionMenuID = 639;

            -- Actualiza el desplegado de Consulta PDM
			UPDATE OPCIONESMENU SET
				Desplegado = CONCAT(Var_DesConsultaPDM,Par_NombreServicio)
			WHERE OpcionMenuID = 642;

            -- Actualiza el desplegado del Parametro PDM
			UPDATE OPCIONESMENU SET
				Desplegado = CONCAT(Var_DesParametroPDM,Par_NombreServicio)
                WHERE OpcionMenuID = 838;

			-- Actualiza el desplegado del Parametro PDM
			UPDATE OPCIONESMENU SET
				Desplegado = CONCAT(Var_DesSeguimientoPDM,Par_NombreServicio)
                WHERE OpcionMenuID = 1060;

			-- Actualiza el desplegado del Parametro PDM
			UPDATE OPCIONESMENU SET
				Desplegado = CONCAT(Var_DesRepSeguimientoPDM,Par_NombreServicio)
                WHERE OpcionMenuID = 1061;

			SET Par_NumErr  := Entero_Cero;
			SET Par_ErrMen  := 'Parametros Modificados Exitosamente.';
            SET Var_Control := 'nombreServicio';

		END ManejoErrores;

         IF (Par_Salida = Salida_SI) THEN
			SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen,
					Var_Control AS control,
					Par_NombreServicio AS consecutivo;
		END IF;
END TerminaStore$$