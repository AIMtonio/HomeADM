-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FUNCIONGIRO
DELIMITER ;
DROP FUNCTION IF EXISTS `FUNCIONGIRO`;
DELIMITER $$

CREATE FUNCTION `FUNCIONGIRO`(
    Par_TarjetaDebito   char(16),
    Par_ClienteID       int(11),
    Par_TipoTar         int(11),
    Par_GiroID          char(4)
) RETURNS char(4) CHARSET latin1
	DETERMINISTIC
BEGIN

    DECLARE Entero_Cero         int(11);
    DECLARE Cadena_Vacia        char(2);
    DECLARE Val_Giro            char(4);

    Set Cadena_Vacia    := '';
    Set Entero_Cero     := 0;

        SELECT GiroID   into Val_Giro
            FROM TARDEBGIROS
            WHERE TarjetaDebID = Par_TarjetaDebito AND GiroID = Par_GiroID;

        if ifnull(Val_Giro, Cadena_Vacia) = Cadena_Vacia then
        begin
            SELECT GiroID   into Val_Giro
                FROM TARDEBGIROTIPOCONT
                WHERE ClienteID = Par_ClienteID and TipoTarjetaDebID = Par_TipoTar AND GiroID = Par_GiroID;

            if ifnull(Val_Giro, Cadena_Vacia) = Cadena_Vacia then
            begin
                SELECT GiroID   into Val_Giro
                    FROM TARDEBGIROSXTIPO
                    WHERE TipoTarjetaDebID = Par_TipoTar AND GiroID = Par_GiroID;

                RETURN ifnull(Val_Giro, Entero_Cero);
            end;
            else
                RETURN ifnull(Val_Giro, Entero_Cero);
            end if;
        end;
        else
            RETURN ifnull(Val_Giro, Entero_Cero);
        end if;

END$$