-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASBCAMOVILCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASBCAMOVILCON`;
DELIMITER $$

CREATE PROCEDURE `CUENTASBCAMOVILCON`(
# ===================================================================================================
# ------- STORE PARA REALIZAR CONSULTAS DE LAS CUENTAS DE BANCA MOVIL PADEMOBILE --------
# ===================================================================================================
	Par_CuentasBcaMovID	BIGINT(20),  			-- Numero del registro para Banca Movil
   	Par_ClienteID		INT(11),				-- Numero de Cliente
	Par_NumCon			TINYINT UNSIGNED,		-- Numero de Consulta

	Par_EmpresaID		INT(11),				-- Parametro de Auditoria
	Aud_Usuario			INT(11),				-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,				-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(20),			-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),			-- Parametro de Auditoria
	Aud_Sucursal		INT(11),				-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)				-- Parametro de Auditoria
)
TerminaStore: BEGIN


	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Con_Principal   INT;
	DECLARE	Con_FCliente	INT;

	DECLARE	Status_A		CHAR(1);
	DECLARE	Status_I		CHAR(1);
	DECLARE	Sprincipal		CHAR(1);
    DECLARE	Con_TelCuenta	INT(11);


	-- ASIGNACION  DE CONSTANTES
	SET	Cadena_Vacia	:= '';              -- Constante cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';    -- Constante Fecha vacia
	SET	Entero_Cero		:= 0;               -- Constante entero cero
	SET	Con_Principal	:= 1;               -- Consulta principal
	SET Con_FCliente	:= 2;				-- Consulta Cliente con Cuenta BCA

    SET	Status_A		:= 'A';				-- Status de Activo
	SET	Status_I		:= 'I';				-- Status de Inactivo
	SET Sprincipal		:= 'S';				-- Es Principal
    SET Con_TelCuenta	:= 4;				-- Telefono Celular de la Cuenta del Cliente

	-- 1.- Consulta principal
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	CM.CuentasBcaMovID,	CM.UsuarioPDMID,	CI.ClienteID,	CI.NombreCompleto,	CM.CuentaAhoID,
				CM.RegistroPDM, CO.TelefonoCelular,	CM.Estatus
			FROM CUENTASBCAMOVIL CM
				INNER JOIN	CLIENTES CI ON CM.ClienteID 	= CI.ClienteID
                INNER JOIN 	CUENTASAHO CO ON CI.ClienteID 	= CO.ClienteID
							AND CM.CuentaAhoID = CO.CuentaAhoID
			WHERE	CM.CuentasBcaMovID 	= Par_CuentasBcaMovID;
	END IF;

	-- 2.- Consulta Cliente con Cuenta BCA
	IF(Par_NumCon = Con_FCliente) THEN
		SELECT	CM.CuentasBcaMovID,	CM.UsuarioPDMID,	CI.ClienteID,	CI.NombreCompleto,	CO.CuentaAhoID,
				CM.RegistroPDM, CO.TelefonoCelular,	CM.Estatus
			FROM CUENTASBCAMOVIL CM
				INNER JOIN	CLIENTES CI ON CM.ClienteID = CI.ClienteID
				INNER JOIN	CUENTASAHO CO ON CI.ClienteID = CO.ClienteID
			WHERE	CM.ClienteID = Par_ClienteID;
	END IF;

    -- 4.- Consulta Telefono Celular de la Cuenta para la Verificacion de Preguntas de Seguridad
	IF(Par_NumCon = Con_TelCuenta) THEN
		SELECT	Cta.ClienteID,	Pre.CuentaAhoID,	Cta.Telefono
			FROM CUENTASBCAMOVIL Cta,
			PREGUNTASSEGURIDAD Pre
            WHERE Pre.CuentaAhoID = Cta.CuentaAhoID
            AND Pre.ClienteID = Cta.ClienteID
            AND Pre.ClienteID = Par_ClienteID
            LIMIT 1;
	END IF;

END TerminaStore$$