-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREGARPRENHIPOACT
DELIMITER ;
DROP PROCEDURE IF EXISTS CREGARPRENHIPOACT;

DELIMITER $$
CREATE PROCEDURE `CREGARPRENHIPOACT`(
	-- Store Procedure: De Actualizacion para los Creditos con Garantias Prendarias o Hipotecarias
	-- Modulo Guarda Valores
	Par_GarantiaID      		INT(11),		-- Numero de la garantia(ID de Tabla)
	Par_NumActualizacion		TINYINT UNSIGNED,	-- Numero de Actualizacion

	Par_Salida					CHAR(1),		-- Parametro de Salida
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
	DECLARE Var_Control			VARCHAR(100);	-- Variable de Retorno en Pantalla
	DECLARE Var_GarantiaID		INT(11);		-- ID de Garantia

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante de Cadena Vacia
	DECLARE	Salida_SI			CHAR(1);		-- Constante de Salida SI
	DECLARE	Est_Autorizado		CHAR(1);		-- Constante de Estatus de Garantia Autorizada
	DECLARE	Est_Pagado			CHAR(1);		-- Constante de Estatus de Credito Pagado
	DECLARE	Est_Castigado		CHAR(1);		-- Constante de Estatus de Credito Castigado

	DECLARE	Entero_Cero			INT(11);		-- Constante de Entero Cero
	DECLARE	Entero_Uno			INT(11);		-- Constante de Entero Uno
	DECLARE	Decimal_Cero		DECIMAL(12,2);	-- Constante de Decimal Cero

	-- Declaracion de Actualizaciones
	DECLARE Act_MontoHipoteca	TINYINT UNSIGNED;	-- Actualizacion 1.- Monto de Garantia Hipotecaria

	-- Asignacion  de constantes
	SET	Cadena_Vacia	:= '';
	SET	Salida_SI		:= 'S';
	SET	Est_Autorizado	:= 'U';
	SET	Est_Pagado		:= 'P';
	SET	Est_Castigado	:= 'K';

	SET	Entero_Cero		:= 0;
	SET	Entero_Uno		:= 1;
	SET	Decimal_Cero	:= 0.0;
	SET Var_Control		:= 'garantiaID';

	-- Asignacion de Actualizaciones
	SET Act_MontoHipoteca 	:= 1;

	-- Bloque para manejar los posibles errores
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									 'Disculpe las molestias que esto le ocasiona. Ref: SP-CREGARPRENHIPOACT');
			SET Var_Control	= 'SQLEXCEPTION';
		END;


		SET Par_GarantiaID			:= IFNULL(Par_GarantiaID, Entero_Cero);
		SET Par_NumActualizacion	:= IFNULL(Par_NumActualizacion, Entero_Cero);

		IF( Par_GarantiaID = Entero_Cero ) THEN
			SET Par_NumErr	:= 001;
			SET Par_ErrMen	:= CONCAT('El Numero de Garantia esta Vacio.');
			SET Var_Control	:= 'garantiaID';
			LEAVE ManejoErrores;
		END IF;

		SELECT 	GarantiaID
		INTO 	Var_GarantiaID
		FROM GARANTIAS
		WHERE GarantiaID = Par_GarantiaID;

		IF( IFNULL(Var_GarantiaID, Entero_Cero) = Entero_Cero ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Numero de Garantia no Existe.');
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumActualizacion NOT IN (Act_MontoHipoteca) ) THEN
			SET Par_NumErr	:= 002;
			SET Par_ErrMen	:= CONCAT('El Numero de Actualizacion para los Creditos con Garantia Prendaria o Hipotecaria no es Valido.');
			LEAVE ManejoErrores;
		END IF;

		IF( Par_NumActualizacion = Act_MontoHipoteca ) THEN
			UPDATE CREDITOS Cre
			INNER JOIN ASIGNAGARANTIAS Asig ON Cre.CreditoID = Asig.CreditoID AND Cre.SolicitudCreditoID = Asig.SolicitudCreditoID
			INNER JOIN CREGARPRENHIPO Hip ON Asig.SolicitudCreditoID = Hip.SolicitudCreditoID AND Asig.CreditoID = Hip.CreditoID SET
				Hip.MontoGarHipo 	= Decimal_Cero,

				Hip.Usuario			= Aud_Usuario,
				Hip.FechaActual		= Aud_FechaActual,
				Hip.DireccionIP		= Aud_DireccionIP,
				Hip.ProgramaID		= Aud_ProgramaID,
				Hip.Sucursal		= Aud_Sucursal,
				Hip.NumTransaccion	= Aud_NumTransaccion
			WHERE Asig.GarantiaID = Par_GarantiaID
			  AND Asig.Estatus = Est_Autorizado
			  AND Cre.Estatus NOT IN (Est_Pagado, Est_Castigado);
		END IF;

		SET Par_NumErr	:= 	Entero_Cero;
		SET Par_ErrMen	:= 'La Garantia Prendaria o Hipotecaria se ha Actualizado Correctamente.';

	END ManejoErrores;
	-- Fin del manejador de errores.

	IF(Par_Salida = Salida_SI) THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Par_GarantiaID AS Consecutivo;
	END IF;

END TerminaStore$$