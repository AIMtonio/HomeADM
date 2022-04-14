-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- AVALESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `AVALESLIS`;DELIMITER $$

CREATE PROCEDURE `AVALESLIS`(

    Par_Nombre          VARCHAR(50),
    Par_ClienteID       INT(11),
    Par_NumLis          TINYINT UNSIGNED,

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),

    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Cadena_Espacio      VARCHAR(2);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT;
    DECLARE Lis_Principal       INT;
    DECLARE Lis_Creditos        INT;
    DECLARE Lis_AvalesxCliente  INT;
    DECLARE Lis_PersonaFisica   INT(11);
    DECLARE Lis_PersonaMoral    INT(11);
    DECLARE Esta_Vigente        CHAR(1);
    DECLARE Esta_Vencido        CHAR(1);
    DECLARE Esta_Castigado      CHAR(1);
    DECLARE CadenaSi            CHAR(1);
    DECLARE Estatus_Vigente     VARCHAR(10);
    DECLARE Estatus_Vencido     VARCHAR(10);
    DECLARE Estatus_Castigado   VARCHAR(10);
    DECLARE EsOficial           CHAR(1);
    DECLARE PersonaMoral        CHAR(1);        -- Persona Moral


    SET Cadena_Vacia        := '';
    SET Cadena_Espacio      := ' ';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Lis_Principal       := 1;
    SET Lis_Creditos        := 2;
    SET Lis_AvalesxCliente  := 3;
    SET Lis_PersonaFisica   := 5;
    SET Lis_PersonaMoral    := 6;

    SET Esta_Vigente        := 'V';
    SET Esta_Vencido        := 'B';
    SET Esta_Castigado      := 'K';
    SET CadenaSi            := 'S';
    SET Estatus_Vigente     := 'VIGENTE';
    SET Estatus_Castigado   := 'CASTIGADO';
    SET Estatus_Vencido     := 'VENCIDO';
    SET EsOficial           := 'S';
    SET PersonaMoral        := 'M';


    IF(Par_NumLis = Lis_Principal)THEN
        SELECT AvalID, NombreCompleto
            FROM AVALES
            WHERE NombreCompleto LIKE   CONCAT("%", Par_Nombre, "%")
            LIMIT 0, 15;
    END IF;


    IF(Par_NumLis = Lis_Creditos)THEN
        DROP TABLE IF EXISTS TMPAVALESSEIDO;
        CREATE TEMPORARY TABLE TMPAVALESSEIDO(FechaNacimiento DATE, RFC VARCHAR(13), DireccionCompleta VARCHAR(500), CreditoID BIGINT(12), ClienteID INT(11),
                                                NombreCompleto VARCHAR(200), MontoCredito DECIMAL(12,2),INDEX(CreditoID,ClienteID));
        INSERT INTO TMPAVALESSEIDO(FechaNacimiento , RFC , DireccionCompleta, CreditoID, ClienteID,
                                                NombreCompleto, MontoCredito)

        SELECT cli.FechaNacimiento, cli.RFC, dir.DireccionCompleta, cre.CreditoID,cre.ClienteID,
                    cli2.NombreCompleto, cre.MontoCredito
                    FROM CLIENTES cli
                    INNER JOIN  AVALESPORSOLICI avs ON  cli.ClienteID = avs.ClienteID
                    INNER JOIN  CREDITOS cre ON avs.SolicitudCreditoID = cre.solicitudCreditoID AND (cre.Estatus = Esta_Vigente OR cre.Estatus = Esta_Vencido)
                    INNER JOIN CLIENTES cli2 ON cre.ClienteID = cli2.ClienteID
                    LEFT JOIN DIRECCLIENTE dir ON cli.ClienteID = dir.ClienteID AND Oficial = CadenaSi
                    WHERE cli.NombreCompleto = Par_Nombre;


        INSERT INTO TMPAVALESSEIDO(FechaNacimiento , RFC , DireccionCompleta, CreditoID, ClienteID,
                                                NombreCompleto, MontoCredito)

        SELECT ava.FechaNac AS FechaNacimiento, ava.RFC, ava.DireccionCompleta, cre.CreditoID,cre.ClienteID,
                    cli.NombreCompleto, cre.MontoCredito
                    FROM  AVALES ava
                    INNER JOIN AVALESPORSOLICI avs  ON (ava.AvalID = avs.AvalID)
                    INNER JOIN CREDITOS cre ON avs.SolicitudCreditoID = cre.SolicitudCreditoID AND (cre.Estatus = Esta_Vigente OR cre.Estatus=Esta_Vencido)
                    INNER JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
                    WHERE ava.NombreCompleto = Par_Nombre;


        INSERT INTO TMPAVALESSEIDO(FechaNacimiento , RFC , DireccionCompleta, CreditoID, ClienteID,
                                                NombreCompleto, MontoCredito)

        SELECT pro.FechaNacimiento, pro.RFC,CONCAT('CALLE ',pro.Calle,', No.',pro.NumExterior,', ',pro.Colonia,', ',mun.Nombre) AS DireccionCompleta,
                        cre.CreditoID,cre.ClienteID, cli.NombreCompleto,cre.MontoCredito
                    FROM PROSPECTOS pro
                        INNER JOIN MUNICIPIOSREPUB mun ON pro.MunicipioID = mun.MunicipioID AND pro.EstadoID = mun.EstadoID
                        INNER JOIN AVALESPORSOLICI avs ON pro.ProspectoID = avs.ProspectoID
                        INNER JOIN CREDITOS cre ON avs.SolicitudCreditoID = cre.SolicitudCreditoID
                        LEFT JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
                        WHERE pro.NombreCompleto = Par_Nombre
                     AND cre.Estatus IN(Esta_Vigente,Esta_Vencido);
        SELECT
            FechaNacimiento,
            IFNULL(RFC, Cadena_Vacia) AS RFC,
            IFNULL(DireccionCompleta, Cadena_Vacia) AS DireccionCompleta,
            CreditoID,
            ClienteID,
            NombreCompleto,
            FORMAT(MontoCredito, 2) AS MontoCredito
        FROM
            TMPAVALESSEIDO;

    END IF;


    IF(Par_NumLis = Lis_AvalesxCliente)THEN

    DROP TABLE IF EXISTS TMPAVALESCLIENTES;
    CREATE TEMPORARY TABLE TMPAVALESCLIENTES(
       ClienteID            INT(11),
       NombreCompleto       VARCHAR(200),
       SucursalID           INT(11),
       Telefono             VARCHAR(100),
       TelefonoCel          VARCHAR(100),
       DireccionCompleta    VARCHAR(500),
       CreditoID            BIGINT(12),
       Estatus              VARCHAR(20),
       INDEX(ClienteID,CreditoID)
    );


        INSERT INTO TMPAVALESCLIENTES()
        SELECT cli.ClienteID, cli.NombreCompleto, cli.SucursalOrigen, CASE WHEN LENGTH(cli.Telefono) > Entero_Cero THEN
                    FNMASCARA(cli.Telefono,'(###) ###-####') ELSE IFNULL(cli.Telefono,Cadena_Vacia) END,
                    CASE WHEN LENGTH(cli.TelefonoCelular) > Entero_Cero THEN
                FNMASCARA(cli.TelefonoCelular,'(###) ###-####') ELSE IFNULL(cli.TelefonoCelular,Cadena_Vacia) END,
                IFNULL(dir.DireccionCompleta,Cadena_Vacia),cre.CreditoID,
                CASE WHEN cre.Estatus = Esta_Vigente THEN Estatus_Vigente ELSE
                CASE WHEN cre.Estatus = Esta_Vencido THEN Estatus_Vencido ELSE
                CASE WHEN cre.Estatus = Esta_Castigado THEN Estatus_Castigado
                        ELSE cre.Estatus END END END AS Estatus
                    FROM CLIENTES cli
                    INNER JOIN  AVALESPORSOLICI avs ON  cli.ClienteID = avs.ClienteID
                    INNER JOIN  CREDITOS cre ON avs.SolicitudCreditoID = cre.solicitudCreditoID
                            AND cre.Estatus IN (Esta_Vigente,Esta_Vencido,Esta_Castigado)
                    INNER JOIN CLIENTES cli2 ON cre.ClienteID = cli2.ClienteID
                    LEFT JOIN DIRECCLIENTE dir ON cli.ClienteID = dir.ClienteID AND Oficial = EsOficial
                    WHERE cre.ClienteID = Par_ClienteID;


        INSERT INTO TMPAVALESCLIENTES()
        SELECT  Entero_Cero, ava.NombreCompleto,  Entero_Cero, CASE WHEN LENGTH(ava.Telefono) > Entero_Cero THEN
                    FNMASCARA(ava.Telefono,'(###) ###-####') ELSE IFNULL(ava.Telefono,Cadena_Vacia) END,
                    CASE WHEN LENGTH(ava.TelefonoCel) > Entero_Cero THEN
                FNMASCARA(ava.TelefonoCel,'(###) ###-####') ELSE IFNULL(ava.TelefonoCel,Cadena_Vacia) END,
                ava.DireccionCompleta, cre.CreditoID,
                CASE WHEN cre.Estatus = Esta_Vigente THEN Estatus_Vigente ELSE
                CASE WHEN cre.Estatus = Esta_Vencido THEN Estatus_Vencido ELSE
                CASE WHEN cre.Estatus = Esta_Castigado THEN Estatus_Castigado
                        ELSE cre.Estatus END END END AS Estatus
                    FROM  AVALES ava
                    INNER JOIN AVALESPORSOLICI avs  ON (ava.AvalID = avs.AvalID)
                    INNER JOIN CREDITOS cre ON avs.SolicitudCreditoID = cre.SolicitudCreditoID
                        AND cre.Estatus IN (Esta_Vigente,Esta_Vencido,Esta_Castigado)
                    INNER JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
                    WHERE cre.ClienteID = Par_ClienteID;



        INSERT INTO TMPAVALESCLIENTES()
        SELECT Entero_Cero, pro.NombreCompleto, Entero_Cero, CASE WHEN LENGTH(pro.Telefono) > Entero_Cero THEN
            FNMASCARA(pro.Telefono,'(###) ###-####') ELSE IFNULL(pro.Telefono,Cadena_Vacia) END,Cadena_Vacia,
                CONCAT('CALLE ',pro.Calle,', No.',pro.NumExterior,', ',pro.Colonia,', ',mun.Nombre) AS DireccionCompleta, cre.CreditoID,
                CASE WHEN cre.Estatus = Esta_Vigente THEN Estatus_Vigente ELSE
                CASE WHEN cre.Estatus = Esta_Vencido THEN Estatus_Vencido ELSE
                CASE WHEN cre.Estatus = Esta_Castigado THEN Estatus_Castigado
                        ELSE cre.Estatus END END END AS Estatus
                    FROM PROSPECTOS pro
                        INNER JOIN MUNICIPIOSREPUB mun ON pro.MunicipioID = mun.MunicipioID AND pro.EstadoID = mun.EstadoID
                        INNER JOIN AVALESPORSOLICI avs ON pro.ProspectoID = avs.ProspectoID
                        INNER JOIN CREDITOS cre ON avs.SolicitudCreditoID = cre.SolicitudCreditoID
                            AND cre.Estatus IN (Esta_Vigente,Esta_Vencido,Esta_Castigado)
                        LEFT JOIN CLIENTES cli ON cre.ClienteID = cli.ClienteID
                        WHERE cre.ClienteID = Par_ClienteID;


        SELECT CASE WHEN ClienteID > Entero_Cero THEN ClienteID ELSE Cadena_Vacia END AS ClienteID,     NombreCompleto,
               CASE WHEN SucursalID > Entero_Cero THEN SucursalID ELSE Cadena_Vacia END AS SucursalID,  Telefono,
               TelefonoCel,     DireccionCompleta,      CreditoID,      Estatus
        FROM TMPAVALESCLIENTES;

    END IF;

    -- Lista los avales que son persona fisica o fisica con actividad empresarial
    IF(Par_NumLis = Lis_PersonaFisica)THEN
        SELECT AvalID, NombreCompleto
            FROM AVALES
            WHERE NombreCompleto LIKE   CONCAT("%", Par_Nombre, "%")
            AND TipoPersona  <> PersonaMoral
            LIMIT 0, 15;
    END IF;
        IF(Par_NumLis = Lis_PersonaMoral)THEN
        SELECT AvalID, NombreCompleto
            FROM AVALES
            WHERE NombreCompleto LIKE   CONCAT("%", Par_Nombre, "%")
            AND TipoPersona = PersonaMoral
            LIMIT 0, 15;
    END IF;

END TerminaStore$$