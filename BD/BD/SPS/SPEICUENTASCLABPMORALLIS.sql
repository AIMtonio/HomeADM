-- SPEICUENTASCLABPMORALLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS SPEICUENTASCLABPMORALLIS;
DELIMITER $$

CREATE PROCEDURE SPEICUENTASCLABPMORALLIS(
	Par_PIDTarea			VARCHAR(50),			-- ID de Proceso del Demonio
   	Par_NumLis				TINYINT UNSIGNED,		-- Numero de consulta

    Par_EmpresaID       	INT(11),				-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),				-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,				-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),			-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),			-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),				-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Lis_Inactivos		INT(11);			-- lista de cuentas inactivas
	DECLARE Lis_PendEnvioDem	INT(11);			-- lista para el demonio
	DECLARE EstInactivo			CHAR(1);

	-- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';
	SET Fecha_Vacia         	:= '1900-01-01';
	SET Entero_Cero         	:= 0;
	SET Decimal_Cero			:= 0.0;
	SET Lis_Inactivos			:= 1;				-- lista de cuentas inactivas
	SET Lis_PendEnvioDem		:= 2;				-- lista para el demonio
	SET EstInactivo				:= 'I';
	
	IF(Par_NumLis = Lis_Inactivos) THEN 
		SELECT 	SpeiCuentaPMoralID,		ClienteID,		CuentaClabe,			FechaCreacion,			Estatus,
				TipoInstrumento,		Instrumento
			FROM SPEICUENTASCLABPMORAL WHERE Estatus = EstInactivo;
	
	END IF;

	-- Opcion 2 .- Lista de Cuentas clabes para la tarea de registro de cuentas clabes
	IF(Par_NumLis = Lis_PendEnvioDem) THEN
		SELECT 	SpeiCuentaPMoralID,			ClienteID,				TipoInstrumento,			Instrumento,				CuentaClabe,
				FechaCreacion,				Estatus,				RazonSocial,				EmpresaSTP,					RFC,
				CURP,						NumIntentos,			ClavePaisSTP,				
				DATE_FORMAT(IFNULL(FechaConstitucion, Fecha_Vacia), '%Y%m%d') as FechaConstitucion,	
				IF(RFC = Cadena_Vacia, CURP, RFC)  AS RfcCurp, 			
				EmpresaID,					Usuario,				DireccionIP,				Sucursal				
		FROM SPEICUENTASCLABPMORAL
		WHERE PIDTarea = Par_PIDTarea AND Estatus = EstInactivo;
	END IF;
END TerminaStore$$
