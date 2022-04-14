
-- CUENTASTRANSFERCON --

DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASTRANSFERCON`;
-- --------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- --------------------------------------------------------------------------------
DELIMITER $$
CREATE PROCEDURE `CUENTASTRANSFERCON`(
	Par_ClienteID		INT(11),
	Par_CuentaTranID	INT(11),
    Par_Clabe			VARCHAR(20),
	Par_NumCon			TINYINT UNSIGNED,
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),

	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
)
TerminaStore: BEGIN
	# DECLARACION DE VARIABLES
    DECLARE Var_ClaveSPEI		INT(11);
    DECLARE Var_InstBanco		INT(11);

	# DECLARACION DE CONSTANTES.
	DECLARE Cadena_Vacia      	CHAR(1);
	DECLARE Entero_Cero        	INT(11);
	DECLARE Fecha_Vacia         DATE;
	DECLARE Con_Principal		INT(11);
	DECLARE Con_PrincipalDos	INT(11);
	DECLARE Con_Beneficiarios   INT(11);
	DECLARE Con_Afiliacion		INT(11);
	DECLARE Con_ExisteDomicilia INT(11);
	DECLARE Con_Clabe			INT(11);
	DECLARE Con_Activo			CHAR(1);
	DECLARE Con_Credito			CHAR(1);
	DECLARE Con_Ambas			CHAR(1);

	# ASIGNACION DE CONSTANTES.
	SET Cadena_Vacia			:= '';
	SET Fecha_Vacia    			:= '1900-01-01';
	SET Entero_Cero        		:= 0;
	SET Con_Activo				:='A';				-- Estatus Activo
	SET Con_Credito				:='C';				-- Aplica para Credito
	SET Con_Ambas				:='A';				-- Aplica para Ambas
    SET	Con_Principal			:= 1;				-- Consulta principal
	SET	Con_PrincipalDos		:= 2;				-- Consulta principal 2
	SET Con_Beneficiarios		:= 3;				-- Consulta benificiarios
	SET Con_Afiliacion			:= 4;				-- Consulta de Afiliacion
	SET Con_ExisteDomicilia		:= 5;				-- Consulta Existe Domiciliacion
	SET Con_Clabe				:= 6;				-- Consulta de Cuenta Clabe
    

	IF(Par_NumCon = Con_Principal )THEN
		SELECT
			ClienteID,		CuentaTranID,		InstitucionID,	Clabe,			Beneficiario,
			Alias,			FechaRegistro,		Estatus,		CuentaDestino,	TipoCuenta,
			TipoCuentaSpei,	RFCBeneficiario,	EsPrincipal,	AplicaPara,		EstatusDomici AS EstatusDomicilio
		FROM CUENTASTRANSFER
			WHERE ClienteID = Par_ClienteID
				AND CuentaTranID = Par_CuentaTranID;
	END IF;

	IF(Par_NumCon = Con_PrincipalDos )THEN
		SELECT
			ClienteID,		CuentaTranID,		InstitucionID,	Clabe,			Beneficiario,
			Alias,			FechaRegistro,		Estatus,		CuentaDestino,	TipoCuenta,
			TipoCuentaSpei,	RFCBeneficiario,	EsPrincipal,	AplicaPara,		EstatusDomici AS EstatusDomicilio
		FROM CUENTASTRANSFER
			WHERE ClienteID = Par_ClienteID
				AND CuentaTranID = Par_CuentaTranID;
	END IF;

	IF(Par_NumCon = Con_Beneficiarios )THEN
		SELECT
				CT.ClienteID,							CT.CuentaTranID,		CT.InstitucionID,	CT.Clabe,			CT.Beneficiario,
				CT.Alias,								CT.FechaRegistro,		CT.Estatus,			CT.CuentaDestino,	CT.TipoCuenta,
				IFNULL(CT.TipoCuentaSpei,Entero_Cero) AS TipoCuentaSpei,	CT.RFCBeneficiario,		CT.EsPrincipal,		UPPER(IT.NombreCorto) AS NombreCorto
			FROM CUENTASTRANSFER CT, INSTITUCIONES IT
		WHERE  IT.ClaveParticipaSpei 	= CT.InstitucionID
			AND	  CT.ClienteID = Par_ClienteID 
			AND	  CT.Clabe = Par_Clabe
			AND	  CT.Estatus = Con_Activo;
	END IF;

	-- 4.- Consulta de Afiliacion
	IF(Par_NumCon = Con_Afiliacion)THEN
		SELECT InstitucionID INTO Var_ClaveSPEI
			FROM CUENTASTRANSFER
			WHERE ClienteID = Par_ClienteID	
            AND Estatus = Con_Activo 
            AND AplicaPara IN (Con_Credito,Con_Ambas);

		SELECT InstitucionID INTO Var_InstBanco
			FROM INSTITUCIONES
			WHERE ClaveParticipaSpei = Var_ClaveSPEI;

		SELECT ClienteID, Var_InstBanco AS InstitucionID, Clabe
			FROM CUENTASTRANSFER
			WHERE ClienteID = Par_ClienteID	
            AND Estatus = Con_Activo;

	END IF;
	-- 5.- Consulta Existe Domiciliacion
	IF Par_NumCon = Con_ExisteDomicilia THEN
		SELECT ClienteID,	Clabe,	EstatusDomici AS EstatusDomicilio
			FROM CUENTASTRANSFER
			WHERE AplicaPara IN (Con_Credito,Con_Ambas)
			AND ClienteID = Par_ClienteID
			AND Estatus = Con_Activo;
	END IF;

	-- 6.- Consulta de Cuenta Clabe
	IF (Par_NumCon = Con_Clabe) THEN
		SELECT ClienteID,	Clabe,	EstatusDomici AS  EstatusDomicilio
			FROM CUENTASTRANSFER
			WHERE AplicaPara IN (Con_Credito,Con_Ambas)
			AND Clabe = Par_Clabe
			AND Estatus = Con_Activo;
	END IF;

END TerminaStore$$