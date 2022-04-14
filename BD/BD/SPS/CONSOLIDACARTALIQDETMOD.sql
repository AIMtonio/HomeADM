-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONSOLIDACARTALIQDETMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS CONSOLIDACARTALIQDETMOD;

DELIMITER $$
CREATE PROCEDURE CONSOLIDACARTALIQDETMOD(
-- SP MODIFICA EL ID DEL ARCHIVO EN EL EXPEDIENTE DE LAS CARTAS DE LIQUIDACION INTERNAS

	Par_ConsolidaCartaID		INT(11),		-- Consecutivo de consolidación de acuerdo con la solicitud de crédito
	Par_CartaLiquidaID			INT(11),		-- Identificador de la carta interna
	Par_ArchivoCartaID			INT(11),		-- ID de la Carga de Archivo de Carta de Liquidacion Tab SOLICITUDARCHIVOS

	Par_Salida					CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error
 	-- Parametros de Auditoria
	Par_EmpresaID				INT(11),		-- Parametros de Auditoria
	Aud_Usuario					INT(11),		-- Parametros de Auditoria
	Aud_FechaActual				DATETIME,		-- Parametros de Auditoria
	Aud_DireccionIP				VARCHAR(15),	-- Parametros de Auditoria
	Aud_ProgramaID				VARCHAR(50),	-- Parametros de Auditoria
	Aud_Sucursal				INT(11),		-- Parametros de Auditoria
	Aud_NumTransaccion			BIGINT(20)		-- Parametros de Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		VARCHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT(11);
	DECLARE	SalidaSI			CHAR(1);
	DECLARE	SalidaNO			CHAR(1);
	DECLARE Con_Interna			CHAR(1);
	DECLARE Var_Control			VARCHAR(25);

	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena vacia
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET	SalidaSI				:= 'S';				-- Salida Si
	SET	SalidaNO				:= 'N'; 			-- Salida No
	set Con_Interna				:= 'I';

	SET	Aud_FechaActual	:= CURRENT_TIMESTAMP();

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-ASIGNACARTALIQALT');
			SET Var_Control:= 'sqlException' ;
		END;


		IF(IFNULL(Par_ConsolidaCartaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 001;
			SET Par_ErrMen := 'La consolidación esta Vacia.';
			SET Var_Control:= 'consolidaCartaID' ;
			LEAVE ManejoErrores;
		END IF;


		IF(IFNULL(Par_ArchivoCartaID, Entero_Cero) = Entero_Cero) THEN
			SET Par_NumErr := 002;
			SET Par_ErrMen := 'El ID del archivo no puede ser cero.';
			SET Var_Control:= 'archivoCartaID' ;
			LEAVE ManejoErrores;
		END IF;

			UPDATE CONSOLIDACARTALIQDET
			   SET ArchivoIDCarta		= Par_ArchivoCartaID
			 WHERE CartaLiquidaID		= Par_CartaLiquidaID
			   AND TipoCarta			= Con_Interna
			   AND ConsolidaCartaID		= Par_ConsolidaCartaID;

		SET	Par_NumErr := Entero_Cero;
		SET	Par_ErrMen := 'Carta de Liquidacion Interna Modificada Correctamente';
		SET Var_Control:= 'consolidaCartaID' ;

END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_ConsolidaCartaID AS Consecutivo;
	END IF;

END TerminaStore$$
