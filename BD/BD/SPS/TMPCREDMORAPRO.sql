-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TMPCREDMORAPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `TMPCREDMORAPRO`;DELIMITER $$

CREATE PROCEDURE `TMPCREDMORAPRO`(	)
TerminaStore: BEGIN

truncate table TMPCREDMORA;

insert into TMPCREDMORA
select C.CreditoID, C.ClienteID, FUNCIONEXIGIBLE(C.CreditoID) Total_Pagar,
        SaldoCapVencido+SaldoCapAtrasad+SaldoInterAtras+SaldoInterVenc Saldo_Vencido,
        DiasAtraso,NoCuotasAtraso,'1900-01-01' Fecha_Ult_Pago, 0.0 Monto_ul_pago,
        NOW() Fecha_Sig_Pago, MontoCuota Couta
    from SALDOSCREDITOS S,CREDITOS C
    where C.CreditoID=S.CreditoID and (SaldoCapAtrasad>0.0 or SaldoCapVencido>0.0)
    and S.FechaCorte=(Select MAX(FechaCorte) from SALDOSCREDITOS);

update TMPCREDMORA
    set FechaUltPago=(select ifnull(MAX(FechaPago),'1900-01-01')
                        from DETALLEPAGCRE
                         where TMPCREDMORA.CreditoID=DETALLEPAGCRE.CreditoID);
update TMPCREDMORA
    set MonUltPago=(select ifnull(SUM(MontoTotPago),0.0)
                        from DETALLEPAGCRE
                         where TMPCREDMORA.CreditoID=DETALLEPAGCRE.CreditoID
                         group by CreditoID,FechaPago,Transaccion
                         order by FechaPago desc,Transaccion desc LIMIT 1);

SELECT CreditoID, ClienteID, TotalPagar, SaldoVencido, DiasAtraso,
        CuotasAtraso, FECHAANUM(FechaUltPago) as FechaUltPago, MonUltPago,
        FECHAANUM(FechaSigPago) as FechaSigPago, Cuota
FROM  TMPCREDMORA;

END TerminaStore$$