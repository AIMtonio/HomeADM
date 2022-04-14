-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPROXVENCIMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPROXVENCIMREP`;DELIMITER $$

CREATE PROCEDURE `CREPROXVENCIMREP`(
    Par_NumDias     int,

    Par_Salida      char(1),
    inout	Par_NumErr int,
    inout	Par_ErrMen varchar(350),

    Par_EmpresaID       	int,

    Aud_Usuario         	int,
    Aud_FechaActual     	DateTime,
    Aud_DireccionIP     	varchar(15),
    Aud_ProgramaID      	varchar(50),
    Aud_Sucursal        	int,
    Aud_NumTransaccion  	bigint

	)
TerminaStore: BEGIN


DECLARE Var_FechaActual date;
DECLARE Var_FechaConsul date;


DECLARE Decimal_Cero    decimal(12,2);
DECLARE Pro_NoCobraIVA  char(1);
DECLARE Cli_NoPagaIVA   char(1);
DECLARE Est_Vigente     char(1);
DECLARE Est_Vencida     char(1);
DECLARE Est_Atraso      char(1);


SET Decimal_Cero    = 0.00;
SET Pro_NoCobraIVA  = 'N';
SET Cli_NoPagaIVA   = 'N';
SET Est_Vigente     = 'V';
SET Est_Vencida     = 'B';
SET Est_Atraso      = 'A';

select FechaSistema into Var_FechaActual
    from PARAMETROSSIS;

set Var_FechaConsul = ADDDATE(Var_FechaActual, Par_NumDias);

select  RTRIM(LTRIM(CONVERT(Amo.CreditoID,CHAR(11)))) as num_credito,
        max(Amo.ClienteID) as idcliente,
        FECHAANUM(min(Amo.FechaVencim)) as fec_vencimiento,
        (   sum(Amo.Capital) +
            sum(Amo.Interes) +
            (CASE
                    WHEN max(Pro.CobraIVAInteres) = Pro_NoCobraIVA or
                      max(Cli.PagaIVA) = Cli_NoPagaIVA THEN
                        Decimal_Cero
                    ELSE
                        round(sum(Amo.Interes) * max(Suc.IVA),2)
                    END )) as monto_vencimiento

    from AMORTICREDITO  Amo,
         CLIENTES   Cli,
         CREDITOS   Cre,
         PRODUCTOSCREDITO Pro,
         SUCURSALES Suc
    where Amo.FechaVencim   <= Var_FechaConsul
      and Amo.FechaVencim   >= Var_FechaActual
      and ( Amo.Estatus  = Est_Vigente
       or   Amo.Estatus  = Est_Vencida
       or   Amo.Estatus  = Est_Atraso   )
      and Amo.CreditoID = Cre.CreditoID
      and Cre.ProductoCreditoID = Pro.ProducCreditoID
      and Cre.ClienteID = Cli.ClienteID
      and Cli.SucursalOrigen    = Suc.SucursalID

    group by Amo.CreditoID;


END TerminaStore$$