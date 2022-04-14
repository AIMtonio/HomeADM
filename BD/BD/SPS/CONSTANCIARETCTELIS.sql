-- CONSTANCIARETCTELIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONSTANCIARETCTELIS`;
DELIMITER $$

CREATE PROCEDURE `CONSTANCIARETCTELIS`(
-- -------------------------------------------------------------------------------- --
-- -- SP DE LISTA DE INFORMACION PARA LA GENERACION DE CONSTANCIAS DE RETENCION --- --
-- -------------------------------------------------------------------------------- --
	Par_AnioProceso 		INT(11),		-- Anio para generar Constancia Retencion
    Par_SucursalInicio		INT(11),		-- Sucursal de Inicio
	Par_SucursalFin			INT(11),		-- Sucursal de Fin
	Par_NombreComp		    VARCHAR(50),	-- Nombre Completo Cliente
    Par_ClienteID			INT(11),		-- Numero de Cliente

    Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

    Par_EmpresaID       	INT(11),		-- Parametro de auditoria ID de la empresa
    Aud_Usuario         	INT(11),		-- Parametro de auditoria ID del usuario
    Aud_FechaActual     	DATETIME,		-- Parametro de auditoria Fecha actual
    Aud_DireccionIP     	VARCHAR(15),	-- Parametro de auditoria Direccion IP
    Aud_ProgramaID      	VARCHAR(50),	-- Parametro de auditoria Programa
    Aud_Sucursal        	INT(11),		-- Parametro de auditoria ID de la sucursal
    Aud_NumTransaccion  	BIGINT(20)  	-- Parametro de auditoria Numero de la transaccion
)TerminaStore:BEGIN

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	Lis_Principal	INT(11);
	DECLARE Lis_Foranea		INT(11);

	DECLARE Lis_Rango		INT(11);
	DECLARE Lis_Cte			INT(11);
    DECLARE Lis_CteConsRet	INT(11);
    DECLARE Lis_RangoCtePDF	INT(11);
    DECLARE Cons_SI			CHAR(1);		-- Constante si

    DECLARE Var_GeneraConsRetPDF 	CHAR(1);		-- Parametro S=si genera la constancia para todos o N= solo los qu tienen ISR mayor  0

	-- Asignacion de Constantes
	SET	Cadena_Vacia	:= '';				-- Cadena vacia
	SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha vacia
	SET	Entero_Cero		:= 0;				-- Entero Cero
	SET	Lis_Principal	:= 1;				-- Lista Principal
	SET	Lis_Foranea		:= 2;				-- Lista Foranea

	SET Lis_Rango		:= 3;				-- Lista de Rangos
    SET Lis_Cte			:= 4;				-- Lista de Clientes
    SET Lis_CteConsRet	:= 5; 				-- Lista de Clientes para generar la Constancia de Retencion
	SET Lis_RangoCtePDF	:= 6;				-- Lista rango de clientes para generar constancia en PDF
    SET Cons_SI			:= 'S';

    -- 1.- Lista Principal
    IF(Par_NumLis = Lis_Principal)THEN
		SELECT 	Anio, 	SucursalID, 	ClienteID,  CadenaCFDI,	Estatus, 	RFC,
				CONCAT(Anio,Mes,LPAD(ClienteID,10,'0')) AS IdentificadorBus
		FROM CONSTANCIARETCTE
		WHERE Anio = Par_AnioProceso
			AND CadenaCFDI != Cadena_Vacia
			AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin;
	END IF;

	-- 2.- Lista Foranea
	IF(Par_NumLis = Lis_Foranea )THEN
		SELECT DISTINCT(ClienteID), Cte.SucursalID,
			CONCAT(Par.RutaCBB, Par.AnioProceso, '/', LPAD(CONVERT(Cte.SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0), '-',Par.AnioProceso, '.png') AS RutaCBB,
			CONCAT(Par.RutaCFDI, Par.AnioProceso, '/', LPAD(CONVERT(Cte.SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(Cte.ClienteID,CHAR), 10, 0), '-',Par.AnioProceso, '.xml') AS RutaXML
		FROM CONSTANCIARETCTE Cte, CONSTANCIARETPARAMS Par
		WHERE Cte.SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
			AND Cte.Anio = Par_AnioProceso;
	END IF;

	-- 3.- Lista de Rangos
	IF(Par_NumLis = Lis_Rango)THEN
		SELECT MIN(ClienteID) AS Minimo, MAX(ClienteID) AS Maximo, COUNT(ClienteID) AS NumRegistros
		FROM CONSTANCIARETCTE
		WHERE SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
			AND Anio = Par_AnioProceso;
	END IF;

	-- 4.- Lista de Clientes
	IF(Par_NumLis = Lis_Cte)THEN
		SELECT 	Anio, SucursalID, ClienteID,  CadenaCFDI,		Estatus, 	RFC,
				CONCAT(Anio,Mes,LPAD(ClienteID,10,'0')) AS IdentificadorBus
		FROM CONSTANCIARETCTE
		WHERE Anio = Par_AnioProceso AND CadenaCFDI != Cadena_Vacia
			AND SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
			AND ClienteID = Par_ClienteID;
	END IF;

    -- 5.- Lista de Clientes para generar la Constancia de Retencion
	IF(Par_NumLis = Lis_CteConsRet)THEN
		SELECT Con.ClienteID,  Cte.NombreCompleto
		FROM CONSTANCIARETCTE Con,
				 CLIENTES Cte
		WHERE Con.ClienteID = Cte.ClienteID
            AND Con.Anio = Par_AnioProceso
            AND Cte.NombreCompleto LIKE CONCAT("%", Par_NombreComp, "%")
		LIMIT 0,15;
	END IF;


	-- 6.- Lista de Rangos clientes par generar su constancia en pdf
	IF(Par_NumLis = Lis_RangoCtePDF)THEN

		SET Var_GeneraConsRetPDF := (SELECT GeneraConsRetPDF FROM CONSTANCIARETPARAMS LIMIT 1);

		DROP TABLE IF EXISTS TMPRANGOCTECONSRET;
		CREATE TEMPORARY TABLE TMPRANGOCTECONSRET(
			ClienteID			INT(11),
            NumTransaccion		BIGINT(20),
			PRIMARY KEY(ClienteID),
            KEY `IDX_TMPRANGOCTECONSRET_1` (`NumTransaccion`)
		);
        INSERT INTO TMPRANGOCTECONSRET
		SELECT ClienteID, Aud_NumTransaccion
        FROM CONSTANCIARETCTE
		WHERE SucursalID BETWEEN Par_SucursalInicio AND Par_SucursalFin
			AND Anio = Par_AnioProceso
            AND ClienteID >= Par_ClienteID
            AND IF(Var_GeneraConsRetPDF = Cons_SI,
				MontoTotRet >= Entero_Cero,
                MontoTotRet > Entero_Cero)
		LIMIT 500;

		SELECT MIN(ClienteID) AS Minimo, MAX(ClienteID) AS Maximo, COUNT(ClienteID) AS NumRegistros
		FROM TMPRANGOCTECONSRET
        WHERE NumTransaccion = Aud_NumTransaccion;
	END IF;

END TerminaStore$$