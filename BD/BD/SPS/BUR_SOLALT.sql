-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BUR_SOLALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BUR_SOLALT`;DELIMITER $$

CREATE PROCEDURE `BUR_SOLALT`(
	Par_SOL_NUMERO	VARCHAR(10),
	Par_SOL_PRINOM	VARCHAR(1000),
	Par_SOL_SEGNOM	VARCHAR(1000),
	Par_SOL_APEPAT	VARCHAR(1000),
	Par_SOL_APEMAT	VARCHAR(1000),

	Par_SOL_FECNAC	DATE,
	Par_SOL_RFC		VARCHAR(13),
	Par_SOL_CURP	VARCHAR(18),
	Par_SOL_TELEFO	VARCHAR(10),
	Par_SOL_TIPO	VARCHAR(2),

	Par_SOL_MEDIO	VARCHAR(2),
	Par_SOL_REF		VARCHAR(1000),
	Par_SOL_EXITO	VARCHAR(1)
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
									'Disculpe las molestias que esto le ocasiona. Ref: SP-BUR_SOLALT');
    END;

	SET Par_SOL_NUMERO	:=IFNULL(Par_SOL_NUMERO,Cadena_Vacia);
	SET Par_SOL_PRINOM	:=IFNULL(Par_SOL_PRINOM,Cadena_Vacia);
	SET Par_SOL_SEGNOM	:=IFNULL(Par_SOL_SEGNOM,Cadena_Vacia);
	SET Par_SOL_APEPAT	:=IFNULL(Par_SOL_APEPAT,Cadena_Vacia);
	SET Par_SOL_APEMAT	:=IFNULL(Par_SOL_APEMAT,Cadena_Vacia);
	SET Par_SOL_FECNAC	:=IFNULL(Par_SOL_FECNAC,Fecha_Vacia);
	SET Par_SOL_RFC		:=IFNULL(Par_SOL_RFC,Cadena_Vacia);
	SET Par_SOL_CURP	:=IFNULL(Par_SOL_CURP,Cadena_Vacia);
	SET Par_SOL_TELEFO	:=IFNULL(Par_SOL_TELEFO,Cadena_Vacia);
	SET Par_SOL_TIPO	:=IFNULL(Par_SOL_TIPO,Cadena_Vacia);
	SET Par_SOL_MEDIO	:=IFNULL(Par_SOL_MEDIO,Cadena_Vacia);
	SET Par_SOL_REF		:=IFNULL(Par_SOL_REF,Cadena_Vacia);
	SET Par_SOL_EXITO	:=IFNULL(Par_SOL_EXITO,Cadena_Vacia);

	INSERT INTO bur_sol (
		SOL_NUMERO,			SOL_PRINOM,			SOL_SEGNOM,			SOL_APEPAT,			SOL_APEMAT,
		SOL_FECNAC,			SOL_RFC,			SOL_CURP,			SOL_TELEFO,			SOL_TIPO,
		SOL_MEDIO,			SOL_REF,			SOL_EXITO
	)VALUES(
		Par_SOL_NUMERO,		Par_SOL_PRINOM,		Par_SOL_SEGNOM,		Par_SOL_APEPAT,		Par_SOL_APEMAT,
		Par_SOL_FECNAC,		Par_SOL_RFC,		Par_SOL_CURP,		Par_SOL_TELEFO,		Par_SOL_TIPO,
		Par_SOL_MEDIO,		Par_SOL_REF,		Par_SOL_EXITO);

	SET Par_NumErr := 0;
	SET Par_ErrMen := CONCAT('Solicitud de Buro Guardada Exitosamente.');
END ManejoErrores;

	SELECT
		Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Cadena_Vacia AS control,
	    Entero_Cero AS consecutivo;

END TerminaStore$$