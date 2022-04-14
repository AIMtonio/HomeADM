-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARTALIQUIDACIONACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARTALIQUIDACIONACT`;
DELIMITER $$

CREATE PROCEDURE `CARTALIQUIDACIONACT`(
-- ========== SP PARA ACTUALIZAR LA CARTA DE LIQUIDACIÓN =============================================
	Par_CartaLiquidaID 			BIGINT(12),				-- Numero de carta de liquidacion
	Par_CreditoID				BIGINT(12),				-- CreditoID para la carta de liquidación
	Par_ArchivoIDCarta			INT(11),				-- Numero de Expediente de Credito
	Par_CodigoQR				MEDIUMBLOB,				-- QR de Carta de Liquidacion
	Par_TipoAct					TINYINT UNSIGNED,		-- Tipo de Actulizacion

	Par_Salida				CHAR(1),			-- Salida
	INOUT Par_NumErr		INT(11),			-- Numero de error
	INOUT Par_ErrMen		VARCHAR(400),		-- Mensaje de error

	-- Parametros de Auditoria
	Aud_EmpresaID			INT(11),			-- Empresa ID
	Aud_Usuario				INT(11),			-- Campo Auditoria
	Aud_FechaActual			DATETIME,			-- Campo Auditoria

	Aud_DireccionIP			VARCHAR(15),		-- Campo Auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Campo Auditoria
	Aud_Sucursal			INT(11),			-- Campo Auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Campo Auditoria
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_Control		VARCHAR(100);		-- Variable de Control

	-- Declaracion de constantes.
	DECLARE	Var_EstAct		CHAR(1);			-- Constante Estatus Activo
	DECLARE	Cadena_Vacia	CHAR(1);			-- Constante Cadena Vacia
	DECLARE	Entero_Cero		INT;				-- Constante Cero
	DECLARE	Salida_SI		CHAR(1);			-- Parametro de salida SI
	DECLARE	Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE Con_SI 			CHAR(1);			-- Contante S- Si
	DECLARE Con_TipActExp	INT(11);			-- Tipo de Actualizacion del Expediente
	DECLARE Con_TipActQR	INT(11);			-- Tipo de Actualizacion del QR

	-- Asiganacion de constantes
	SET	Var_EstAct			:= 'A';				-- Estatus activo
	SET	Cadena_Vacia		:= '';				-- Cadena vacia
	SET	Entero_Cero			:= 0;				-- Valor 0
	SET	Salida_SI			:= 'S';				-- Constante salida Si
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha vacia
	SET Con_SI				:= 'S';				-- Constante S - Si
	SET Con_TipActExp 		:= 1;				-- Tipo de Actualizacion del Expediente
	SET Con_TipActQR 		:= 2;				-- Tipo de Actualizacion del QR

	-- Asignacion de Variables
	SET	Var_Control			:= Cadena_Vacia;

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET	Par_NumErr	:= 999;
			SET	Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
							'Disculpe las molestias que esto le ocaciones. Ref: SP-CARTALIQUIDACIONACT');
			SET	Var_Control	:='SQLEXCEPTION';
		END;


		IF(IFNULL(Par_TipoAct,Entero_Cero)= Con_TipActExp )THEN

			-- Validar que el Par_ArchivoIDCarta exista para el Credito
			IF NOT EXISTS (SELECT DigCreaID
							FROM CREDITOARCHIVOS
							WHERE CreditoID 	= Par_CreditoID
							  AND DigCreaID		= Par_ArchivoIDCarta) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen 	:= 'El Expediente No Existe.';
				SET	Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			IF NOT EXISTS (SELECT CartaLiquidaID
							FROM CARTALIQUIDACION
							WHERE CartaLiquidaID = Par_CartaLiquidaID) THEN
				SET	Par_NumErr 	:= 002;
				SET	Par_ErrMen 	:= 'La Carta de Liquidacion No Existe';
				SET	Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE CARTALIQUIDACION SET
				ArchivoIDCarta = Par_ArchivoIDCarta
			WHERE CartaLiquidaID = Par_CartaLiquidaID;

		END IF;

		IF(IFNULL(Par_TipoAct,Entero_Cero) = Con_TipActQR )THEN

			IF NOT EXISTS (SELECT CartaLiquidaID
							FROM CARTALIQUIDACIONDET
							WHERE CartaLiquidaID = Par_CartaLiquidaID) THEN
				SET	Par_NumErr 	:= 001;
				SET	Par_ErrMen 	:= 'La Carta de Liquidacion No Existe';
				SET	Var_Control := 'creditoID';
				LEAVE ManejoErrores;
			END IF;

			UPDATE CARTALIQUIDACIONDET SET
				CodigoQR = Par_CodigoQR
			WHERE CartaLiquidaID = Par_CartaLiquidaID;
		END IF;

		SET	Par_NumErr  	:= 000;
		SET	Par_ErrMen  	:= CONCAT("Carta de Liquidación Actualizada Exitosamente: ", CONVERT(Par_CreditoID, CHAR));
		SET	Var_Control 	:= 'creditoID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT	Par_NumErr 			AS NumErr,
				Par_ErrMen 			AS ErrMen,
				Var_Control			AS Control,
				Par_CreditoID 		AS Consecutivo;
	END IF;

END TerminaStore$$