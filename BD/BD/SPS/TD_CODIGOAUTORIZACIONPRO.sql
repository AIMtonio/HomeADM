-- TD_CODIGOAUTORIZACIONPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TD_CODIGOAUTORIZACIONPRO`;

DELIMITER $$
CREATE PROCEDURE `TD_CODIGOAUTORIZACIONPRO`(
	-- Store Procedure para obtener el codigo de Autorizacion
	-- Modulo Tarjetas de Debito
	OUT Par_CodigoTransaccionID	CHAR(6),		-- Numero de Autorizacion

	INOUT Par_NumErr			INT(11),		-- Numero de Error
	INOUT Par_ErrMen			VARCHAR(400),	-- Mensaje de Error

	Aud_EmpresaID				INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,		-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_CodigoTransaccionID	INT(11);	-- Codigo de Autorizacion

	-- Declaracion de Constantes
	DECLARE Cadena_Cero				CHAR(1);	-- Constante Cadena Cero
	DECLARE Entero_Cero				INT(11);	-- Constante Entero Cero
	DECLARE Entero_Uno				INT(11);	-- Constante Entero Uno
	DECLARE Entero_Seis				INT(11);	-- Constante Entero Seis
	DECLARE Con_MaxNumAutoriacion	INT(11);	-- Constante Maximo Numero Permitido

	-- Asignavion de Constantes
	SET Cadena_Cero				:= '0';
	SET Entero_Cero				:= 0;
	SET Entero_Uno				:= 1;
	SET Entero_Seis				:= 6;
	SET Con_MaxNumAutoriacion	:= 999999;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 1299;
			SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-TD_CODIGOAUTORIZACIONPRO');
		END;

		SELECT	IFNULL(TransaccionID, Entero_Cero)
		INTO	Var_CodigoTransaccionID
		FROM TD_CODIGOAUTORIZACION
		FOR UPDATE;
		
		SET Var_CodigoTransaccionID := Var_CodigoTransaccionID + Entero_Uno;

		UPDATE TD_CODIGOAUTORIZACION SET
			TransaccionID = LAST_INSERT_ID(TransaccionID) + Entero_Uno
		WHERE RegistroID = Entero_Uno;

		IF( Var_CodigoTransaccionID = Con_MaxNumAutoriacion ) THEN
			UPDATE TD_CODIGOAUTORIZACION SET
				TransaccionID = Entero_Cero
			WHERE RegistroID = Entero_Uno;
		END IF;

		SET Par_CodigoTransaccionID := LPAD(CAST((SELECT LAST_INSERT_ID()) AS CHAR(6)),Entero_Seis, Cadena_Cero);

	END ManejoErrores;
	-- Fin del manejador de errores

END TerminaStore$$