-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- INTEGRAGRUPONOSOLLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `INTEGRAGRUPONOSOLLIS`;DELIMITER $$

CREATE PROCEDURE `INTEGRAGRUPONOSOLLIS`(
    Par_GrupoID         BIGINT(12),
    Par_TipoLis         INT(11),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)

        )
TerminaStore: BEGIN



    DECLARE Var_CreditoID   BIGINT(12);
    DECLARE Var_ClienteID   INT(11);
    DECLARE Var_ExigDia     DECIMAL(12,2);
    DECLARE Var_TotalDia    DECIMAL(12,2);
    DECLARE Var_SaldoAho    DECIMAL(12,2);
    DECLARE Var_TotalSaldo  DECIMAL(12,2);


    DECLARE Lis_Principal   INT(11);
    DECLARE EstatusVig      CHAR(1);
    DECLARE EstatusVen      CHAR(1);
    DECLARE EstatusAct      CHAR(1);
    DECLARE EstatusBlo      CHAR(1);
    DECLARE Entero_Cero     INT(1);

    DECLARE CREDITOSCLIENTE CURSOR FOR
            SELECT CRE.ClienteID, CRE.CreditoID
                FROM CREDITOS CRE
                RIGHT JOIN TMPINTEGRANTESGRUPO TMP
                    ON CRE.ClienteID = TMP.ClienteID AND IFNULL(CRE.CreditoID,Entero_Cero) > Entero_Cero
                WHERE CRE.Estatus IN(EstatusVig,EstatusVen) ;



    SET Lis_Principal   := 1;
    SET EstatusVig      :='V';
    SET EstatusVen      :='B';
    SET EstatusAct      :='A';
    SET EstatusBlo      :='B';
    SET Var_ExigDia     :=0.0;
    SET Var_TotalDia    :=0.0;
    SET Var_SaldoAho    :=0.0;
    SET Var_TotalSaldo  :=0.0;
    SET Entero_Cero     := 0;



       DROP TABLE IF EXISTS TMPINTEGRANTESGRUPO;
         CREATE TEMPORARY TABLE TMPINTEGRANTESGRUPO (
            GrupoID         BIGINT(12),
            ClienteID       INT(11),
            NombreCompleto  VARCHAR(200),
            EsMenorEdad     CHAR(5),
            Estatus         CHAR(20),
            TipoIntegrantes INT(4),
            Ahorros         DECIMAL(16,2),
            ExigibleDia     DECIMAL(16,2),
            TotalAlDia      DECIMAL(16,2),
            KEY `IDX_GRUPOID_TMP` (`GrupoID`),
            KEY `IDX_CLIENTEID_TMP` (`ClienteID`)
         );


        DROP TABLE IF EXISTS TMPSALDOCUENTSAHO;
         CREATE TEMPORARY TABLE TMPSALDOCUENTSAHO (
            ClienteID       INT(11),
            Ahorros         DECIMAL(16,2),
            KEY `IDX_CLIENTEID_TMPAHO` (`ClienteID`)
         );

    IF(Par_TipoLis = Lis_Principal)THEN


        INSERT INTO TMPINTEGRANTESGRUPO(GrupoID,ClienteID,NombreCompleto,EsMenorEdad,Estatus,TipoIntegrantes, Ahorros, ExigibleDia, TotalAlDia
        )SELECT   IT.GrupoID,IT.ClienteID, CL.NombreCompleto,
            CASE CL.EsMenorEdad WHEN 'S' THEN 'SI' WHEN 'N' THEN 'NO' END AS EsMenorEdad,
            CASE CL.Estatus WHEN 'A' THEN 'ACTIVO' WHEN 'I' THEN 'INACTIVO' END AS Estatus,
            IT.TipoIntegrantes,Var_SaldoAho, Var_ExigDia, Var_TotalDia
         FROM INTEGRAGRUPONOSOL  IT
         LEFT JOIN CLIENTES CL
            ON IT.ClienteID= CL.ClienteID
         WHERE  IT.GrupoID=Par_GrupoID;



         OPEN  CREDITOSCLIENTE;
            BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    CICLOCREDITOSCLIEN: LOOP
                    FETCH CREDITOSCLIENTE  INTO Var_ClienteID, Var_CreditoID;

                     SET   Var_ExigDia  := (SELECT ExigibleDia FROM TMPINTEGRANTESGRUPO WHERE ClienteID=Var_ClienteID);
                     SET   Var_TotalDia := (SELECT TotalAlDia FROM TMPINTEGRANTESGRUPO WHERE ClienteID=Var_ClienteID);

                    UPDATE TMPINTEGRANTESGRUPO
                    SET
                        ExigibleDia = Var_ExigDia + IFNULL((FUNCIONEXIGIBLE(Var_CreditoID)),Entero_Cero),
                        TotalAlDia  = Var_TotalDia + IFNULL((FUNCIONTOTDEUDACRE(Var_CreditoID)),Entero_Cero)
                    WHERE ClienteID=Var_ClienteID;

                END LOOP CICLOCREDITOSCLIEN;
            END;

    CLOSE CREDITOSCLIENTE;


        INSERT INTO TMPSALDOCUENTSAHO(ClienteID,Ahorros
        )SELECT IG.ClienteID, SUM(IFNULL(CAHO.SaldoDispon,Entero_Cero))
         FROM TMPINTEGRANTESGRUPO  IG
         INNER JOIN CUENTASAHO CAHO
                    ON IG.ClienteID= CAHO.ClienteID
         WHERE CAHO.Estatus IN(EstatusAct,EstatusBlo)
         GROUP BY IG.ClienteID;


         UPDATE TMPINTEGRANTESGRUPO  TMPIG
            INNER JOIN TMPSALDOCUENTSAHO TMPSC
            ON TMPIG.ClienteID = TMPSC.ClienteID
            SET
                TMPIG.Ahorros   = TMPSC.Ahorros;


         SELECT GrupoID, ClienteID, TipoIntegrantes, NombreCompleto,Estatus,EsMenorEdad, Ahorros, ExigibleDia, TotalAlDia
         FROM TMPINTEGRANTESGRUPO;


         DROP TABLE IF EXISTS TMPINTEGRANTESGRUPO;
         DROP TABLE IF EXISTS TMPSALDOCUENTSAHO;
    END IF;


END TerminaStore$$