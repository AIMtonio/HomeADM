-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PAGOXREFERENCIAVAL
DELIMITER ;
DROP PROCEDURE IF EXISTS `PAGOXREFERENCIAVAL`;DELIMITER $$

CREATE PROCEDURE `PAGOXREFERENCIAVAL`(
	/*SP PARA LA VALIDACIÓN DEL ABONO A CTA POR PAGO POR REFERENCIA.*/
	Par_TransaccionID 				BIGINT(20),					# Número de Transaccion
	Par_CuentaAhoID 				BIGINT(12),					# Número de Cuenta de Ahorro que hizo el pago
	Par_Referencia 					VARCHAR(20),				# Número de Referencia de Pago
	Par_Monto 						DECIMAL(16,2),				# Monto de Pago
	Par_Salida						CHAR(1),					# Indica el tipo de salida S.- SI N.- No
	INOUT Par_NumErr				INT,						# Numero de Error
	INOUT Par_ErrMen				VARCHAR(400),				# Mensaje de Error
	OUT Par_CreditoID				BIGINT(12),
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
	DECLARE Var_Consecutivo 		VARCHAR(200);				-- Numero consecutivo para la imagen a digitalizar
	DECLARE Var_FechaRegistro 		DATE;						-- Fecha en la que se digitalizo el Archivo
	DECLARE Var_ClienteID			INT(11);					-- Número de Cliente
	DECLARE Var_CreditoID			BIGINT(12);					-- Número de Credito
	DECLARE Var_FechaSistema		DATE;
	DECLARE Var_PagoxReferencia		CHAR(1);
	DECLARE Var_CuentaAhoID			BIGINT(12);
	-- Declaracion de constantes
	DECLARE Estatus_Pendiente			CHAR(1);
	DECLARE Entero_Cero				INT(11);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Cons_NO					CHAR(1);
	DECLARE SalidaSi				CHAR(1);

	-- Asignacion de constantes
	SET Estatus_Pendiente		:= 'P';							-- Estatus Activo
	SET Entero_Cero				:=0;							-- Entero Cero
	SET Cadena_Vacia			:= '';							-- Cadena Vacia
	SET Cons_NO					:= 'N';							-- Constante No
	SET SalidaSi				:= 'S';							-- Salida Si
	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr		:= 999;
			SET Par_ErrMen		:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOXREFERENCIAVAL');
			SET Var_Control		:= 'sqlException' ;
		END;
		SET Var_PagoxReferencia := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro='PagosXReferencia');
		SET Par_Referencia 		:= IFNULL(Par_Referencia,Cadena_Vacia);

		IF(Var_PagoxReferencia = 'S') THEN
			SET Var_FechaSistema	:= (SELECT FechaSistema FROM PARAMETROSSIS);
			SELECT
				CRED.CreditoID,				CRED.ClienteID,		CRED.CuentaID
				INTO
				Var_CreditoID,				Var_ClienteID,		Var_CuentaAhoID
				FROM CREDITOS AS CRED
					WHERE CRED.ReferenciaPago = Par_Referencia
						AND CRED.CuentaID = Par_CuentaAhoID;

			IF(IFNULL(Var_CuentaAhoID,Cadena_Vacia) != Par_CuentaAhoID) THEN
				SET Par_NumErr := 2;
				SET Par_ErrMen := 'La Referencia no Corresponde con la Cuenta del Credito.';
				SET Var_Control 	:= 'referencia' ;
				SET Var_Consecutivo	:= Par_Referencia;
				LEAVE ManejoErrores;
			ELSE
				SET Par_CreditoID := Var_CreditoID;-- Referencia para bloqueos
				SET	Par_NumErr		:= 001;
				SET	Par_ErrMen		:= CONCAT('El Abono a Cta bloqueado exitosamente.');
				SET Var_Control 	:= 'referencia' ;
				SET Var_Consecutivo	:= Par_Referencia;
				LEAVE ManejoErrores;
			END IF;
		END IF;
		SET	Par_NumErr		:= 000;
		SET	Par_ErrMen		:= CONCAT('Continua Proceso.');
		SET Var_Control 	:= 'referencia' ;
		SET Var_Consecutivo	:= Par_Referencia;
	END ManejoErrores;

	IF(Par_Salida = SalidaSi) THEN
		SELECT 	Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$