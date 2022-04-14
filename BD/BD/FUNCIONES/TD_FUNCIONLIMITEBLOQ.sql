
-- TD_FUNCIONLIMITEBLOQ
DELIMITER ;
DROP FUNCTION IF EXISTS `TD_FUNCIONLIMITEBLOQ`;
DELIMITER $$

CREATE FUNCTION `TD_FUNCIONLIMITEBLOQ`(
  -- -----------------------------------------------------------
  --  Obtiene el limite de Bloqueo Tarjeta
  -- -----------------------------------------------------------
    Par_TarjetaDebito   CHAR(16),   -- Numero de tarjeta
    Par_ClienteID       INT(11),    -- Cliente ID
    Par_TipoTar         INT(11),    -- Tipo de tarjeta
    Par_NumConsulta     INT(11)     -- Numero de consulta
) RETURNS char(1) CHARSET latin1
    DETERMINISTIC
BEGIN

DECLARE Entero_Cero     INT(11);
DECLARE Cadena_Vacia    CHAR(2);
DECLARE Con_BloqATM     INT(11);
DECLARE Con_BloqPOS     INT(11);
DECLARE Con_BloqCashB   INT(11);
DECLARE Con_OpeMOTO     INT(11);

DECLARE Val_Limite      CHAR(1);
DECLARE Var_FechaSistema    DATE;

SET Entero_Cero     := 0;
SET Cadena_Vacia    := '';
SET Con_BloqATM     := 1;   -- Consulta para obtener si se bloquea ATM
SET Con_BloqPOS     := 2;   -- Consulta para obtener si se bloquea POS
SET Con_BloqCashB   := 3;   -- Consulta para obtener si se bloquea CashBack
SET Con_OpeMOTO     := 4;   -- Consulta para obtener si acepta transacciones MOTO

SET Var_FechaSistema    := (SELECT FechaSistema FROM PARAMETROSSIS);

    -- Bloqueo ATM
    IF (Par_NumConsulta = Con_BloqATM ) THEN
        SELECT BloquearATM  INTO Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito
                AND Vigencia > Var_FechaSistema;

        IF IFNULL(Val_Limite, Cadena_Vacia) =  Cadena_Vacia THEN
            BEGIN
                SELECT BloquearATM    INTO Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar ;

                IF IFNULL(Val_Limite, Cadena_Vacia) = Cadena_Vacia THEN
                    BEGIN
                        SELECT BloquearATM  INTO Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar ;
                        RETURN Val_Limite;
                    END;
                ELSE
                    RETURN Val_Limite;
                END IF;
            END;
        ELSE
            RETURN Val_Limite;
        END IF;
    END IF;

    --  Bloqueo POS
    IF (Par_NumConsulta = Con_BloqPOS ) THEN
        SELECT BloquearPOS  INTO Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        IF IFNULL(Val_Limite, Cadena_Vacia) =  Cadena_Vacia THEN
            BEGIN
                SELECT BloquearPOS    INTO Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar ;

                IF IFNULL(Val_Limite, Cadena_Vacia) = Cadena_Vacia THEN
                    BEGIN
                        SELECT BloquearPOS  INTO Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar ;
                        RETURN Val_Limite;
                    END;
                ELSE
                    RETURN Val_Limite;
                END IF;
            END;
        ELSE
            RETURN Val_Limite;
        END IF;
    END IF;

    -- Bloqueo de Con_BloqCashBack
    IF (Par_NumConsulta = Con_BloqCashB) THEN
        SELECT BloquearCashBack  INTO Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        IF IFNULL(Val_Limite, Cadena_Vacia) =  Cadena_Vacia THEN
            BEGIN
                SELECT BloquearCashBack    INTO Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar;

                IF IFNULL(Val_Limite, Cadena_Vacia) = Cadena_Vacia THEN
                    BEGIN
                        SELECT BloquearCashBack  INTO Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar ;
                        RETURN Val_Limite;
                    END;
                ELSE
                    RETURN Val_Limite;
                END IF;
            END;
        ELSE
            RETURN Val_Limite;
        END IF;
    END IF;

    -- Operacion MOTO
    IF (Par_NumConsulta = Con_OpeMOTO) THEN
        SELECT AceptaOpeMoto  INTO Val_Limite
            FROM TARDEBLIMITES
            WHERE TarjetaDebID = Par_TarjetaDebito AND Vigencia > Var_FechaSistema;

        IF IFNULL(Val_Limite, Cadena_Vacia) =  Cadena_Vacia THEN
            BEGIN
                SELECT AceptaOpeMoto    INTO Val_Limite
                    FROM TARDEBLIMITXCONTRA LCON
                    WHERE ClienteID = Par_ClienteID
                            AND TipoTarjetaDebID = Par_TipoTar ;

                IF IFNULL(Val_Limite, Cadena_Vacia) = Cadena_Vacia THEN
                    BEGIN
                        SELECT AceptaOpeMoto  INTO Val_Limite
                            FROM TARDEBLIMITESXTIPO LTIP
                            WHERE TipoTarjetaDebID = Par_TipoTar ;
                        RETURN Val_Limite;
                    END;
                ELSE
                    RETURN Val_Limite;
                END IF;
            END;
        ELSE
            RETURN Val_Limite;
        END IF;
    END IF;

END$$