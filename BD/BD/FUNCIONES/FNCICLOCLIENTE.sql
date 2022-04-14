DELIMITER ;
DROP FUNCTION IF EXISTS FNCICLOCLIENTE;
DELIMITER $$
CREATE FUNCTION `FNCICLOCLIENTE`(
-- Funcion que obtiene el Clico Del Cliente
    Par_GrupoID             int,
    Par_CreditoID           BIGINT

) RETURNS int(11)
    DETERMINISTIC
BEGIN

	DECLARE Par_CicloCliente 	INT;
    DECLARE No_Es_Agropecuario  CHAR(1);

    SET No_Es_Agropecuario  := 'N';
	
	SET Par_GrupoID     := IFNULL(Par_GrupoID, 0);
    SET Par_CreditoID   := IFNULL(Par_CreditoID, 0);

    IF ( Par_GrupoID = 0 AND Par_CreditoID > 0) THEN
        SELECT GrupoID INTO Par_GrupoID
        FROM CREDITOS WHERE CreditoID = Par_CreditoID LIMIT 1;
    END IF;

    IF(EXISTS (SELECT GrupoID FROM INTEGRAGRUPOSCRE WHERE GrupoID=Par_GrupoID))THEN

            SELECT DISTINCT Gpo.CicloActual
            INTO            Par_CicloCliente
            FROM 	GRUPOSCREDITO Gpo
                INNER JOIN INTEGRAGRUPOSCRE InG ON Gpo.GrupoID= InG.GrupoID
                INNER JOIN SOLICITUDCREDITO Sol ON InG.SolicitudCreditoID= Sol.SolicitudCreditoID
                INNER JOIN PRODUCTOSCREDITO Pro ON Sol.ProductoCreditoID= Pro.ProducCreditoID
                INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Gpo.SucursalID
                    WHERE  	Gpo.GrupoID = Par_GrupoID
                            AND Gpo.EsAgropecuario = No_Es_Agropecuario;

    ELSE
            SELECT	    Gpo.CicloActual
                INTO    Par_CicloCliente
                FROM 	GRUPOSCREDITO Gpo,
                        SUCURSALES Suc
                    WHERE  	Gpo.GrupoID =Par_GrupoID
                        AND Suc.SucursalID = Gpo.SucursalID
                            AND Gpo.EsAgropecuario = No_Es_Agropecuario;
    END IF;
RETURN Par_CicloCliente;
END$$