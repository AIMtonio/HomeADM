-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUR_DIRALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUR_DIRALT`;DELIMITER $$

CREATE PROCEDURE `BUR_DIRALT`(
	Par_BUR_SOLNUM	VARCHAR(10),
	Par_DIR_CALLE	VARCHAR(100),
	Par_DIR_NUMEXT	VARCHAR(10),
	Par_DIR_NUMINT	VARCHAR(10),
	Par_DIR_MZA		VARCHAR(10),

	Par_DIR_LOTE	VARCHAR(10),
	Par_DIR_COLONI	VARCHAR(100),
	Par_DIR_DELEGA	VARCHAR(100),
	Par_DIR_CODPOS	VARCHAR(5),
	Par_DIR_CIUDAD	VARCHAR(100),

	Par_DIR_ESTADO	VARCHAR(10)
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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BUR_DIRALT');
    END;

	SET Par_BUR_SOLNUM	:=IFNULL(Par_BUR_SOLNUM,Cadena_Vacia);
	SET Par_DIR_CALLE	:=IFNULL(Par_DIR_CALLE,Cadena_Vacia);
	SET Par_DIR_NUMEXT	:=IFNULL(Par_DIR_NUMEXT,Cadena_Vacia);
	SET Par_DIR_NUMINT	:=IFNULL(Par_DIR_NUMINT,Cadena_Vacia);
	SET Par_DIR_MZA		:=IFNULL(Par_DIR_MZA,Cadena_Vacia);
	SET Par_DIR_LOTE	:=IFNULL(Par_DIR_LOTE,Cadena_Vacia);
	SET Par_DIR_COLONI	:=IFNULL(Par_DIR_COLONI,Cadena_Vacia);
	SET Par_DIR_DELEGA	:=IFNULL(Par_DIR_DELEGA,Cadena_Vacia);
	SET Par_DIR_CODPOS	:=IFNULL(Par_DIR_CODPOS,Cadena_Vacia);
	SET Par_DIR_CIUDAD	:=IFNULL(Par_DIR_CIUDAD,Cadena_Vacia);
	SET Par_DIR_ESTADO	:=IFNULL(Par_DIR_ESTADO,Cadena_Vacia);

	INSERT INTO bur_dir (
		BUR_SOLNUM, 		DIR_CALLE,		 	DIR_NUMEXT,	 		DIR_NUMINT, 		DIR_MZA,
		DIR_LOTE, 			DIR_COLONI,		 	DIR_DELEGA,	 		DIR_CODPOS, 		DIR_CIUDAD,
		DIR_ESTADO
	)VALUES(
		Par_BUR_SOLNUM,		Par_DIR_CALLE,		Par_DIR_NUMEXT,		Par_DIR_NUMINT,		Par_DIR_MZA,
		Par_DIR_LOTE,		Par_DIR_COLONI,		Par_DIR_DELEGA,		Par_DIR_CODPOS,		Par_DIR_CIUDAD,
		Par_DIR_ESTADO);

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Direccion de Buro Guardada Exitosamente.');
END ManejoErrores;

	SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Cadena_Vacia AS control,
	    Entero_Cero AS consecutivo;

END TerminaStore$$