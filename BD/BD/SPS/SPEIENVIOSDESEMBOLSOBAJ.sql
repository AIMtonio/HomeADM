-- SP SPEIENVIOSDESEMBOLSOBAJ

DELIMITER ;

DROP PROCEDURE IF EXISTS `SPEIENVIOSDESEMBOLSOBAJ`;

DELIMITER $$

CREATE PROCEDURE `SPEIENVIOSDESEMBOLSOBAJ`(
	-- SP que realiza la baja a la tabla SPEIENVIOSDESEMBOLSO que ayuda a realizar movimientos de pagos por SPEI
	Par_FolioSpeiID					BIGINT(20),				-- ID desembolso de un envio SPEI

	Par_Salida						CHAR(1),				-- Parametro para salida de datos
	INOUT Par_NumErr				INT(11),				-- Parametro de entrada/salida de numero de error
	INOUT Par_ErrMen				VARCHAR(400),			-- Parametro de entrada/salida de mensaje de control de respuesta de acuerdo al desarrollador

	Aud_EmpresaID 					INT(11),				-- Parametros de auditoria
	Aud_Usuario						INT(11),				-- Parametros de auditoria
	Aud_FechaActual					DATETIME,				-- Parametros de auditoria
	Aud_DireccionIP					VARCHAR(15),			-- Parametros de auditoria
	Aud_ProgramaID					VARCHAR(50),			-- Parametros de auditoria
	Aud_Sucursal					INT(11), 				-- Parametros de auditoria
	Aud_NumTransaccion				BIGINT(20)				-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(400);			-- Variable de control

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);				-- Entero cero
	DECLARE Cadena_Vacia			CHAR(1);				-- Cadena vacia
	DECLARE Var_SalidaSI			CHAR(1);				-- Salida si

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;					-- Asignacion de entero cero
	SET Cadena_Vacia				:= '';					-- Asignacion de cadena vacia
	SET Var_SalidaSI				:= 'S';					-- Salida si

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr  = 999;
			SET Par_ErrMen  = CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref:SP- SPEIENVIOSDESEMBOLSOBAJ');
			SET Var_Control = 'sqlException';
		END;

		IF(IFNULL(Par_FolioSpeiID, Entero_Cero))= Entero_Cero THEN
			SET Par_NumErr 	:= 001;
			SET Par_ErrMen 	:= 'El Folio SPEI se encuentra vacio';
			SET Var_Control := 'FolioSpeiID' ;
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM SPEIENVIOSDESEMBOLSO
			WHERE FolioSPEI = Par_FolioSpeiID;

		SET Par_NumErr := 0;
		SET Par_ErrMen 	:= CONCAT(" El SPEI por Desembolso se ha dado de baja exitosamente: ", CONVERT(Par_FolioSpeiID, CHAR));
		SET Var_Control := 'FolioSpei';

	END ManejoErrores;

	IF (Par_Salida = Var_SalidaSI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control;
	END IF;

END TerminaStore$$