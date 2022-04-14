-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- MINISTRACREDAGROBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `MINISTRACREDAGROBAJ`;DELIMITER $$

CREATE PROCEDURE `MINISTRACREDAGROBAJ`(
	/*SP para dar de Baja las Ministraciones de Creditos Agropecuario*/
	Par_SolicitudCreditoID		BIGINT(12),				# Numero de Solicitud de Credito
	Par_CreditoID				BIGINT(20),				# Numero de Credito
	Par_ClienteID				INT(11),				# Numero de Cliente
	Par_ProspectoID				INT(11),				# Numero de Prospecto

	Par_Salida					CHAR(1),				# Tipo de Salida S. Si N. No
	INOUT	Par_NumErr			INT(11),				# Numero de Error
	INOUT	Par_ErrMen			VARCHAR(400),			# Mensaje de Error
	/*Parametros de Auditoria*/
	Aud_EmpresaID				INT(11),

	Aud_Usuario					INT(11),
	Aud_FechaActual				DATETIME,
	Aud_DireccionIP				VARCHAR(15),
	Aud_ProgramaID				VARCHAR(50),
	Aud_Sucursal				INT(11),

	Aud_NumTransaccion			BIGINT(20)
)
TerminaStore:BEGIN

	-- Declaracion de variables
	DECLARE Var_Control				VARCHAR(50);			# Variable con el ID del control de Pantalla
	DECLARE Var_FechaSistema		DATE;					# Fecha Actual del Sistema

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia			CHAR(1);				# Cadena Vacia
	DECLARE	Fecha_Vacia				DATE;					# Fecha Vacia
	DECLARE	Entero_Cero				INT;					# Entero Cero
	DECLARE	Decimal_Cero			DECIMAL;				# Decimal Cero
	DECLARE	SalidaNo				CHAR(1);				# Constante SI
	DECLARE	SalidaSi				CHAR(1);				# Constante NO

	-- Asignacion de Constantes
	SET	Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET	Entero_Cero					:= 0;
	SET	SalidaSi					:= 'S';

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-MINISTRACREDAGROBAJ');
			SET Var_Control := 'sqlException';
		END;

		SET Par_SolicitudCreditoID		:= IFNULL(Par_SolicitudCreditoID, Entero_Cero);
		SET Par_CreditoID				:= IFNULL(Par_CreditoID, Entero_Cero);
		SET Par_ClienteID				:= IFNULL(Par_ClienteID, Entero_Cero);
		SET Par_ProspectoID				:= IFNULL(Par_ProspectoID, Entero_Cero);

		IF(Par_SolicitudCreditoID>Entero_Cero) THEN
			DELETE FROM MINISTRACREDAGRO
				WHERE
				SolicitudCreditoID = Par_SolicitudCreditoID/* AND (CreditoID IS NULL OR CreditoID = Entero_Cero)*/ ;
			IF(Par_ClienteID > Entero_Cero) THEN
				DELETE FROM MINISTRACREDAGRO
					WHERE
					ClienteID = Par_ClienteID AND (CreditoID IS NULL OR CreditoID = Entero_Cero) AND (SolicitudCreditoID IS NULL OR SolicitudCreditoID = Entero_Cero);
			END IF;
		ELSEIF(Par_CreditoID>Entero_Cero) THEN
			DELETE FROM MINISTRACREDAGRO
				WHERE
				CreditoID = Par_CreditoID;
				IF(Par_ClienteID > Entero_Cero) THEN
					DELETE FROM MINISTRACREDAGRO
						WHERE
						ClienteID = Par_ClienteID AND (CreditoID IS NULL OR CreditoID = Entero_Cero) AND (SolicitudCreditoID IS NULL OR SolicitudCreditoID = Entero_Cero);
			END IF;
		ELSEIF(Par_ClienteID>Entero_Cero AND Par_SolicitudCreditoID=Entero_Cero AND Par_CreditoID = Entero_Cero) THEN
			DELETE FROM MINISTRACREDAGRO
				WHERE
				ClienteID = Par_ClienteID AND (CreditoID IS NULL OR CreditoID = Entero_Cero) AND (SolicitudCreditoID IS NULL OR SolicitudCreditoID = Entero_Cero);
		ELSEIF(Par_ProspectoID>Entero_Cero AND Par_SolicitudCreditoID=Entero_Cero AND Par_CreditoID = Entero_Cero) THEN
			DELETE FROM MINISTRACREDAGRO
				WHERE
				ProspectoID = Par_ProspectoID AND (CreditoID IS NULL OR CreditoID = Entero_Cero) AND (SolicitudCreditoID IS NULL OR SolicitudCreditoID = Entero_Cero);
		END IF;

		SET Par_NumErr	:= 0;
		SET Par_ErrMen	:=CONCAT('Ministraciones Eliminadas Exitosamente.');

	END ManejoErrores;

	IF(Par_Salida=SalidaSi)THEN
		SELECT	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Par_SolicitudCreditoID AS Consecutivo,
				'agrega' AS Control;
	END IF;
END TerminaStore$$