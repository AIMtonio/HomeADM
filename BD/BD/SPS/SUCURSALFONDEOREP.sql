-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SUCURSALFONDEOREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `SUCURSALFONDEOREP`;DELIMITER $$

CREATE PROCEDURE `SUCURSALFONDEOREP`(
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

/* Declaracion de Constantes */
DECLARE Fecha_Vacia     date;
DECLARE Cadena_Vacia    char(1);
DECLARE Entero_Cero     int;
DECLARE Estatus_Vigente char(1);
DECLARE Estatus_Autori  char(1);
DECLARE Caja_Atencion   char(2);
DECLARE Caja_Principal  char(2);
DECLARE Disp_Efectivo   char(1);

/* Asignacion de Constantes */
set Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
set Cadena_Vacia    := '';                  -- Cadena Vacia
set Entero_Cero     := 0.00;                -- Entero en Cero
set Estatus_Vigente := 'V';                 -- Estatus del Credito: Vigente
set Estatus_Autori  := 'A';                 -- Estatus del Credito: Autorizado
set Caja_Atencion   := 'CA';                -- Tipo de Caja: Atencion al Publico
set Caja_Principal  := 'CP';                -- Tipo de Caja: Principal
set Disp_Efectivo   := 'E';                 -- Tipo de Dispersion: En Efectivo.

select Suc.SucursalID, max(Suc.NombreSucurs) as NombreSucurs,

	ifnull((select sum(cav.SaldoEfecMN) FROM CAJASVENTANILLA cav
		where cav.SucursalID = Suc.SucursalID and TipoCaja=Caja_Atencion), Entero_Cero)  as SaldoCajAtenc,

	ifnull((select sum(cap.SaldoEfecMN) FROM CAJASVENTANILLA cap
		where cap.SucursalID = Suc.SucursalID and TipoCaja=Caja_Principal), Entero_Cero)  as SaldoCajPrin,

        ifnull((select sum(Cre.MontoCredito)
                        from CREDITOS Cre
                            where Cre.SucursalID = Suc.SucursalID
                              and Cre.TipoDispersion = Disp_Efectivo

                              and    Cre.Estatus = Estatus_Autori
                                     ), Entero_Cero) as PorDesemb,

        ifnull((select sum(Cre.MontoCredito)
                        from CREDITOS Cre
                            where Cre.SucursalID = Suc.SucursalID
                              and Cre.TipoDispersion = Disp_Efectivo

                              and    Cre.Estatus = Estatus_Vigente
                                AND FechaInicio=Par_Fecha
                                     ), Entero_Cero)  as DesembHoy,

            ifnull((select sum(MontoEnFirme)
                        from CAJASMOVS Cai
                        where Cai.SucursalID = Suc.SucursalID
                          and Cai.TipoOperacion = 16), Entero_Cero) as MtoRecBancos

    from SUCURSALES Suc,
		CAJASVENTANILLA Caj
    where Caj.SucursalID = Suc.SucursalID
    group by Suc.SucursalID;

END TerminaStore$$