-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISBITACORAACCESOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISBITACORAACCESOALT`;DELIMITER $$

CREATE PROCEDURE `HISBITACORAACCESOALT`(
# =====================================================================================
# ------- STORED PARA EL PASO A HISTORICO DE LA TABLA DE BITACORA DE ACCESOS  ---------
# =====================================================================================
	Par_FechaOperacion		DATE,				-- Fecha de operacion cuando se realiza el cierre

    Par_Salida    			CHAR(1), 			-- Parametro de salida S= si, N= no
    INOUT	Par_NumErr 		INT(11),			-- Parametro de salida numero de error
    INOUT	Par_ErrMen  	VARCHAR(400),		-- Parametro de salida mensaje de error

    Par_EmpresaID       	INT(11),			-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),			-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,			-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(150),		-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),			-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  		-- Parametro de auditoria Numero de la transaccion
	)
TerminaStore: BEGIN


	-- DECLARACION DE VARIABLES

    -- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Salida_SI       	CHAR(1);      		-- Parametro de salida SI

	DECLARE Salida_NO       	CHAR(1);      		-- Parametro de salida NO
	DECLARE Entero_Uno      	INT(11);      		-- Entero Uno

    -- ASIGNACIŃ DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Salida_SI          		:= 'S';

	SET Salida_NO           	:= 'N';
	SET Entero_Uno          	:= 1;

	ManejoErrores:BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
		BEGIN
			SET Par_NumErr = 999;
			SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
			concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP- HISBITACORAACCESOALT ');
		END;


	INSERT INTO `HISBITACORAACCESO` (
			FechaCorte, 		AccesoID, 		Fecha, 			Hora, 			ClaveUsuario,
            SucursalID, 		UsuarioID, 		Perfil, 		AccesoIP, 	    Recurso,
            TipoAcceso, 		TipoMetodo, 	DetalleAcceso,
            EmpresaID, 			Usuario, 		FechaActual, 	DireccionIP, 	ProgramaID,
            Sucursal, 			NumTransaccion
	)
	SELECT 	Par_FechaOperacion,	AccesoID, 		Fecha, 			Hora, 			ClaveUsuario,
            SucursalID, 		UsuarioID, 		Perfil, 		AccesoIP, 	    Recurso,
            TipoAcceso, 		TipoMetodo, 	DetalleAcceso,
            EmpresaID, 			Usuario, 		FechaActual, 	DireccionIP, 	ProgramaID,
            Sucursal, 			NumTransaccion
					FROM BITACORAACCESO
						WHERE Fecha <= Par_FechaOperacion;


	DELETE FROM  BITACORAACCESO
		WHERE Fecha <= Par_FechaOperacion;


	SET Par_NumErr 	:=	0;
	SET Par_ErrMen	:=	'Historico de bitacora de accesos Realizado Exitosamente';

	END ManejoErrores;

	IF (Par_Salida = Salida_SI) THEN
		SELECT  Par_NumErr AS NumErr,
					Par_ErrMen AS ErrMen;
	END IF;

END TerminaStore$$