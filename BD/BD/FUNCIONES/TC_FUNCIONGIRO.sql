-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TC_FUNCIONGIRO
DELIMITER ;
DROP FUNCTION IF EXISTS `TC_FUNCIONGIRO`;DELIMITER $$

CREATE FUNCTION `TC_FUNCIONGIRO`(
-- Determina si un iro de negocio es permitido
    Par_TarjetaCredito   CHAR(16),  -- Numero de Tarjeta
    Par_ClienteID       INT(11),    -- Numero de Cliente
    Par_TipoTar         INT(11),    -- Tipo de Tarjeta
    Par_GiroID          CHAR(5)     -- Numero del Giro
) RETURNS char(4) CHARSET latin1
    DETERMINISTIC
BEGIN

    DECLARE Entero_Cero         INT(11);
    DECLARE Cadena_Vacia        CHAR(2);
    DECLARE Val_Giro            CHAR(4);

    SET Cadena_Vacia    := '';
    SET Entero_Cero     := 0;

        SELECT GiroID   INTO Val_Giro
            FROM TARCREDGIROS
            WHERE TarjetaCredID = Par_TarjetaCredito AND GiroID = Par_GiroID;

        IF IFNULL(Val_Giro, Cadena_Vacia) = Cadena_Vacia THEN
        BEGIN
            SELECT GiroID   INTO Val_Giro
                FROM TARDEBGIROTIPOCONT
                WHERE ClienteID = Par_ClienteID AND TipoTarjetaDebID = Par_TipoTar AND GiroID = Par_GiroID;

            IF IFNULL(Val_Giro, Cadena_Vacia) = Cadena_Vacia THEN
            BEGIN
                SELECT GiroID   INTO Val_Giro
                    FROM TARDEBGIROSXTIPO
                    WHERE TipoTarjetaDebID = Par_TipoTar AND GiroID = Par_GiroID;

                RETURN IFNULL(Val_Giro, Entero_Cero);
            END;
            ELSE
                RETURN IFNULL(Val_Giro, Entero_Cero);
            END IF;
        END;
        ELSE
            RETURN IFNULL(Val_Giro, Entero_Cero);
        END IF;

END$$