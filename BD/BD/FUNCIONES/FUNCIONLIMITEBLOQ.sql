-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONLIMITEBLOQ
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONLIMITEBLOQ`;
DELIMITER $$

CREATE FUNCTION `FUNCIONLIMITEBLOQ`(
    Par_TarjetaDebito   char(16),
    Par_ClienteID       int(11),
    Par_TipoTar         int(11),
    Par_NumConsulta     int(11)
) RETURNS char(1) CHARSET latin1
	DETERMINISTIC
BEGIN

DECLARE Entero_Cero     int(11);
DECLARE Cadena_Vacia    char(2);
DECLARE Con_BloqATM     int(11);
DECLARE Con_BloqPOS     int(11);
DECLARE Con_BloqCashB   int(11);
DECLARE Con_OpeMOTO     int(11);

DECLARE Val_Limite      char(1);
DECLARE Var_FechaSistema    date;

Set Entero_Cero     := 0;
Set Cadena_Vacia    := '';
Set Con_BloqATM     := 1;
Set Con_BloqPOS     := 2;
Set Con_BloqCashB   := 3;
Set Con_OpeMOTO     := 4;

Set Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS);


    if (Par_NumConsulta = Con_BloqATM ) then
        SELECT BloquearATM  into Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito
                AND Vigencia > Var_FechaSistema;

        if ifnull(Val_Limite, Cadena_Vacia) =  Cadena_Vacia then
            begin
                SELECT BloquearATM    into Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar ;

                if ifnull(Val_Limite, Cadena_Vacia) = Cadena_Vacia then
                    begin
                        SELECT BloquearATM  into Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar ;
                        RETURN Val_Limite;
                    end;
                else
                    RETURN Val_Limite;
                end if;
            end;
        else
            RETURN Val_Limite;
        end if;
    end if;


    if (Par_NumConsulta = Con_BloqPOS ) then
        SELECT BloquearPOS  into Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_Limite, Cadena_Vacia) =  Cadena_Vacia then
            begin
                SELECT BloquearPOS    into Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar ;

                if ifnull(Val_Limite, Cadena_Vacia) = Cadena_Vacia then
                    begin
                        SELECT BloquearPOS  into Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar ;
                        RETURN Val_Limite;
                    end;
                else
                    RETURN Val_Limite;
                end if;
            end;
        else
            RETURN Val_Limite;
        end if;
    end if;


    if (Par_NumConsulta = Con_BloqCashB) then
        SELECT BloquearCashBack  into Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_Limite, Cadena_Vacia) =  Cadena_Vacia then
            begin
                SELECT BloquearCashBack    into Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar;

                if ifnull(Val_Limite, Cadena_Vacia) = Cadena_Vacia then
                    begin
                        SELECT BloquearCashBack  into Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar ;
                        RETURN Val_Limite;
                    end;
                else
                    RETURN Val_Limite;
                end if;
            end;
        else
            RETURN Val_Limite;
        end if;
    end if;


    if (Par_NumConsulta = Con_OpeMOTO) then
        SELECT AceptaOpeMoto  into Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_Limite, Cadena_Vacia) =  Cadena_Vacia then
            begin
                SELECT AceptaOpeMoto    into Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar ;

                if ifnull(Val_Limite, Cadena_Vacia) = Cadena_Vacia then
                    begin
                        SELECT AceptaOpeMoto  into Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar ;
                        RETURN Val_Limite;
                    end;
                else
                    RETURN Val_Limite;
                end if;
            end;
        else
            RETURN Val_Limite;
        end if;
    end if;

END$$