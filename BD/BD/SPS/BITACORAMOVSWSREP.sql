-- BITACORAMOVSWSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORAMOVSWSREP`;
DELIMITER $$

CREATE PROCEDURE `BITACORAMOVSWSREP`(
    Par_FechaInicio         DATE,
    Par_FechaFin            DATE,
    Par_CatRazonImpagoID    INT(11),
    Par_CreditoID           BIGINT(12),
    Par_ClienteID           INT(11),
    Par_PromotorID          INT(11),
    Par_SucursalID          INT(11),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
	)
TerminaStore: BEGIN
    -- DECLARACION DE VARIABLES
    DECLARE Var_Sentencia       VARCHAR(3000);
    DECLARE Var_FechaSistema    DATE;
    -- Declaracion de Constantes
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT;
    DECLARE Var_TipoMov         CHAR(2);            -- Impago de Credito

    -- Asignacion de Constantes
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Var_TipoMov         := 'IC';

    SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS;

    SET Var_Sentencia := CONCAT("SELECT CLI.NombreCompleto,         BIT.CreditoID,      CRE.MontoCredito,                                     AMOR.AmortizacionID,    BIT.Fecha, 
                                        AMOR.MontoCuota as Capital, CAT.Descripcion,    AMOR.DiasMoratorio AS DiasMora,IFNULL(PRO.NombrePromotor, '') as NombrePromotor
                                    FROM BITACORAMOVSWS BIT 
                                    INNER JOIN CLIENTES CLI ON CLI.ClienteID = BIT.ClienteID  
                                    INNER JOIN CREDITOS CRE ON CRE.CreditoID = BIT.CreditoID
                                    INNER JOIN CATRAZONIMPAGOCRE CAT ON CAT.CatRazonImpagoCreID = BIT.CatRazonImpagoID
                                    LEFT JOIN BITACORACREMOVSWS AMOR ON AMOR.BitacoraMovsWSID = BIT.BitacoraMovsWSID AND  AMOR.CreditoID = BIT.CreditoID
                                    LEFT JOIN PROMOTORES PRO ON PRO.PromotorID = BIT.PromotorID");

    SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE BIT.TipoMov = "',Var_TipoMov,'" AND BIT.Fecha BETWEEN "',Par_FechaInicio,'" AND "',Par_FechaFin,'" ');

    -- Filtron por razon impago
    SET Par_CatRazonImpagoID := IFNULL(Par_CatRazonImpagoID, Entero_Cero);
    IF(Par_CatRazonImpagoID != Entero_Cero) THEN
        SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND BIT.CatRazonImpagoID =',Par_CatRazonImpagoID);
    END IF;

    -- filtro por credito
    SET Par_CreditoID := IFNULL(Par_CreditoID, Entero_Cero);
    IF(Par_CreditoID != Entero_Cero) THEN 
        SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND BIT.CreditoID =',Par_CreditoID);
    END IF;

     -- filtro por credito
    SET Par_ClienteID := IFNULL(Par_ClienteID, Entero_Cero);
    IF(Par_ClienteID != Entero_Cero) THEN 
        SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND BIT.ClienteID =',Par_ClienteID);
    END IF;

     -- filtro por credito
    SET Par_PromotorID := IFNULL(Par_PromotorID, Entero_Cero);
    IF(Par_PromotorID != Entero_Cero) THEN 
        SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND BIT.PromotorID =',Par_PromotorID);
    END IF;

     -- filtro por credito
    SET Par_SucursalID := IFNULL(Par_SucursalID, Entero_Cero);
    IF(Par_SucursalID != Entero_Cero) THEN 
        SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND CLI.SucursalOrigen =',Par_SucursalID);
    END IF;

    SET @Sentencia  = (Var_Sentencia);

    PREPARE STBITACORAMOVSWSREP FROM @Sentencia;
    EXECUTE STBITACORAMOVSWSREP ;
    DEALLOCATE PREPARE STBITACORAMOVSWSREP;
END TerminaStore$$