-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before AND after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETADEBITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETADEBITOCON`;

DELIMITER $$
CREATE PROCEDURE `TARJETADEBITOCON`(
    Par_TarjetaDebID        CHAR(16),
    Par_LoteDebitoID        INT(11),
    Par_CuentaAhoID         BIGINT(12),
    Par_TipoTarjetaDebID    INT(11),
    Par_ClienteID           INT(11),
    Par_Relacion            CHAR(1),
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

    -- Declaracion de Variables
    DECLARE Var_EstatusExis         CHAR(1);
    DECLARE Var_TarjetaDebID        CHAR(16);
    DECLARE Var_Estatus             INT(11);
    DECLARE Var_TipoTarjetaDebID    INT(11);
    DECLARE Var_ClienteID           INT(11);
    DECLARE Var_CuentaAhoID         BIGINT(12);
    DECLARE Var_TipoCuentaID        INT(11);
    DECLARE Var_ComisionAnual       decimal(14,2);
    DECLARE Var_PagoComAnual        CHAR(1);
    DECLARE Var_FPagoComAnual       DATE;
    DECLARE Var_FechaProximoPag     DATE;
    DECLARE Var_FechaActivacion     DATE;

    -- Declaracion de Consultas
    DECLARE Con_Principal       INT(11);
    DECLARE Con_TipoTarjeta     INT(11);
    DECLARE Con_AsociaCuenta    INT(11);
    DECLARE Con_TipoTar         INT(11);
    DECLARE Con_TarjetaID       INT(11);
    DECLARE Con_TarjetaComi     INT(11);
    DECLARE Con_AsociaTarjeta   INT(11);
    DECLARE Con_EstatusTarjeta  INT(11);
    DECLARE Con_TarDebAsigna    INT(11);
    DECLARE Con_TarDebNivUno    INT(11);
    DECLARE Con_TarDebCancel    INT(11);
    DECLARE Con_TarDebCta       INT(11);
    DECLARE Con_LimiteTarDeb    INT(11);
    DECLARE Con_GirosTarDebInd  INT(11);
    DECLARE Con_Activas         INT(11);
    DECLARE Con_MovTarDeb       INT(11);
    DECLARE Con_TarExistentes   INT(11);
    DECLARE Con_TarCuenta       INT(11);

    -- Declarancion de Constantes
    DECLARE ID_ComAnual         INT(11);
    DECLARE ConCobroAnual       INT(11);
    DECLARE TD_Bloqueada        INT(11);
    DECLARE Fecha_Vacia         DATE;

    DECLARE EstatusSolic        CHAR(1);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Entero_Cero         INT(11);
    DECLARE Est_Activada        INT(11);
    DECLARE Est_Asigna          INT(11);
    DECLARE EstatusCanc         INT(11);
    DECLARE Est_Bloqueada       INT(11);
    DECLARE Est_Expirada        INT(11);
    DECLARE EstatusEsquemaCom   CHAR(1);

    -- Asignacion de Consultas
    SET Con_Principal       := 1;
    SET Con_AsociaCuenta    := 3;
    SET Con_TipoTar         := 4;
    SET Con_TarjetaID       := 5;
    SET Con_EstatusTarjeta  := 7;
    SET Con_TarDebNivUno    := 8;
    SET Con_TarDebAsigna    := 9;
    SET Con_TarDebCancel    := 10;
    SET Con_TarDebCta       := 11;
    SET Con_LimiteTarDeb    := 12;
    SET Con_AsociaTarjeta   := 13;
    SET Con_GirosTarDebInd  := 14;
    SET Con_TarjetaComi     := 15;
    set Con_Activas         := 16;
    SET Con_MovTarDeb       := 17;
    set Con_TarCuenta       := 18;
    SET ConCobroAnual       := 19;
    SET Con_TarExistentes   := 20;

    -- Asignacion de Constantes
    SET EstatusSolic        := 'S';
    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET ID_ComAnual         := 1;


    SET Est_Asigna          := 6;
    SET Est_Activada        := 7;
    SET Est_Bloqueada       := 8;
    SET EstatusCanc         := 9;
    SET Est_Expirada        := 10;
    SET TD_Bloqueada        := 13;
    SET EstatusEsquemaCom   := 'A';
    SET Fecha_Vacia         := '1900-01-01';

    IF( Par_NumCon = Con_Principal ) THEN
        SELECT
            `TarjetaDebID`,     `LoteDebitoID`,         `FechaRegistro`,    `FechaVencimiento`, `FechaActivacion`,
            `Estatus`,          `ClienteID`,            `CuentaAhoID`,      `FechaBloqueo`,     `MotivoBloqueo`,
            `FechaCancelacion`, `MotivoCancelacion`,    `FechaDesbloqueo`,  `MotivoDesbloqueo`, `NIP`,
            `NombreTarjeta`,    `Relacion`,             `SucursalID`,       `TipoTarjetaDebID`
        FROM TARJETADEBITO
        WHERE TarjetaDebID = Par_TarjetaDebID;
    END IF;


    IF( Par_NumCon = Con_AsociaCuenta ) THEN
        SELECT
            TarjetaDebID,   ClienteID,  CuentaAhoID,    NombreTarjeta,  Relacion,
            TipoTarjetaDebID, Estatus
        FROM TARJETADEBITO
        WHERE TarjetaDebID  = Par_TarjetaDebID
            AND CuentaAhoID = Par_CuentaAhoID  ;

    END IF;


    IF( Par_NumCon = Con_TipoTar ) THEN
        SELECT
            TarjetaDebID,   ClienteID,  CuentaAhoID,    NombreTarjeta,  Relacion,
            TipoTarjetaDebID
        FROM TARJETADEBITO
        WHERE TarjetaDebID = Par_TarjetaDebID;
    END IF;


    IF( Par_NumCon = Con_TarjetaID ) THEN
        SELECT
            TarjetaDebID,   Est.Descripcion,    Cli.ClienteID,  NombreCompleto, Cli.CorpRelacionado,
            Est.EstatusId
        FROM TARJETADEBITO AS Tar
        INNER JOIN CLIENTES AS Cli ON Tar.ClienteID=Cli.ClienteID
        INNER JOIN ESTATUSTD AS Est ON Est.EstatusID=Tar.Estatus
        WHERE TarjetaDebID = Par_TarjetaDebID AND Tar.Estatus = Est_Activada;
    END IF;


    IF( Par_NumCon = Con_AsociaTarjeta ) THEN
        SELECT
            Tar.TarjetaDebID,   Ti.Descripcion,     Tar.ClienteID,      Cli.NombreCompleto,     Tar.CuentaAhoID,
            Cue.Etiqueta,       Cli.Clasificacion,  Cli.CorpRelacionado,Cli.ClienteID AS ClienteCorporativo,
            Cli.RazonSocial,    Tar.TipoTarjetaDebID,Sol.Estatus,       Tar.NombreTarjeta,Ti.IdentificacionSocio
        FROM TARJETADEBITO Tar
        INNER JOIN TIPOTARJETADEB Ti ON Tar.TipoTarjetaDebID=Ti.TipoTarjetaDebID
        INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
        INNER JOIN  CUENTASAHO Cue ON Cue.ClienteID = Cli.ClienteID AND Tar.CuentaAhoID = Cue.CuentaAhoID
        LEFT JOIN SOLICITUDTARDEB Sol ON Sol.TarjetaDebAntID = Par_TarjetaDebID
        WHERE Tar.TarjetaDebID = Par_TarjetaDebID;
    END IF;


    IF( Par_NumCon = Con_EstatusTarjeta ) THEN
        SELECT
            Tar.TarjetaDebID,   Tar.Estatus,    etd.Descripcion
        FROM TARJETADEBITO Tar, ESTATUSTD etd
        WHERE   Tar.Estatus = etd.EstatusID
            AND Tar.TarjetaDebID = Par_TarjetaDebID;
    END IF;


    IF( Par_NumCon = Con_TarDebNivUno ) THEN
        SELECT
            TarjetaDebID,   td.Estatus,     etd.Descripcion,    CorpRelacionado,    TipoTarjetaDebID,
            TipoCuentaID,   cli.ClienteID,  ch.CuentaAhoID,     SaldoDispon,        PrimerNombre,
            SegundoNombre,  ApellidoPaterno,ApellidoMaterno
        FROM TARJETADEBITO td,  CLIENTES cli ,      CUENTASAHO ch,  ESTATUSTD etd
        WHERE etd.EstatusID     = td.Estatus
            AND cli.ClienteID   = td.ClienteID
            AND ch.CuentaAhoID  = td.CuentaAhoID
            AND td.TarjetaDebID = Par_TarjetaDebID;
    END IF;


    IF( Par_NumCon = Con_TarDebAsigna ) THEN
        SELECT
            Tar.TarjetaDebID,   Cli.CorpRelacionado,    Cli.ClienteID AS ClienteCorporativo,    Tar.Estatus
        FROM TARJETADEBITO Tar
        INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
        WHERE Tar.TarjetaDebID = Par_TarjetaDebID;
    END IF;

    IF( Par_NumCon = Con_TarDebCancel ) THEN
        SELECT
            TarjetaDebID,   Cli.ClienteID,  NombreCompleto, Est.Descripcion,    Cli.CorpRelacionado,
            Est.EstatusId
        FROM TARJETADEBITO AS Tar
        LEFT JOIN CLIENTES AS Cli ON Tar.ClienteID = Cli.ClienteID
        LEFT JOIN ESTATUSTD AS Est ON Est.EstatusID= Tar.Estatus
        WHERE Tar.Estatus != EstatusCanc AND Tar.Estatus != Est_Expirada  AND Tar.TarjetaDebID = Par_TarjetaDebID;
    END IF;


    IF( Par_NumCon = Con_TarDebCta  ) THEN
        SELECT
            Estatus,        TipoTarjetaDebID,       NombreTarjeta,      Relacion
        FROM TARJETADEBITO
        WHERE CuentaAhoID = Par_CuentaAhoID;
    END IF;
    IF( Par_NumCon = Con_LimiteTarDeb  ) THEN
        SELECT Tar.TarjetaDebID,Est.Descripcion,Cli.ClienteID,Cli.NombreCompleto,
                    Cli.CorpRelacionado,CTA.CuentaAhoID,TCTA.Descripcion,Tip.TipoTarjetaDebID,
                    Tip.Descripcion,Est.EstatusId, Tip.IdentificacionSocio
            FROM TARJETADEBITO AS Tar
            LEFT JOIN CLIENTES AS Cli ON Tar.ClienteID=Cli.ClienteID
            LEFT JOIN ESTATUSTD AS Est ON Est.EstatusID=Tar.Estatus
            LEFT JOIN TIPOTARJETADEB AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID
            LEFT JOIN CUENTASAHO AS CTA ON Tar.CuentaAhoID=CTA.CuentaAhoID
            LEFT JOIN TIPOSCUENTAS AS TCTA ON TCTA.TipoCuentaID=CTA.TipoCuentaID
        WHERE Tar.TarjetaDebID=Par_TarjetaDebID;
      END IF;

    IF( Par_NumCon = Con_GirosTarDebInd  ) THEN
        SELECT Tar.TarjetaDebID,Est.Descripcion,Cli.ClienteID,Cli.NombreCompleto,
                    Cli.CorpRelacionado,CTA.CuentaAhoID,TCTA.Descripcion,Tip.TipoTarjetaDebID,
                    Tip.Descripcion,Est.EstatusId,Tip.IdentificacionSocio
            FROM TARJETADEBITO AS Tar
            LEFT JOIN CLIENTES AS Cli ON Tar.ClienteID=Cli.ClienteID
            LEFT JOIN ESTATUSTD AS Est ON Est.EstatusID=Tar.Estatus
            LEFT JOIN TIPOTARJETADEB AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID
            LEFT JOIN CUENTASAHO AS CTA ON Tar.CuentaAhoID=CTA.CuentaAhoID
            LEFT JOIN TIPOSCUENTAS AS TCTA ON TCTA.TipoCuentaID=CTA.TipoCuentaID
        WHERE Tar.TarjetaDebID=Par_TarjetaDebID AND Est.EstatusID = Est_Activada;
      END IF;


    IF( Par_NumCon = Con_TarjetaComi )THEN
        SELECT Td.ClienteID, Td.CuentaAhoID, Te.MontoComision
            FROM TARJETADEBITO Td
            INNER JOIN TIPOSCUENTATARDEB Tc ON Td.TipoTarjetaDebID = Tc.TipoTarjetaDebID
            INNER JOIN TARDEBESQUEMACOM Te ON Td.TipoTarjetaDebID = Te.TipoTarjetaDebID AND Tc.TipoCuentaID = Te.TipoCuentaID
            WHERE Td.TarjetaDebID = Par_TarjetaDebID ;
    END IF;

    IF( Par_NumCon = Con_ActivAS ) THEN
        SELECT
    Tar.TarjetaDebID,       Est.Descripcion,    Cli.ClienteID,      Cli.NombreCompleto,
    Cli.CorpRelacionado,    CTA.CuentaAhoID,    TCTA.Descripcion,   Tip.TipoTarjetaDebID,
    Tip.Descripcion,        Est.EstatusId
            FROM TARJETADEBITO AS Tar LEFT JOIN
             CLIENTES AS Cli ON Tar.ClienteID=Cli.ClienteID
            LEFT JOIN ESTATUSTD AS Est ON Est.EstatusID=Tar.Estatus
            LEFT JOIN TIPOTARJETADEB AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID
            LEFT JOIN CUENTASAHO AS CTA ON Tar.CuentaAhoID=CTA.CuentaAhoID
            LEFT JOIN TIPOSCUENTAS AS TCTA ON TCTA.TipoCuentaID=CTA.TipoCuentaID
        WHERE Tar.TarjetaDebID = Par_TarjetaDebID AND Tar.Estatus = Est_Activada;
    END IF;


    IF( Par_NumCon = Con_MovTarDeb ) THEN
        SELECT
            Tar.TarjetaDebID,       Est.Descripcion,    Cli.ClienteID,      Cli.NombreCompleto,
            Cli.CorpRelacionado,    CTA.CuentaAhoID,    TCTA.Descripcion AS NombreCuenta,   Tip.TipoTarjetaDebID,
            Tip.Descripcion AS NombreTarjeta,       Est.EstatusId AS Estatus, Tip.IdentificacionSocio
            FROM TARJETADEBITO AS Tar LEFT JOIN
                CLIENTES AS Cli ON Tar.ClienteID=Cli.ClienteID
            LEFT JOIN ESTATUSTD AS Est ON Est.EstatusID=Tar.Estatus
            LEFT JOIN TIPOTARJETADEB AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID
            LEFT JOIN CUENTASAHO AS CTA ON Tar.CuentaAhoID=CTA.CuentaAhoID
            LEFT JOIN TIPOSCUENTAS AS TCTA ON TCTA.TipoCuentaID=CTA.TipoCuentaID
        WHERE Tar.TarjetaDebID = Par_TarjetaDebID AND Tar.Estatus IN (Est_Activada, Est_Bloqueada, EstatusCanc, Est_Expirada);
    END IF;


    IF( Par_NumCon = Con_TarCuenta  ) THEN
        SELECT
            TarjetaDebID,   Estatus,    TipoTarjetaDebID,   Relacion,   TipoCobro,
            NombreTarjeta
        FROM TARJETADEBITO
        WHERE CuentaAhoID = Par_CuentaAhoID AND Relacion = Par_Relacion
            AND Estatus not in( EstatusCanc,Est_Expirada) AND TipoTarjetaDebID=Par_TipoTarjetaDebID;

    END IF;

    IF( Par_NumCon = ConCobroAnual)THEN
        SELECT Tar.TarjetaDebID,        Tar.Estatus,    Tar.TipoTarjetaDebID,   Tar.ClienteID,  Tar.CuentaAhoID,
                PagoComAnual,   FPagoComAnual, FechaActivacion
            into Var_TarjetaDebID,      Var_Estatus,        Var_TipoTarjetaDebID,   Var_ClienteID,  Var_CuentaAhoID,
                Var_PagoComAnual, Var_FPagoComAnual,        Var_FechaActivacion
            FROM TARJETADEBITO Tar
                WHERE (Estatus = Est_Activada OR (Estatus = Est_Bloqueada AND MotivoBloqueo = TD_Bloqueada))
                and  TarjetaDebID = Par_TarjetaDebID;

        SET Var_TipoCuentaID    := (SELECT TipoCuentaID
                                    FROM CUENTASAHO
                                    WHERE CuentaAhoID = Var_CuentaAhoID);

        SET Var_ComisionAnual   :=  (SELECT MontoComision
                                        FROM TARDEBESQUEMACOM
                                        WHERE TipoTarjetaDebID = Var_TipoTarjetaDebID
                                            AND TipoCuentaID = Var_TipoCuentaID
                                            AND TarDebComisionID = ID_ComAnual
                                            AND Estatus = EstatusEsquemaCom);

        IF( ifnull(Var_FPagoComAnual, Fecha_Vacia) = Fecha_Vacia)THEN
            SET Var_FechaProximoPag := DATE_ADD(IFNULL(Var_FechaActivacion ,Fecha_Vacia), INTERVAL 6 MONTH);
        ELSE
            SET Var_FechaProximoPag := DATE_ADD(Var_FPagoComAnual, INTERVAL 1 YEAR);

        END IF;


        SELECT Var_TarjetaDebID AS TarjetaDebID,    Var_Estatus AS Estatus,     Var_TipoTarjetaDebID AS TipoTarjetaDebID,
            Var_ClienteID AS ClienteID,     Var_CuentaAhoID AS CuentaAhoID,
                Var_PagoComAnual AS PagoComAnual,   Var_FPagoComAnual AS FPagoComAnual, Var_ComisionAnual AS ComisionAnual,
                Var_FechaActivacion AS FechaActivacion,Var_FechaProximoPag AS FechaProximoPag,
                Cli.NombreCompleto, Cli.CorpRelacionado,TCta.TipoCuentaID,      TCta.Descripcion AS DesTipoCta,
                TTar.Descripcion  AS DesTipoTarjeta, Est.Descripcion AS DesEstatus, TTar.IdentificacionSocio
              FROM CLIENTES Cli,
                    CUENTASAHO  Cta,
                    TIPOSCUENTAS  TCta,
                    TIPOTARJETADEB TTar,
                    ESTATUSTD Est
                WHERE Cli.ClienteID = Var_ClienteID
                AND  Cta.CuentaAhoID  =Var_CuentaAhoID
                AND TCta.TipoCuentaID=Cta.TipoCuentaID
                AND TTar.TipoTarjetaDebID=Var_TipoTarjetaDebID
                AND Est.EstatusID=Var_Estatus;
    END IF;


    IF( Par_NumCon = Con_TarExistentes ) THEN
        SELECT
            Tar.TarjetaDebID,       Est.Descripcion,    Cli.ClienteID,      Cli.NombreCompleto,
            Cli.CorpRelacionado,    CTA.CuentaAhoID,    TCTA.Descripcion AS NombreCuenta,   Tip.TipoTarjetaDebID,
            Tip.Descripcion AS NombreTarjeta,       Est.EstatusId AS Estatus
            FROM TARJETADEBITO AS Tar LEFT JOIN
                CLIENTES AS Cli ON Tar.ClienteID=Cli.ClienteID
            LEFT JOIN ESTATUSTD AS Est ON Est.EstatusID=Tar.Estatus
            LEFT JOIN TIPOTARJETADEB AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaDebID
            LEFT JOIN CUENTASAHO AS CTA ON Tar.CuentaAhoID=CTA.CuentaAhoID
            LEFT JOIN TIPOSCUENTAS AS TCTA ON TCTA.TipoCuentaID=CTA.TipoCuentaID
        WHERE Tar.TarjetaDebID = Par_TarjetaDebID;
    END IF;
END TerminaStore$$