-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUR_SEGPEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUR_SEGPEALT`;DELIMITER $$

CREATE PROCEDURE `BUR_SEGPEALT`(
	Par_BUR_SOLNUM		VARCHAR(10),
	Par_PE_CONSEC		INT(11),
	Par_PE_SEGMEN		VARCHAR(2),
	Par_PE_VALOR		MEDIUMTEXT
)
TerminaStore:BEGIN
	-- Declaracion de Constantes
DECLARE Fecha_Vacia			DATE;
DECLARE Cadena_Vacia		CHAR(1);
DECLARE Entero_Cero			INT;
DECLARE Decimal_Cero		DECIMAL;
DECLARE SalidaSI			CHAR(1);
DECLARE Par_NumErr			INT(11);
DECLARE Par_ErrMen			VARCHAR(400);

	-- Asignacion de Constantes
SET Fecha_Vacia			:='1900-01-01';		-- Fecha Vacia
SET Cadena_Vacia		:='';				-- Cadena Vacia
SET Entero_Cero			:=0;				-- Entero Cero
SET Decimal_Cero		:=0.0;				-- Decimal Cero
SET SalidaSI			:='S';				-- Salida SI

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BUR_SEGPEALT');
    END;

	SET Par_BUR_SOLNUM	:=IFNULL(Par_BUR_SOLNUM,Cadena_Vacia);
	SET Par_PE_CONSEC	:=IFNULL(Par_PE_CONSEC,Cadena_Vacia);
	SET Par_PE_SEGMEN	:=IFNULL(Par_PE_SEGMEN,Cadena_Vacia);
	SET Par_PE_VALOR	:=IFNULL(Par_PE_VALOR,Cadena_Vacia);

	INSERT INTO bur_segpe (
		BUR_SOLNUM,		PE_CONSEC,		PE_SEGMEN,		PE_VALOR
	)VALUES(
		Par_BUR_SOLNUM,	Par_PE_CONSEC,	Par_PE_SEGMEN,	Par_PE_VALOR);

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Segmento PE de Buro Guardada Exitosamente.');
END ManejoErrores;

	SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Cadena_Vacia AS control,
	    Entero_Cero AS consecutivo;

END TerminaStore$$