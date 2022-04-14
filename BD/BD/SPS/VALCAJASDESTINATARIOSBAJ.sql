-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VALCAJASDESTINATARIOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `VALCAJASDESTINATARIOSBAJ`;
DELIMITER $$

CREATE PROCEDURE `VALCAJASDESTINATARIOSBAJ`(
	Par_Salida				CHAR(1),		-- Parametro de SALIDA S: SI N: No
	INOUT Par_NumErr		INT(11),		-- Parametro de SALIDA numero de error
	INOUT Par_ErrMen		VARCHAR(400),	-- Parametro de SALIDA Mensaje de error

	Par_EmpresaID			INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP			VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- DECLARACIÓN DE CONSTANTES
	DECLARE Salida_SI 			CHAR(1);		# Constante Cadena Si
	DECLARE Entero_Cero			INT(11);		# Constante Entero Cero
	DECLARE Cadena_Vacia		VARCHAR(1);		# Constante Cadena Vacía
	DECLARE Var_Control			VARCHAR(50);	# Control en Pantalla
	DECLARE	Var_Consecutivo 	INT(11); 		# Consecutivo en Pantalla

	-- ASIGNACIÓN DE CONSTANTES
	SET Salida_SI				:= 'S';			-- Constante Si
	SET Cadena_Vacia			:= '';			-- Cadena vacía
	SET Entero_Cero				:= 0;			-- Constante Cero

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr	:=	999;
			SET Par_ErrMen	:=	CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: VALCAJASDESTINATARIOSBAJ');
		END;

		DELETE FROM VALCAJASDESTINATARIOS;

		SET Par_NumErr		:= 000;
		SET Par_ErrMen		:= 'Tabla Vaciada Exitosamente';
		SET Var_Control		:= 'destinatarioID';

	END ManejoErrores;

	IF(Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen  AS ErrMen,
				Var_Control AS control,
				Entero_Cero AS consecutivo;
	END IF;
END TerminaStore$$