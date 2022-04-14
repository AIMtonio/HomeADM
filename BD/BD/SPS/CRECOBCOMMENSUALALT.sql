-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CRECOBCOMMENSUALALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CRECOBCOMMENSUALALT`;DELIMITER $$

CREATE PROCEDURE `CRECOBCOMMENSUALALT`(
	/*SP para dar de alta los cortes de mes que tiene un credito de acuerdo a su plazo */
	Par_CreditoID			BIGINT(20),			# Numero de Credito
    Par_NumMes				INT(11),			# Consecutivo
	Par_FechaCorte			DATE,				# Fecha de Corte
    Par_TipoCredito			CHAR(1),			# Tipo de Credito N:Nuevo;  R:Reestructurado
	Par_Salida				CHAR(1),			# Tipo de Salida S.- Si N.- No
	INOUT Par_NumErr		INT(11),			# Numero de Error

	INOUT Par_ErrMen		VARCHAR(400),		# Mensaje de Error
	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11) ,
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),

	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
	)
TerminaStore: BEGIN



	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE Salida_SI 			CHAR(1);
    DECLARE Entero_Cero			INT(11);

	-- Declaracion de Variables
	DECLARE Var_Control			VARCHAR(20);
	DECLARE Var_Consecutivo		VARCHAR(50);

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';
	SET Salida_SI				:= 'S';
    SET Entero_Cero 			:= 0;

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	:= 999;
			SET Par_ErrMen	:= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CRECOBCOMMENSUALALT');
			SET Var_Control	:= 'sqlException';
		END;


		INSERT INTO CRECOBCOMMENSUAL(
			CreditoID,			NumMes,				FechaCorte,			TipoCredito,		EmpresaID,
            Usuario,			FechaActual,		DireccionIP,		ProgramaID,			Sucursal,
            NumTransaccion)
		VALUES (
			Par_CreditoID,		Par_NumMes,			Par_FechaCorte,		Par_TipoCredito,	Aud_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
            Aud_NumTransaccion);

		SET	Par_NumErr			:= 0;
		SET	Par_ErrMen			:= CONCAT('Ingreso Agregado Exitosamente: ');
		SET Var_Control			:= 'tipo';
		SET Var_Consecutivo		:= Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$