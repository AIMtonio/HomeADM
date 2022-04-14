-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TARDEBACLARACIONCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TARDEBACLARACIONCON`;DELIMITER $$

CREATE PROCEDURE `TARDEBACLARACIONCON`(
#SP PARA CONSULTA DE ACLARACION
    Par_ReporteID       INT(11),			-- Pametro de reporte ID
    Par_TipoTarjeta		CHAR(1),			-- Parametro de tipo tarjeta
    Par_NumCon          TINYINT UNSIGNED,   -- Parametro numero consulta

    Aud_EmpresaID       INT(11),    		-- Parametro de Auditoria
    Aud_Usuario         INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  BIGINT(20)			-- Parametro de Auditoria
	)
TerminaStore: BEGIN

DECLARE Con_Principal       INT(11);		-- Consulta Principal
DECLARE Con_Foranea         INT(11);		-- Consulta foranea
DECLARE Con_Parametros      INT(11);		-- Consulta Parametros
DECLARE Con_Resultado       INT(11);		-- Consulta Resultado
DECLARE Con_CredAclara		INT(11);		-- Consulta Credito Aclara
DECLARE Con_ResultCre		INT(11);		-- Consulta Resultado

SET Con_Principal       := 1;
SET Con_Foranea         := 2;
SET Con_Parametros      := 3;   -- Consulta de Parametros de TARDEBPARAMS
SET Con_Resultado       := 4;
SET Con_CredAclara		:= 5;
SET Con_ResultCre		:= 6;

    IF(Par_NumCon = Con_Principal) THEN
		SELECT
            Tar.TipoAclaraID,   Tar.ReporteID,      Tar.Estatus,        Tar.TarjetaDebID,   Tarj.TipoTarjetaDebID,
			Ti.Descripcion,		Tarj.ClienteID,     Cli.NombreCompleto, Tarj.CuentaAhoID,   Cue.Etiqueta,
            (SELECT ClienteID FROM CLIENTES WHERE Cli.CorpRelacionado = ClienteID) AS ClienteCorporativo,
            (SELECT RazonSocial FROM CLIENTES WHERE Cli.CorpRelacionado = ClienteID) AS RazonSocial,
            Tar.InstitucionID,  Ins.Nombre,			Tar.OpeAclaraID,    Tar.Comercio,       Tar.NoCajero,
			Tar.FechaOperacion, Tar.MontoOperacion, Tar.TransaccionRep, Tar.DetalleReporte, Tar.NoAutorizacion
        FROM TARDEBACLARACION Tar
        INNER JOIN TARJETADEBITO Tarj ON Tarj.TarjetaDebID = Tar.TarjetaDebID
        INNER JOIN TIPOTARJETADEB Ti ON Tarj.TipoTarjetaDebID = Ti.TipoTarjetaDebID
        INNER JOIN CLIENTES Cli ON Tarj.ClienteID = Cli.ClienteID
        INNER JOIN INSTITUCIONES  Ins ON Tar.InstitucionID = Ins.InstitucionID
        INNER JOIN CUENTASAHO Cue ON Cue.ClienteID = Cli.ClienteID AND Tarj.CuentaAhoID = Cue.CuentaAhoID
        WHERE Tar.ReporteID = Par_ReporteID
        AND Tar.TipoTarjeta = Par_TipoTarjeta;
    END IF;


    IF ( Par_Numcon = Con_Parametros ) THEN
        SELECT
            MaxDiasAclara
        FROM TARDEBPARAMS;
    END IF;

    IF(Par_NumCon = Con_Resultado) THEN
        SELECT    Tar.ReporteID,      Tar.TarjetaDebID,    Tar.Estatus,
            Tarj.ClienteID,     Cli.NombreCompleto, Tarj.CuentaAhoID,   Cue.Etiqueta,
            (SELECT ClienteID FROM CLIENTES WHERE Cli.CorpRelacionado = ClienteID) AS ClienteCorporativo,
            (SELECT RazonSocial FROM CLIENTES WHERE Cli.CorpRelacionado = ClienteID) AS RazonSocial,Ope.Descripcion,
               Tar.DetalleReporte,FechaResolucion, DetalleResolucion
        FROM TARDEBACLARACION Tar
        INNER JOIN TARJETADEBITO Tarj ON Tarj.TarjetaDebID = Tar.TarjetaDebID
        INNER JOIN TIPOTARJETADEB Ti ON Tarj.TipoTarjetaDebID = Ti.TipoTarjetaDebID
        INNER JOIN CLIENTES Cli ON Tarj.ClienteID = Cli.ClienteID
        INNER JOIN INSTITUCIONES  Ins ON Tar.InstitucionID = Ins.InstitucionID
        INNER JOIN CUENTASAHO Cue ON Cue.ClienteID = Cli.ClienteID AND Tarj.CuentaAhoID = Cue.CuentaAhoID
        INNER JOIN TARDEBOPEACLARA Ope ON Tar.OpeAclaraId=Ope.OpeAclaraId AND Ope.TipoAclaraId=Tar.TipoAclaraId
		WHERE Tar.ReporteID = Par_ReporteID
        AND Tar.TipoTarjeta = Par_TipoTarjeta;
    END IF;

    IF(Par_NumCon = Con_CredAclara) THEN
		SELECT
            Tar.TipoAclaraID,   Tar.ReporteID,      Tar.Estatus,        Tar.TarjetaDebID,   	Tarj.TipoTarjetaCredID,
			Ti.Descripcion,		Tarj.ClienteID,     Cli.NombreCompleto, Tarj.LineaTarCredID,
            (SELECT ClienteID FROM CLIENTES WHERE Cli.CorpRelacionado = ClienteID) AS ClienteCorporativo,
            (SELECT RazonSocial FROM CLIENTES WHERE Cli.CorpRelacionado = ClienteID) AS RazonSocial,
            Tar.InstitucionID,  Ins.Nombre,			Tar.OpeAclaraID,    Tar.Comercio,       	Tar.NoCajero,
			Tar.FechaOperacion, Tar.MontoOperacion, Tar.TransaccionRep, Tar.DetalleReporte, 	Tar.NoAutorizacion,
            Pr.Descripcion AS NombreProducto, Pr.ProducCreditoID

        FROM TARDEBACLARACION Tar
        INNER JOIN TARJETACREDITO Tarj ON Tarj.TarjetaCredID = Tar.TarjetaDebID
        INNER JOIN TIPOTARJETADEB Ti ON Tarj.TipoTarjetaCredID = Ti.TipoTarjetaDebID
        INNER JOIN CLIENTES Cli ON Tarj.ClienteID = Cli.ClienteID
        INNER JOIN INSTITUCIONES  Ins ON Tar.InstitucionID = Ins.InstitucionID
        INNER JOIN TIPOTARJETADEB Tp ON  Tarj.TipoTarjetaCredID = Tp.TipoTarjetaDebID
        INNER JOIN PRODUCTOSCREDITO Pr ON Tp.ProductoCredito = Pr.ProducCreditoID
        WHERE Tar.ReporteID = Par_ReporteID
        AND Tar.TipoTarjeta = Par_TipoTarjeta;
    END IF;

    IF(Par_NumCon = Con_ResultCre) THEN
        SELECT  Tar.ReporteID,      Tar.TarjetaDebID,   Tar.Estatus, 	Tarj.ClienteID,     Cli.NombreCompleto,
				(SELECT ClienteID FROM CLIENTES WHERE Cli.CorpRelacionado = ClienteID) AS ClienteCorporativo,
				(SELECT RazonSocial FROM CLIENTES WHERE Cli.CorpRelacionado = ClienteID) AS RazonSocial,Ope.Descripcion,
                Tar.DetalleReporte,	FechaResolucion, 	DetalleResolucion, Pr.Descripcion AS NombreProducto, Pr.ProducCreditoID
        FROM TARDEBACLARACION Tar
			INNER JOIN TARJETACREDITO Tarj ON Tarj.TarjetaCredID = Tar.TarjetaDebID
			INNER JOIN TIPOTARJETADEB Ti ON Tarj.TipoTarjetaCredID = Ti.TipoTarjetaDebID
			INNER JOIN CLIENTES Cli ON Tarj.ClienteID = Cli.ClienteID
			INNER JOIN INSTITUCIONES  Ins ON Tar.InstitucionID = Ins.InstitucionID
			INNER JOIN TIPOTARJETADEB Tp ON  Tarj.TipoTarjetaCredID = Tp.TipoTarjetaDebID
			INNER JOIN PRODUCTOSCREDITO Pr ON Tp.ProductoCredito = Pr.ProducCreditoID
			INNER JOIN TARDEBOPEACLARA Ope ON Tar.OpeAclaraID=Ope.OpeAclaraID AND Ope.TipoAclaraID=Tar.TipoAclaraID
		WHERE Tar.ReporteID = Par_ReporteID
			AND Tar.TipoTarjeta = Par_TipoTarjeta;
    END IF;

END TerminaStore$$