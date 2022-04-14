-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONLIMITENUM
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONLIMITENUM`;DELIMITER $$

CREATE FUNCTION `FUNCIONLIMITENUM`(
    Par_TarjetaDebito   char(16),
    Par_ClienteID       int(11),
    Par_TipoTar         int(11),
    Par_NumConsulta     int(11)
) RETURNS int(11)
    DETERMINISTIC
BEGIN

DECLARE Entero_Cero     int(11);
DECLARE Cadena_Vacia    char(2);
DECLARE Con_DispoDiario int(11);
DECLARE Con_DispoMes    int(11);
DECLARE Con_NumConsulta int(11);
DECLARE Con_CompraDiario int(11);
DECLARE Con_CompraMes   int(11);
DECLARE Con_ConsultaMes int(11);

DECLARE Val_Limite          decimal(12,4);
DECLARE Var_FechaSistema    date;

Set Entero_Cero         := 0;
Set Cadena_Vacia        := '';
Set Con_DispoDiario     := 1;
Set Con_DispoMes        := 2;
Set Con_NumConsulta	:= 3;
Set Con_CompraDiario    := 3;
Set Con_CompraMes       := 4;
Set Con_ConsultaMes     := 5;

Set Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS);

    if (Par_NumConsulta = Con_DispoDiario ) then
        SELECT NoDisposiDia  into Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_Limite, Cadena_Vacia) =  Cadena_Vacia then
            begin
                SELECT NoDisposiDia    into Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar;

                if ifnull(Val_Limite, Cadena_Vacia) = Cadena_Vacia then
                    begin
                        SELECT NoDisposiDia  into Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar;
                        RETURN ifnull(Val_Limite, Entero_Cero);
                    end;
                else
                    RETURN ifnull(Val_Limite, Entero_Cero);
                end if;
            end;
        else
            RETURN ifnull(Val_Limite, Entero_Cero);
        end if;
    end if;


	if (Par_NumConsulta = Con_NumConsulta ) then
		SELECT NumConsultaMes	into Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_Limite, Cadena_Vacia) =  Cadena_Vacia then
            begin
                SELECT NumConsultaMes    into Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar;

                if ifnull(Val_Limite, Cadena_Vacia) = Cadena_Vacia then
                    begin
                        SELECT NumConsultaMes  into Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar;
                        RETURN ifnull(Val_Limite, Entero_Cero);
                    end;
                else
                    RETURN ifnull(Val_Limite, Entero_Cero);
                end if;
            end;
        else
            RETURN ifnull(Val_Limite, Entero_Cero);
        end if;
	end if;
END$$