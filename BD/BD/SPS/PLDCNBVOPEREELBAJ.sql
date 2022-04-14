-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDCNBVOPEREELBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDCNBVOPEREELBAJ`;DELIMITER $$

CREATE PROCEDURE `PLDCNBVOPEREELBAJ`(
/* SP QUE ELIMINA LOS REGISTROS PARA VOLVER A GENERAR EL REPORTE
   DE OPERACIONES RELEVANTES*/
	Par_EmpresaID		INT(11),		-- ID de la Empresa
	Par_PeriodoInicio	DATE,			-- Fecha de Inicio del Periodo
	Par_PeriodoFin		DATE,			-- Fecha Final del Periodo
	Par_Salida          CHAR(1),		-- Indica el tipo de salida S.- Si N.- No
	INOUT Par_NumErr    INT(11),		-- Numero de Error

	INOUT Par_ErrMen    VARCHAR(400),	-- Mensaje de Error
	/* Parametros de Auditoria */
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),

	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN

-- Declaracion de Constantes
DECLARE Entero_Cero     INT;
DECLARE Decimal_Cero    DECIMAL(12,2);
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	SalidaSI		CHAR(1);

-- Asignacion de Constantes
SET Entero_Cero  := 0;		-- Entero cero
SET Cadena_Vacia := '';		-- Cadena Vacia
SET SalidaSI	 := 'S';	-- Salida Si
SET Decimal_Cero := 0.00;	-- Decimal cero

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-PLDCNBVOPEREELBAJ');
		END;

	DELETE FROM PLDCNBVOPEREELE
		WHERE PeriodoReporte = DATE_FORMAT(Par_PeriodoFin,'%Y%m');

	SET Par_NumErr := 000;
	SET Par_ErrMen := CONCAT('Registros Eliminados Correctamente.');

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            'bajaControl' AS control,
			Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$