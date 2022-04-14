-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARJETACREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARJETACREDITOCON`;DELIMITER $$

CREATE PROCEDURE `TARJETACREDITOCON`(
-- SP PARA CONSULTAR LA TARJETA DE ECREDITO
    Par_TarjetaCredID       CHAR(16),       -- ID de la tarjeta de credito
    Par_LoteDebitoID        INT(11),        -- ID del lote de tarjeta
    Par_ProductoID          BIGINT(12),     -- ID del producto
    Par_TipoTarjetaDebID    INT(11),        -- ID de tipo de tarjeta
    Par_ClienteID           INT(11),        -- ID del cliente

    Par_Relacion            CHAR(1),        -- Relacion
    Par_NumCon              TINYINT UNSIGNED, -- Numero de consulta

    Par_EmpresaID           INT(11),        -- Auditoria
    Aud_Usuario             INT(11),        -- Auditoria
    Aud_FechaActual         DATETIME,       -- Auditoria
    Aud_DireccionIP         VARCHAR(15),    -- Auditoria
    Aud_ProgramaID          VARCHAR(50),    -- Auditoria
    Aud_Sucursal            INT(11),        -- Auditoria
    Aud_NumTransaccion      BIGINT(20)      -- Auditoria
    )
TerminaStore: BEGIN
-- declaracion de variables


-- Declaracion de Constantes
DECLARE Fecha_Vacia         DATE;
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Entero_Cero         INT;
DECLARE Est_Activada        INT;
DECLARE Est_Bloqueada       INT;
DECLARE EstatusCanc         INT;
DECLARE Est_Expirada        INT;
DECLARE Con_Principal       INT;
DECLARE Con_TarjetaCredID   INT;
DECLARE Con_TarDebAsigna    INT;
DECLARE Con_TarDebCancel    INT;
DECLARE Con_GirosTarCredInd INT;
DECLARE Con_TarExistentes   INT;
DECLARE Con_MovTarCred      INT;
DECLARE Con_AsociaTarjeta   INT;
DECLARE Con_LimiteTarCred   INT;
DECLARE Con_TarjetaComi     INT;
DECLARE Con_TarjetaAsig     INT;
-- Asignacion de Constantes



SET Fecha_Vacia         :='1900-01-01';
SET Cadena_Vacia        :='';
SET Entero_Cero         :=0;
SET Est_Activada        :=7;    -- Estatus Ativa de una tarjeta
SET Est_Bloqueada       :=8;    -- Estatus Bloqueado de una tarjeta
SET EstatusCanc         :=9;    -- Estatus Cancelado de una tarjeta
SET Est_Expirada        :=10;   -- Estatus de Tarjeta Expirada

SET Con_Principal       :=1;
SET Con_TarjetaCredID   :=2;    -- Consulta Tarjeta Asociado a un cliente
SET Con_TarDebAsigna    :=3;    -- Consulta Tarjeta Asignacion
SET Con_TarDebCancel    :=4;    -- CONSULTA DE TARJETA DE CREDITO PARA LA CANCELACION
SET Con_GirosTarCredInd :=5;    -- Consulta giros aceptados por tarjeta individual 14
SET Con_TarExistentes   :=6;    -- Consulta de Todas las Tarjetas existentes 15
SET Con_MovTarCred      :=7;    -- Consulta de Movimientos por Tarjeta Filtra Activas, Canceladas y Bloqueadas} 16
SET Con_AsociaTarjeta   :=8;    -- Consulta Cliente Asociada a una Tarjeta
SET Con_LimiteTarCred   :=9;    -- Limite de Tarjeta de Cred
SET Con_TarjetaComi     :=10;   -- Consulta para pantalla de Solicitud Tarjeta
SET Con_TarjetaAsig     :=11;   -- Consulta de tarjeta para la asiganacion de tarjeta





    -- 1 Consulta Pricipal
    IF(Par_NumCon = Con_Principal) THEN
        SELECT  TarjetaCredID,        LoteCreditoID,        FechaRegistro,    FechaVencimiento,     FechaActivacion,
                Estatus,              ClienteID,            FechaBloqueo,     MotivoBloqueo,        FechaCancelacion,
                MotivoCancelacion,    FechaDesbloqueo,      MotivoDesbloqueo, NIP,                  NombreTarjeta,
                Relacion,             SucursalID,           TipoTarjetaCredID
        FROM TARJETACREDITO
        WHERE TarjetaCredID = Par_TarjetaCredID;
    END IF;

    -- 2 Consulta Tarjeta de credito Activada a un cliente
    IF(Par_NumCon = Con_TarjetaCredID) THEN
        SELECT
            Tar.TarjetaCredID,   Est.Descripcion,    Cli.ClienteID,  NombreCompleto, Cli.CorpRelacionado,
            Est.EstatusId
        FROM TARJETACREDITO AS Tar
        INNER JOIN CLIENTES AS Cli ON Tar.ClienteID=Cli.ClienteID
        INNER JOIN ESTATUSTD AS Est ON Est.EstatusID=Tar.Estatus
        WHERE Tar.TarjetaCredID = Par_TarjetaCredID
          AND Tar.Estatus = Est_Activada;
    END IF;

    -- 3 Consulta los datos del cliente de la tarjeta con estatus de Asignado A clientes
    IF(Par_NumCon = Con_TarDebAsigna) THEN
        SELECT  Tar.TarjetaCredID,   Cli.CorpRelacionado,    Cli.ClienteID AS ClienteCorporativo,    Tar.Estatus
        FROM TARJETACREDITO Tar
        INNER JOIN CLIENTES Cli ON Tar.ClienteID = Cli.ClienteID
        WHERE Tar.TarjetaCredID = Par_TarjetaCredID;
    END IF;


    -- 4 Consulta los datos del cliente para la cancelacion de la tarjeta de credito
    IF(Par_NumCon = Con_TarDebCancel) THEN
        SELECT  TarjetaCredID,   Cli.ClienteID,  NombreCompleto, Est.Descripcion,    Cli.CorpRelacionado,
                Est.EstatusId
        FROM TARJETACREDITO AS Tar
        LEFT JOIN CLIENTES  AS Cli ON Tar.ClienteID = Cli.ClienteID
        LEFT JOIN ESTATUSTD AS Est ON Est.EstatusID= Tar.Estatus
        WHERE Tar.Estatus != EstatusCanc
          AND Tar.Estatus != Est_Expirada
          AND Tar.TarjetaCredID = Par_TarjetaCredID;
    END IF;


-- 5 Consulta giros aceptados por tarjeta individual
    IF(Par_NumCon = Con_GirosTarCredInd ) THEN
        SELECT  Tar.TarjetaCredID,      Est.Descripcion,            Cli.ClienteID,                      Cli.NombreCompleto,
                Cli.CorpRelacionado,    LIN.LineaTarCredID,         PRO.Descripcion AS ProductoDesc,    Tip.TipoTarjetaDebID,
                Tip.Descripcion AS DescripcionTD,       Tip.IdentificacionSocio,    PRO.ProducCreditoID AS ProductoID
          FROM      TARJETACREDITO AS Tar
          LEFT JOIN CLIENTES          AS Cli ON Tar.ClienteID=Cli.ClienteID
          LEFT JOIN ESTATUSTD         AS Est ON Est.EstatusID=Tar.Estatus
          LEFT JOIN TIPOTARJETADEB    AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaCredID
          LEFT JOIN LINEATARJETACRED  AS LIN ON Tar.LineaTarCredID=LIN.LineaTarCredID
          LEFT JOIN PRODUCTOSCREDITO  AS PRO ON PRO.ProducCreditoID=Tip.ProductoCredito
         WHERE Tar.TarjetaCredID=Par_TarjetaCredID
           AND Est.EstatusID = Est_Activada;
     END IF;

 -- 6 Consulta de todas las tarjetas existentes
    IF (Par_NumCon = Con_TarExistentes) THEN
        SELECT  Tar.TarjetaCredID,                      Est.Descripcion,            Cli.ClienteID,                      Cli.NombreCompleto,
                Cli.CorpRelacionado,                    LIN.LineaTarCredID,         PRO.Descripcion AS ProductoDesc,    Tip.TipoTarjetaDebID,
                Tip.Descripcion AS NombreTarjeta,       Est.EstatusId AS Estatus,   PRO.ProducCreditoID AS ProductoID
            FROM      TARJETACREDITO AS Tar
            LEFT JOIN CLIENTES          AS Cli  ON Tar.ClienteID=Cli.ClienteID
            LEFT JOIN ESTATUSTD         AS Est  ON Est.EstatusID=Tar.Estatus
            LEFT JOIN TIPOTARJETADEB    AS Tip  ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaCredID
            LEFT JOIN LINEATARJETACRED  AS LIN  ON Tar.LineaTarCredID=LIN.LineaTarCredID
            LEFT JOIN PRODUCTOSCREDITO  AS PRO  ON PRO.ProducCreditoID=Tip.ProductoCredito
        WHERE Tar.TarjetaCredID = Par_TarjetaCredID;
    END  IF;

     -- 7 Consulta de tarjetas para la pantalla de Consulta de Movimientos por Tarjeta
    IF (Par_NumCon = Con_MovTarCred) THEN
        SELECT  Tar.TarjetaCredID,                      Est.Descripcion,          Cli.ClienteID,                        Cli.NombreCompleto,
                Cli.CorpRelacionado,                    LIN.LineaTarCredID,       PRO.Descripcion AS ProductoDesc,      Tip.TipoTarjetaDebID,
                Tip.Descripcion AS NombreTarjeta,       Est.EstatusId AS Estatus, Tip.IdentificacionSocio,              PRO.ProducCreditoID AS ProductoID
            FROM      TARJETACREDITO    AS Tar
            LEFT JOIN CLIENTES          AS Cli  ON Tar.ClienteID=Cli.ClienteID
            LEFT JOIN ESTATUSTD         AS Est  ON Est.EstatusID=Tar.Estatus
            LEFT JOIN TIPOTARJETADEB    AS Tip  ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaCredID
            LEFT JOIN LINEATARJETACRED  AS LIN  ON Tar.LineaTarCredID=LIN.LineaTarCredID
            LEFT JOIN PRODUCTOSCREDITO  AS PRO  ON PRO.ProducCreditoID=Tip.ProductoCredito
        WHERE Tar.TarjetaCredID = Par_TarjetaCredID AND Tar.Estatus IN (Est_Activada, Est_Bloqueada, EstatusCanc, Est_Expirada);
    END IF;

    -- 8 Consulta Cliente Asociada a una Tarjeta
    IF(Par_NumCon = Con_AsociaTarjeta) THEN
        SELECT
            Tar.TarjetaCredID,   Ti.Descripcion,     Tar.ClienteID,      Cli.NombreCompleto,
            Cli.Clasificacion,  Cli.CorpRelacionado,Cli.ClienteID AS ClienteCorporativo,
            Cli.RazonSocial,    Tar.TipoTarjetaCredID,Sol.Estatus,       Tar.NombreTarjeta,Ti.IdentificacionSocio
        FROM TARJETACREDITO AS Tar
            LEFT JOIN   TIPOTARJETADEB  AS Ti  ON Tar.TipoTarjetaCredID = Ti.TipoTarjetaDebID
            LEFT JOIN   CLIENTES        AS Cli ON Tar.ClienteID = Cli.ClienteID
            LEFT JOIN   SOLICITUDTARCRE AS Sol ON Sol.TarjetaCreAntID = Par_TarjetaCredID
        WHERE Tar.TarjetaCredID = Par_TarjetaCredID;
    END IF;

    IF(Par_NumCon = Con_LimiteTarCred ) THEN
        SELECT  Tar.TarjetaCredID,      Est.Descripcion,                        Cli.ClienteID,          Cli.NombreCompleto,        Cli.CorpRelacionado,
                Tip.TipoTarjetaDebID,   Tip.Descripcion AS NombreTarjeta,       Est.EstatusID,          Tip.IdentificacionSocio
            FROM      TARJETACREDITO    AS Tar
            LEFT JOIN CLIENTES          AS Cli ON Tar.ClienteID=Cli.ClienteID
            LEFT JOIN ESTATUSTD         AS Est ON Est.EstatusID=Tar.Estatus
            LEFT JOIN TIPOTARJETADEB    AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaCredID
        WHERE Tar.TarjetaCredID=Par_TarjetaCredID;
      END IF;


    -- Consulta para la pantalla de solicitud de Tarjeta
    IF (Par_NumCon = Con_TarjetaComi )THEN
        SELECT Td.ClienteID, Td.LineaTarCredID, Te.MontoComision
            FROM TARJETACREDITO Td
            INNER JOIN TIPOSCUENTATARDEB Tc ON Td.TipoTarjetaCredID = Tc.TipoTarjetaDebID
            INNER JOIN TARDEBESQUEMACOM Te  ON Td.TipoTarjetaCredID = Te.TipoTarjetaDebID AND Tc.TipoCuentaID = Te.TipoCuentaID
            WHERE Td.TarjetaCredID = Par_TarjetaCredID LIMIT 1;
    END IF;

-- Consulta para la pantalla de Asiganacion de tarjeta
    IF (Par_NumCon = Con_TarjetaAsig )THEN
        SELECT TarjetaCredID,    Estatus,          ClienteID,         Relacion
          FROM TARJETACREDITO
         WHERE TipoTarjetaCredID = Par_TipoTarjetaDebID
           AND TarjetaCredID = Par_TarjetaCredID ;
    END IF;


END TerminaStore$$