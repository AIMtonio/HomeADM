-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOMOVNOMINALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOMOVNOMINALIS`;
DELIMITER $$

CREATE PROCEDURE `TIPOMOVNOMINALIS`(
    -- SP para lista de tipos de movimiento de tesoreria de acuerdo a la cuenta contable
    Par_Descripcion     VARCHAR(50),        -- descripcion de busqueda
    Par_NumCta          VARCHAR(40),        -- Numero de cuenta contable
    Par_NumLis          TINYINT UNSIGNED,   -- Numero de lista

    Aud_EmpresaID       INT(11),            -- Parametros de auditoria
    Aud_Usuario         INT(11),            -- Parametros de auditoria
    Aud_FechaActual     DATETIME,           -- Parametros de auditoria
    Aud_DireccionIP     VARCHAR(20),        -- Parametros de auditoria
    Aud_ProgramaID      VARCHAR(50),        -- Parametros de auditoria
    Aud_Sucursal        INT(11),            -- Parametros de auditoria
    Aud_NumTransaccion  BIGINT(20)          -- Parametros de auditoria
    )
TerminaStore: BEGIN

DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT(11);

DECLARE TipoConcili     CHAR(1);
DECLARE Lis_Nomina      INT(11);


Set Cadena_Vacia    := '';              -- constante cadena vacia
Set Fecha_Vacia     := '1900-01-01';    -- Fecha vacia
Set Entero_Cero     := 0;               -- Entero cero
Set TipoConcili     := 'C';             -- Tipo conciliacion
Set Lis_Nomina      := 6;               -- Lista para tipo de movimiento de tesoreria

IF(Par_NumLis = Lis_Nomina) THEN     
    SELECT  TipoMovTesoID,  Descripcion
        FROM TIPOSMOVTESO
        WHERE CuentaContable    = Par_NumCta
          AND Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
     LIMIT 0, 15;
END IF;

END TerminaStore$$