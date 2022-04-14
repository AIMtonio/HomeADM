-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUIMIENTOCAMPOMOD
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOCAMPOMOD`;DELIMITER $$

CREATE PROCEDURE `SEGUIMIENTOCAMPOMOD`(
    Par_SeguimientoID       INT(11),
    Par_Descripcion         VARCHAR(150),
    Par_CategoriaID         INT(11),
    Par_CicloCteInicio      INT(11),
    Par_CicloCteFin         INT(11),

    Par_Estatus             CHAR(1),
    Par_EjecutorID          INT(11),
    Par_NivelAplicacion     CHAR(1),
    Par_AplicaCarteraVig    CHAR(1),
    Par_AplicaCarteraAtra   CHAR(1),

    Par_AplicaCarteraVen    CHAR(2),
    Par_NoAplicaCartera     CHAR(1),
    Par_PermiteManual       CHAR(1),
    Par_Base                CHAR(1),
    Par_BasePorcen          INT(11),

    Par_BaseNumero          INT(11),
    Par_Alcance             CHAR(1),
    Par_RecPropios          CHAR(1),

    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT(11),
    INOUT   Par_ErrMen      VARCHAR(350),

    Aud_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Var_Consecutivo     VARCHAR(50);
    DECLARE Var_Control         VARCHAR(50);
    DECLARE ParValorBase        INT;
    DECLARE ParFechaGeneracion  DATE;


    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT(11);
    DECLARE Salida_SI           CHAR(1);
    DECLARE Salida_NO           CHAR(1);
    DECLARE BaseNumero          CHAR(1);
    DECLARE BasePorcentaje      CHAR(1);


    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Salida_SI           := 'S';
    SET Salida_NO           := 'N';
    SET BaseNumero          := 'N';
    SET BasePorcentaje      := 'P';

    ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGUIMIENTOCAMPOMOD');
        SET Var_Control = 'sqlException' ;
    END;

    IF(IFNULL(Par_Descripcion, Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := 1;
        SET Par_ErrMen  := 'La Descripcion esta Vacia';
        SET Var_Control := 'descripcion';
        SET Var_Consecutivo:= Par_Descripcion;
    END IF;

    IF(IFNULL(Par_CategoriaID, Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := 2;
        SET Par_ErrMen  := 'La Categoria esta Vacia';
        SET Var_Control := 'categoriaID';
        SET Var_Consecutivo:= Par_CategoriaID;
    END IF;

    IF(IFNULL(Par_CicloCteInicio, Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := 3;
        SET Par_ErrMen  := 'El Ciclo Cliente Inicio esta Vacio';
        SET Var_Control := 'cicloCteInicio';
        SET Var_Consecutivo:= Par_CicloCteInicio;
    END IF;

    IF(IFNULL(Par_CicloCteFin, Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr  := 4;
        SET Par_ErrMen  := 'El Ciclo Cliente Final esta Vacio';
        SET Var_Control := 'cicloCteFinal';
        SET Var_Consecutivo:= Par_CicloCteFin;
    END IF;

    IF(IFNULL(Par_EjecutorID, Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := 5;
        SET Par_ErrMen  := 'El Tipo Gestion esta Vacio';
        SET Var_Control := 'ejecutorID';
        SET Var_Consecutivo:= Par_EjecutorID;
    END IF;

    IF(IFNULL(Par_NivelAplicacion, Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := 6;
        SET Par_ErrMen  := 'El Nivel de Aplicacion No Esta Seleccionado';
        SET Var_Control := 'nivelAplicacion';
        SET Var_Consecutivo:= Par_NivelAplicacion;
    END IF;

    IF(IFNULL(Par_PermiteManual, Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := 7;
        SET Par_ErrMen  := 'Seleccione si el Seguimiento permite generacion manual';
        SET Var_Control := 'permiteManual';
        SET Var_Consecutivo:= Par_PermiteManual;
    END IF;

    IF(IFNULL(Par_Alcance, Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := 8;
        SET Par_ErrMen  := 'Seleccione el Alcance';
        SET Var_Control := 'alcGlobal';
        SET Var_Consecutivo:= Par_Alcance;
    END IF;

    IF(IFNULL(Par_Base, Cadena_Vacia))= Cadena_Vacia THEN
        SET Par_NumErr  := 9;
        SET Par_ErrMen  := 'Seleccione la Base de Generacion';
        SET Var_Control := 'base';
        SET Var_Consecutivo:= Par_Base;
    END IF;

    IF (Par_Base  = BaseNumero) THEN
        SET ParValorBase := Par_BaseNumero;
    END IF;

    IF (Par_Base = BasePorcentaje) THEN
        SET ParValorBase = Par_BasePorcen;
    END IF;

    SET ParFechaGeneracion := CURRENT_TIMESTAMP();

    UPDATE `SEGUIMIENTOCAMPO`   SET
         `DescripcionSegto`     = Par_Descripcion,
         `CategoriaSegtoID`     = Par_CategoriaID,
         `CicloInicioCte`       = Par_CicloCteInicio,
         `CicloFinCte`          = Par_CicloCteFin,
         `EjecutorID`           = Par_EjecutorID,
         `NivelAplicaVentas`    = Par_NivelAplicacion,
         `AplicaCarteraVigente` = Par_AplicaCarteraVig,
         `AplicaCarteraAtrasada`= Par_AplicaCarteraAtra,
         `AplicaCarteraVencida` = Par_AplicaCarteraVen,
         `CarteraNoAplica`      = Par_NoAplicaCartera,
         `PermiteManual`        = Par_PermiteManual,
         `BaseGeneracion`       = Par_Base,
         `ValorBase`            = ParValorBase,
         `Alcance`              = Par_Alcance,
         `RecPropios`           = Par_RecPropios,
         `FechaGeneracion`      = ParFechaGeneracion,
         `Estatus`              = Par_Estatus
    WHERE SeguimientoID = Par_SeguimientoID;

        SET Par_NumErr  := 000;
        SET Par_ErrMen  := CONCAT("Seguimiento Modificado Exitosamente: ", CONVERT(Par_SeguimientoID, CHAR));
        SET Var_Control := 'seguimientoID';
        SET Var_Consecutivo:= Par_CategoriaID;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

    IF(Par_Salida = Salida_NO) THEN
        SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
        SET Par_ErrMen := Par_ErrMen;
    END IF;

END TerminaStore$$