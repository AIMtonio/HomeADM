-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOREALIZADOSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOREALIZADOSALT`;DELIMITER $$

CREATE PROCEDURE `SEGTOREALIZADOSALT`(
    Par_SegtoPrograID   INT(11),
    Par_UsuarioSegto    INT(11),
    Par_FechaSegto      DATE,
    Par_HoraCaptura     CHAR(5),
    Par_TipoContacto    CHAR(1),

    Par_NombreContacto  VARCHAR(200),
    Par_ClienteEnterado CHAR(1),
    Par_FechaCaptura    DATE,
    Par_Comentario      VARCHAR(1000),
    Par_ResultSegtoID   INT(11),

    Par_FechaSegtoFor   DATE,
    Par_RecomSegtoID    INT(11),
    Par_SegdaRecomSegtoID   INT(11),
    Par_HoraSegtoFor    CHAR(5),
    Par_Estatus         CHAR(1),

    Par_TelefonFijo     VARCHAR(20),
    Par_TelefonCel      VARCHAR(20),

    Par_Salida          CHAR(1),
    INOUT   Par_NumErr  INT,
    INOUT   Par_ErrMen  VARCHAR(350),

    Par_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Par_SegtoRealizaID INT(11);
    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Consecutivo     VARCHAR(50);


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT;
    DECLARE Salida_SI           CHAR(1);
    DECLARE Salida_NO           CHAR(1);
    DECLARE EstatusTerminado   CHAR(1);
    DECLARE PrimerRegistro     INT(11);
    DECLARE EstatusIniciado     CHAR(1);



    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Salida_SI       := 'S';
    SET Salida_NO       := 'N';
    SET EstatusTerminado   := 'T';
    SET PrimerRegistro     := 1;
    SET EstatusIniciado     :='I';

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOREALIZADOSALT');
        SET Var_Control = 'sqlException' ;
    END;

    SET Aud_FechaActual := CURRENT_TIMESTAMP();


    SET Par_SegtoRealizaID := (SELECT IFNULL(MAX(SegtoRealizaID),Entero_Cero)+1
                                FROM SEGTOREALIZADOS
                                WHERE SegtoPrograID = Par_SegtoPrograID) ;

    INSERT INTO SEGTOREALIZADOS (
        SegtoPrograID,          SegtoRealizaID,             UsuarioSegto,       FechaSegto,             HoraCaptura,
        TipoContacto,           NombreContacto,             ClienteEnterado,    FechaCaptura,           Comentario,
        TelefonFijo,            TelefonCel,                 ResultadoSegtoID,   FechaSegtoFor,          HoraSegtoFor,
        RecomendacionSegtoID,   SegdaRecomendaSegtoID,      Estatus,            EmpresaID,              Usuario,
        FechaActual,            DireccionIP,                ProgramaID,         Sucursal,               NumTransaccion )
    VALUES (
        Par_SegtoPrograID,  Par_SegtoRealizaID,     Par_UsuarioSegto,       Par_FechaSegto,         Par_HoraCaptura,
        Par_TipoContacto,   Par_NombreContacto,     Par_ClienteEnterado,    Par_FechaCaptura,       Par_Comentario,
        Par_TelefonFijo,        Par_TelefonCel,         Par_ResultSegtoID,      Par_FechaSegtoFor,      Par_HoraSegtoFor,
        Par_RecomSegtoID,   Par_SegdaRecomSegtoID,  Par_Estatus,            Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    IF (Par_SegtoRealizaID = PrimerRegistro)THEN
        UPDATE SEGTOPROGRAMADO SET
            FechaInicioSegto = Par_FechaCaptura
        WHERE SegtoPrograID = Par_SegtoPrograID;
    END IF;
    IF (Par_Estatus = EstatusTerminado )THEN
        UPDATE SEGTOPROGRAMADO SET
            FechaFinalSegto = Par_FechaCaptura
        WHERE SegtoPrograID = Par_SegtoPrograID;
    END IF;
    IF (Par_Estatus = EstatusIniciado )THEN
        UPDATE SEGTOPROGRAMADO SET
            Estatus = Par_Estatus
        WHERE SegtoPrograID = Par_SegtoPrograID;
    END IF;


            SET Par_NumErr  := 000;
            SET Par_ErrMen  := CONCAT("Captura de Seguimiento Realizado con Exito, Numero ", CONVERT(Par_SegtoRealizaID,CHAR));
            SET Var_Control := 'segtoRealizaID';
            SET Var_Consecutivo := Par_SegtoRealizaID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT  Par_NumErr AS NumErr,
                Par_ErrMen AS ErrMen,
                Var_Control AS Control,
                Var_Consecutivo AS Consecutivo;
    ELSE
        SET Par_NumErr:=    0;
        SET Par_ErrMen:=    CONCAT("Captura de Seguimiento Realizado con Exito, Numero ", CONVERT(Par_SegtoRealizaID,CHAR)) ;

    END IF;

END TerminaStore$$