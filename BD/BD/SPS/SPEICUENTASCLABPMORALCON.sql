-- SPEICUENTASCLABPMORALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS SPEICUENTASCLABPMORALCON;
DELIMITER $$

CREATE PROCEDURE SPEICUENTASCLABPMORALCON(
	Par_ClienteID			INT(11),
	Par_Instrumento			BIGINT(12),
	Par_CuentaClabe			VARCHAR(18),			-- Cuenta clabe ante STP
   	Par_NumCon				TINYINT UNSIGNED,		-- Numero de consulta

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN
	-- DECLARACION DE CONSTANTES

	DECLARE Cadena_Vacia		CHAR(1);     		-- Constante cadena vacia ''
	DECLARE Fecha_Vacia     	DATE;		   		-- Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero     	INT(1);       		-- Constante Entero cero 0
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- DECIMAL cero
	DECLARE Con_Principal		INT(11);			-- consulta principal
	DECLARE Con_Firma			INT(11);			-- Consulta de firma
	DECLARE Est_Activo			CHAR(1);			-- Estatus activo
	DECLARE Est_Baja			CHAR(1);			-- Estatus baja
	DECLARE Est_Inactivo		CHAR(1);			-- Estatus inactivo
	DECLARE Est_PendAuto		CHAR(1);			-- Estatus pendiente autorizacion

	-- ASIGNACION DE CONSTANTES

	SET Cadena_Vacia        	:= '';				-- Constante cadena vacia ''
	SET Fecha_Vacia         	:= '1900-01-01';	-- Constante Fecha vacia 1900-01-01
	SET Entero_Cero         	:= 0;				-- Constante Entero cero 0
	SET Decimal_Cero			:= 0.0;				-- DECIMAL cero
	SET Con_Principal			:= 1;				-- consulta principal
	SET Con_Firma				:= 2;				-- Consulta de firma
	SET Est_Activo				:= 'A';				-- Estatus activo
	SET Est_Baja				:= 'B';				-- Estatus baja
	SET Est_Inactivo			:= 'I';				-- Estatus inactivo
	SET Est_PendAuto			:= 'P';				-- Estatus pendiente autorizacion
	
	IF(Par_NumCon = Con_Principal) THEN 
		SELECT 	SpeiCuentaPMoralID,		ClienteID,		CuentaClabe,			FechaCreacion,			Estatus,
				TipoInstrumento,		Instrumento,
        	CASE WHEN Estatus = Est_Activo THEN 'AUTORIZADO'
				WHEN Estatus = Est_Inactivo THEN 'INACTIVO'
            	WHEN Estatus = Est_Baja	THEN 'BAJA'
            	WHEN Estatus = Est_PendAuto THEN 'PENDIENTE POR AUTORIZAR' END DesEstatus
			FROM SPEICUENTASCLABPMORAL where ClienteID = Par_ClienteID and Instrumento = Par_Instrumento;
	END IF;

	-- Opcion 2 .- Consulta para ws de registro de cuentas clabes
	IF(Par_NumCon = Con_Firma) THEN
		SELECT 	SpeiCuentaPMoralID,		Estatus,				Firma,					ClienteID,					CuentaClabe
		FROM SPEICUENTASCLABPMORAL
		WHERE CuentaClabe = Par_CuentaClabe;
	END IF;
END TerminaStore$$
