-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- COMISIONESSALPROAHOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `COMISIONESSALPROAHOCON`;
DELIMITER $$

CREATE PROCEDURE `COMISIONESSALPROAHOCON`(
    -- SP PARA CONSULTAR LAS COMISIONES PENDIENTES DE COBRAR
    Par_ClienteID                   INT(11),                -- CLIENTE ID
    Par_CuentaAhoID                 BIGINT(12),             -- CUENTA DE AHORRO DEL CLIENTE
    Par_NumCon                      TINYINT UNSIGNED,       -- NUMERO DE CONSULTA

    Aud_EmpresaID                   INT(11),                -- AUDITORIA
    Aud_Usuario                     INT(11),                -- AUDITORIA
    Aud_FechaActual                 DATETIME,               -- AUDITORIA
    Aud_DireccionIP                 VARCHAR(15),            -- AUDITORIA
    Aud_ProgramaID                  VARCHAR(50),            -- AUDITORIA
    Aud_Sucursal                    INT(11),                -- AUDITORIA
    Aud_NumTransaccion              BIGINT(20)              -- AUDITORIA
)
TerminaStore: BEGIN

    -- DECLARACION DE CONSTANTES
    DECLARE Con_ComisionesPendientesCobro           INT(11);
    DECLARE Con_ComisionesPagadas                   INT(11);

    -- ASIGNACION DE CONSTANTES
    SET Con_ComisionesPendientesCobro               := 1;
    SET Con_ComisionesPagadas                       := 2;


    -- CONSULTA DE LAS COMISIONES PENDIENTES DE PAGO
	IF(Par_NumCon = Con_ComisionesPendientesCobro) THEN
		SELECT	C.ComisionID,             CLI.ClienteID,            C.CuentaAhoID
			FROM COMSALDOPROMPEND C
            INNER JOIN CUENTASAHO A ON A.CuentaAhoID=C.CuentaAhoID
            INNER JOIN CLIENTES CLI ON CLI.ClienteID= A.ClienteID
            WHERE CLI.ClienteID=Par_ClienteID
            AND C.Estatus="V";
	END IF;
    -- CONSULTA DE LAS COMISIONES PAGADAS
    IF(Par_NumCon = Con_ComisionesPagadas) THEN
		SELECT	C.CobroID,          C.ComisionID,             CLI.ClienteID,            C.CuentaAhoID
			FROM COMSALDOPROMCOBRADO C
            INNER JOIN CUENTASAHO A ON A.CuentaAhoID=C.CuentaAhoID
            INNER JOIN CLIENTES CLI ON CLI.ClienteID= A.ClienteID
            WHERE C.CuentaAhoID=Par_CuentaAhoID
            AND C.ComisionID !=0
            AND C.OrigenCobro="A";
	END IF;


END TerminaStore$$