-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSTIMBRADOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADATOSTIMBRADOREP`;
DELIMITER $$

CREATE PROCEDURE `EDOCTADATOSTIMBRADOREP`(
	Par_NumCon				TINYINT unsigned,

	Par_ClienteID			INT(11)
)

TerminaStore:BEGIN
-- DECLARACION DE CONSTANTES    ------
DECLARE Con_Principal		INT(11);

-- ASIGNACION DE CONSTANTES
SET Con_Principal		    := 1;


	IF ( Par_NumCon = Con_Principal ) THEN
        -- Sera necesario cambiar el principal del LEFT JOIN en caso de querer hacer pruebas o cuando se tenga que usar en otro cliente que no este en el principalSofom
        SELECT
            CFDINoCertSAT AS SERIECERTIFICADOSAT,
            CFDIFechaEmision AS FECHAEMISIONCFDI,
            CFDINoCertEmisor AS SERIECERTIFICADOEMISOR,
            CFDIUUID AS FOLIOFISCAL,
            CFDISelloCFD AS SELLODIGITALCFD,
            CFDISelloSAT AS SELLODIGITALSAT,
            CFDICadenaOrig as CADENAORIGINAL,
            CFDIFechaTimbrado AS FECHACERTIFICACION,
            CONCAT(RutaCBB, PrefijoEmpresa, '/', AnioMes, '/', LPAD(CONVERT(SucursalID,CHAR), 3, 0) ,'/',LPAD(CONVERT(ClienteID,CHAR), 10, 0),'-1-',AnioMes, '.png') AS RutaCBB
        FROM
            EDOCTADATOSCTE, EDOCTAPARAMS
        WHERE
            ClienteID = Par_ClienteID;

    END IF;

END TerminaStore$$