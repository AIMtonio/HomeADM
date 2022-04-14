-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICIDOCENTBAJ
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICIDOCENTBAJ`;DELIMITER $$

CREATE PROCEDURE `SOLICIDOCENTBAJ`(
    Par_Solicitud       BIGINT(20),
    Par_Salida          CHAR(1),
    INOUT Par_NumErr    INT(11),
    INOUT Par_ErrMen    VARCHAR(400),

    Par_EmpresaID       INT(11),

    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Cadena_Vacia    CHAR(1);
DECLARE Fecha_Vacia     DATE;
DECLARE Entero_Cero     INT(11);
DECLARE Str_SI          CHAR(1);
DECLARE Str_NO          CHAR(1);
DECLARE SolStaInactiva  CHAR(1);
DECLARE Var_Control     VARCHAR(100);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01';
SET Entero_Cero     := 0;
SET Str_SI          := 'S';
SET Str_NO          := 'N';
SET SolStaInactiva  := 'I';

ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr := 999;
                SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                     'esto le ocasiona. Ref: SP-SOLICIDOCENTBAJ');
                SET Var_Control := 'sqlException' ;
            END;

    IF(IFNULL(Par_Solicitud, Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr:= 001;
        SET Par_ErrMen:= 'El numero de solicitud no es valido.';
        SET Var_Control:='solicitudCreditoID' ;
        LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS( SELECT SolicitudCreditoID
                   FROM SOLICITUDCREDITO
                   WHERE SolicitudCreditoID = Par_Solicitud
                     AND Estatus = SolStaInactiva) THEN
        SET Par_NumErr:= 002;
        SET Par_ErrMen:= CONCAT("La Solicitud de Credito no tiene estatus de Inactiva o no existe: ", CONVERT(Par_Solicitud, CHAR)) ;
        SET Var_Control:='solicitudCreditoID' ;
        LEAVE ManejoErrores;
    END IF;

    DELETE FROM SOLICIDOCENT WHERE SolicitudCreditoID = Par_Solicitud;

    SET Par_NumErr := 0;
    SET Par_ErrMen := CONCAT("La Solicitud de Credito: ", CONVERT(Par_Solicitud, CHAR)," fue eliminada del checklist");
    SET Var_Control:='solicitudCreditoID' ;

END ManejoErrores;

IF(Par_Salida = Str_SI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Par_Solicitud AS consecutivo;
END IF;

END TerminaStore$$