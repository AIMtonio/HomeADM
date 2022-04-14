-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CREDITOARCHIVOSBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CREDITOARCHIVOSBAJ`;DELIMITER $$

CREATE PROCEDURE `CREDITOARCHIVOSBAJ`(
    Par_CreditoID           BIGINT(12),
    Par_TipoDocumentoID     INT(11),
    Par_DigCreditoID        INT(11),
    Par_TipoBaja            INT(11),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),
    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
            )
TerminaStore: BEGIN


DECLARE Var_EstatusCred CHAR(1);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Str_SI              CHAR(1);
DECLARE Str_NO              CHAR(1);
DECLARE StaCreAut           CHAR(1);
DECLARE StaCreVig           CHAR(1);
DECLARE StaCreVen           CHAR(1);
DECLARE StaCreCas           CHAR(1);
DECLARE StaCrePag           CHAR(1);
DECLARE TipoPorCredFolio    INT(11);



SET     Cadena_Vacia            := '';
SET     Fecha_Vacia             := '1900-01-01';
SET     Entero_Cero             := 0;
SET     Str_SI                  := 'S';
SET     Str_NO                  := 'N';
SET     StaCreAut               := 'A';
SET     StaCreVig               := 'V';
SET     StaCreVen               := 'B';
SET     StaCreCas               := 'K';
SET     StaCrePag               := 'P';
SET     TipoPorCredFolio        := 1;


SET     Par_NumErr              := 1;
SET     Par_ErrMen              := Cadena_Vacia;


IF Par_TipoBaja = TipoPorCredFolio THEN
    SET Var_EstatusCred := Cadena_Vacia;

    SET Var_EstatusCred := (SELECT Estatus FROM CREDITOS WHERE CreditoID = Par_CreditoID);

    IF IFNULL(Var_EstatusCred, Cadena_Vacia) =  Cadena_Vacia THEN
        SET Par_ErrMen  := 'El Credito No Existe';
        IF Par_Salida = Str_SI THEN
                SELECT  '001' AS NumErr,
                        Par_ErrMen AS ErrMen,
                        'creditoID' AS control,
                        Entero_Cero AS consecutivo;
        END IF;
    END IF;



    DELETE FROM CREDITOARCHIVOS
        WHERE CreditoID   = Par_CreditoID
          AND DigCreaID   = Par_DigCreditoID;

    SET Par_NumErr  := Entero_Cero;
    SET Par_ErrMen  := 'El documento fue Eliminado Exitosamente';

    IF Par_Salida = Str_SI THEN
            SELECT  '000' AS NumErr,
                    Par_ErrMen AS ErrMen,
                    'creditoID' AS control,
                    Par_CreditoID AS consecutivo;
    END IF;
END IF;

END TerminaStore$$