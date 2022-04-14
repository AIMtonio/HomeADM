-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUEAHOBLOQDESMASPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUEAHOBLOQDESMASPRO`;DELIMITER $$

CREATE PROCEDURE `CUEAHOBLOQDESMASPRO`(
    Par_Proceso         char(1),           -- B .- Bloqueo, D .- Desbloqueo
    Par_Salida          char(1),
    inout Par_NumErr    int,
    inout Par_ErrMen    varchar(400),
    Par_EmpresaID       int,

    Aud_Usuario         int,
    Aud_FechaActual     datetime,
    Aud_DireccionIP     varchar(15),
    Aud_ProgramaID      varchar(50),
    Aud_Sucursal        int,
    Aud_NumTransaccion  bigint
	)
TerminaStore: BEGIN

-- Declaracion de Variables
DECLARE Var_CuentaAhoID bigint;
DECLARE Var_SaldoDispon decimal(14,2);
DECLARE Var_MontoBloq   decimal(14,2);
DECLARE Var_BloqueoID   bigint;
DECLARE Var_FechaSis    date;

-- Declaracion de Constantes
DECLARE Entero_Cero     int;
DECLARE Cadena_Vacia    char(1);
DECLARE Fecha_Vacia     date;
DECLARE Var_Si          char(1);
DECLARE Var_No          char(1);
DECLARE Estatus_Activa  char(1);
DECLARE Blo_AutoDep     int;
DECLARE Tipo_Bloqueo    char(1);
DECLARE Tipo_DesBloqueo char(1);
DECLARE Salida_SI       char(1);
DECLARE Salida_NO       char(1);
DECLARE Des_BloqMasivo  varchar(50);
DECLARE Des_DesBloqMas  varchar(50);


-- Cursor para el Bloqueo de Saldo Masivo
DECLARE CURSORBLOQUEO CURSOR FOR
    select Cue.CuentaAhoID, Cue.SaldoDispon
            from CUENTASAHO Cue
            inner join TIPOSCUENTAS as Tip on Tip.TipoCuentaID= Cue.TipoCuentaID
                                           and Tip.EsBloqueoAuto = Var_Si
            where SaldoDispon > Entero_Cero
              and Cue.Estatus = Estatus_Activa;

-- Cursor para el DesBloqueo de Saldo Masivo
DECLARE CURSORDESBLOQUEO CURSOR FOR
    select CuentaAhoID, BloqueoID, MontoBloq
        from BLOQUEOS Blo
        where TiposBloqID = Blo_AutoDep
          and NatMovimiento = Tipo_Bloqueo
          and ifnull(FolioBloq, Entero_Cero) = Entero_Cero;

-- Asignacion de Constantes
Set Entero_Cero     := 0;                   -- Entero en Cero
Set Fecha_Vacia     := '1900-01-01';        -- Fecha Vacia
Set Cadena_Vacia    := '';                  -- Cadena Vacia
Set Var_Si          := 'S';                 -- Valor: SI
Set Var_No          := 'N';                 -- Valor: NO
Set Estatus_Activa  := 'A';                 -- Estatus de la Cuenta: Activa
Set Blo_AutoDep     := 13;                  -- Tipo de Bloqueo Automatico en cada Deposito
Set Tipo_Bloqueo    := 'B';                 -- Tipo de Movimiento de Bloqueo
Set Tipo_DesBloqueo := 'D';                 -- Tipo de Movimiento de DesBloqueo
Set Salida_SI       := 'S';                 -- Si Regresa un Resultado
Set Salida_NO       := 'N';                 -- No Regresa un Resultado
Set Des_BloqMasivo  := 'BLOQUEO MASIVO DE CUENTA'; -- Descripcion de Bloqueo Automatico
Set Des_DesBloqMas  := 'DESBLOQUEO MASIVO DE CUENTA'; -- Descripcion de DesBloqueo Automatico

select FechaSistema into Var_FechaSis
	from PARAMETROSSIS;

-- Proceso de Bloqueo Masivo
if(Par_Proceso = Tipo_Bloqueo) then
    OPEN CURSORBLOQUEO;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP

        FETCH CURSORBLOQUEO into
            Var_CuentaAhoID,    Var_SaldoDispon;

            CALL `BLOQUEOSPRO`(
                Entero_Cero,    Tipo_Bloqueo,       Var_CuentaAhoID,    Var_FechaSis,       Var_SaldoDispon,
                Fecha_Vacia,    Blo_AutoDep,        Des_BloqMasivo,     Aud_NumTransaccion, Cadena_Vacia,
                Cadena_Vacia,   Salida_NO,          Par_NumErr,         Par_ErrMen,         Par_EmpresaID,
                Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,
                Aud_NumTransaccion  );

        END LOOP;
    END;
    CLOSE CURSORBLOQUEO;
end if;

-- Proceso de DesBloqueo Masivo
if(Par_Proceso = Tipo_DesBloqueo) then
    OPEN CURSORDESBLOQUEO;
    BEGIN
        DECLARE EXIT HANDLER FOR SQLSTATE '02000' BEGIN END;
        LOOP

        FETCH CURSORDESBLOQUEO into
            Var_CuentaAhoID,    Var_BloqueoID, Var_MontoBloq;

            CALL `BLOQUEOSPRO`(
                Var_BloqueoID,  Tipo_DesBloqueo,    Var_CuentaAhoID,    Var_FechaSis,           Var_MontoBloq,
                Var_FechaSis,   Blo_AutoDep,        Des_DesBloqMas,     Aud_NumTransaccion,     Cadena_Vacia,
                Cadena_Vacia,   Salida_NO,          Par_NumErr,         Par_ErrMen,             Par_EmpresaID,
                Aud_Usuario,    Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
                Aud_NumTransaccion  );

        END LOOP;
    END;
    CLOSE CURSORDESBLOQUEO;

end if;

set Par_NumErr := 0;
set Par_ErrMen := 'Proceso Realizado Exitosamente.';

if (Par_Salida = Salida_SI) then
    select convert(Par_NumErr, char) as NumErr,
           Par_ErrMen as ErrMen;
end if;

END TerminaStore$$