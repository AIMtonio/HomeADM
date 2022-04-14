-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGTOREALIZADOSMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGTOREALIZADOSMOD`;DELIMITER $$

CREATE PROCEDURE `SEGTOREALIZADOSMOD`(
    Par_SegtoPrograID   INT(11),
    Par_SegtoRealizaID  INT(11),
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
    Par_HoraSegtoFor   CHAR(5),

    Par_Estatus         CHAR(1),
    Par_TelefonFijo     VARCHAR(20),
    Par_TelefonCel      VARCHAR(20),

    Par_Salida          CHAR(1),
    INOUT   Par_NumErr  INT(11),
    INOUT   Par_ErrMen  VARCHAR(350),

    Aud_EmpresaID       INT,
    Aud_Usuario         INT,
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT,
    Aud_NumTransaccion  BIGINT
    )
TerminaStore: BEGIN


    DECLARE Var_Control         VARCHAR(50);
    DECLARE Var_Consecutivo     VARCHAR(50);
    DECLARE ParValorBase     INT;
    DECLARE ParFechaGeneracion  DATE;
    DECLARE VarSeguimientoID INT;


    DECLARE Estatus_Activo  CHAR(1);
    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia     DATE;
    DECLARE Entero_Cero     INT;
    DECLARE Salida_SI       CHAR(1);
    DECLARE Salida_NO       CHAR(1);
    DECLARE BaseNumero       CHAR(1);
    DECLARE BasePorcentaje   CHAR(1);


    SET Cadena_Vacia        := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Salida_SI       := 'S';
    SET Salida_NO       := 'N';
    SET   BaseNumero    := 'N';
    SET   BasePorcentaje := 'P';

    ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGTOREALIZADOSMOD');
        SET Var_Control = 'sqlException' ;
    END;

    UPDATE `SEGTOREALIZADOS` SET
        `UsuarioSegto`          = Par_UsuarioSegto,
        `FechaSegto`            = Par_FechaSegto,
        `HoraCaptura`           = Par_HoraCaptura,
        `TipoContacto`          = Par_TipoContacto,
        `NombreContacto`        = Par_NombreContacto,
        `ClienteEnterado`       = Par_ClienteEnterado,
        `FechaCaptura`          = Par_FechaCaptura,
        `Comentario`            = Par_Comentario,
        `ResultadoSegtoID`      = Par_ResultSegtoID,
        `FechaSegtoFor`         = Par_FechaSegtoFor,
        `HoraSegtoFor`          = Par_HoraSegtoFor,
        `RecomendacionSegtoID`  = Par_RecomSegtoID,
        `SegdaRecomendaSegtoID` = Par_SegdaRecomSegtoID,
        `Estatus`               = Par_Estatus,
        `TelefonFijo`           = Par_TelefonFijo,
        `TelefonCel`            = Par_TelefonCel
        WHERE SegtoPrograID = Par_SegtoPrograID AND SegtoRealizaID =  Par_SegtoRealizaID;

    SET Par_NumErr := 0;
    SET Par_ErrMen := CONCAT("Seguimiento Modificado Exitosamente: ", CONVERT(Par_SegtoRealizaID, CHAR));
    SET Var_Control     := 'segtoRealizaID';
    SET Var_Consecutivo := Par_SegtoRealizaID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$