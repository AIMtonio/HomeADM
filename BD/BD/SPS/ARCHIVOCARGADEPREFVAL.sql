-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ARCHIVOCARGADEPREFVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `ARCHIVOCARGADEPREFVAL`;DELIMITER $$

CREATE PROCEDURE `ARCHIVOCARGADEPREFVAL`(
	/* VALIDACIÓN DEL ARCHIVO DE CARGA PARA DEPÓSITOS REFERENCIADOS. */
	Par_InstitucionID	    INT(12),		-- InstitucionID
	Par_ReferenciaMov		VARCHAR(150),	-- Referencia del movimiento
	Par_Salida				CHAR(1),		-- Indica Salida
	INOUT Par_NumErr		INT(11),		-- Inout NumErr

	INOUT Par_ErrMen		VARCHAR(400),	-- Inout ErrMen
	/* Parámetros de Auditoría. */
	Par_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN

-- Declaracion de Constantes
DECLARE Var_Control		VARCHAR(50);

-- Declaracion de Constantes
DECLARE SalidaSi		CHAR(1);
DECLARE TipoValTres		INT(1);
DECLARE TipoValCuatro	INT(1);
DECLARE TipoCanal		INT(1);

-- Asignacion de Constantes
SET SalidaSi			:='S';			-- Constante Salida SI
SET TipoValTres			:= 3;
SET TipoValCuatro		:= 4;
SET TipoCanal			:= 2;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ARCHIVOCARGADEPREFVAL');
			SET Var_Control:= 'sqlException' ;
		END;

	-- Si la la validación ya existe en la tabla CARGAARCHIVOSDEPREFER
	IF EXISTS (SELECT NumVal FROM ARCHIVOCARGADEPREF
				WHERE InstitucionID=Par_InstitucionID
					AND ReferenciaMov=Par_ReferenciaMov AND TipoCanal=TipoCanal
					AND NumVal IN (TipoValTres,TipoValCuatro) LIMIT 1)THEN
		SET Par_NumErr := 10;
		SET Par_ErrMen := 'La Referencia ya Está Registrada en la Tabla Temporal con una Validación Repetida';
		LEAVE ManejoErrores;
	END IF;

	SET Par_NumErr := 0;
	SET Par_ErrMen := 'Validacion Exitosa.';

END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				'InstitucionID' AS control,
				0 AS consecutivo;
	END IF;

END TerminaStore$$