-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONLIMITEMONTO
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONLIMITEMONTO`;
DELIMITER $$

CREATE FUNCTION `FUNCIONLIMITEMONTO`(
    Par_TarjetaDebito   char(16),
    Par_ClienteID       int(11),
    Par_TipoTar         int(11),
    Par_NumCon          int(11)
) RETURNS decimal(12,4)
	DETERMINISTIC
BEGIN

    DECLARE Entero_Cero         int(11);
    DECLARE Decimal_Cero        decimal(12,0);
    DECLARE Cadena_Vacia        char(2);
    DECLARE Val_MontoLimite     decimal(12,4);
    DECLARE Con_DispoDiario    int(11);
    DECLARE Con_DispoMes        int(11);
    DECLARE Con_CompraDiario    int(11);
    DECLARE Con_CompraMes       int(11);
    DECLARE Var_FechaSistema    date;

    Set Cadena_Vacia        := '';
    Set Entero_Cero         := 0;
    Set Decimal_Cero        := 0.00;
    Set Con_DispoDiario     := 1;
    Set Con_DispoMes        := 2;
    Set Con_CompraDiario    := 3;
    Set Con_CompraMes       := 4;

    Set Var_FechaSistema    := (SELECT  FechaSistema FROM PARAMETROSSIS);


    if (Par_NumCon = Con_DispoDiario) then
        SELECT DisposiDiaNac    into Val_MontoLimite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_MontoLimite, Cadena_Vacia)= Cadena_Vacia then
        begin
            SELECT DisposiDiaNac    into Val_MontoLimite
                FROM TARDEBLIMITXCONTRA LCON
                WHERE ClienteID = Par_ClienteID and TipoTarjetaDebID = Par_TipoTar;

            if ifnull(Val_MontoLimite, Cadena_Vacia) = Cadena_Vacia then
            begin
                SELECT DisposiDiaNac    into Val_MontoLimite
                    FROM TARDEBLIMITESXTIPO LTIP
                    WHERE TipoTarjetaDebID = Par_TipoTar ;
                RETURN ifnull(Val_MontoLimite, Decimal_Cero);
            end;
            else
                RETURN ifnull(Val_MontoLimite, Decimal_Cero);
            end if;
        end;
        else
            RETURN ifnull(Val_MontoLimite, Decimal_Cero);
        end if;
    end if;


    if (Par_NumCon = Con_DispoMes) then

        SELECT DisposiMesNac    into Val_MontoLimite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_MontoLimite, Cadena_Vacia)= Cadena_Vacia then
        begin
            SELECT DisposiMesNac    into Val_MontoLimite
                FROM TARDEBLIMITXCONTRA LCON
                WHERE ClienteID = Par_ClienteID and TipoTarjetaDebID = Par_TipoTar ;

            if ifnull(Val_MontoLimite, Cadena_Vacia) = Cadena_Vacia then
            begin
                SELECT DisposiMesNac    into Val_MontoLimite
                    FROM TARDEBLIMITESXTIPO LTIP
                    WHERE TipoTarjetaDebID = Par_TipoTar;
                RETURN ifnull(Val_MontoLimite, Decimal_Cero);
            end;
            else
                RETURN ifnull(Val_MontoLimite, Decimal_Cero);
            end if;
        end;
        else
            RETURN ifnull(Val_MontoLimite, Decimal_Cero);
        end if;
    end if;


    if (Par_NumCon = Con_CompraDiario) then

        SELECT ComprasDiaNac    into Val_MontoLimite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_MontoLimite, Cadena_Vacia)= Cadena_Vacia then
        begin
            SELECT ComprasDiaNac    into Val_MontoLimite
                FROM TARDEBLIMITXCONTRA LCON
                WHERE ClienteID = Par_ClienteID and TipoTarjetaDebID = Par_TipoTar ;

            if ifnull(Val_MontoLimite, Cadena_Vacia) = Cadena_Vacia then
            begin
                SELECT ComprasDiaNac    into Val_MontoLimite
                    FROM TARDEBLIMITESXTIPO LTIP
                    WHERE TipoTarjetaDebID = Par_TipoTar ;
                RETURN ifnull(Val_MontoLimite, Decimal_Cero);
            end;
            else
                RETURN ifnull(Val_MontoLimite, Decimal_Cero);
            end if;
        end;
        else
            RETURN ifnull(Val_MontoLimite, Decimal_Cero);
        end if;
    end if;


    if (Par_NumCon = Con_CompraMes) then

        SELECT ComprasMesNac    into Val_MontoLimite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        if ifnull(Val_MontoLimite, Cadena_Vacia)= Cadena_Vacia then
        begin
            SELECT ComprasMesNac    into Val_MontoLimite
                FROM TARDEBLIMITXCONTRA LCON
                WHERE ClienteID = Par_ClienteID and TipoTarjetaDebID = Par_TipoTar ;

            if ifnull(Val_MontoLimite, Cadena_Vacia) = Cadena_Vacia then
            begin
                SELECT ComprasMesNac    into Val_MontoLimite
                    FROM TARDEBLIMITESXTIPO LTIP
                    WHERE TipoTarjetaDebID = Par_TipoTar ;
                RETURN ifnull(Val_MontoLimite, Decimal_Cero);
            end;
            else
                RETURN ifnull(Val_MontoLimite, Decimal_Cero);
            end if;
        end;
        else
            RETURN ifnull(Val_MontoLimite, Decimal_Cero);
        end if;
    end if;

END$$