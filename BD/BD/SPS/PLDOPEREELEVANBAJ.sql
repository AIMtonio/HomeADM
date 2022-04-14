-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEREELEVANBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEREELEVANBAJ`;DELIMITER $$

CREATE PROCEDURE `PLDOPEREELEVANBAJ`(

	Par_EmpresaID		INT(11),
	Par_PeriodoInicio	DATE,
	Par_PeriodoFin		DATE,
	Par_Salida          CHAR(1),
	INOUT Par_NumErr    INT,

	INOUT Par_ErrMen    VARCHAR(400),

	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
				)
TerminaStore: BEGIN


DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	SalidaSI		CHAR(1);


SET Entero_Cero  := 0;
SET Cadena_Vacia := '';
SET SalidaSI	 := 'S';
SET Decimal_Cero := 0.00;

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDOPEREELEVANBAJ');
		END;

	DELETE FROM  PLDOPEREELEVANT
		WHERE Fecha>=Par_PeriodoInicio AND Fecha<=Par_PeriodoFin;

	SET Par_NumErr = 000;
	SET Par_ErrMen = CONCAT('Registros Eliminados Correctamente.');

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'bajaControl' AS control,
			Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$