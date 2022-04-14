-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSCTELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADATOSCTELIS`;
DELIMITER $$

CREATE PROCEDURE `EDOCTADATOSCTELIS`(
	-- Lista de Clientas para generar el Estado de Cuenta
	Par_Descripcion 	VARCHAR(100),		-- Descripcion
	Par_SucursalInicio 	INT(11),			-- Sucursal Inicio
	Par_SucursalFin		INT(11),			-- Sucursal Final
	Par_ClienteID		INT(11),			-- Numero de Cliente

	Par_NumLis			TINYINT UNSIGNED,	-- Numero de Lista

	Aud_EmpresaID		INT(11),			-- Parametro de Auditoria
	Aud_Usuario			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal		INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT;
	DECLARE	Lis_Principal	INT;
	DECLARE Lis_Foranea		INT;

    DECLARE Lis_Rango		INT;
	DECLARE Lis_Cte			INT;

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';				-- Cadena Vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero		:= 0;				-- Entero Cero
	SET	Lis_Principal	:= 1;				-- Lista Principal
	SET	Lis_Foranea		:= 2;				-- Lista Foranea

    SET Lis_Rango		:= 3;				-- Lista por Rangos
	SET Lis_Cte			:= 4;				-- Lista por Clientes

	-- 1.- Lista Principal
	IF (Par_NumLis = Lis_Principal )THEN
		SELECT AnioMes, SucursalID, ClienteID,  CadenaCFDI,	Estatus, CadenaCFDIRet, EstatusRet, CONCAT(AnioMes,LPAD(ClienteID,10,'0')) AS IdentificadorBus
			FROM EDOCTADATOSCTE
			WHERE AnioMes = Par_Descripcion
			AND (CadenaCFDI != Cadena_Vacia OR CadenaCFDIRet != Cadena_Vacia)
			AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin;
	END IF;

	-- 2.- Lista Foranea
	IF (Par_NumLis = Lis_Foranea )THEN
		SELECT DISTINCT(ClienteID), Cte.SucursalID,
			CONCAT(Par.RutaCBB, Par.PrefijoEmpresa, '/', MesProceso, '/', LPAD(CONVERT(Cte.SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0),'-','1','-',MesProceso, '.png') AS RutaCBB,
			CONCAT(Par.RutaCFDI, Par.PrefijoEmpresa, '/', MesProceso, '/', LPAD(CONVERT(Cte.SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0),'-','1','-',MesProceso, '.xml') AS RutaXML,
            CONCAT(Par.RutaCBB, MesProceso, '/', LPAD(CONVERT(Cte.SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0),'-','2','-',MesProceso, '.png') AS RutaCBBRet,
			CONCAT(Par.RutaCFDI, MesProceso, '/', LPAD(CONVERT(Cte.SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0),'-','2','-',MesProceso, '.xml') AS RutaXMLRet
		FROM EDOCTADATOSCTE Cte, EDOCTAPARAMS Par
		WHERE SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin;
	END IF;

    -- 3.- Lista por Rangos
	IF (Par_NumLis = Lis_Rango)THEN
		SELECT MIN(ClienteID) AS minimo, MAX(ClienteID) AS maximo, COUNT(ClienteID) AS numRegistros
		FROM EDOCTADATOSCTE
		WHERE SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin;
	END IF;

	-- 4.- Lista por Cliente
	IF (Par_NumLis = Lis_Cte )THEN
		SELECT AnioMes, SucursalID, ClienteID,  CadenaCFDI, Estatus, CadenaCFDIRet, EstatusRet, CONCAT(AnioMes,LPAD(ClienteID,10,'0')) AS IdentificadorBus
			FROM EDOCTADATOSCTE
			WHERE AnioMes = Par_Descripcion
            AND (CadenaCFDI != Cadena_Vacia OR CadenaCFDIRet != Cadena_Vacia)
			AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
			AND ClienteID = Par_ClienteID;
	END IF;

END TerminaStore$$