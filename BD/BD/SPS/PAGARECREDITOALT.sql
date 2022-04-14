-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGARECREDITOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGARECREDITOALT`;

DELIMITER $$
CREATE PROCEDURE `PAGARECREDITOALT`(
	-- Store Procedure que realiza el Alta del Pagare de Credito
	-- Modulo: Cartera
	-- Pantalla Cartera --> Registro --> Pagare Credito
	Par_CreditoID			BIGINT(12),		-- Parametro Credito ID
	Par_Salida				CHAR(1),		-- Parametro de Salida

	OUT Par_NumErr			INT(11),		-- Parametro Numero de Error
	OUT Par_ErrMen			VARCHAR(400),	-- Parametro Mensaje de Error

	Par_EmpresaID			INT(11),		-- Parametro de Auditoria Empresa ID
	Aud_Usuario				INT(11),		-- Parametro de Auditoria Usuario ID
	Aud_FechaActual			DATETIME,		-- Parametro de Auditoria Fecha Actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de Auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de Auditoria Programa ID
	Aud_Sucursal			INT(11),		-- Parametro de Auditoria Sucursal ID
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de Auditoria Numero de Transaccion
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(20);	-- Campo para el id del control de pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);	-- Valor del consecutivo
	DECLARE Var_CliEspecifico		INT(11);		-- Numero de Cliente Especifico

	-- Declaracion de Constantes
	DECLARE SalidaSI				CHAR(1);		-- Constante Salida SI
	DECLARE Entero_Cero				INT(11);		-- Constante Entero Cero
	DECLARE Con_ClienteConsol		INT(11);		-- Cliente Especifico Consol

	-- Asignacion de Constantes
	SET SalidaSI			:= 'S';
	SET Entero_Cero			:= 0;
	SET Con_ClienteConsol	:= 10;

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGARECREDITOALT');
			SET Var_Control:= 'sqlException';
		END;



		SET Var_CliEspecifico	:= (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CliProcEspecifico');

		IF( IFNULL(Var_CliEspecifico, Entero_Cero) = Con_ClienteConsol) THEN
			IF EXISTS (SELECT CreditoID FROM PAGARECREDITO WHERE CreditoID = Par_CreditoID LIMIT 1) THEN
				DELETE FROM PAGARECREDITO WHERE CreditoID = Par_CreditoID;
			END IF;
		END IF;

		-- Respaldo de la informacion  de la tabla AMORTICREDITO despues del desembolso
		INSERT INTO  PAGARECREDITO (
				AmortizacionID,		CreditoID,			ClienteID,			CuentaID,			FechaInicio,
				FechaVencim,		FechaExigible,		Capital,			Interes,			IVAInteres,
				EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion)
		SELECT 	AmortizacionID,		CreditoID,			ClienteID,			CuentaID,			FechaInicio,
				FechaVencim,		FechaExigible,		Capital,			Interes,			IVAInteres,
				EmpresaID,			Usuario,			FechaActual,		DireccionIP,		ProgramaID,
				Sucursal,			NumTransaccion
		FROM AMORTICREDITO
		WHERE CreditoID =Par_CreditoID;

		SET Par_NumErr 	:= 000;
		SET Par_ErrMen 	:= CONCAT('Pagare Registrado Exitosamente para el Credito: ',Par_CreditoID);
		SET Var_Control := 'creditoID';
		SET Var_Consecutivo := Par_CreditoID;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$