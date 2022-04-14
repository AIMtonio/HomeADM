-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_FUNCIONLIMITEMONTO
DELIMITER ;
DROP FUNCTION IF EXISTS `TC_FUNCIONLIMITEMONTO`;DELIMITER $$

CREATE FUNCTION `TC_FUNCIONLIMITEMONTO`(
  -- -----------------------------------------------------------
  --  Obtiene el limite de Tarjeta
  -- -----------------------------------------------------------
    Par_TarjetaCredito   CHAR(16),  -- Tarjeta de credito
    Par_ClienteID       INT(11),    -- Numero de cliente
    Par_TipoTar         INT(11),    -- Tipo de Tarjeta
    Par_NumCon          INT(11)     -- Numero de Consulta
) RETURNS decimal(12,4)
    DETERMINISTIC
BEGIN

    DECLARE Entero_Cero         INT(11);
    DECLARE Decimal_Cero        DECIMAL(12,0);
    DECLARE Cadena_Vacia        CHAR(2);
    DECLARE Val_MontoLimite     DECIMAL(12,4);
    DECLARE Con_DispoDiario     INT(11);
    DECLARE Con_DispoMes        INT(11);
    DECLARE Con_CompraDiario    INT(11);
    DECLARE Con_CompraMes       INT(11);
    DECLARE Var_FechaSistema    DATE;

    SET Cadena_Vacia        := '';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.00;
    SET Con_DispoDiario     := 1;   -- Consulta para obtener el limite de monto diario para disposicion
    SET Con_DispoMes        := 2;   -- Consulta para obtener el limite de monto mensual para disposicion
    SET Con_CompraDiario    := 3;   -- Consulta para obtener el limite de monto diario para compra
    SET Con_CompraMes       := 4;   -- Consulta para obtener el limite de monto mensual para compra

    SET Var_FechaSistema    := (SELECT  FechaSistema FROM PARAMETROSSIS);

    -- Disposicion Diario
    IF (Par_NumCon = Con_DispoDiario) THEN
        SELECT DisposiDiaNac    INTO Val_MontoLimite
            FROM TARCRELIMITES
            WHERE TarjetaCredID = Par_TarjetaCredito AND Vigencia > Var_FechaSistema;

        IF IFNULL(Val_MontoLimite, Cadena_Vacia)= Cadena_Vacia THEN
        BEGIN
            SELECT DisposiDiaNac    INTO Val_MontoLimite
                FROM TARDEBLIMITXCONTRA LCON
                WHERE ClienteID = Par_ClienteID AND TipoTarjetaDebID = Par_TipoTar;

            IF IFNULL(Val_MontoLimite, Cadena_Vacia) = Cadena_Vacia THEN
            BEGIN
                SELECT DisposiDiaNac    INTO Val_MontoLimite
                    FROM TARDEBLIMITESXTIPO LTIP
                    WHERE TipoTarjetaDebID = Par_TipoTar ;
                RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
            END;
            ELSE
                RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
            END IF;
        END;
        ELSE
            RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
        END IF;
    END IF;

    -- Disposicion Mensual
    IF (Par_NumCon = Con_DispoMes) THEN

        SELECT DisposiMesNac    INTO Val_MontoLimite
            FROM TARCRELIMITES
            WHERE TarjetaCredID = Par_TarjetaCredito AND Vigencia > Var_FechaSistema;

        IF IFNULL(Val_MontoLimite, Cadena_Vacia)= Cadena_Vacia THEN
        BEGIN
            SELECT DisposiMesNac    INTO Val_MontoLimite
                FROM TARDEBLIMITXCONTRA LCON
                WHERE ClienteID = Par_ClienteID AND TipoTarjetaDebID = Par_TipoTar ;

            IF IFNULL(Val_MontoLimite, Cadena_Vacia) = Cadena_Vacia THEN
            BEGIN
                SELECT DisposiMesNac    INTO Val_MontoLimite
                    FROM TARDEBLIMITESXTIPO LTIP
                    WHERE TipoTarjetaDebID = Par_TipoTar;
                RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
            END;
            ELSE
                RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
            END IF;
        END;
        ELSE
            RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
        END IF;
    END IF;

    -- Limite Compra Diario
    IF (Par_NumCon = Con_CompraDiario) THEN

        SELECT ComprasDiaNac    INTO Val_MontoLimite
            FROM TARCRELIMITES
            WHERE TarjetaCredID = Par_TarjetaCredito AND Vigencia > Var_FechaSistema;

        IF IFNULL(Val_MontoLimite, Cadena_Vacia)= Cadena_Vacia THEN
        BEGIN
            SELECT ComprasDiaNac    INTO Val_MontoLimite
                FROM TARDEBLIMITXCONTRA LCON
                WHERE ClienteID = Par_ClienteID AND TipoTarjetaDebID = Par_TipoTar ;

            IF IFNULL(Val_MontoLimite, Cadena_Vacia) = Cadena_Vacia THEN
            BEGIN
                SELECT ComprasDiaNac    INTO Val_MontoLimite
                    FROM TARDEBLIMITESXTIPO LTIP
                    WHERE TipoTarjetaDebID = Par_TipoTar ;
                RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
            END;
            ELSE
                RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
            END IF;
        END;
        ELSE
            RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
        END IF;
    END IF;

    -- Limite Compra Mensual
    IF (Par_NumCon = Con_CompraMes) THEN

        SELECT ComprasMesNac    INTO Val_MontoLimite
            FROM TARCRELIMITES
            WHERE TarjetaCredID = Par_TarjetaCredito AND Vigencia > Var_FechaSistema;

        IF IFNULL(Val_MontoLimite, Cadena_Vacia)= Cadena_Vacia THEN
        BEGIN
            SELECT ComprasMesNac    INTO Val_MontoLimite
                FROM TARDEBLIMITXCONTRA LCON
                WHERE ClienteID = Par_ClienteID AND TipoTarjetaDebID = Par_TipoTar ;

            IF IFNULL(Val_MontoLimite, Cadena_Vacia) = Cadena_Vacia THEN
            BEGIN
                SELECT ComprasMesNac    INTO Val_MontoLimite
                    FROM TARDEBLIMITESXTIPO LTIP
                    WHERE TipoTarjetaDebID = Par_TipoTar ;
                RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
            END;
            ELSE
                RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
            END IF;
        END;
        ELSE
            RETURN IFNULL(Val_MontoLimite, Decimal_Cero);
        END IF;
    END IF;

END$$