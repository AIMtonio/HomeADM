-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONCILIACIONTESO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONCILIACIONTESO`;DELIMITER $$

CREATE PROCEDURE `CONCILIACIONTESO`(
  Par_InstitucionID   int(11),
  Par_NumCtaInstit char(18),
  Par_NumTransaccion bigint(20),
  Par_Numcon  tinyint unsigned


		)
TerminaStore: BEGIN

DECLARE CuentaAhorro bigint(12);
DECLARE MovsInter int;
DECLARE MovsExter int;
DECLARE Con_Status char(1);
DECLARE Var_NumColumn INT;
DECLARE Var_Num int;
DECLARE Monto decimal(12,2);
DECLARE Tipo int;

set MovsInter := 1;
set MovsExter := 2;
set Con_Status := 'N';

if(Par_Numcon = MovsInter)then

        set CuentaAhorro := (SELECT CuentaAhoID FROM CUENTASAHOTESO where InstitucionID = Par_InstitucionID and NumCtaInstit = Par_NumCtaInstit);

        insert into MOVIMIENTOSINTER(   NumTransaccion,    FechaOpe,   Descripcion,     TipoMov,    MontoMov,   Estatus)
                              select Par_NumTransaccion,   FechaMov,   DescripcionMov,  TipoMov,    MontoMov,    Status
                              from TESORERIAMOVS
                              where CuentaAhoID=CuentaAhorro
                              and Status = Con_Status order by FechaMov;

        select FechaOpe,Descripcion,TipoMov,MontoMov,Estatus,Par_NumTransaccion
               from MOVIMIENTOSINTER
               where NumTransaccion = Par_NumTransaccion;
end if;


if(Par_Numcon = MovsExter)then


        set CuentaAhorro = (SELECT CuentaAhoID FROM CUENTASAHOTESO where InstitucionID = Par_InstitucionID and NumCtaInstit = Par_NumCtaInstit );


        insert into MOVIMIENTOSEXTER (NumTransaccion,        FechaOperacion,        DescripcionMov,        TipoMovs,        MontoMovs)
                    select           Par_NumTransaccion,     FechaOperacion,        DescripcionMov,        TC.TipoMov,        TC.MontoMov
                    from         TESOMOVSCONCILIA TC,        MOVIMIENTOSINTER MI
                    where         CuentaAhoID = CuentaAhorro
                                    and         TC.MontoMov = MI.MontoMov
                                    and         TC.TipoMov = MI.TipoMov
                                    and         TC.FechaOperacion = MI.FechaOpe
                                    and         MI.NumTransaccion = Par_NumTransaccion order by FechaOperacion;


        select FechaOperacion,DescripcionMov,TipoMovs,MontoMovs
               from MOVIMIENTOSEXTER
               where NumTransaccion = Par_NumTransaccion;

end if;

END TerminaStore$$