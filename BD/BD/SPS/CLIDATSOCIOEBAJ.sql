-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CLIDATSOCIOEBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `CLIDATSOCIOEBAJ`;DELIMITER $$

CREATE PROCEDURE `CLIDATSOCIOEBAJ`(

    Par_LinNeg          INT(11),
    Par_Prospecto       INT(11),
    Par_Cliente         INT(11),
    Par_SocioEID        INT(11),
    Par_Salida          CHAR(1),
    inout Par_NumErr    INT(11),
    inout Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_HistID          INT(11);
DECLARE Var_FechaActual     DATE;
DECLARE Var_Pivote          VARCHAR(15);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATETIME;
DECLARE Entero_Cero         INT(11);
DECLARE Str_SI              CHAR(1);
DECLARE Str_NO              CHAR(1);



SET     Cadena_Vacia        := '';
SET     Fecha_Vacia         := '1900-01-01';
SET     Entero_Cero         := 0;
SET     Str_SI              := 'S';
SET     Str_NO              := 'N';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr := '999';
                    SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                            'Disculpe las molestias que esto le ocasiona. Ref: SP-CLIDATSOCIOEBAJ');
                    SET Var_Pivote := 'sqlException' ;
                END;



SET     Par_NumErr  := 1;
SET     Par_ErrMen  := Cadena_Vacia;

SET Var_FechaActual :=  (SELECT FechaSistema FROM PARAMETROSSIS);

IF ifnull(Par_Cliente,Entero_Cero) <> Entero_Cero then
        DELETE
            FROM CLIDATSOCIOE
            WHERE   CatSocioEID = Par_SocioEID and ClienteID = Par_Cliente and LinNegID = Par_LinNeg;
END IF;

IF  ifnull(Par_Prospecto,Entero_Cero) <> Entero_Cero then
        DELETE
            FROM CLIDATSOCIOE
            WHERE   CatSocioEID = Par_SocioEID and ProspectoID = Par_Prospecto and LinNegID = Par_LinNeg;
END IF;

SET Par_NumErr  := Entero_Cero;
SET Par_ErrMen  := 'Datos Socioeconómicos dados de baja Exitosamente.' ;


END ManejoErrores;


IF(Par_Salida = Str_SI) then
    select  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Pivote AS control,
            Par_LinNeg AS consecutivo;
END IF;

END TerminaStore$$