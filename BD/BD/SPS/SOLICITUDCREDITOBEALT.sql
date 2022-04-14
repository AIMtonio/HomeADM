-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLICITUDCREDITOBEALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLICITUDCREDITOBEALT`;DELIMITER $$

CREATE PROCEDURE `SOLICITUDCREDITOBEALT`(
    Par_SoliCredID          BIGINT(20),
    Par_ClienteID           INT(11),
    Par_ProspectoID         INT(11),
    Par_InstitNominaID      INT(11),
    Par_NegocioAfiliadoID   INT(11),

    Par_FolioCtrl         VARCHAR(20),

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


DECLARE varControl              CHAR(50);


    DECLARE Estatus_Reg         CHAR(1);
    DECLARE Estatus_Activo      CHAR(1);
    DECLARE Entero_Cero         INT;
    DECLARE Decimal_Cero        DECIMAL(14,2);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Salida_SI           CHAR(1);

    SET Estatus_Reg         :='R';
    SET Estatus_Activo      :='A';
    SET Entero_Cero         :=0;
    SET Decimal_Cero        :=0.0;
    SET Cadena_Vacia        :='';
    SET Fecha_Vacia         :='1900-01-01';
    SET Salida_SI           :='S';


    SET Par_NumErr          := 0;
    SET Par_ErrMen          := '';

ManejoErrores:BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr := '999';
                SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                     'esto le ocasiona. Ref: SP-SOLICITUDCREDITOBEALT');
                SET varControl := 'sqlException' ;
            END;

SET Par_ClienteID   := IFNULL(Par_ClienteID,Entero_Cero);
SET Par_ProspectoID := IFNULL(Par_ProspectoID,Entero_Cero);
SET Par_FolioCtrl   := IFNULL(Par_FolioCtrl, Cadena_Vacia);



INSERT INTO SOLICITUDCREDITOBE(
                SolicitudCreditoID, ClienteID,   ProspectoID,       InstitNominaID,     NegocioAfiliadoID,
            FolioCtrl,          EmpresaID,      Usuario,          FechaActual,    DireccionIP,
            ProgramaID,     Sucursal,           NumTransaccion)
       VALUES(
            Par_SoliCredID,     Par_ClienteID,    Par_ProspectoID,  Par_InstitNominaID, Par_NegocioAfiliadoID,
            Par_FolioCtrl,     Par_EmpresaID,     Aud_Usuario,          Aud_FechaActual, Aud_DireccionIP,
            Aud_ProgramaID,   Aud_Sucursal,      Aud_NumTransaccion);

    SET Par_NumErr  := 000;
    SET Par_ErrMen  :=  CONCAT("La Solicitud de Credito: ", CONVERT(Par_SoliCredID, CHAR)," Fue Agregada.");
    SET varControl  := 'SolicitudCreditoID' ;
    LEAVE ManejoErrores;


END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  CONVERT(Par_NumErr, CHAR(3)) AS NumErr,
                Par_ErrMen           AS ErrMen,
                varControl           AS control,
                Par_SoliCredID       AS consecutivo;
    END IF;
END TerminaStore$$