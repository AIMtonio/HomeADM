-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASSANTANDERACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASSANTANDERACT`;
DELIMITER $$


CREATE PROCEDURE `CUENTASSANTANDERACT`(
	/*SP PARA ACTUALIZACION DE LAS CUENTAS DE SANTANDER U OTROS*/
	Par_Estatus				CHAR(1),			-- ESTATUS
    Par_NumeroCta			VARCHAR(20),		-- NUMERO DE CUENTA
    Par_CodigoRechazo		CHAR(20),			-- CODIGO DE RECHAZO
    Par_NombreArchivo		VARCHAR(100),		-- NOMBRE DEL ARCHIVO   
    Par_TipoArchivo			VARCHAR(4),			-- TIPO DE ARCHIVO QUE SE PROCESO
    
    Par_TipoAct				TINYINT UNSIGNED, 	-- TIPO DE TRANSACCION
	Par_Salida				CHAR(1), 			-- SALIDA
	INOUT Par_NumErr		INT(11),			-- NUM ERROR
	INOUT Par_ErrMen		VARCHAR(400),		-- MENSAJE DE ERROR
	Aud_EmpresaID			INT(11),			-- AUDITORIA
    
	Aud_Usuario				INT(11),			-- AUDITORIA
	Aud_FechaActual			DATETIME,			-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal			INT(11),			-- AUDITORIA
	
    Aud_NumTransaccion		BIGINT(20)			-- AUDITORIA
	)

TerminaStore: BEGIN
	-- DECLARACIO DE VARIABLES
    DECLARE Var_Control			VARCHAR(25);
    DECLARE Var_NumeroCta		VARCHAR(20);
    DECLARE Var_CtaExistentes	INT(11);
    
	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);		-- CADENA VACIA
	DECLARE Fecha_Vacia			DATE;			-- FECHA VACIA
	DECLARE Entero_Cero			INT(11);		-- ENTERO CERO
	DECLARE Entero_Uno			INT(11);		-- ENTERO UNO
	DECLARE Salida_SI			CHAR(1);		-- SALIDA SI
	DECLARE Salida_No			CHAR(1);		-- SALIDA NO
	DECLARE EstatusA			CHAR(1);		-- ESTATUS ACTIVO
	DECLARE EstatusC			CHAR(1);		-- ESTATUS CANCELADO
	DECLARE EstatusJ			CHAR(1);		-- ESTATUS EJECUTADA
	DECLARE EstatusN			CHAR(1);		-- ESTATUS EN PROCESO
	DECLARE EstatusP			CHAR(1);		-- ESTATUS PENDIENTE DE AUTORIZAR
	DECLARE EstatusD			CHAR(1);		-- ESTATUS PENDIENTE DE ACTIVAR
	DECLARE EstatusR			CHAR(1);		-- ESTATUS RECHAZADA
	DECLARE Act_CtasActivas		INT(11);		-- ACTUALIZACION DE CUENTAS ACTIVAS
	DECLARE Act_CtasPendientes	INT(11);		-- ACTUALIZACION DE CUENTAS PENDIENTES
    
	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
    SET Salida_SI			:= 'S';
	SET Entero_Cero			:= 0;
	SET Entero_Uno			:= 1;
	SET Act_CtasActivas		:= 1;
    SET Act_CtasPendientes	:= 2;
	SET EstatusA			:= "A";
	SET EstatusC			:= "C";
	SET EstatusJ			:= "J";
	SET EstatusN			:= "N";
	SET EstatusP			:= "P";
	SET EstatusD			:= "D";
	SET EstatusR			:= "R";
    
ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASSANTANDERACT');
	END;

	-- ACTUALIZACION DE CUENTAS ACTIVAS
    IF(Par_TipoAct = Act_CtasActivas)THEN
		UPDATE CUENTASSANTANDER CUE
		INNER JOIN DISPCTAACTIVAS DIS ON DIS.NumeroCta=CUE.NumeroCta
            SET CUE.Estatus = EstatusA,
				CUE.DesEstatus = "Activa"
		WHERE DIS.NumTransaccion=Aud_NumTransaccion
		AND NombreArchivo=Par_NombreArchivo; 
    END IF;
    
    -- ACTUALIZACION DE CUENTAS PENDIENTES
    IF(Par_TipoAct = Act_CtasPendientes)THEN           
		UPDATE CUENTASSANTANDER CUE
		INNER JOIN DISPCTAPENDIENTES DIS ON DIS.NumeroCta=CUE.NumeroCta
            SET CUE.Estatus = CASE DIS.Estatus WHEN "Cancelada" THEN EstatusC
											   WHEN "Ejecutada" THEN EstatusJ
                                               WHEN "En proceso" THEN EstatusN
                                               WHEN "Pendiente por autorizar" THEN EstatusP
                                               WHEN "Pendiente por activar" THEN EstatusD
                                               WHEN "Rechazada" THEN EstatusR
								ELSE CUE.Estatus END,
				 CUE.DesEstatus = DIS.Estatus
		WHERE DIS.NumTransaccion=Aud_NumTransaccion
		AND NombreArchivo=Par_NombreArchivo; 
        
    END IF;	
    
	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Operacion Realizada Exitosamente.');
	SET Var_Control := 'rutaArchCtasActivas';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$
