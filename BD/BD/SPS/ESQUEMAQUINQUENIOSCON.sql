-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESQUEMAQUINQUENIOSCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESQUEMAQUINQUENIOSCON`;
DELIMITER $$


CREATE PROCEDURE `ESQUEMAQUINQUENIOSCON`(
-- SP PARA CONSULTAR ESQUEMA DE QUINQUENIOS
	Par_InstitNominaID			INT(11),			-- Numero de Institucion Nomina
	Par_ConvenioNominaID    	BIGINT UNSIGNED,	-- Numero de Convenio Nomina
	Par_SucursalID				INT(11),			-- Sucursal del cliente
    Par_QuinquenioID			INT(11),			-- Quinquenio ID
    Par_ClienteID				INT(11),			-- Cliente ID
   
	Par_NumCon					TINYINT UNSIGNED,	-- Parametro que solicita el numero de consulta
    
	Aud_EmpresaID				INT(11),			-- Parametros de auditoria
	Aud_Usuario					INT(11),			-- Parametros de auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal				INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de auditoria
	)

TerminaStore: BEGIN


-- DECLARACION DE CONSTANTES
	DECLARE EstatusActivo		CHAR(1);
	DECLARE Con_Principal   	INT(11);
	DECLARE Con_Foranea		   	INT(11);
    DECLARE Con_ExisteEsqueQ    INT(11);

	-- ASIGNACION DE CONSTANTES
    SET EstatusActivo			:="A";
	SET Con_Principal			:= 1;
	SET Con_Foranea				:= 2;
    SET Con_ExisteEsqueQ		:= 3;


 
	-- Consulta principal
	IF(Par_NumCon = Con_Principal) THEN
		SELECT EsqQuinquenioID, 			InstitNominaID, 	ConvenioNominaID, 			SucursalID, 
			   QuinquenioID, 				PlazoID, 			EmpresaID
			FROM ESQUEMAQUINQUENIOS
            WHERE FIND_IN_SET(Par_QuinquenioID, QuinquenioID)
            AND FIND_IN_SET(Par_SucursalID, SucursalID)
            AND InstitNominaID = Par_InstitNominaID
            AND ConvenioNominaID = Par_ConvenioNominaID;
	END IF;
    
    -- Consulta foranea
    IF(Par_NumCon = Con_Foranea) THEN
        SELECT 	ESQ.EsqQuinquenioID, 			NOM.InstitNominaID, 	NOM.ConvenioNominaID, 			ESQ.SucursalID, 
				NOM.QuinquenioID, 				ESQ.PlazoID, 			ESQ.EmpresaID,					CONCAT(CAT.QuinquenioID,"-",CAT.DescripcionCorta) AS DesQuinquenio,
                CRE.Descripcion AS Desplazo,	CON.ManejaQuinquenios
			FROM CONVENIOSNOMINA CON
			INNER JOIN ESQUEMAQUINQUENIOS ESQ ON ESQ.ConvenioNominaID= CON.ConvenioNominaID
			INNER JOIN NOMINAEMPLEADOS NOM ON NOM.ConvenioNominaID= CON.ConvenioNominaID
			INNER JOIN CATQUINQUENIOS CAT ON CAT.QuinquenioID= NOM.QuinquenioID
			LEFT OUTER JOIN CREDITOSPLAZOS CRE ON FIND_IN_SET(CRE.PlazoID, ESQ.PlazoID) AND CRE.PlazoID IS NULL
			WHERE FIND_IN_SET(Par_SucursalID, ESQ.SucursalID)
			AND NOM.ClienteID = Par_ClienteID
			AND NOM.InstitNominaID = Par_InstitNominaID
            AND NOM.Estatus	= EstatusActivo
            AND CON.Estatus = EstatusActivo
            LIMIT 1;

	END IF;
    
    -- Consulta para saber si el convenio e empresa nomina cuenta con un esquema de quinquenio
	IF(Par_NumCon = Con_ExisteEsqueQ) THEN
    SELECT COUNT(EsqQuinquenioID) AS Cantidad  FROM ESQUEMAQUINQUENIOS
			WHERE InstitNominaID = Par_InstitNominaID
            AND ConvenioNominaID = Par_ConvenioNominaID;
	
	END IF;
    
    
END TerminaStore$$