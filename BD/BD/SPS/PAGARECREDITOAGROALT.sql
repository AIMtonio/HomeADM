-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGARECREDITOAGROALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGARECREDITOAGROALT`;
DELIMITER $$

CREATE PROCEDURE `PAGARECREDITOAGROALT`(
/*SP que realiza el respaldo de las amortizaciones creadas en el desembolso del credito agropecuario*/
	Par_CreditoID			BIGINT(12),					# Numero de Credito
	Par_Salida				CHAR(1),					# Salida S:Si N:No
	INOUT Par_NumErr		INT(11),					# Numero de Error
	INOUT Par_ErrMen		VARCHAR(400),				# Mensaje de Salida
	/*Parametros de Auditoria*/
	Aud_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore:BEGIN
	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(20);	-- Campo para el id del control de pantalla
	DECLARE Var_Consecutivo			VARCHAR(50);	-- Valor del consecutivo
	-- Declaracion de Constantes
	DECLARE SalidaSI				CHAR(1);
	DECLARE Entero_Cero				INT;

	-- Asignacion de Constantes
	SET SalidaSI			:='S';		-- Salida SI
	SET Entero_Cero			:=0;		-- entero Cero

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGARECREDITOAGROALT');
			SET Var_Control:= 'sqlException';
		END;

		-- Respaldo de la informacion  de la tabla AMORTICREDITO despues del desembolso
		/*Actualizamos el capital de las amortizaciones actuales*/
		UPDATE PAGARECREDITO AS Pag
			INNER JOIN AMORTICREDITO AS Amo ON Pag.CreditoID =Amo.CreditoID AND Amo.AmortizacionID = Pag.AmortizacionID
		SET
			Pag.Capital		= Amo.Capital,
			Pag.Interes		= Amo.Interes,
			Pag.IVAInteres	= Amo.IVAInteres
		WHERE Pag.CreditoID	= Par_CreditoID;

		/*Se insertan las amortizaciones que aun no existen en la tabla del PAGARECREDITO*/
		INSERT INTO PAGARECREDITO (
			AmortizacionID,			CreditoID,				ClienteID,				CuentaID,			FechaInicio,
			FechaVencim,			FechaExigible,			Capital,				Interes,			IVAInteres,
			EmpresaID,				Usuario,				FechaActual,			DireccionIP,		ProgramaID,
			Sucursal,				NumTransaccion)
		SELECT
			Amo.AmortizacionID,		Amo.CreditoID,			Amo.ClienteID,			Amo.CuentaID,		Amo.FechaInicio,
			Amo.FechaVencim,		Amo.FechaExigible,		Amo.Capital,			Amo.Interes,		Amo.IVAInteres,
			Amo.EmpresaID,			Amo.Usuario,			Amo.FechaActual,		Amo.DireccionIP,	Amo.ProgramaID,
			Amo.Sucursal,			Amo.NumTransaccion
		FROM AMORTICREDITO AS Amo
			LEFT JOIN PAGARECREDITO AS Pag ON Amo.CreditoID = Pag.CreditoID AND Amo.AmortizacionID = Pag.AmortizacionID
		WHERE Amo.CreditoID =Par_CreditoID
			AND Pag.CreditoID IS NULL;/*Mientras la amortizacion aun no exista en el pagare se inserta*/

		SET Par_NumErr := 000;
		SET Par_ErrMen := CONCAT('Pagare Registrado Exitosamente para el Credito: ',Par_CreditoID);
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