-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDADJUNTOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDADJUNTOSBAJ`;DELIMITER $$

CREATE PROCEDURE `PLDADJUNTOSBAJ`(
	/*SP dar de baja los archivos adjuntos.*/
	Par_AdjuntoID 					INT(11),					# Numero de Archivo Adjunto
	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID					INT(11),
	Aud_Usuario						INT(11),
	Aud_FechaActual					DATETIME,
	Aud_DireccionIP					VARCHAR(15),
	Aud_ProgramaID					VARCHAR(50),
	Aud_Sucursal					INT(11),
	Aud_NumTransaccion				BIGINT(12)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Control				VARCHAR(50);				-- ID del Control en pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);				-- Value del Control de Pantalla

	-- Declaracion de constantes
	DECLARE Estatus_Activo			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);

	-- Asignacion de constantes
	SET Estatus_Activo			:= 'A';							-- Estatus Activo
	SET Entero_Cero				:=0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDADJUNTOSBAJ');
			SET Var_Control		:= 'sqlException' ;
		END;

		IF(IFNULL(Par_AdjuntoID,Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'El ID del Archivo Adjunto esta Vacio.';
			SET Var_Control	:= 'tipoProcesoID';
			LEAVE ManejoErrores;
		END IF;

		UPDATE PLDADJUNTOS SET
			Estatus = 'B'
			WHERE AdjuntoID = Par_AdjuntoID;

		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Archivo Eliminado Exitosamente.');
		SET Var_Control 	:= 'adjuntar' ;
		SET Var_Consecutivo	:= Par_AdjuntoID;

	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$