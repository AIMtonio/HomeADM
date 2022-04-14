-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOINVGARREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOINVGARREP`;
DELIMITER $$

CREATE PROCEDURE `CREDITOINVGARREP`(
    Par_SucursalInicial     BIGINT,
    Par_ClienteID           BIGINT,
    Par_CreditoID           BIGINT(12),
    Par_NumCon              INT(11),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)

        )
TerminaStore: BEGIN

DECLARE Var_Sentencia       VARCHAR(8000);
DECLARE Var_MontoBloq       DECIMAL(14,2);
DECLARE Var_CuentaAho       INT(11);
DECLARE Var_TipoCta         VARCHAR(200);
DECLARE Var_CreditoID       BIGINT(12);

DECLARE Entero_Cero         INT;
DECLARE EstatusVigente      CHAR(1);
DECLARE EstatusVencido      CHAR(1);
DECLARE EstatusActivas      CHAR(1);
DECLARE EstatusBloqueadas   CHAR(1);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE NombreTabla         VARCHAR(300);
DECLARE Con_TablaPrincipal  INT(11);
DECLARE Con_CtaAhorro       INT(11);
DECLARE Con_CtaInver        INT(11);
DECLARE Si_Elimina          CHAR(1);
DECLARE No_Elimina          CHAR(1);

SET Entero_Cero             := 0;
SET EstatusVigente          :='V';
SET EstatusVencido          :='B';
SET EstatusActivas          :='A';
SET EstatusBloqueadas       :='B';
SET Cadena_Vacia            :='';
SET NombreTabla             :=CONCAT('TMPCREDITOINV',CONVERT(Aud_NumTransaccion,CHAR));
SET Con_TablaPrincipal      :=1;
SET Con_CtaAhorro           :=2;
SET Con_CtaInver            :=3;
SET Si_Elimina              :="S";
SET No_Elimina              :="N";


IF Par_NumCon=Con_TablaPrincipal THEN

    SET Var_Sentencia := CONCAT(' drop table if exists ', NombreTabla, ' ; ');

    SET @Sentencia  = (Var_Sentencia);

    PREPARE STCREDITOINVGARREP FROM @Sentencia;
    EXECUTE STCREDITOINVGARREP;
    DEALLOCATE PREPARE STCREDITOINVGARREP;


    SET Var_Sentencia := CONCAT(' CREATE TEMPORARY TABLE ', NombreTabla, ' (
                                                                        `Tmp_SucursalID`    int(11),
                                                                        `Tmp_Nomb_Suc`      varchar(50),
                                                                        `Tmp_ClienteID`     int(11),
                                                                        `Tmp_NombreCliente` varchar(100),
                                                                        `Tmp_CreditoID`     bigint(12),
                                                                        `Tmp_ProductoID`    int(11),
                                                                        `Tmp_NombreProducto`varchar(100),
                                                                        `Tmp_MontoCredito`  decimal(14,2),
                                                                        `Tmp_Estatus`       varchar(10),
                                                                        `Tmp_DiasAtraso`    int(11),
                                                                        `Tmp_PorcGarLiq`    decimal(12,2),
                                                                        `Tmp_GarLiqReq`     decimal(14,2),
                                                                        `Tmp_GarLiqAct`     decimal(14,2),
                                                                        `Tmp_InversionID`   int(11),
                                                                        `Tmp_Etiqueta`      varchar(100),
                                                                        `Tmp_Monto`         decimal(14,2),
                                                                        `Tmp_MontoBloq`     decimal(14,2),
                                                                        `Tmp_DescCta`       varchar(100),
                                                                        `Tmp_CuentaAhoID`   bigint(12),
                                                                        Primary Key (Tmp_SucursalID, Tmp_ClienteID, Tmp_CreditoID)
                                    ); ');


    SET @Sentencia  = (Var_Sentencia);

    PREPARE STCREDITOINVGARREP FROM @Sentencia;
    EXECUTE STCREDITOINVGARREP;
    DEALLOCATE PREPARE STCREDITOINVGARREP;



    SET Var_Sentencia := CONCAT(' Insert into ',NombreTabla,' ( Tmp_SucursalID,  Tmp_Nomb_Suc,          Tmp_ClienteID,     Tmp_NombreCliente,   Tmp_CreditoID,
                                                                Tmp_ProductoID,  Tmp_NombreProducto,    Tmp_MontoCredito,   Tmp_Estatus,       Tmp_DiasAtraso,
                                                                Tmp_PorcGarLiq,  Tmp_GarLiqReq ,        Tmp_GarLiqAct ) ');

    SET Var_Sentencia := CONCAT(Var_Sentencia,' select Suc.SucursalID, Suc.NombreSucurs, Cli.ClienteID, Cli.NombreCompleto, Cre.CreditoID,  Cre.ProductoCreditoID, Prod.Descripcion,
															Cre.MontoCredito, CASE  WHEN Cre.Estatus = "I" THEN "INACTIVO"
																					WHEN Cre.Estatus =   "A" THEN "AUTORIZADO"
																					WHEN Cre.Estatus =  "V" THEN "VIGENTE"
																					WHEN Cre.Estatus =  "P" THEN "PAGADO"
																					WHEN Cre.Estatus =  "C" THEN "CANCELADO"
																					WHEN Cre.Estatus =  "B" THEN "VENCIDO"
																					WHEN Cre.Estatus =  "K" THEN "CASTIGADO"
																					WHEN Cre.Estatus =  "S" THEN "SUSPENDIDO" end as Estatus,
                                                        CALCULADIASATRASO(Cre.CreditoID) as diasAtraso, Cre.PorcGarLiq, Cre.AporteCliente, FUNCIONMONTOGARLIQ (Cre.CreditoID) as GarLiqActual  ' );
    SET Var_Sentencia := CONCAT(Var_Sentencia,'  from CREDITOS Cre
                                                 inner join CLIENTES Cli on Cli.ClienteID = Cre.ClienteID
                                                 inner join SUCURSALES Suc on Suc.SucursalID = Cre.SucursalID
                                                 inner join PRODUCTOSCREDITO Prod on Prod.ProducCreditoID = Cre.ProductoCreditoID ');
    SET Var_Sentencia := CONCAT(Var_Sentencia,'  WHERE (Cre.Estatus = "I" or  Cre.Estatus =  "A" or  Cre.Estatus =  "V" or  Cre.Estatus = "B" or Cre.Estatus = "S")
                                                   and ifnull(FUNCIONMONTOGARLIQ (Cre.CreditoID),0.0 ) > 0.0 ');

    IF Par_SucursalInicial != Entero_Cero THEN
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Cre.SucursalID = ',Par_SucursalInicial);
    END IF;


    IF Par_ClienteID!=Entero_Cero THEN
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Cre.ClienteID= ',Par_ClienteID);
    END IF;

    IF Par_CreditoID!=Entero_Cero THEN
            SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' and Cre.CreditoID= ',Par_CreditoID);
    END IF;

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, ' order by Suc.SucursalID, Cli.ClienteID, Cre.CreditoID ; ');


    SET @Sentencia  = (Var_Sentencia);

    PREPARE STCREDITOINVGARREP FROM @Sentencia;
    EXECUTE STCREDITOINVGARREP;
    DEALLOCATE PREPARE STCREDITOINVGARREP;




    SET Var_Sentencia = '';

    SET Var_Sentencia :=  CONCAT(Var_Sentencia, '   select    Tmp_SucursalID, Tmp_Nomb_Suc,       Tmp_ClienteID,   Tmp_NombreCliente, Tmp_CreditoID,  ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, '             Tmp_ProductoID, Tmp_NombreProducto, Tmp_MontoCredito,Tmp_Estatus,       Tmp_DiasAtraso, ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, '             Tmp_PorcGarLiq, Tmp_GarLiqReq,      Tmp_GarLiqAct,   Tmp_InversionID,   Tmp_Etiqueta, ');
    SET Var_Sentencia :=  CONCAT(Var_Sentencia, '             Tmp_Monto,      Tmp_MontoBloq,      Tmp_DescCta,     Tmp_CuentaAhoID  from  ' , NombreTabla, ' ; ');


    SET @Sentencia  = (Var_Sentencia);

    PREPARE STCREDITOINVGARREP FROM @Sentencia;
    EXECUTE STCREDITOINVGARREP;
    DEALLOCATE PREPARE STCREDITOINVGARREP;
END IF;


IF Par_NumCon=Con_CtaAhorro THEN
    SELECT Blo.MontoBloq,Cue.CuentaAhoID,Tip.Descripcion
        FROM    BLOQUEOS Blo
            INNER JOIN CUENTASAHO Cue ON Cue.CuentaAhoID = Blo.CuentaAhoID
            INNER JOIN TIPOSCUENTAS Tip ON Tip.TipoCuentaID = Cue.TipoCuentaID
                WHERE   Blo.TiposBloqID = 8
                  AND   Blo.Referencia  = CAST(Par_CreditoID AS CHAR)
                  AND   Blo.NatMovimiento = "B"
                  AND   IFNULL(Blo.FolioBloq,0) = 0
                  AND   Cue.ClienteID = Par_ClienteID;



END IF;

IF Par_NumCon=Con_CtaInver THEN

    SELECT Inv.Monto,CI.MontoEnGar,CI.InversionID,Inv.Etiqueta
        FROM    CREDITOINVGAR CI
        LEFT JOIN INVERSIONES Inv ON Inv.InversionID=CI.InversionID
            WHERE CI.CreditoID = Par_CreditoID;


END IF;



END TerminaStore$$