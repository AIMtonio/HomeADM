-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISGRUPOSFAMALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISGRUPOSFAMALT`;DELIMITER $$

CREATE PROCEDURE `HISGRUPOSFAMALT`(
/* SP DE ALTA EN  HISTÓRICO DE GRUPOS FAMILIARES */
	Par_ClienteID				BIGINT(12),		-- ID del Cliente a quien le pertenece el grupo.
	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Par_EmpresaID				INT(11),

	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),

	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE	Var_Control     CHAR(15);

-- Declaracion de Constantes
DECLARE	Cadena_Vacia	VARCHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT(11);
DECLARE	SalidaSI        CHAR(1);
DECLARE	SalidaNO        CHAR(1);

-- Asignacion de Constantes
SET Cadena_Vacia		:= '';				-- Cadena vacia
SET Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
SET Entero_Cero			:= 0;				-- Entero Cero
SET	SalidaSI        	:= 'S';				-- Salida Si
SET	SalidaNO        	:= 'N'; 			-- Salida No
SET Aud_FechaActual 	:= NOW();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-HISGRUPOSFAMALT');
			SET Var_Control:= 'sqlException' ;
		END;
	SET @Var_GpoFamID := (SELECT MAX(GruposFamID) FROM HISGRUPOSFAM WHERE ClienteID = Par_ClienteID);
	SET @Var_GpoFamID := IFNULL(@Var_GpoFamID, Entero_Cero);

	INSERT INTO HISGRUPOSFAM (
		GruposFamID,
		ClienteID,			FamClienteID,		TipoRelacionID,		EmpresaID,		UsuarioID,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion)
	SELECT
		(@Var_GpoFamID := @Var_GpoFamID +1),
		ClienteID,			FamClienteID,		TipoRelacionID,		EmpresaID,		UsuarioID,
		FechaActual,		DireccionIP,		ProgramaID,			Sucursal,		NumTransaccion
	 FROM GRUPOSFAM
		WHERE ClienteID = Par_ClienteID;

	SET	Par_NumErr := Entero_Cero;
	SET	Par_ErrMen := CONCAT('Historico Guardado Exitosamente.');
	SET Var_Control:= 'clienteID' ;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr AS NumErr,
			Par_ErrMen AS ErrMen,
			Var_Control AS Control,
			Par_ClienteID AS Consecutivo;
END IF;

END TerminaStore$$