-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBCODIGORESPUESTAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBCODIGORESPUESTAPRO`;DELIMITER $$

CREATE PROCEDURE `TARDEBCODIGORESPUESTAPRO`(
	/* Mapeo de respuestas de SAFI con Entura y Payware */
	Par_CodigoSAFI 			VARCHAR(3),		-- Codigo de respuesta del SAFI
	INOUT Par_CodigoResp 	VARCHAR(3),		-- Codigo de respuesta Mapeado
	Par_TipoOperacion 	VARCHAR(2), 		-- Tipo de Operacion de Tarjeta

	Par_Salida				CHAR(1),		-- Salida
	INOUT	Par_NumErr 		INT, 			-- Salida
	INOUT	Par_ErrMen  	VARCHAR(400), 	-- Salida

	Par_EmpresaID			INT, 			-- Auditoria
	Aud_Usuario         	INT, 			-- Auditoria
	Aud_FechaActual     	DATETIME, 		-- Auditoria
	Aud_DireccionIP     	VARCHAR(15), 	-- Auditoria
	Aud_ProgramaID      	VARCHAR(50), 	-- Auditoria
	Aud_Sucursal        	INT(11), 		-- Auditoria
	Aud_NumTransaccion  	BIGINT(20) 		-- Auditoria
)
TerminaStore:BEGIN

DECLARE Var_TipoConexion VARCHAR(1);  -- Tipo de Conexion


DECLARE Cone_Entura		CHAR(1);		--  Conexion Entura
DECLARE Cone_Prosa		CHAR(1); 		--  Conexion Prosa
DECLARE Clave_TipoCon	VARCHAR(50);  	-- Clave de conexion
DECLARE Tipo_POS		VARCHAR(5); 	-- Tipo de operacion POS
DECLARE Tipo_ATM		VARCHAR(5); 	-- Tipo de Operacion ATM
DECLARE Salida_SI		CHAR(1);		-- Indica que se hara una salida
DECLARE Cod_ErrSis		VARCHAR(3); 	-- Codigo de error Sistema -Entura
DECLARE Cod_ErrPOS		VARCHAR(2); 	-- Codigo de Error POS
DECLARE Var_LlaveTipoConTD		VARCHAR(100);


SET Cone_Entura		:= 'E';
SET Cone_Prosa		:= 'P';
SET Clave_TipoCon	:= 'TarDebTipoConexion';

SET Tipo_ATM		:= '01';
SET Salida_SI		:= 'S';

SET Cod_ErrSis		:= '909';
SET Cod_ErrPOS		:= '06';
SET Var_LlaveTipoConTD	:= "ConexionTarjetas";		-- Llave Parámetro: Tipo de Conexión de Tarjeta de Debito

ManejoErrores:BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
						'esto le ocasiona. Ref: SP-TARDEBCODIGORESPUESTAPRO');
	    SET Par_CodigoResp = Cod_ErrPOS;
    END;

	SELECT 	ValorParametro
    INTO Var_TipoConexion
	FROM PARAMGENERALES
	WHERE	LlaveParametro	= Var_LlaveTipoConTD;

	SET Var_TipoConexion := IFNULL(Var_TipoConexion,Cone_Prosa);

	IF Var_TipoConexion = Cone_Prosa THEN
		SELECT CodigoProsaID INTO Par_CodigoResp FROM
		CATCODIGORESPEQSAFI WHERE CodigoSAFI = Par_CodigoSAFI;

		SET Par_CodigoResp := IFNULL(Par_CodigoResp,Cod_ErrPOS);
	END IF;

    IF Var_TipoConexion = Cone_Entura THEN
		SELECT CodigoEnturaID INTO Par_CodigoResp FROM
		CATCODIGORESPEQSAFI WHERE CodigoSAFI = Par_CodigoSAFI;

		SET Par_CodigoResp := IFNULL(Par_CodigoResp,Cod_ErrSis);
	END IF;


	SET Par_NumErr := 0;
    SET Par_ErrMen := 'Codigo de Respuesta Exitoso';

END ManejoErrores;


	IF  Par_Salida = Salida_SI THEN

		SELECT Par_NumErr AS NumErr,
			    Par_ErrMen AS ErrMen,
                Par_CodigoResp AS Consecutivo;

    END IF;


END TerminaStore$$