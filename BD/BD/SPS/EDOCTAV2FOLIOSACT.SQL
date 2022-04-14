-- SP EDOCTAV2FOLIOSACT
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2FOLIOSACT;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2FOLIOSACT`(
	-- Stored procedure para actualizar el folio de la tabla EDOCTAV2FOLIOS
	INOUT Par_FolioEDOCTA	BIGINT(20),			-- Folio generado en el estado de cuenta
	Par_NumAct				TINYINT UNSIGNED,	-- Indica el tipo de actualizacion que se realizara
	Par_Salida				CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr		INT(11),			-- Parametro que corresponde a un numero de exito o error
	INOUT Par_ErrMen		VARCHAR(400),		-- Parametro que corresponde a un mensaje de exito o error
	Par_EmpresaID			INT(11),			-- Parametros de Auditoria
	Aud_Usuario				INT(11),			-- Parametros de Auditoria
	Aud_FechaActual			DATETIME,			-- Parametros de Auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametros de Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametros de Auditoria
	Aud_Sucursal			INT(11),			-- Parametros de Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametros de Auditoria
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control		VARCHAR(50);		-- Variable de Control

	-- Declaracion de Constantes.
	DECLARE Cadena_Vacia	CHAR(1);			-- Cadena Vacia
	DECLARE Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE Entero_Cero		INT(11);			-- Entero Cero
	DECLARE Var_SalidaSI	CHAR(1);			-- Salida si
	DECLARE Var_ActFolio	TINYINT UNSIGNED;	-- Actualizacion del folio generado en el estado de cuenta

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET	Var_SalidaSI		:= 'S';				-- Salida si
	SET	Var_ActFolio		:= 1;				-- Actualizacion del folio generado en el estado de cuenta

	-- Valores por default
	SET Par_EmpresaID		:= IFNULL(Par_EmpresaID, Entero_Cero);
	SET Aud_Usuario			:= IFNULL(Aud_Usuario, Entero_Cero);
	SET Aud_FechaActual		:= IFNULL(Aud_FechaActual, Fecha_Vacia);
	SET Aud_DireccionIP		:= IFNULL(Aud_DireccionIP, Cadena_Vacia);
	SET Aud_ProgramaID		:= IFNULL(Aud_ProgramaID, Cadena_Vacia);
	SET Aud_Sucursal		:= IFNULL(Aud_Sucursal, Entero_Cero);
	SET Aud_NumTransaccion	:= IFNULL(Aud_NumTransaccion, Entero_Cero);

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2FOLIOSACT');
			SET Var_Control	= 'sqlException';
		END;

		-- Actualizacion del folio generado en el estado de cuenta
		IF Par_NumAct = Var_ActFolio THEN
			UPDATE EDOCTAV2FOLIOS SET
				FolioEDOCTA			= FolioEDOCTA + 1,
				EmpresaID			= Par_EmpresaID,
				Usuario				= Aud_Usuario,
				FechaActual			= Aud_FechaActual,
				DireccionIP			= Aud_DireccionIP,
				ProgramaID			= Aud_ProgramaID,
				Sucursal			= Aud_Sucursal,
				NumTransaccion		= Aud_NumTransaccion;

			SELECT		IFNULL(FolioEDOCTA, Entero_Cero)
				INTO	Par_FolioEDOCTA
				FROM	EDOCTAV2FOLIOS;

			SET Par_NumErr	:= Entero_Cero;
			SET Par_ErrMen	:= CONCAT('Folio actualizado exitosamente: ', CAST(Par_FolioEDOCTA AS CHAR));
			SET Var_Control	:= 'FolioEDOCTA';
			LEAVE ManejoErrores;
		END IF;
	END ManejoErrores; -- Fin del bloque manejo de errores

	IF (Par_Salida = Var_SalidaSI) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_Control			AS control,
				Par_FolioEDOCTA	AS consecutivo;
	END IF;
END TerminaStore$$
