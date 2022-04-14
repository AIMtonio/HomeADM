-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCUENTAIVACARTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCUENTAIVACARTBAJ`;DELIMITER $$

CREATE PROCEDURE `SUBCUENTAIVACARTBAJ`(
-- ============================================================
-- SP PARA DAR DE BAJA SUBCUENTAS IVA DE LAS CUENTAS CONTABLES
-- ============================================================
	Par_ConceptoCartID	INT(11),		-- Numero de Concepto Cartera
	Par_Porcentaje		DECIMAL(12,2),	-- Porcentaje de IVA Asignado

	Par_Salida			CHAR(1),
INOUT Par_NumErr		INT(11),
INOUT Par_ErrMen		VARCHAR(400),

	/* Parametros Auditoria */
	Par_EmpresaID		INT(11),
	Aud_UsuarioID		INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore:BEGIN
	/*Declaración de Variables*/
	DECLARE Var_Control		VARCHAR(100);

	/* Declaración de Constantes*/
	DECLARE Entero_Cero INT(11);
	DECLARE Const_Si 	CHAR(1);

	/*Asignación de Constantes*/
	SET Entero_Cero :=	0;
	SET Const_Si 	:= 'S';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCUENTAIVACARTBAJ');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		IF(IFNULL(Par_ConceptoCartID,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 01;
			SET Par_ErrMen := 'El Concepto de Cartera esta vacio.';
			SET Var_Control := 'conceptoCartID';
		END IF;

		IF(IFNULL(Par_Porcentaje,Entero_Cero)=Entero_Cero)THEN
			SET Par_NumErr := 02;
			SET Par_ErrMen := 'El Porcentaje esta vacio.';
			SET Var_Control := 'porcentaIVA';
		END IF;

		DELETE FROM SUBCUENTAIVACART
		WHERE ConceptoCartID = Par_ConceptoCartID
		AND Porcentaje = Par_Porcentaje;

		SET Par_NumErr := 00;
		SET Par_ErrMen := 'SubCuenta IVA Elimanada Exitosamente';

	END ManejoErrores;

	IF(Par_Salida=Const_Si)THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;

END TerminaStore$$