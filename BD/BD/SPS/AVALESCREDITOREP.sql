-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESCREDITOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESCREDITOREP`;DELIMITER $$

CREATE PROCEDURE `AVALESCREDITOREP`(
    Par_ClienteInicial      INT(11),
    Par_ClienteFinal        INT(11),
    Par_FechaInicial        DATE,
    Par_FechaFinal          DATE,
    Par_Promotor            INT(11),

    Par_DiasMora            INT(4),
    Par_SucursalID          INT(11),
    Par_Estatus             CHAR(1),
    Par_ProductoID          INT(11),

    Par_EmpresaID           INT(11),

    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),

    Aud_NumTransaccion      BIGINT(20)
            )
TerminaStore: BEGIN


DECLARE Var_DiasMora        INT(4);
DECLARE Var_NumControl      VARCHAR(50);
DECLARE Var_FechaSistema    DATE;
DECLARE Var_Sentencia       VARCHAR(9000);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Entero_Uno          INT;
DECLARE Salida_SI           CHAR(1);
DECLARE Estatus_Pagado      CHAR(1);
DECLARE Numero_Negativo     INT;
DECLARE No_Aplica           CHAR(2);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Entero_Uno          := 1;
SET Estatus_Pagado      := 'P';
SET Numero_Negativo     := -1;
SET No_Aplica           :='NA';

SET  Var_FechaSistema := (SELECT FechaSistema
                                    FROM PARAMETROSSIS);

IF(Par_ClienteFinal=Numero_Negativo)THEN
    SET Par_ClienteFinal := Entero_Cero;
END IF;

DROP TABLE IF EXISTS TMPAVALCRED;
DROP TABLE IF EXISTS TMPFEXCRED;


CREATE TEMPORARY TABLE TMPAVALCRED(
    ClienteID       INT(11),
    NombreCliente   VARCHAR(200),
    CreditoID       BIGINT(12),
    MontoCredito    DECIMAL(12,2),
    Descripcion     VARCHAR(100),
    Estatus         CHAR(1),
    SaldoActual     DECIMAL(12,2),
    SaldoExigible   DECIMAL(12,2),
    AvalID          VARCHAR(20),
    Cliente         VARCHAR(20),
    ProspectoID     VARCHAR(20),
    NombreComplAv   VARCHAR(200),
    DiaMora         INT,
    FechaExigible   DATE,
    INDEX(ClienteID,CreditoID)
);


CREATE TEMPORARY TABLE TMPFEXCRED(
    CreditoID       BIGINT(12),
    DiaMora         INT,
    FechaExigible   DATE,
    INDEX(CreditoID)
);

SET Var_Sentencia :='INSERT INTO TMPAVALCRED (ClienteID,NombreCliente,CreditoID,MontoCredito,Descripcion,Estatus,SaldoActual,SaldoExigible,AvalID,';
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  'Cliente,ProspectoID,NombreComplAv,DiaMora,FechaExigible) ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  'SELECT  LPAD(CLE.ClienteID,10,\'0\') as ClienteID,      CLE.NombreCompleto as NombreCliente, CRE.CreditoID,CRE.MontoCredito,   PRO.Descripcion ,CRE.Estatus,');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  'FUNCIONTOTDEUDACRE(CRE.CreditoID) as SaldoActual,');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  'FUNCIONCONPAGOANTCRE(CRE.CreditoID) as SaldoExigible,   ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' IFNULL(AVA.AvalID, 0) as AvalID,');
SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' IFNULL(C.ClienteID, 0) as Cliente,');
SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' IFNULL(P.ProspectoID, 0) as ProspectoID,');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  'CONVERT(  case when  AVA.AvalID <> 0 and  AVA.ClienteID = 0 and AVA.ProspectoID= 0 then ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '        IFNULL(AV.NombreCompleto,"NA") ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '    ELSE    case when  AVA.AvalID = 0  and   AVA.ClienteID <> 0 and AVA.ProspectoID= 0 then ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '        IFNULL(C.NombreCompleto,"NA") ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '    ELSE    case when  AVA.AvalID = 0  and   AVA.ClienteID = 0 and AVA.ProspectoID<> 0 then ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '        IFNULL(P.NombreCompleto,"NA") ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '    ELSE    case when  AVA.AvalID <> 0  and   AVA.ClienteID <> 0 and AVA.ProspectoID= 0 then  ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '        IFNULL(C.NombreCompleto,"NA") ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '    ELSE    case when  AVA.AvalID <> 0  and   AVA.ClienteID = 0 and   AVA.ProspectoID <> 0 then  ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '        IFNULL(AV.NombreCompleto,"NA") ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '    ELSE    case when  AVA.AvalID = 0  and  AVA.ClienteID <> 0 and   AVA.ProspectoID <> 0 then ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '              IFNULL(C.NombreCompleto,"NA")  ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '    ELSE    case when  AVA.AvalID <> 0  and   AVA.ClienteID <> 0 and   AVA.ProspectoID <> 0 then ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '       IFNULL(C.NombreCompleto,"NA")  ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '    ELSE ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  '        IFNULL(AV.NombreCompleto,"NA") end end end end end end end,CHAR) as NombreCompleto, ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,  Entero_Cero,',"',Fecha_Vacia,'"');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,   '   FROM CLIENTES CLE,');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,      '     CREDITOS CRE ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,    '  left join SOLICITUDCREDITO SOL on CRE.SolicitudCreditoID =  SOL.SolicitudCreditoID ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,    '  left join AVALESPORSOLICI AVA on SOL.SolicitudCreditoID =   AVA.SolicitudCreditoID ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,    '  left join  AVALES AV on AVA.AvalID =    AV.AvalID   ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,    '  left join  CLIENTES C on  AVA.ClienteID= C.ClienteID  ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,    ' left join  PROSPECTOS P on AVA.ProspectoID= P.ProspectoID  ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,    ' inner join  PRODUCTOSCREDITO PRO on CRE.ProductoCreditoID = PRO.ProducCreditoID ');
SET Var_Sentencia:=     CONCAT(Var_Sentencia,    ' where CLE.ClienteID=     CRE.ClienteID  ');

SET Par_ClienteInicial  :=IFNULL(Par_ClienteInicial,Entero_Cero);
SET Par_ClienteFinal    :=IFNULL(Par_ClienteFinal,Entero_Cero);

IF(Par_ClienteInicial!=Entero_Cero)THEN
    IF(Par_ClienteFinal!=Entero_Cero)THEN
        SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' and CRE.ClienteID >= "',Par_ClienteInicial,'"');
        SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' and CRE.ClienteID <= "',Par_ClienteFinal,'"');
    ELSE
        SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' and CRE.ClienteID = "',Par_ClienteInicial,'"');
    END IF;
END IF;

SET Par_FechaInicial :=IFNULL(Par_FechaInicial,Fecha_Vacia);
SET Par_FechaFinal :=IFNULL(Par_FechaFinal,Fecha_Vacia);

IF(Par_FechaInicial != Fecha_Vacia)THEN
    IF(Par_FechaFinal != Fecha_Vacia)THEN
        SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' and CRE.FechaInicio >= "',Par_FechaInicial,'"');
        SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' and CRE.FechaInicio <= "',Par_FechaFinal,'"');
    ELSE
        SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' and CRE.FechaInicio = "',Par_FechaInicial,'"');
    END IF;
END IF;

SET Par_Promotor :=IFNULL(Par_Promotor,Entero_Cero);

IF(Par_Promotor != Entero_Cero)THEN
    SET Var_Sentencia:=     CONCAT(Var_Sentencia, ' and SOL.PromotorID = ',CONVERT(Par_Promotor,CHAR));
END IF;

SET Par_SucursalID :=IFNULL(Par_SucursalID,Entero_Cero);

IF(Par_SucursalID !=Entero_Cero)THEN
    SET Var_Sentencia:=     CONCAT(Var_Sentencia,'  and CRE.SucursalID =',CONVERT(Par_SucursalID,CHAR));
END IF;

SET Par_Estatus := IFNULL(Par_Estatus,Cadena_Vacia);

IF(Par_Estatus!=Cadena_Vacia)THEN
    SET Var_Sentencia:=     CONCAT(Var_Sentencia,"  and CRE.Estatus ='",Par_Estatus,"'");
END IF;

SET Par_ProductoID := IFNULL(Par_ProductoID,Entero_Cero);

IF(Par_ProductoID!=Entero_Cero)THEN
    SET Var_Sentencia:=     CONCAT(Var_Sentencia,'  and CRE.ProductoCreditoID =',CONVERT(Par_ProductoID,CHAR));
END IF;

SET Var_Sentencia:=     CONCAT(Var_Sentencia, '  order by CRE.ClienteID asc;');

SET @Sentencia  = (Var_Sentencia);

PREPARE AVALESCREDITOREP FROM @Sentencia;
EXECUTE AVALESCREDITOREP;
DEALLOCATE PREPARE AVALESCREDITOREP;


INSERT INTO TMPFEXCRED (CreditoID, FechaExigible)
SELECT Amo.creditoID, IFNULL(MIN(Amo.FechaExigible),Fecha_Vacia)
    FROM TMPAVALCRED Tmp, AMORTICREDITO Amo
        WHERE Amo.creditoID = Tmp.CreditoID
            AND Amo.FechaExigible >= Var_FechaSistema
            AND Amo.Estatus != Estatus_Pagado
    GROUP BY Amo.creditoID;

UPDATE TMPAVALCRED Tmp, TMPFEXCRED Amo
SET Tmp.FechaExigible = Amo.FechaExigible
    WHERE Amo.creditoID = Tmp.CreditoID;

TRUNCATE TABLE TMPFEXCRED;

INSERT INTO TMPFEXCRED (CreditoID, FechaExigible,DiaMora)
SELECT Amo.creditoID, MIN(Amo.FechaExigible),CASE WHEN IFNULL(MIN(Amo.FechaExigible), Fecha_Vacia) = Fecha_Vacia THEN Entero_Cero
                ELSE (DATEDIFF(Var_FechaSistema, MIN(Amo.FechaExigible)) + Entero_Uno)
                END
    FROM TMPAVALCRED Tmp, AMORTICREDITO Amo
        WHERE Tmp.creditoID = Amo.CreditoID
            AND Amo.FechaExigible <= Var_FechaSistema
            AND Amo.Estatus != Estatus_Pagado
    GROUP BY Amo.creditoID;


UPDATE TMPAVALCRED Tmp, TMPFEXCRED Amo
SET Tmp.DiaMora = Amo.DiaMora
    WHERE Amo.creditoID = Tmp.CreditoID;

SET Par_DiasMora :=IFNULL(Par_DiasMora,Entero_Cero);

SET Var_Sentencia :='SELECT ClienteID,NombreCliente,CreditoID,MontoCredito,Descripcion,Estatus,SaldoActual,SaldoExigible,AvalID,';
SET Var_Sentencia := CONCAT(Var_Sentencia,'Cliente,ProspectoID,NombreComplAv as NombreCompleto,DiaMora,FechaExigible  FROM TMPAVALCRED');

IF(Par_DiasMora>=Entero_Cero)THEN
    SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE DiaMora = ',CAST(Par_DiasMora AS CHAR));
END IF;

SET Var_Sentencia := CONCAT(Var_Sentencia, ';');

SET @Sentencia2 = (Var_Sentencia);

PREPARE AVALESCREDITOREP2 FROM @Sentencia2;
EXECUTE AVALESCREDITOREP2;
DEALLOCATE PREPARE AVALESCREDITOREP2;

DROP TABLE IF EXISTS TMPAVALCRED;
DROP TABLE IF EXISTS TMPFEXCRED;

END TerminaStore$$