-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREPROXDESEMREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREPROXDESEMREP`;DELIMITER $$

CREATE PROCEDURE `CREPROXDESEMREP`(
    Par_Fecha           date,

    Par_EmpresaID       int,

    Aud_Usuario         int,
    Aud_FechaActual     DateTime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint

	)
TerminaStore: BEGIN


DECLARE EstatusAutorizado   char(1);
DECLARE PagareImpresoSI     char(1);


SET EstatusAutorizado   = 'A';
SET PagareImpresoSI     = 'S';


select CreditoID as NUM_CREDITO, ClienteID as IDCLIENTE, FECHAANUM(FechaAutoriza) as FEC_AUTORIZACION,
FECHAANUM(FechaInicio) as FEC_DESEMBOLSO, 0 as TRABAJADO, 0 as FEC_PROCESO
    from CREDITOS
    where PagareImpreso = PagareImpresoSI
      and FechaAutoriza   = Par_Fecha
      and Estatus       = EstatusAutorizado;


END TerminaStore$$