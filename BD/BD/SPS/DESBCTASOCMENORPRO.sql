-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- DESBCTASOCMENORPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `DESBCTASOCMENORPRO`;DELIMITER $$

CREATE PROCEDURE `DESBCTASOCMENORPRO`(
    Par_Proceso         char(1),

    Par_EmpresaID       int,
    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
		)
TerminaStore: BEGIN


DECLARE Var_CuentaAhoID bigint(12);
DECLARE Var_MontoBloq   decimal(14,2);
DECLARE Var_BloqueoID   bigint;
DECLARE Var_FechaSis    date;



DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Var_Si          char(1);
DECLARE Var_No          char(1);
DECLARE Tipo_Bloqueo    char(1);
DECLARE Tipo_DesBloqueo char(1);
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);
DECLARE Des_DesBloqMas  varchar(50);
DECLARE ErrMen			varchar(20);
DECLARE NumErr			int(11);
DECLARE Blo_AutoDep		int(11);
DECLARE Decimal_Cero	decimal(14,2);

DECLARE CURSORDESBLOQUEO CURSOR FOR

	select Cta.CuentaAhoID, Blo.BloqueoID, ifnull(Blo.MontoBloq,Decimal_Cero)
		from  CANCSOCMENORCTA Cta
		INNER JOIN BLOQUEOS Blo on Blo.CuentaAhoID = Cta.CuentaAhoID and Blo.NatMovimiento = "B" and ifnull(Blo.FolioBloq,Entero_Cero) = Entero_Cero
			where Cta.Aplicado="N";



Set Entero_Cero     := 0;
Set Fecha_Vacia     := '1900-01-01';
Set Cadena_Vacia    := '';
Set Var_Si          := 'S';
Set Var_No          := 'N';
Set Tipo_Bloqueo    := 'B';
Set Tipo_DesBloqueo := 'D';
Set Salida_SI       := 'S';
Set Salida_NO       := 'N';
Set Des_DesBloqMas  := 'DESBLOQUEO AUT.DE CUENTA';
Set ErrMen			:="";
Set NumErr			:=0;
set Blo_AutoDep		:=13;
Set Decimal_Cero	:=0.0;
select FechaSistema into Var_FechaSis
	from PARAMETROSSIS;


    OPEN CURSORDESBLOQUEO;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP

        FETCH CURSORDESBLOQUEO into
            Var_CuentaAhoID, Var_BloqueoID, Var_MontoBloq;

			if Var_MontoBloq!=Decimal_Cero then
				CALL `BLOQUEOSPRO`(
					Var_BloqueoID,  Par_Proceso,       Var_CuentaAhoID,    Var_FechaSis,           Var_MontoBloq,
					Var_FechaSis,   Blo_AutoDep,        Des_DesBloqMas,     Aud_NumTransaccion,     Cadena_Vacia,
					Cadena_Vacia,   Salida_NO,          NumErr,         	ErrMen,             	Par_EmpresaID,
					Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
					Aud_NumTransaccion  );
			end if;

        END LOOP;
    END;
    CLOSE CURSORDESBLOQUEO;




END TerminaStore$$