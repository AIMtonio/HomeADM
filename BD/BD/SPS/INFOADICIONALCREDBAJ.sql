-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INFOADICIONALCREDBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `INFOADICIONALCREDBAJ`;
DELIMITER $$

CREATE PROCEDURE `INFOADICIONALCREDBAJ`(
-- SP PARA DAR DE BAJA LA INFORMACION ADICIONAL DE LOS CREDITOS
	Par_CreditoID		BIGINT(20),		-- Numero de Credito

    Par_Salida			CHAR(1),		-- Parametro Establece si requiere Salida
	INOUT Par_NumErr	INT(11),		-- Parametro INOUT para el Numero de Error
	INOUT Par_ErrMen	VARCHAR(400),	-- Parametro INOUT para la Descripcion del Error

	-- AUDITORIA GENERAL
    Aud_EmpresaID		INT(11),		-- Parametro de auditoria ID de la empresa
	Aud_Usuario			INT(11),		-- Parametro de auditoria ID del usuario
	Aud_FechaActual		DATETIME,		-- Parametro de auditoria Fecha actual
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de auditoria Direccion IP
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de auditoria Programa
	Aud_Sucursal		INT(11),		-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion	BIGINT(20)		-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
    DECLARE Var_Control			VARCHAR(100);	-- Control de Retorno en pantalla
    DECLARE Var_Consecutivo		VARCHAR(200);	-- Numero consecutivo

	-- DECLARACION DE CONSTANTES
    DECLARE	Cadena_Vacia	CHAR(1);	-- Cadena vacia
	DECLARE	Fecha_Vacia		DATE;		-- Fecha vacia
	DECLARE	Entero_Cero		INT(11);	-- Entero en cero
    DECLARE Salida_SI 		CHAR(1);	-- Salida SI

	-- ASIGNACION DE CONSTANTES
    SET	Cadena_Vacia	:= '';				-- Valor de auditoria
	SET	Fecha_Vacia		:= '1900-01-01';	-- Valor de auditoria
	SET	Entero_Cero		:= 0;				-- Valor de auditoria
	SET Var_Control		:= '';				-- Valor de auditoria
    SET Salida_SI		:= 'S';				-- Valor de auditoria

    ManejoErrores:BEGIN
		DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr := 999;
			SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-INFOADICIONALCREDBAJ');
			SET Var_Control := 'SQLEXCEPTION';
		END;

		SET Par_CreditoID	:= IFNULL(Par_CreditoID, Entero_Cero);

        IF(Par_CreditoID = Entero_Cero) THEN
			SET Par_NumErr := 1;
			SET Par_ErrMen := CONCAT('El Credito esta Vacio.');
			SET Var_Control := 'CreditoID';
			LEAVE ManejoErrores;
		END IF;

		DELETE FROM INFOADICIONALCRED WHERE CreditoID = Par_CreditoID;

		SET Par_NumErr  	:=  0;
		SET Par_ErrMen  	:=  CONCAT('Relacion de Credito Eliminada. ', Par_CreditoID);
		SET Var_Control 	:=  'CreditoID';

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
		SELECT Par_NumErr AS NumErr,
			   Par_ErrMen AS ErrMen,
			   Var_Control AS Control,
               Var_Consecutivo AS Consecutivo;
	END IF;

END TerminaStore$$
