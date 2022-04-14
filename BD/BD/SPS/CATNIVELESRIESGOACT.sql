-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CATNIVELESRIESGOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CATNIVELESRIESGOACT`;DELIMITER $$

CREATE PROCEDURE `CATNIVELESRIESGOACT`(
  -- SP Para actualizar valores de el catalogo de niveles de riesgos
	Par_NivelRiesgoID         CHAR(1),			-- ID del nivel de riesgo a actualizar
	Par_TipoPersona					CHAR(1),				-- Tipo de Persona
	Par_Minimo                TINYINT(4),		-- Porcentaje minimo para considerarse em determinado nivel
	Par_Maximo                TINYINT(4),		-- Porcentaje maximo para considerarse em determinado nivel
	Par_SeEscala              CHAR(1),			-- Causa o no escalonamiento interno
	Par_Estatus               CHAR(1),			-- Estatus del nivel de Riesgo

	Par_Salida                CHAR(1),			-- El sp genera una salida
	INOUT Par_NumErr          INT(11),			-- Parametro de salida con numero de error
	INOUT Par_ErrMen          VARCHAR(400),		-- Parametro de salida con el mensaje de error
	Par_EmpresaID             INT(11),			-- Parametros de auditoria
	Aud_Usuario               INT(11),			-- Auditoria

	Aud_FechaActual           DATETIME,			-- Auditoria
	Aud_DireccionIP           VARCHAR(15),		-- Auditoria
	Aud_ProgramaID            VARCHAR(50),		-- Auditoria
	Aud_Sucursal              INT(11),			-- Auditoria
	Aud_NumTransaccion        BIGINT(20)		-- Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);		-- Control
	DECLARE Var_NumTransaccion		BIGINT(20);			-- Obtiene el numero de transaccion anterior

		-- Declaracion de constantes
	DECLARE NuevoCodigoNiveles		INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE SalidaSI				CHAR(1);
	DECLARE RiesgoAltoID			CHAR(1);
	DECLARE RiesgoBajoID			CHAR(1);
	DECLARE SalidaNO				CHAR(1);
	DECLARE Clientes_Activos		INT(11);
	DECLARE TipoPers_Fisica 		CHAR(1);			-- Tipo de Persona Fisica
	DECLARE TipoPers_ActFisica 		CHAR(1);			-- Tipo de Persona Fisica con Act Empresarial
	DECLARE TipoPers_Moral 			CHAR(1);			-- Tipo de Persona Moral
	DECLARE TipoPers_Todas 			CHAR(1);			-- Todos los Tipos de Persona

	SET NuevoCodigoNiveles			:= (SELECT CodigoNiveles FROM CATNIVELESRIESGO LIMIT 1)+1;	-- Se actualiza el codigo de niveles
	SET Cadena_Vacia				:= '' ;				-- Cadena o string vacio
	SET Entero_Cero					:= 0 ;				-- Entero en cero
	SET SalidaSI					:= 'S';				-- El Store SI genera una Salida
	SET RiesgoAltoID				:= 'A';				-- Identificador del Nivel de riesgo alto
	SET RiesgoBajoID				:= 'B';				-- Identificador del Nivel de riesgo Bajo
	SET SalidaNO					:= 'N';				-- El Store NO genera una Salida
	SET Clientes_Activos			:= 1;				-- Para Actualizar Clientes Activos
	SET TipoPers_Fisica				:= 'F';
	SET TipoPers_ActFisica			:= 'A';
	SET TipoPers_Moral				:= 'M';
	SET TipoPers_Todas				:= 'T';

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
          BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                  'Disculpe las molestias que esto le ocasiona. Ref: SP-CATNIVELESRIESGOACT');
            SET Var_Control = 'sqlException' ;
          END;

    IF(IFNULL(Par_NivelRiesgoID, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 001;
        SET Par_ErrMen  := 'El ID del Nivel de Riesgo ID Esta Vacio';
        SET Var_Control := 'nivelRiesgoID';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Minimo , Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 002;
        SET Par_ErrMen  := 'El Porcentaje Minimo esta Vacio';
        SET Var_Control := 'minimo';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Maximo, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 003;
        SET Par_ErrMen  := 'El Porcentaje Maximo esta Vacio';
        SET Var_Control := 'maximo';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_SeEscala, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 004;
        SET Par_ErrMen  := 'Indique si la Operacion se Escala';
        SET Var_Control := 'seEscala';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_SeEscala, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr  := 004;
        SET Par_ErrMen  := 'Indique si la Operacion se Escala';
        SET Var_Control := 'seEscala';
        LEAVE ManejoErrores;
    END IF;

    IF Par_NivelRiesgoID = RiesgoAltoID AND Par_Maximo<>100 THEN
        SET Par_NumErr  := 005;
				SET Par_ErrMen	:= 'El Valor Máximo del Nivel de Riesgo Alto debe ser 100';
        SET Var_Control := 'maximoM';
        LEAVE ManejoErrores;
    END IF;

    IF Par_NivelRiesgoID = RiesgoBajoID AND Par_Minimo<>0 THEN
        SET Par_NumErr  := 006;
				SET Par_ErrMen	:= 'El Valor Minimo del Nivel de Riesgo Bajo debe ser 0';
        SET Var_Control := 'maximoM';
        LEAVE ManejoErrores;
    END IF;

		IF (Par_TipoPersona = Cadena_Vacia) THEN
				SET Par_NumErr	:= 007;
				SET Par_ErrMen	:= 'El Tipo de Persona esta Vacio.';
				SET Var_Control := 'tipoPersona';
				LEAVE ManejoErrores;
		END IF;

        #SOLO SI EL NUMERO DE TRANSACCION ES DISTINTA INSERTA EN HISTORICO
		# Inserta en el historico del catalogo de niveles de riesgo
		IF(Par_TipoPersona = TipoPers_Todas) THEN
				SET Var_NumTransaccion := (SELECT NumTransaccion
											FROM CATNIVELESRIESGO
												WHERE TipoPersona = Par_TipoPersona
													ORDER BY CodigoNiveles ASC LIMIT 1);
			IF (Var_NumTransaccion <> Aud_NumTransaccion) THEN
				INSERT INTO HISCATNIVELESRIESGO(
					CodigoNiveles,		NivelRiesgoID,		TipoPersona,			Descripcion,		Minimo,
					Maximo,				SeEscala,			Estatus,				EmpresaID,			Usuario,
					FechaActual,		DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion)
					SELECT
					CodigoNiveles,		NivelRiesgoID,		TipoPersona,			Descripcion,		Minimo,
					Maximo,				SeEscala,			Estatus,				EmpresaID,			Usuario,
					FechaActual,		DireccionIP,		ProgramaID,				Sucursal,			NumTransaccion
					FROM CATNIVELESRIESGO;

				UPDATE CATNIVELESRIESGO SET
					CodigoNiveles=NuevoCodigoNiveles,
					NumTransaccion=Aud_NumTransaccion;
			END IF;
		  ELSE
				SET Var_NumTransaccion := (SELECT NumTransaccion
												FROM CATNIVELESRIESGO
													WHERE TipoPersona = Par_TipoPersona
													ORDER BY CodigoNiveles ASC LIMIT 1);
				IF (Var_NumTransaccion <> Aud_NumTransaccion) THEN
					INSERT INTO HISCATNIVELESRIESGO(
						CodigoNiveles,			NivelRiesgoID,		Descripcion,			Minimo,				Maximo,
						SeEscala,				Estatus,			EmpresaID,				Usuario,			FechaActual,
						DireccionIP,			ProgramaID,			Sucursal,				NumTransaccion)
						SELECT
							CodigoNiveles,		NivelRiesgoID,		Descripcion,			Minimo,					Maximo,
							SeEscala,			Estatus,			EmpresaID,				Usuario,				FechaActual,
							DireccionIP,		ProgramaID,			Sucursal,				NumTransaccion
							FROM CATNIVELESRIESGO
								WHERE TipoPersona = Par_TipoPersona;

					UPDATE CATNIVELESRIESGO SET
						CodigoNiveles=NuevoCodigoNiveles,
						NumTransaccion=Aud_NumTransaccion
						WHERE TipoPersona = Par_TipoPersona;
				END IF;
		END IF;
		# Realiza la actualizacion

		IF(Par_TipoPersona = TipoPers_Todas) THEN
			UPDATE CATNIVELESRIESGO SET
				Minimo					= Par_Minimo,
				Maximo					= Par_Maximo,
				SeEscala				= Par_SeEscala,
				Estatus					= Par_Estatus,
				EmpresaID				= Par_EmpresaID,
				Usuario					= Aud_Usuario,
				FechaActual				= Aud_FechaActual,
				DireccionIP				= Aud_DireccionIP,
				ProgramaID				= Aud_ProgramaID,
				Sucursal				= Aud_Sucursal
				WHERE
					NivelRiesgoID	= Par_NivelRiesgoID;
		  ELSE
			UPDATE CATNIVELESRIESGO SET
				Minimo				= Par_Minimo,
				Maximo				= Par_Maximo,
				SeEscala			= Par_SeEscala,
				Estatus				= Par_Estatus,
				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal
				WHERE
					NivelRiesgoID	= Par_NivelRiesgoID
					AND TipoPersona = Par_TipoPersona;
		END IF;

		SET Par_NumErr	:= 000;
		SET Par_ErrMen	:= 'Niveles de Riesgo Actualizados Exitosamente';
		SET Var_Control := 'codigoNivelID';
	END ManejoErrores;	-- END del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Entero_Cero	AS Consecutivo;
	END IF;
END TerminaStore$$