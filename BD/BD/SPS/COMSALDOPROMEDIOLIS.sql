-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMSALDOPROMEDIOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMSALDOPROMEDIOLIS`;
DELIMITER $$

CREATE PROCEDURE `COMSALDOPROMEDIOLIS`(
    -- SP PARA LISTAR LAS COMICIONES DE SALDO PROMEDIO
    Par_ClienteID                   INT(11),                -- CLIENTE
    Par_CuentaAhoID                 BIGINT(12),             -- CUENTA DE AHORRO
    Par_NumLis                      TINYINT UNSIGNED,       -- NUMERO DE LISTA

    Aud_EmpresaID                   INT(11),                -- AUDITORIA
    Aud_Usuario                     INT(11),                -- AUDITORIA
    Aud_FechaActual                 DATETIME,               -- AUDITORIA
    Aud_DireccionIP                 VARCHAR(15),            -- AUDITORIA
    Aud_ProgramaID                  VARCHAR(50),            -- AUDITORIA
    Aud_Sucursal                    INT(11),                -- AUDITORIA
    Aud_NumTransaccion              BIGINT(20)              -- AUDITORIA
)
TerminaStore: BEGIN
    -- DECALRACION DE VARIABLES
    DECLARE Var_FechaSistema            DATE;
    DECLARE Var_FechaIniSis             DATE;

    -- DECLARACION DE CONSTANTES
    DECLARE Lis_ComPendientes           INT(11);
    DECLARE Lis_ComPagadas              INT(11);


    -- ASIGNACION DE CONSTANTES
    SET Lis_ComPendientes               := 1;
    SET Lis_ComPagadas                  := 2;

    SET Var_FechaSistema:= (SELECT FechaSistema FROM PARAMETROSSIS WHERE EmpresaID=1);
    SET Var_FechaIniSis := SUBDATE(Var_FechaSistema, DAYOFMONTH(Var_FechaSistema) - 1);


	IF(Par_NumLis = Lis_ComPendientes) THEN
        SELECT	C.ComisionID,           C.FechaCorte,           C.CuentaAhoID,          C.ComSaldoPromOri,      C.IVAComSalPromOri,
                C.ComSaldoPromAct,      C.IVAComSalPromAct,     C.ComSaldoPromCob,      C.IVAComSalPromCob,     C.ComSaldoPromCond,
                C.IVAComSalPromCond,    C.Estatus,              C.OrigenComision,       CLI.ClienteID,          'COMISION POR SALDO PROMEDIO' AS TipoComision,
                (IFNULL(C.ComSaldoPromAct, 0)+IFNULL(C.IVAComSalPromAct, 0)) AS TotalSaldoCom,                  'COMISION PENDIENTE DE COBRO' AS Descripcion,
                CASE  C.Estatus WHEN 'V' THEN "VIGENTE"
                                WHEN 'P' THEN "PAGADO"
                                WHEN 'C' THEN "CONDONADO"
                ELSE "" END AS DesEstatus
            FROM COMSALDOPROMPEND C
            INNER JOIN CUENTASAHO CTA ON CTA.CuentaAhoID = C.CuentaAhoID
            INNER JOIN CLIENTES CLI ON CLI.ClienteID= CTA.ClienteID
        WHERE C.Estatus = "V"
        AND C.CuentaAhoID = Par_CuentaAhoID;
	END IF;

    IF(Par_NumLis = Lis_ComPagadas) THEN
        SELECT	C.CobroID,              C.ComisionID,           C.CuentaAhoID,                  C.SaldoDispon,          C.FechaCobro,
                C.ComSaldoPromPend,     C.IVAComSalPromPend,    C.ComSaldoPromCob,              C.IVAComSalPromCob,     C.TotalCobrado,
                C.OrigenCobro,          CLI.ClienteID,          'COMISION POR SALDO PROMEDIO' AS TipoComision,          'COMISION PENDIENTE DE COBRO' AS Descripcion,
                CASE  C.OrigenCobro WHEN 'C' THEN 'CIERRE DE MES'
                                    WHEN 'A' THEN "ABONO A CUENTA."
                ELSE '' END AS DesOrigen
            FROM COMSALDOPROMCOBRADO C
            INNER JOIN CUENTASAHO CTA ON CTA.CuentaAhoID = C.CuentaAhoID
            INNER JOIN CLIENTES CLI ON CLI.ClienteID= CTA.ClienteID
        WHERE C.CuentaAhoID = Par_CuentaAhoID
        AND (C.FechaCobro BETWEEN Var_FechaIniSis AND Var_FechaSistema)
        AND C.ComisionID!=0
        AND C.OrigenCobro='A';
	END IF;

END TerminaStore$$