-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REGULATORIOI0391BAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `REGULATORIOI0391BAJ`;DELIMITER $$

CREATE PROCEDURE `REGULATORIOI0391BAJ`(
/************************************************************************
---- SP QUE BORRA LOS REGISTROS DE UN PERIODO DEL REGULATORIO I0391 -----
************************************************************************/
	Par_Anio				INT(11), 		-- Ano del reporte
	Par_Mes					INT(11),		-- Mes del reporte
	Par_TipoBaja			TINYINT UNSIGNED, -- Tipo de Baja
    Par_TipoInstitucion		INT, 			-- ID del tipo de institucion

	Par_Salida          	CHAR(1),
    INOUT Par_NumErr    	INT,
    INOUT Par_ErrMen   		VARCHAR(400),

    Par_EmpresaID       	INT(11),
    Aud_Usuario         	INT(11),
    Aud_FechaActual     	DATETIME,
    Aud_DireccionIP     	VARCHAR(15),
    Aud_ProgramaID      	VARCHAR(50),
    Aud_Sucursal        	INT,
	Aud_NumTransaccion  	BIGINT(20)

	)
TerminaStore:BEGIN
-- Declaracion de Variables
DECLARE Var_Control		VARCHAR(50);

-- Descripcion de constantes
DECLARE BajaPeriodo			INT;
DECLARE Cadena_Vacia		CHAR;
DECLARE Entero_Cero			INT;
DECLARE SalidaSI			CHAR;
-- Asignacion de Constantes
SET BajaPeriodo				:=1;		-- Baja del Historial por Periodo
SET Cadena_Vacia			:='';		-- Cadena Vacia
SET Entero_Cero				:=0;		-- Entero _Cero
SET SalidaSI				:='S';		-- Salida Si

ManejoErrores: BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr	= 999;
				SET Par_ErrMen	= CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-REGULATORIOI0391BAJ');
				SET Var_Control = 'SQLEXCEPTION';
			END;

	IF (Par_TipoBaja=BajaPeriodo)THEN

		IF (Par_Anio=Entero_Cero)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El Ano del Periodo esta vacio';
				SET Var_Control  := 'anio' ;
				LEAVE ManejoErrores;
		END IF;

	    IF (Par_Mes=Entero_Cero)THEN
				SET Par_NumErr  := 1;
				SET Par_ErrMen  := 'El Mes del Periodo esta vacio';
				SET Var_Control  := 'mes' ;
				LEAVE ManejoErrores;
		END IF;


		DELETE FROM `HIS-REGULATORIOI0391` WHERE Anio = Par_Anio  AND Mes = Par_Mes
        AND TipoInstitucionID = Par_TipoInstitucion;

		SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT("Reporte Eliminado Exitosamente.");
        LEAVE ManejoErrores;
	END IF;

END ManejoErrores;  -- END del Handler de Errores

	IF (Par_Salida = SalidaSI) THEN
            SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                    Par_ErrMen AS ErrMen,
                    Var_Control AS control,
                    Entero_Cero AS consecutivo;
    END IF;


END TerminaStore$$