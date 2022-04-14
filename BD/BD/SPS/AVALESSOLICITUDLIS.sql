-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESSOLICITUDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESSOLICITUDLIS`;DELIMITER $$

CREATE PROCEDURE `AVALESSOLICITUDLIS`(
	/* SP que lista los clientes que son AVALES en una SOLICITUD DE CREDITO,
		se utiliza para Reestructuras de Credito */

	Par_ClienteID			VARCHAR(100),	-- ID del Cliente
	Par_CreditoID  			BIGINT(12),		-- ID del Credito
	Par_NumLis				TINYINT UNSIGNED,	-- Numero de Lista

     -- Parametros de Auditoria
	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT
	)
TerminaStore: BEGIN


# Declaracion de Variables

DECLARE Var_SolicitudCreditoID	BIGINT(20);

#Declaracion de Constantes
DECLARE	Lis_Principal		INT(11);
DECLARE Entero_Cero			INT(11);
DECLARE	Cliente_SI			CHAR(1);
DECLARE Cliente_No			CHAR(1);



#Asignacion de Constantes
SET	Lis_Principal	:= 4;
SET Cliente_SI		:= 'S';
SET Cliente_NO		:= 'N';
SET Entero_Cero		:= 0;

-- Se obtienen el Numero de Solicitud de Credito
SET Var_SolicitudCreditoID:= (SELECT SolicitudCreditoID FROM CREDITOS  WHERE CreditoID =  Par_CreditoID);

-- Seccion que lista los avales que son Clientes y estan asignados una Solicitud de Credito
IF(Par_NumLis = Lis_Principal) THEN
	SELECT  AP.SolicitudCreditoID,	IFNULL(AP.AvalID,Entero_Cero) AS AvalID,
    IFNULL(C.ClienteID,Entero_Cero) AS ClienteID,
    IFNULL(P.ProspectoID,Entero_Cero) AS ProspectoID,

    CASE WHEN  AP.AvalID <> Entero_Cero  AND   AP.ClienteID = Entero_Cero AND AP.ProspectoID= Entero_Cero THEN
      A.NombreCompleto
    ELSE
      CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID= Entero_Cero  THEN
        C.NombreCompleto
      ELSE
        CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID = Entero_Cero  AND AP.ProspectoID<> Entero_Cero THEN
          P.NombreCompleto
        ELSE
          CASE WHEN  AP.AvalID <> Entero_Cero AND   AP.ClienteID <> Entero_Cero   THEN
            A.NombreCompleto
          ELSE
            CASE WHEN  AP.AvalID <> Entero_Cero AND   AP.ProspectoID <> Entero_Cero THEN
              A.NombreCompleto
              ELSE
				CASE WHEN  AP.AvalID = Entero_Cero  AND   AP.ClienteID <> Entero_Cero AND AP.ProspectoID != Entero_Cero  THEN
				C.NombreCompleto
              END
            END
          END
        END
      END
    END
    AS NombreCompleto
  FROM        AVALESPORSOLICI AP
    LEFT OUTER JOIN AVALES A        ON AP.AvalID = A.AvalID
    LEFT OUTER JOIN CLIENTES C        ON AP.ClienteID = C.ClienteID
    LEFT OUTER JOIN PROSPECTOS P      ON AP.ProspectoID = P.ProspectoID
    WHERE SolicitudCreditoID=Var_SolicitudCreditoID
    AND AP.AvalID = Entero_Cero
    HAVING  NombreCompleto LIKE CONCAT("%", Par_ClienteID, "%")
	LIMIT 0, 15;

END IF;

END TerminaStore$$