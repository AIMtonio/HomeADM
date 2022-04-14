-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASMAYORCEDEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASMAYORCEDEALT`;DELIMITER $$

CREATE PROCEDURE `CUENTASMAYORCEDEALT`(
# ==========================================================
# ----- SP PARA REGISTRAR LAS CUENTAS DE MAYOR DE CEDES-----
# ==========================================================
	Par_ConceptoCedeID	INT(5),
	Par_Cuenta			CHAR(4),
	Par_Nomenclatura 	VARCHAR(60),
	Par_NomenclaturaCR 	VARCHAR(60),

    Par_Salida			CHAR(1),
	INOUT Par_NumErr 	INT(11),
	INOUT Par_ErrMen  	VARCHAR(400),

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
		)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_Control		VARCHAR(50);
	DECLARE Var_Consecutivo	INT(11);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT(3);
	DECLARE	Decimal_Cero	DECIMAL(12,2);
	DECLARE SalidaSI		CHAR(1);

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';
	SET	Entero_Cero			:= 0;
	SET	Decimal_Cero		:= 0.0;
    SET SalidaSI			:= 'S';

	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr = 999;
				SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASMAYORCEDEALT');
			END;

		IF(IFNULL(Par_ConceptoCedeID,Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 1;
			SET	Par_ErrMen	:= 'El Concepto esta Vacio.';
			SET Var_Control	:= 'conceptoCedeID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Aud_EmpresaID,Entero_Cero))= Entero_Cero THEN
			SET	Par_NumErr 	:= 2;
			SET	Par_ErrMen	:= 'El Numero de Empresa esta Vacio.';
			SET Var_Control	:= 'empresaID';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Cuenta,Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 	:= 3;
			SET	Par_ErrMen	:= 'La Cuenta esta Vacia.';
			SET Var_Control	:= 'cuenta';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_Nomenclatura,Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 	:= 4;
			SET	Par_ErrMen	:= 'La Nomenclatura esta Vacia.';
			SET Var_Control	:= 'nomenclatura';
			LEAVE ManejoErrores;
		END IF;

		IF(IFNULL(Par_NomenclaturaCR,Cadena_Vacia))= Cadena_Vacia THEN
			SET	Par_NumErr 	:= 4;
			SET	Par_ErrMen	:= 'La Nomenclatura Costos esta Vacia.';
			SET Var_Control	:= 'nomenclaturaCR';
			LEAVE ManejoErrores;
		END IF;


		SET Aud_FechaActual := CURRENT_TIMESTAMP();

		INSERT INTO CUENTASMAYORCEDE(
			ConceptoCedeID,		Cuenta,			Nomenclatura,		NomenclaturaCR,		EmpresaID,
			Usuario,			FechaActual,	DireccionIP,		ProgramaID,			Sucursal,
            NumTransaccion)
		VALUES(
			Par_ConceptoCedeID,	Par_Cuenta,		Par_Nomenclatura,	Par_NomenclaturaCR,	Aud_EmpresaID,
            Aud_Usuario,		Aud_FechaActual,Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal,
			Aud_NumTransaccion);

		SET	Par_NumErr 	:= 000;
		SET	Par_ErrMen	:= CONCAT('Cuenta Agregada Exitosamente: ',CONVERT(Par_ConceptoCedeID,CHAR));
		SET Var_Control	:= 'conceptoCedeID';
		SET Var_Consecutivo:=Entero_Cero;

	END ManejoErrores;

	IF (Par_Salida = SalidaSI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS control,
				Var_Consecutivo AS consecutivo;
	END IF;

END TerminaStore$$