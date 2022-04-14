-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- REQTOSCOBRANZAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `REQTOSCOBRANZAREP`;DELIMITER $$

CREATE PROCEDURE `REQTOSCOBRANZAREP`(
    Par_ClienteID       INT(11),
    Par_RequerimientoID INT(11),
    Par_GerenteID       INT(11),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN

DECLARE Var_ClienteID       INT;
DECLARE Var_CreditoID       BIGINT(12);
DECLARE Var_NombreCliente   VARCHAR(50);
DECLARE Var_DirecCliente    VARCHAR(200);
DECLARE Var_Oficial         CHAR(1);
DECLARE Var_FechaExigible   DATE;
DECLARE MontoExig           DECIMAL(14,2);
DECLARE TotalMontoEx        VARCHAR(100);
DECLARE Var_Vencido         CHAR(1);


DECLARE Var_Vigente         CHAR(1);
DECLARE Var_MontoSeguro     DECIMAL(14,2);
DECLARE MontoLetra          VARCHAR(200);
DECLARE diaMora             INT;
DECLARE Var_MoraInf         INT;
DECLARE Var_MoraSup         INT;
DECLARE Var_JefeCobranza    VARCHAR(100);
DECLARE Var_JefeOperayPromo VARCHAR(100);
DECLARE Var_Gerente         VARCHAR(100);
DECLARE Var_Estado          VARCHAR(100);
DECLARE Var_Municipio       VARCHAR(100);


DECLARE Con_PrimerReqto     INT;
DECLARE Con_SegundoReqto    INT;
DECLARE Con_TercerReqto     INT;
DECLARE EstatusPagado       CHAR(1);

DECLARE Cadena_Vacia    VARCHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Var_FechaSis    DATE;
DECLARE Entero_Cero     INT;
DECLARE Dir_Oficial     CHAR(1);
DECLARE Seccion_Benefi  INT;
DECLARE Cue_Activa      CHAR(1);
DECLARE Es_Beneficiario CHAR(1);
DECLARE Var_Principal   CHAR(1);


DECLARE CURSORPORCLIENTE CURSOR FOR
SELECT CreditoID FROM CREDITOS WHERE ClienteID = Var_ClienteID
AND (Estatus = Var_Vigente OR Estatus = Var_Vencido );

DECLARE CURSORCLIENTES CURSOR FOR
SELECT ClienteID, CreditoID FROM CREDITOS WHERE (Estatus = Var_Vigente OR Estatus = Var_Vencido );


SET Con_PrimerReqto     := 1;
SET Con_SegundoReqto    := 2;
SET Con_TercerReqto     := 3;
SET Var_Oficial         := 'S';
SET EstatusPagado       := 'P';
SET Var_Vencido         := 'B';
SET Var_Vigente         := 'V';

SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Dir_Oficial         := 'S';
SET Es_Beneficiario     := 'S';
SET Cue_Activa          := 'A';
SET Var_Principal       := 'S';

TRUNCATE TMPREQTOSCOBRANZA;


    SELECT FechaSistema,NombreJefeCobranza,NomJefeOperayPromo INTO Var_FechaSis,Var_JefeCobranza,Var_JefeOperayPromo
            FROM    PARAMETROSSIS;

    SELECT Us.NombreCompleto,Edo.Nombre, Mun.Nombre INTO Var_Gerente,Var_Estado,Var_Municipio
            FROM USUARIOS AS Us
            INNER JOIN SUCURSALES AS Suc ON Us.SucursalUsuario =  Suc.SucursalID
            INNER JOIN ESTADOSREPUB AS Edo ON Suc.EstadoID = Edo.EstadoID
            INNER JOIN MUNICIPIOSREPUB AS Mun ON Edo.EstadoID = Mun.EstadoID
            AND Suc.MunicipioID = Mun.MunicipioID
            WHERE Us.UsuarioID=Par_GerenteID;

    SET Par_ClienteID := IFNULL(Par_ClienteID,Entero_Cero);

    SELECT DiasMoraInf,DiasMoraSup INTO Var_MoraInf,Var_MoraSup
            FROM REQTOSCOBRANZA
            WHERE RequerimientoID = Par_RequerimientoID;

    IF(Par_ClienteID!=0)THEN


        SELECT Cl.ClienteID, Cl.NombreCompleto, Dir.DireccionCompleta INTO Var_ClienteID,Var_NombreCliente,Var_DirecCliente
            FROM CLIENTES AS Cl
            INNER JOIN DIRECCLIENTE AS Dir
            ON Cl.ClienteID = Dir.ClienteID
            AND Dir.Oficial = Var_Oficial
            WHERE Cl.ClienteID =  Par_ClienteID;

        OPEN CURSORPORCLIENTE;
                BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    CICLOPORCLIENTE: LOOP

                 FETCH CURSORPORCLIENTE INTO Var_CreditoID;

                 SET diaMora := (DATEDIFF( Var_FechaSis,(SELECT MIN(FechaExigible)
                                                        FROM AMORTICREDITO
                                                        WHERE CreditoID     = Var_CreditoID
                                                        AND FechaExigible <= Var_FechaSis
                                                        AND Estatus       != EstatusPagado)));

                 IF(diaMora >= Var_MoraInf AND diaMora <= Var_MoraSup)THEN


                        SET Var_FechaExigible :=  (   SELECT MIN(FechaExigible)
                                FROM AMORTICREDITO
                                WHERE CreditoID     = Var_CreditoID
                                AND FechaExigible <= Var_FechaSis
                                AND Estatus       != EstatusPagado);

                         SET MontoExig := FUNCIONEXIGIBLE(Var_CreditoID);
                         SET TotalMontoEx  := FORMAT(ROUND(MontoExig,2),2);
                        SET MontoLetra := FUNCIONNUMLETRAS(MontoExig);



                        INSERT INTO TMPREQTOSCOBRANZA (ClienteID,CreditoID,NombreCliente,DireccionCliente,DiasMora,FechaExigible,MontoExigible,MontoLetras)
                            VALUES(Var_ClienteID,Var_CreditoID,Var_NombreCliente,Var_DirecCliente,diaMora,Var_FechaExigible,TotalMontoEx,MontoLetra);

                 END IF;
              END LOOP;
        END;
        CLOSE CURSORPORCLIENTE;


        ELSE IF(Par_ClienteID = 0)THEN

        OPEN CURSORCLIENTES;
                BEGIN
                    DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
                    CICLOCLIENTES: LOOP

                 FETCH CURSORCLIENTES INTO Var_ClienteID,Var_CreditoID;

                 SET diaMora := (DATEDIFF( Var_FechaSis,(SELECT MIN(FechaExigible)
                                                        FROM AMORTICREDITO
                                                        WHERE CreditoID     = Var_CreditoID
                                                        AND FechaExigible <= Var_FechaSis
                                                        AND Estatus       != EstatusPagado)));

                 IF(diaMora >= Var_MoraInf AND diaMora <= Var_MoraSup)THEN


                        SET Var_NombreCliente := (
                        SELECT Cl.NombreCompleto
                            FROM CLIENTES AS Cl
                            INNER JOIN DIRECCLIENTE AS Dir
                            ON Cl.ClienteID = Dir.ClienteID
                            AND Dir.Oficial = Var_Oficial
                            WHERE Cl.ClienteID =  Var_ClienteID );

                      SET Var_DirecCliente := (
                        SELECT  Dir.DireccionCompleta
                            FROM CLIENTES AS Cl
                            INNER JOIN DIRECCLIENTE AS Dir
                            ON Cl.ClienteID = Dir.ClienteID
                            AND Dir.Oficial = Var_Oficial
                            WHERE Cl.ClienteID =  Var_ClienteID );


                        SET  Var_FechaExigible := (SELECT MIN(FechaExigible)
                                FROM AMORTICREDITO
                                WHERE CreditoID     = Var_CreditoID
                                AND FechaExigible <= Var_FechaSis
                                AND Estatus       != EstatusPagado);

                         SET MontoExig := Entero_Cero;
                         SET MontoExig := FUNCIONEXIGIBLE(Var_CreditoID);
                         SET TotalMontoEx  := FORMAT(ROUND(MontoExig,2),2);
                        SET MontoLetra := FUNCIONNUMLETRAS(MontoExig);



                        INSERT INTO TMPREQTOSCOBRANZA (ClienteID,CreditoID,NombreCliente,DireccionCliente,DiasMora,FechaExigible,MontoExigible,MontoLetras)
                            VALUES(Var_ClienteID,Var_CreditoID,Var_NombreCliente,Var_DirecCliente,diaMora,Var_FechaExigible,TotalMontoEx,MontoLetra);

                 END IF;

              END LOOP;
        END;
        CLOSE CURSORCLIENTES;

        END IF;
    END IF;

SELECT ClienteID,CreditoID,NombreCliente,DireccionCliente,DiasMora,DATE_FORMAT(FechaExigible,'%d/%m/%Y') AS FechaExigible,
        MontoExigible,MontoLetras,Var_FechaSis,Var_JefeCobranza,Var_JefeOperayPromo,Var_Gerente,Var_Estado,Var_Municipio
        FROM TMPREQTOSCOBRANZA ORDER BY ClienteID,CreditoID;



END TerminaStore$$