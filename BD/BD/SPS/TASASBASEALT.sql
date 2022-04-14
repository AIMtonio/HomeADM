-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TASASBASEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `TASASBASEALT`;DELIMITER $$

CREATE PROCEDURE `TASASBASEALT`(
	# ====== ALTA DE UNA TASA BASE ==========================
	Par_Nombre			VARCHAR(45),
	Par_Descripcion		VARCHAR(100),
	Par_Valor			DECIMAL(12,4),
    Par_ClaveCNBV		INT,
    Par_Salida          CHAR(1),

OUT Par_NumErr          INT,
OUT Par_ErrMen          VARCHAR(400),
	Aud_Empresa			INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,

	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN

DECLARE 	Var_Control		VARCHAR(50);


DECLARE		Cadena_Vacia	CHAR(1);
DECLARE		Entero_Cero		INT;
DECLARE		Float_Cero		FLOAT;
DECLARE		Var_Consecutivo		INT;
DECLARE 	VarFechaSis		DATE;
DECLARE 	Salida_SI		CHAR(1);


SET	Cadena_Vacia		:= '';
SET	Entero_Cero		:= 0;
SET	Float_Cero		:= 0.0;
SET Salida_SI		:= 'S';

SET Aud_FechaActual := CURRENT_TIMESTAMP();

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr   = 999;
        SET Par_ErrMen   = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
            'esto le ocasiona. Ref: SP-TASASBASEALT');
		SET Var_Control  = 'SQLEXCEPTION';
    END;



	IF(IFNULL( Aud_Usuario, Entero_Cero)) = Entero_Cero THEN
		SET Par_NumErr	:= 1;
        SET Par_ErrMen	:= 'El Usuario no esta logeado';
        SET Var_Control	:= 'tasaBaseID';

		LEAVE ManejoErrores;
	END IF;

	SET Var_Consecutivo := (SELECT IFNULL(COUNT(*),0)+1 FROM TASASBASE);

	INSERT TASASBASE (TasaBaseID, 	Nombre, 		Descripcion, 	Valor, 		ClaveCNBV,
					  EmpresaID, 	Usuario, 		FechaActual, 	DireccionIP, ProgramaID,
                      Sucursal, 	NumTransaccion)

			   VALUES(Var_Consecutivo, 		Par_Nombre,			Par_Descripcion, 	Par_Valor, 			Par_ClaveCNBV,
					  Aud_Empresa,			Aud_Usuario,		Aud_FechaActual,	Aud_DireccionIP,	Aud_ProgramaID,
                      Aud_Sucursal,			Aud_NumTransaccion);

	SET VarFechaSis := (SELECT FechaSistema FROM PARAMETROSSIS);

	CALL `HIS-TASASBASEALT`(VarFechaSis,	Var_Consecutivo,	Par_Valor,
						  Aud_Empresa,		Aud_Usuario,	Aud_FechaActual,
						  Aud_DireccionIP,	Aud_ProgramaID,
						  Aud_Sucursal,		Aud_NumTransaccion);

    SET Par_NumErr	:= 0;
	SET Par_ErrMen	:= CONCAT("Tasa Base Agregada Exitosamente: ", CONVERT(Var_Consecutivo, CHAR));
    SET Var_Control	:= 'tasaBaseID';


END ManejoErrores;


	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
				Par_ErrMen AS ErrMen,
				Var_Control AS Control,
				IFNULL(Var_Consecutivo,0) AS Consecutivo;
	END IF;

END TerminaStore$$