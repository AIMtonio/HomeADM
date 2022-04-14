-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPDEPOARRENDABAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPDEPOARRENDABAJ`;DELIMITER $$

CREATE PROCEDURE `TMPDEPOARRENDABAJ`(
	-- SP QUE BORRA TABLA DE PASO
	Par_Salida			CHAR(1),		-- INDICA SI EXISTE O NO UNA SALIDA
	INOUT Par_NumErr	INT(11),		-- NUMERO DE ERROR
	INOUT Par_ErrMen	VARCHAR(400),	-- MENSAJE DE ERROR

	Aud_EmpresaID		INT(11),		-- PARAMETRO DE AUDITORIA
	Aud_Usuario			INT(11),		-- PARAMETRO DE AUDITORIA
	Aud_FechaActual		DATETIME,		-- PARAMETRO DE AUDITORIA
	Aud_DireccionIP		VARCHAR(15),	-- PARAMETRO DE AUDITORIA
	Aud_ProgramaID		VARCHAR(50),	-- PARAMETRO DE AUDITORIA
	Aud_Sucursal		INT(11),		-- PARAMETRO DE AUDITORIA
	Aud_NumTransaccion	BIGINT(20)		-- PARAMETRO DE AUDITORIA
  )
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Entero_Cero			INT(11);		-- VALOR CERO
	DECLARE Decimal_Cero		DECIMAL(14,2);	-- VALOR CERO
	DECLARE Cadena_Vacia		CHAR(1);		-- CADENA VACIA
	DECLARE Var_SI				CHAR(1);		-- VALOR SI
	DECLARE Var_Control			VARCHAR(50);	-- CONTROL
	DECLARE Par_Consecutivo		VARCHAR(50);	-- CONSECUTIVO


	-- Asignacion de Constantes
	SET Entero_Cero     := 0;		-- VALOR CERO
	SET Decimal_Cero    := 0;		-- VALOR CERO
	SET Cadena_Vacia    := '';		-- CADENA VACIA
	SET Var_SI			:= 'S';		-- VALOR SI

	-- Asignacion de Variables
	SET Aud_FechaActual		:= CURRENT_TIMESTAMP();			-- FECHA ACTUAL
	SET Par_ErrMen			:= CONCAT(  'El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-TMPDEPOARRENDABAJ');

	ManejoErrores: BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
			            'esto le ocasiona. Ref: SP-TMPDEPOARRENDABAJ');
			SET Var_Control:= 'sqlException' ;
		END;

		DELETE FROM TMPDEPOARRENDA WHERE NumTransaccion =  Aud_NumTransaccion;

		SET Par_NumErr      := 0;
		SET Par_ErrMen      := CONCAT("Deposito referenciado borrado exitosamente");
		SET Par_Consecutivo := Aud_NumTransaccion;
		SET Var_Control   := 'institucionID';

	END ManejoErrores;

	-- SI LA SALIDA ES SI DEVUELVE EL MENSAJE DE EXITO
	IF (Par_Salida = Var_SI) THEN
	    SELECT  Par_NumErr,
				Par_ErrMen,
				Var_Control,
				Par_Consecutivo;
	END IF;

END TerminaStore$$