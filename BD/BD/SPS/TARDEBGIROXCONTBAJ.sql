-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBGIROXCONTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBGIROXCONTBAJ`;DELIMITER $$

CREATE PROCEDURE `TARDEBGIROXCONTBAJ`(
	#SP DE TARJETA DE GIROS PARA BAJA
    Par_TipoTarjetaDebID	INT(11),	-- Parametro de Tipo Tarjeta ID
	Par_ClienteID         	CHAR(13),	-- Parametro de Cliente ID

    Par_Salida         		CHAR(1),	-- Parametro de Salida
    INOUT Par_NumErr		INT(11),	-- Parametro de numero de Error
    INOUT Par_ErrMen		VARCHAR(400),-- Parametro de Mensaje de Error

    Aud_EmpresaID			INT(11),	-- Parametro de Auditoria
	Aud_Usuario				INT(11),	-- Parametro de Auditoria
	Aud_FechaActual			DATETIME,	-- Parametro de Auditoria
	Aud_DireccionIP			VARCHAR(15),-- Parametro de Auditoria
	Aud_ProgramaID			VARCHAR(50),-- Parametro de Auditoria
	Aud_Sucursal			INT(11),	-- Parametro de Auditoria
	Aud_NumTransaccion		BIGINT(20)	-- Parametro de Auditoria
		)
TerminaStore: BEGIN
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Entero_Cero		INT;
	DECLARE consecutivo		INT;
	DECLARE SalidaSI		CHAR(1);

	SET	Cadena_Vacia	:= '';		-- Cadena Vacia
	SET	Entero_Cero		:= 0;		-- Enetro Cero
	SET	consecutivo		:= 0;		-- Consucutivo
	SET Aud_FechaActual := CURRENT_TIMESTAMP();	-- Fecha Actual
	SET SalidaSI		:= 'S';		-- Salida SI

ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
							'esto le ocasiona. Ref: SP-TARDEBGIROXCONTBAJ');
		END;

	DELETE
	FROM 		TARDEBGIROTIPOCONT
	WHERE 	TipoTarjetaDebID	= Par_TipoTarjetaDebID
    AND ClienteId=Par_ClienteID ;

	SET Par_NumErr := 000;
	SET	Par_ErrMen := 'Giros Eliminados Correctamente' ;

END ManejoErrores;  -- END del Handler de Errores

 IF (Par_Salida = SalidaSI) THEN
	SELECT  Par_NumErr  		AS NumErr,
			Par_ErrMen 			AS ErrMen,
			'tipoTarjetaDebID' 	AS control,
			Entero_Cero 		AS consecutivo;
	END IF;

END TerminaStore$$