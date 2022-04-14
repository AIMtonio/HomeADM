-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOARCHIVOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOSVENTACARALT`;
DELIMITER $$

CREATE PROCEDURE `CREDITOSVENTACARALT`(
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
DECLARE     Var_FechaSistema    DATE;

-- DECLARACION DE CONSTANTES 
DECLARE Con_Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia         DATETIME;
DECLARE Con_Entero_Cero     INT(11);
DECLARE Con_EstVigente      CHAR(1);
DECLARE Esta_Pagado         CHAR(1);


-- ASIGNACION DE CONSTANTES 
SET Con_Cadena_Vacia    := '';
SET Fecha_Vacia         := '1900-01-01';
SET Con_Entero_Cero     := 0;
SET Con_EstVigente      := 'V' ;
SET Esta_Pagado         := 'P' ;

-- ASIGNACION DE VARIABLES 
SET Aud_FechaActual := CURRENT_TIMESTAMP();

-- SE OBTIENE LA FECHA DEL SISTEMA
SELECT FechaSistema INTO Var_FechaSistema FROM PARAMETROSSIS  LIMIT 1 ;

TRUNCATE CREDITOSVENTACAR; 

TRUNCATE TMPCREDITOSVENTACAR; 
TRUNCATE TMPCREVENTACARDIAATR; 

insert into TMPCREDITOSVENTACAR (CreditoID, ProducCreditoID)
SELECT  Cre.CreditoID, ProductoCreditoID FROM CREDITOS   Cre WHERE   Cre.Estatus    = Con_EstVigente;

INSERT INTO  TMPCREVENTACARDIAATR(
    CreditoID,  DiasAtraso)
SELECT  dif.CreditoID,    (datediff(Var_FechaSistema,MIN(dif.FechaFinPeriodo))+MIN(dif.DiasDiferidos))
    FROM    TMPCREDITOSVENTACAR T,
            CREDITOSDIFERIDOS dif,
            AMORTICREDITO amo  
    WHERE   dif.CreditoID = T.CreditoID
        AND dif.CreditoID = amo.CreditoID
        AND dif.FechaFinPeriodo > amo.FechaExigible
        AND dif.FechaFinPeriodo < Var_FechaSistema
    GROUP BY dif.CreditoID, T.CreditoID;


UPDATE  TMPCREDITOSVENTACAR T,
        TMPCREVENTACARDIAATR dif SET 
    T.DiasAtraso = dif.DiasAtraso
WHERE   dif.CreditoID = T.CreditoID;

-- insetar numero de dias de atraso para los que no son diferidos 
TRUNCATE TMPCREVENTACARDIAATR; 
INSERT INTO  TMPCREVENTACARDIAATR(
    CreditoID,  DiasAtraso)
SELECT  T.CreditoID,  (CASE WHEN IFNULL(min(FechaExigible), Fecha_Vacia) = Fecha_Vacia THEN 0
                                        ELSE ( datediff(Var_FechaSistema,min(FechaExigible)) + 1)  END)
FROM TMPCREDITOSVENTACAR T,  AMORTICREDITO Amo
WHERE Amo.CreditoID = T.CreditoID
    AND Amo.Estatus != Esta_Pagado
    AND Amo.FechaExigible <= Var_FechaSistema
    AND IFNULL(T.DiasAtraso, Con_Entero_Cero) = Con_Entero_Cero
GROUP BY T.CreditoID;


UPDATE  TMPCREDITOSVENTACAR T,
        TMPCREVENTACARDIAATR dif SET 
    T.DiasAtraso = dif.DiasAtraso
WHERE   dif.CreditoID = T.CreditoID
    AND IFNULL(T.DiasAtraso, Con_Entero_Cero) = Con_Entero_Cero;

DELETE FROM TMPCREDITOSVENTACAR WHERE ProducCreditoID in (SELECT ProducCreditoID FROM PRODUCTOSCREDITO WHERE ProductoNomina = 'S');
DELETE FROM TMPCREDITOSVENTACAR WHERE CreditoID in (SELECT CreditoID FROM HISCREDITOSVENTACAR);


INSERT INTO CREDITOSVENTACAR (
        CreditoID,      EmpresaID,      Usuario,        FechaActual,        DireccionIP,
        ProgramaID,     Sucursal,       NumTransaccion)
SELECT  CreditoID,      Par_EmpresaID,  Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP, 
        Aud_ProgramaID, Aud_Sucursal,   Aud_NumTransaccion
    FROM TMPCREDITOSVENTACAR; 

SELECT  CreditoID,      EmpresaID,      Usuario,        FechaActual,        DireccionIP,
        ProgramaID,     Sucursal,       NumTransaccion
    FROM CREDITOSVENTACAR; 

END TerminaStore$$