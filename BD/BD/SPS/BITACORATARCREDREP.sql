-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORATARCREDREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORATARCREDREP`;DELIMITER $$

CREATE PROCEDURE `BITACORATARCREDREP`(
-- Genera el reporte de Estatus de tarjetas de credito
    Par_TarjetaCredID   CHAR(16),  -- Numero de tarjeta

    Par_EmpresaID       INT,          -- Auditoria
    Aud_Usuario         INT,          -- Auditoria
    Aud_FechaActual     DATETIME,       -- Auditoria
    Aud_DireccionIP     VARCHAR(15),    -- Auditoria
    Aud_ProgramaID      VARCHAR(50),    -- Auditoria
    Aud_Sucursal        INT,            -- Auditoria
    Aud_NumTransaccion  BIGINT          -- Auditoria

    )
TerminaStore: BEGIN

-- Declaracion de Variables

-- Declaracion de Constantes
DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT;



-- Asignacion de Constantes
SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;

SELECT  Tar.TarjetaCredID,                          Est.Descripcion AS Estatus,                 Cli.ClienteID,                  NombreCompleto,
        Cli.CorpRelacionado,                        'Credito' TipoCuenta,                       Tip.TipoTarjetaDebID,           LPAD(CONVERT(LIN.LineaTarCredID, CHAR),11,'0') AS LineaTarCredID,
        Tip.Descripcion AS TipoTarjeta,             Est.EstatusId,                                                         DATE(Bit.Fecha)AS Fecha,        UPPER(Bit.DescripAdicio) AS DescripAdicio,
        Cat.Descripcion AS Motivo,                 (SELECT RazonSocial
                                                      FROM CLIENTES
                                                     WHERE ClienteID= Cli.CorpRelacionado) AS RazonSocial
   FROM BITACORATARCRED AS Bit
    INNER JOIN TARJETACREDITO AS Tar ON Bit.TarjetaCredID =Tar.TarjetaCredID
    LEFT JOIN  CLIENTES AS Cli ON Tar.ClienteID=Cli.ClienteID
    LEFT JOIN  ESTATUSTD AS Est ON Est.EstatusID=Bit.TipoEvenTDID
    LEFT JOIN  CATALCANBLOQTAR AS Cat ON Cat.MotCanBloID =Bit.MotivoBloqID
    LEFT JOIN  TIPOTARJETADEB AS Tip ON Tip.TipoTarjetaDebID=Tar.TipoTarjetaCredID
    LEFT JOIN  LINEATARJETACRED AS LIN ON Tar.LineaTarCredID=LIN.LineaTarCredID
WHERE Tar.TarjetaCredID=Par_TarjetaCredID;

END TerminaStore$$