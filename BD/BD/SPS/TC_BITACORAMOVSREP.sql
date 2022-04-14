-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_BITACORAMOVSREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `TC_BITACORAMOVSREP`;DELIMITER $$

CREATE PROCEDURE `TC_BITACORAMOVSREP`(
-- SP PARA GENERAR REPORTE DE MOVIMIENTOS DE TARJETA DE CREDITO
    Par_TarjetaCredID       CHAR(16),           -- ID de la tarjeta de credito
    Par_TipoOperacionID     CHAR(2),            -- Tipo de operacion
    Par_AnioPeriodo         INT,                -- Ano del Perido
    Par_MesPeriodo          INT,                -- Mes del periodo
    Par_FechaInicio         DATE,               -- Fecha de inicio
    Par_FechaFin            DATE,               -- Fecha final
    Par_TipoReporte         TINYINT UNSIGNED,   -- Tipo de reporte

    Par_EmpresaID           INT,                -- Auditoria
    Aud_Usuario             INT,                -- Auditoria
    Aud_FechaActual         DATE,               -- Auditoria
    Aud_DireccionIP         VARCHAR(15),        -- Auditoria
    Aud_ProgramaID          VARCHAR(50),        -- Auditoria
    Aud_Sucursal            INT,                -- Auditoria
    Aud_NumTransaccion      BIGINT              -- Auditoria
    )
TerminaStore: BEGIN


    DECLARE CompraNormal        VARCHAR(30);  -- Compra normal
    DECLARE RetiroEfectivo      VARCHAR(30);  -- retiro en efectivo
    DECLARE CompraRetiroEfec    VARCHAR(30);  -- Compra y retiro en efectivo
    DECLARE ConsultaSaldo       VARCHAR(30);  -- Consulta de saldo
    DECLARE CompraTpoAire       VARCHAR(30);  -- Camprade tiempo aire
    DECLARE AjusteCompra        VARCHAR(30);  -- Ajuste de compra
    DECLARE Est_Activada        INT;          -- Estatus activa
    DECLARE Est_Bloqueada       INT;          -- Estatus Bloqueada
    DECLARE EstatusCanc         INT;          -- Estatus Cancelada
    DECLARE Est_Expirada        INT;          -- Tarjeta Expirada
    DECLARE Est_Procesado       CHAR(1);      -- Estatus procesado o asiganda
    DECLARE Est_Registrado      CHAR(1);      -- Estatus Registrado
    DECLARE Rep_Principal       INT(11);      -- Reporte Principal
    DECLARE Rep_OperTarjeta     INT(11);      -- Reporte por Tarjeta
    DECLARE OpeCompraNormal     CHAR(2);     -- Operacion Compra normal
    DECLARE OpeRetiroEfectivo   CHAR(2);     -- Operacion Retiro en efectivo
    DECLARE OpeConsultaSaldo    CHAR(2);     -- Operacion de consulta de saldo
    DECLARE OpeCompraRetiro     CHAR(2);     -- Operacion compra y retiro de efectivo
    DECLARE OpeCompraTpoAire    CHAR(2);     -- Operacion de compra de tiempo aire
    DECLARE OpeAjusteCompra     CHAR(2);     -- operacion de ajuste de compra
    DECLARE MovExitoso          VARCHAR(30); -- Motivo exitoso
    DECLARE MovRechazado        VARCHAR(30); -- Motivo Rechazado
    DECLARE Nat_Cargo           CHAR(1);     -- cargo
    DECLARE Nat_Abono           CHAR(1);     -- Abono
    DECLARE MonedaMX            INT;         -- Moneda mexicana
    DECLARE MonedaUSD           INT;         -- Dolar
    DECLARE Entero_Cero         INT;
    DECLARE TipoMovTodos        INT;        -- Todos los movimietos
    DECLARE TipoMovExito        INT;        -- Evento exito
    DECLARE TipoMovRechazado    INT;        -- Evento Rechazado

    SET CompraNormal        := 'COMPRA POS';
    SET RetiroEfectivo      := 'RETIRO EN EFECTIVO ATM';
    SET CompraRetiroEfec    := 'RETIRO EN COMPRA POS';
    SET ConsultaSaldo       := 'CONSULTA DE SALDO ATM';
    SET CompraTpoAire       := 'COMPRA DE TIEMPO AIRE ATM';
    SET AjusteCompra        := 'AJUSTE DE COMPRA';
    SET MovExitoso          := 'EXITOSO';
    SET MovRechazado        := 'RECHAZADO';

    SET Est_Procesado       := 'P';
    SET Est_Registrado      := 'R';  -- Estatus Registrado
    SET Est_Activada        := 7;
    SET Est_Bloqueada       := 8;
    SET EstatusCanc         := 9;
    SET Est_Expirada        := 10;
    SET OpeCompraNormal     := '00';
    SET OpeRetiroEfectivo   := '01';
    SET OpeConsultaSaldo    := '31';
    SET OpeCompraRetiro     := '09';
    SET OpeCompraTpoAire    := '10';
    SET OpeAjusteCompra     := '02';
    SET Rep_Principal       := 1;
    SET Rep_OperTarjeta     := 2;

    SET Nat_Cargo           := 'C';
    SET Nat_Abono           := 'A';
    SET MonedaMX            := 484;
    SET MonedaUSD           := 840;
    SET Entero_Cero         := 0;
    SET TipoMovTodos        := 3;
    SET TipoMovExito        := 4;
    SET TipoMovRechazado    := 5;


--  CONSULTA PRINCIPAL


IF(Par_TipoReporte = Rep_Principal) THEN
    SELECT
            FechaOperacion, Referencia,  CONCAT(NombreComercio,' [',Ciudad,', ',Pais,']', CASE WHEN CodigoMonOpe = MonedaUSD THEN CONCAT(' / Dolar $ ',MontoOperacion,', TC: $ ',TipoCambio) ELSE '' END ) AS NombreComercio,
            CASE WHEN Naturaleza = Nat_Cargo THEN IFNULL(MontoOperacionMx,Entero_Cero) ELSE Entero_Cero END AS Cargos,
            CASE WHEN Naturaleza = Nat_Abono THEN IFNULL(MontoOperacionMx,Entero_Cero) ELSE Entero_Cero END AS Abonos
        FROM  TC_BITACORAMOVS
        WHERE TarjetaCredID = Par_TarjetaCredID AND Estatus = Est_Procesado
          AND YEAR(FechaOperacion) = Par_AnioPeriodo AND MONTH(FechaOperacion) = Par_MesPeriodo;

END IF;




IF(Par_TipoReporte = Rep_OperTarjeta) THEN
    SELECT
            Tar.TarjetaCredID,     LPAD(Cli.ClienteID,11,'0') AS ClienteID,     Cli.NombreCompleto,                     Cli.CorpRelacionado,                LPAD(CONVERT(Tar.LineaTarCredID, CHAR),11,'0') AS LineaTarCredID,
            'Credito' TipoCuenta,  TpoTar.TipoTarjetaDebID,                     TpoTar.Descripcion AS TipoTarjeta,      Movs.FechaOperacion AS Fecha,       LPAD(Movs.NumTransaccion, 6, '0') AS NumeroTran,
            Movs.MontoOperacion AS MontoOpe,   Corp.RazonSocial,                Movs.NombreComercio,                    Movs.DatosTiempoAire,
             CASE Movs.Estatus
                WHEN 'P'   THEN 'Procesado'
                WHEN 'R'   THEN 'Registrado'
            END AS TipoEstatus,
            CASE Movs.TipoOperacionID
                WHEN OpeCompraNormal   THEN CompraNormal
                WHEN OpeRetiroEfectivo THEN RetiroEfectivo
                WHEN OpeCompraTpoAire  THEN CompraTpoAire
                WHEN OpeConsultaSaldo  THEN ConsultaSaldo
                WHEN OpeAjusteCompra   THEN AjusteCompra
                WHEN OpeCompraRetiro   THEN CompraRetiroEfec
            END AS Operacion
        FROM         TC_BITACORAMOVS Movs
          INNER JOIN TARJETACREDITO Tar    ON Movs.TarjetaCredID = Tar.TarjetaCredID
          INNER JOIN LINEATARJETACRED Lin  ON Tar.LineaTarCredID = Lin.LineaTarCredID
          INNER JOIN CLIENTES Cli          ON Tar.ClienteID = Cli.ClienteID
          INNER JOIN TIPOTARJETADEB TpoTar ON Tar.TipoTarjetaCredID = TpoTar.TipoTarjetaDebID
           LEFT JOIN CLIENTES Corp         ON Cli.CorpRelacionado = Corp.ClienteID
    WHERE Movs.TarjetaCredID = Par_TarjetaCredID AND Movs.Estatus = Est_Procesado
        AND Movs.FechaOperacion >= DATE(Par_FechaInicio) AND Movs.FechaOperacion <= DATE(Par_FechaFin);

END IF;

IF(Par_TipoReporte = TipoMovTodos) THEN
    SELECT tmov.FechaOperacion AS Fecha, tmov.TarjetaCredID,
                CASE tmov.TipoOperacionID
                    WHEN OpeCompraNormal   THEN CompraNormal
                    WHEN OpeRetiroEfectivo THEN RetiroEfectivo
                    WHEN OpeCompraTpoAire  THEN CompraTpoAire
                    WHEN OpeConsultaSaldo  THEN ConsultaSaldo
                    WHEN OpeAjusteCompra   THEN AjusteCompra
                    WHEN OpeCompraRetiro   THEN CompraRetiroEfec
                    END AS Operacion,
                    tmov.NumTransaccion   AS NumeroTran,
                    tmov.MontoOperacionMx AS MontoOpe,
                    tmov.NombreComercio,
                CASE tmov.Estatus
                    WHEN Est_Procesado  THEN MovExitoso
                    WHEN Est_Registrado THEN MovRechazado
                END AS TipoEstatus
            FROM TC_BITACORAMOVS tmov
            WHERE tmov.FechaOperacion >= DATE(Par_FechaInicio) AND tmov.FechaOperacion <= DATE(Par_FechaFin);
END IF;

-- Exito
IF(Par_TipoReporte = TipoMovExito) THEN
    SELECT tmov.FechaOperacion AS Fecha,
           tmov.TarjetaCredID,
            CASE tmov.TipoOperacionID
                WHEN OpeCompraNormal   THEN CompraNormal
                WHEN OpeRetiroEfectivo THEN RetiroEfectivo
                WHEN OpeCompraTpoAire  THEN CompraTpoAire
                WHEN OpeConsultaSaldo  THEN ConsultaSaldo
                WHEN OpeAjusteCompra   THEN AjusteCompra
                WHEN OpeCompraRetiro   THEN CompraRetiroEfec
                END AS Operacion,
          tmov.NumTransaccion   AS NumeroTran,
          tmov.MontoOperacionMx AS MontoOpe,
          tmov.NombreComercio,
            CASE tmov.Estatus
                WHEN Est_Procesado  THEN MovExitoso
                WHEN Est_Registrado THEN MovRechazado
            END AS TipoEstatus
        FROM TC_BITACORAMOVS tmov
        WHERE tmov.FechaOperacion >= DATE(Par_FechaInicio) AND tmov.FechaOperacion <= DATE(Par_FechaFin)
        AND tmov.Estatus = Est_Procesado;

END IF;
-- Rechazados
IF(Par_TipoReporte = TipoMovRechazado) THEN


    SELECT tmov.FechaOperacion AS Fecha, tmov.TarjetaCredID,
        CASE tmov.TipoOperacionID
            WHEN OpeCompraNormal THEN CompraNormal
            WHEN OpeRetiroEfectivo THEN RetiroEfectivo
            WHEN OpeCompraTpoAire THEN CompraTpoAire
            WHEN OpeConsultaSaldo THEN ConsultaSaldo
            WHEN OpeAjusteCompra THEN AjusteCompra
            WHEN OpeCompraRetiro THEN CompraRetiroEfec
            END AS Operacion, tmov.NumTransaccion AS NumeroTran,
            tmov.MontoOperacionMx AS MontoOpe, tmov.NombreComercio,

        CONCAT((CASE tmov.Estatus
            WHEN Est_Procesado THEN MovExitoso
            WHEN Est_Registrado THEN MovRechazado
        END),' - ',IFNULL(resp.MensajeRespuesta,'')) AS TipoEstatus

    FROM TC_BITACORAMOVS tmov
    LEFT OUTER JOIN TC_BITACORARESP resp
    ON tmov.FechaOperacion = resp.FechaOperacion
        AND tmov.TarjetaCredID = resp.TarjetaCredID
        AND tmov.MontoOperacionMx = resp.MontoTransaccion
    WHERE tmov.FechaOperacion >= DATE(Par_FechaInicio) AND tmov.FechaOperacion <= DATE(Par_FechaFin)
    AND tmov.Estatus = Est_Registrado ;


END IF;




END TerminaStore$$