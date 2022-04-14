-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUR_SEGTLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUR_SEGTLALT`;DELIMITER $$

CREATE PROCEDURE `BUR_SEGTLALT`(
	Par_BUR_SOLNUM		VARCHAR(10),
	Par_TL_CONSEC		INT(11),
	Par_TL_SEGMEN		VARCHAR(2),
	Par_TL_VALOR		MEDIUMTEXT
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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BUR_SEGTLALT');
    END;

	SET Par_BUR_SOLNUM	:=IFNULL(Par_BUR_SOLNUM,Cadena_Vacia);
	SET Par_TL_CONSEC	:=IFNULL(Par_TL_CONSEC,Cadena_Vacia);
	SET Par_TL_SEGMEN	:=IFNULL(Par_TL_SEGMEN,Cadena_Vacia);
	SET Par_TL_VALOR	:=IFNULL(Par_TL_VALOR,Cadena_Vacia);

	INSERT INTO bur_segtl (
		BUR_SOLNUM,		TL_CONSEC,		TL_SEGMEN,		TL_VALOR
	)VALUES(
		Par_BUR_SOLNUM,	Par_TL_CONSEC,	Par_TL_SEGMEN,	Par_TL_VALOR);

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Segmento TL de Buro Guardada Exitosamente.');
END ManejoErrores;

	SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Cadena_Vacia AS control,
	    Entero_Cero AS consecutivo;

END TerminaStore$$