-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TESORERIAMOVSALT2
DELIMITER ;
DROP PROCEDURE IF EXISTS `TESORERIAMOVSALT2`;DELIMITER $$

CREATE PROCEDURE `TESORERIAMOVSALT2`(
    Par_CuentaAhoID     	int(12),
    Par_FechaMov        	date,
    Par_MontoMov        	decimal(12,2),
    Par_DescripcionMov	varchar(150),
    Par_ReferenciaMov   	varchar(150),
    Par_NumeroMov       	int


)
TerminaStore: BEGIN


DECLARE Cadena_Vacia			char(1);
DECLARE Fecha_Vacia			date;
DECLARE Entero_Cero			int;
DECLARE Conciliado_NO       char(1);
DECLARE Var_FolioMovimiento int;
DECLARE Salida_SI           char(1);


Set Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
Set Conciliado_NO       := 'N';
Set Salida_SI           := 'S';


set Par_NumeroMov   := ifnull(Par_NumeroMov, Entero_Cero);


set Var_FolioMovimiento  := ( select ifnull(Max(FolioMovimiento), 0) + 1	from TESORERIAMOVS);


INSERT INTO TESORERIAMOVS(
    FolioMovimiento,    CuentaAhoID,    NumeroMov,      FechaMov,       NatMovimiento,
    MontoMov,           TipoMov,        DescripcionMov, ReferenciaMov,  TipoRegristro,
    Status,             EmpresaID,      Usuario,        FechaActual,    DireccionIP,
    ProgramaID,         Sucursal,       NumTransaccion)
    VALUES(
    Var_FolioMovimiento,    Par_CuentaAhoID,    Par_NumeroMov,      Par_FechaMov,       'A',
    Par_MontoMov,           1,        'SALDO INICIAL', 'SALDO INICIAL',  'P',
    'C',             1,      1,        '2016-04-01',    '1.1.1.1',
    'migracion',         1,      8888888);


END TerminaStore$$