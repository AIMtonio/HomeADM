-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUBCUENTAIVACARTMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUBCUENTAIVACARTMOD`;DELIMITER $$

CREATE PROCEDURE `SUBCUENTAIVACARTMOD`(
-- ==================================================================
-- SP PARA MODIFICAR LA SUBCUENTA CONTABLE CORRESPONDIENTE AL IVA
-- ==================================================================
	Par_ConceptoCartID	INT(11),			-- Número del Concepto de Cartera
	Par_Porcentaje 		DECIMAL(12,2),		-- Procentaje Correspondiente a la subcuenta, 8% o 16%
	Par_SubCuenta		CHAR(2),			-- Subcuenta contable correspondiente al porcentaje

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
	/* Declaración de Variables */
	DECLARE Var_Control		VARCHAR(50);

	/* Declaración de Constantes */
	DECLARE Entero_Cero		INT(11);
	DECLARE Const_Si		CHAR(1);
	DECLARE Cadena_Vacia	CHAR(5);

	/* Asignación de Constantes */
	SET Entero_Cero := 0;
	SET Const_Si	:= 'S';
	SET Cadena_Vacia := '';

	ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-SUBCUENTAIVACARTMOD');
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

		IF(IFNULL(Par_SubCuenta,Cadena_Vacia)=Cadena_Vacia)THEN
			SET Par_NumErr := 03;
			SET Par_ErrMen := 'La Subcuenta esta vacia.';
			SET Var_Control := 'subCuenta7';
		END IF;

		UPDATE SUBCUENTAIVACART SET
				SubCuenta 	=	Par_SubCuenta,
				EmpresaID 	=	Par_EmpresaID,
				UsuarioID 	=	Aud_UsuarioID,
				FechaActual =	Aud_FechaActual,
				DireccionIP	=	Aud_DireccionIP,
				ProgramaID 	=	Aud_ProgramaID,
				Sucursal 	=	Aud_Sucursal,
				NumTransaccion = Aud_NumTransaccion
		WHERE ConceptoCartID = Par_ConceptoCartID
		AND Porcentaje = Par_Porcentaje;


		SET Par_NumErr := 00;
		SET Par_ErrMen := 'SubCuenta IVA Modificada Exitosamente';
        SET Var_Control := 'subCuenta7';

	END ManejoErrores;

	IF(Par_Salida=Const_Si)THEN
		SELECT 	Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control;
	END IF;
END TerminaStore$$