-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SEGUIMIENTOCAMPOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SEGUIMIENTOCAMPOALT`;DELIMITER $$

CREATE PROCEDURE `SEGUIMIENTOCAMPOALT`(
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


    DECLARE VarSeguimientoID    INT(11);
    DECLARE ParValorBase        INT(11);
    DECLARE ParFechaGeneracion  DATE;
    DECLARE Var_Control         VARCHAR(50);
    DECLARE Var_Consecutivo     VARCHAR(50);



    DECLARE Cadena_Vacia        CHAR(1);
    DECLARE Fecha_Vacia         DATE;
    DECLARE Entero_Cero         INT(11);
    DECLARE Salida_SI           CHAR(1);
    DECLARE Salida_NO           CHAR(1);
    DECLARE BaseNumero          CHAR(1);
    DECLARE BasePorcentaje      CHAR(1);


    SET Cadena_Vacia    := '';
    SET Fecha_Vacia     := '1900-01-01';
    SET Entero_Cero     := 0;
    SET Salida_SI       := 'S';
    SET Salida_NO       := 'N';
    SET BaseNumero      := 'N';
    SET BasePorcentaje  := 'P';

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
        SET Par_NumErr = 999;
        SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al
        concretar la operacion. Disculpe las molestias que ', 'esto le ocasiona. Ref: SP-SEGUIMIENTOCAMPOALT');
        SET Var_Control = 'sqlException' ;
    END;

    IF(IFNULL(Par_Descripcion, Cadena_Vacia))= Cadena_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  1;
            SET Par_ErrMen      :=  'La Descripcion esta Vacia';
            SET Var_Control     :=  'descripcion';
            SET Var_Consecutivo := Par_Descripcion;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 1;
            SET Par_ErrMen := 'La Descripcion esta Vacia' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_CategoriaID, Entero_Cero))= Entero_Cero THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  2;
            SET Par_ErrMen      :=  'La Categoria esta Vacia';
            SET Var_Control     :=  'categoriaID';
            SET Var_Consecutivo := Par_CategoriaID;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 2;
            SET Par_ErrMen := 'La Categoria esta Vacia' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_CicloCteInicio, Entero_Cero))= Entero_Cero THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  3;
            SET Par_ErrMen      :=  'El Ciclo Cliente Inicio esta Vacio';
            SET Var_Control     :=  'cicloCteInicio';
            SET Var_Consecutivo := Par_CicloCteInicio;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 3;
            SET Par_ErrMen := 'El Ciclo Cliente Inicio esta Vacio' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_CicloCteFin, Entero_Cero))= Entero_Cero THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  4;
            SET Par_ErrMen      :=  'El Ciclo Cliente Final esta Vacio';
            SET Var_Control     :=  'cicloCteFinal';
            SET Var_Consecutivo := Par_CicloCteFin;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 4;
            SET Par_ErrMen := 'El Ciclo Cliente Final esta Vacio' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_EjecutorID, Cadena_Vacia))= Cadena_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  5;
            SET Par_ErrMen      :=  'El Ejecutor esta Vacio';
            SET Var_Control     :=  'ejecutorID';
            SET Var_Consecutivo := Par_EjecutorID;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 5;
            SET Par_ErrMen := 'El Ejecutor esta Vacio' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;


    IF(IFNULL(Par_NivelAplicacion, Cadena_Vacia))= Cadena_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  6;
            SET Par_ErrMen      :=  'El Nivel de Aplicacion No Esta Seleccionado' ;
            SET Var_Control     :=  'supervisorID';
            SET Var_Consecutivo :=  Par_NivelAplicacion;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 6;
            SET Par_ErrMen := 'El Nivel de Aplicacion No Esta Seleccionado' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_PermiteManual, Cadena_Vacia))= Cadena_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  7;
            SET Par_ErrMen      :=  'Seleccione si el Seguimiento permite generacion manual';
            SET Var_Control     :=  'supervisorID';
            SET Var_Consecutivo := Par_PermiteManual;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 7;
            SET Par_ErrMen := 'Seleccione si el Seguimiento permite generacion manual' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_Alcance, Cadena_Vacia))= Cadena_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  8;
            SET Par_ErrMen      :=  'Seleccione el Alcance';
            SET Var_Control     :=  'alcGlobal';
            SET Var_Consecutivo := Par_Alcance;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 008;
            SET Par_ErrMen := 'Seleccione el Alcance.' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF(IFNULL(Par_Base, Cadena_Vacia))= Cadena_Vacia THEN
        IF (Par_Salida = Salida_SI) THEN
            SET Par_NumErr      :=  9;
            SET Par_ErrMen      :=  'Seleccione la Base de Generacion';
            SET Var_Control     :=  'supervisorID';
            SET Var_Consecutivo := Par_PermiteManual;
            LEAVE ManejoErrores;
        ELSE
            SET Par_NumErr := 9;
            SET Par_ErrMen := 'Seleccione la Base de Generacion.' ;
            LEAVE ManejoErrores;
        END IF;
    END IF;

    IF (Par_Base  = BaseNumero) THEN
        SET ParValorBase := Par_BaseNumero;
    END IF;

    IF (Par_Base = BasePorcentaje) THEN
        SET ParValorBase = Par_BasePorcen;
    END IF;

    SET ParFechaGeneracion := CURRENT_TIMESTAMP();
    CALL FOLIOSAPLICAACT('SEGUIMIENTOCAMPO', VarSeguimientoID);

    INSERT INTO `SEGUIMIENTOCAMPO`(
            `SeguimientoID`,        `DescripcionSegto`,     `CategoriaSegtoID`,     `CicloInicioCte`,           `CicloFinCte`,
            `EjecutorID`,           `NivelAplicaVentas`,    `AplicaCarteraVigente`, `AplicaCarteraAtrasada`,    `AplicaCarteraVencida`,
            `CarteraNoAplica`,      `PermiteManual`,        `BaseGeneracion`,       `ValorBase`,                `Alcance`,
            `RecPropios`,           `FechaGeneracion`,      `Estatus`,
            `EmpresaID`,            `Usuario`,              `FechaActual`,          `DireccionIP`,              `ProgramaID`,
            `Sucursal`,             `NumTransaccion`
        )VALUES(
            VarSeguimientoID,       Par_Descripcion,        Par_CategoriaID,        Par_CicloCteInicio,         Par_CicloCteFin,
            Par_EjecutorID,         Par_NivelAplicacion,    Par_AplicaCarteraVig,   Par_AplicaCarteraAtra,      Par_AplicaCarteraVen,
            Par_NoAplicaCartera,    Par_PermiteManual,      Par_Base,               ParValorBase,               Par_Alcance,
            Par_RecPropios,         ParFechaGeneracion,     Par_Estatus,
            Aud_EmpresaID,          Aud_Usuario,            Aud_FechaActual,        Aud_DireccionIP,            Aud_ProgramaID,
            Aud_Sucursal,           Aud_NumTransaccion
        );

        SET Par_NumErr  := 000;
        SET Par_ErrMen := CONCAT("Seguimiento Agregado Exitosamente: ", CONVERT(VarSeguimientoID, CHAR));
        SET Var_Control     := 'seguimientoID';
        SET Var_Consecutivo := VarSeguimientoID;

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