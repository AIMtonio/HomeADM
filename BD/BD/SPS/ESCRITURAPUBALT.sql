-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ESCRITURAPUBALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ESCRITURAPUBALT`;DELIMITER $$

CREATE PROCEDURE `ESCRITURAPUBALT`(
    Par_ClienteID   INT(11),
    Par_Esc_Tipo    CHAR(1),
    Par_EscriPub    VARCHAR(50),
    Par_LibroEscr   VARCHAR(50),
    Par_VolumenEsc  VARCHAR(10),

    Par_FechaEsc    DATE,
    Par_EstadoIDEsc INT(11),
    Par_LocalEsc    INT(11),
    Par_Notaria     INT(11),
    Par_DirecNotar  VARCHAR(150),

    Par_NomNotario  VARCHAR(100),
    Par_NomApoder   VARCHAR(150),
    Par_RFC_Apoder  VARCHAR(13),
    Par_RegistroPub VARCHAR(10),
    Par_FolioRegPub VARCHAR(10),

    Par_VolRegPub   VARCHAR(10),
    Par_LibroRegPub VARCHAR(10),
    Par_AuxiRegPub  VARCHAR(20),
    Par_FechaRegPub DATE,
    Par_EstadoIDReg INT(11),

    Par_LocalRegPub INT(11),
    Par_Observacion VARCHAR(250),
    Par_Salida              CHAR(1),
    INOUT   Par_NumErr      INT,
    INOUT   Par_ErrMen      VARCHAR(350),

    Par_EmpresaID   INT(11),
    Aud_Usuario     INT(11),
    Aud_FechaActual DATETIME,
    Aud_DireccionIP VARCHAR(15),
    Aud_ProgramaID  VARCHAR(50),

    Aud_Sucursal    INT(11),
    Aud_NumTransaccion  BIGINT
    )
TerminaStore:BEGIN



DECLARE Var_Consecutivo     INT(11);
DECLARE VarControl          VARCHAR(200);


DECLARE Estatus_Vigente     CHAR(1);
DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT(11);
DECLARE Salida_SI           CHAR(1);
DECLARE EscTipo_Poderes     CHAR(1);



SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Var_Consecutivo         := 0;
SET Estatus_Vigente     := 'V';
SET Entero_Cero         := 0;
SET EscTipo_Poderes     :='P';
SET Salida_SI           :='S';


ManejoErrores: BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
        BEGIN
            SET Par_NumErr = 999;
            SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                            'esto le ocasiona. Ref: SP-ESCRITURAPUBALT');
            SET VarControl = 'sqlException';
        END;

    IF(IFNULL(Par_Esc_Tipo,Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 001;
        SET Par_ErrMen := 'El Tipo  de Acta esta Vacio';
        SET VarControl := 'esc_Tipo';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_EscriPub, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 002;
        SET Par_ErrMen := 'El no. de Escritura Publica esta Vacio';
        SET VarControl := 'escrituraPub';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaEsc, Fecha_Vacia)) = Fecha_Vacia THEN
            SET Par_NumErr := 003;
            SET Par_ErrMen := 'La primer Entre calle esta Vacia';
            SET VarControl := 'fechaEsc';
            LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_EstadoIDEsc, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr := 004;
            SET Par_ErrMen := 'El estado esta Vacio';
            SET VarControl := 'estadoIDEsc';
            LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_LocalEsc, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr := 005;
            SET Par_ErrMen := 'La localidad esta Vacia';
            SET VarControl := 'localidadEsc';
            LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_Notaria, Entero_Cero)) = Entero_Cero THEN
            SET Par_NumErr := 006;
            SET Par_ErrMen := 'La notaria esta Vacia';
            SET VarControl := 'notaria';
            LEAVE ManejoErrores;
    END IF;

    IF(Par_Esc_Tipo=EscTipo_Poderes)THEN
    IF(IFNULL(Par_NomApoder, Cadena_Vacia)) = Cadena_Vacia THEN
            SET Par_NumErr := 007;
            SET Par_ErrMen := 'El nombre del Apoderado esta Vacio';
            SET VarControl := 'nomApoderado';
            LEAVE ManejoErrores;
    END IF; END IF;

    IF(Par_Esc_Tipo=EscTipo_Poderes)THEN
    IF(IFNULL(Par_RFC_Apoder, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 008;
        SET Par_ErrMen := 'El RFC del Apoderado esta Vacio';
        SET VarControl := 'RFC_Apoderado';
        LEAVE ManejoErrores;
    END IF; END IF;

    IF(IFNULL(Par_RegistroPub, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 009;
        SET Par_ErrMen := 'El Registro esta Vacio';
        SET VarControl := 'registroPub';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FolioRegPub, Cadena_Vacia)) = Cadena_Vacia THEN
        SET Par_NumErr := 010;
        SET Par_ErrMen := 'El Folio esta Vacio';
        SET VarControl := 'folioRegPub';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_FechaRegPub, Fecha_Vacia)) = Fecha_Vacia THEN
        SET Par_NumErr := 011;
        SET Par_ErrMen := 'La Fecha esta Vacia';
        SET VarControl := 'fechaRegPub';
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_EstadoIDReg, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr := 012;
        SET Par_ErrMen := 'La Entidad Federativa de Registro Pub esta Vacio';
        SET VarControl := 'estadoIDReg' ;
        LEAVE ManejoErrores;
    END IF;

    IF(IFNULL(Par_LocalRegPub, Entero_Cero)) = Entero_Cero THEN
        SET Par_NumErr := 013;
        SET Par_ErrMen := 'La localidad  de Registro Pub esta Vacia';
        SET VarControl := 'localidadRegPub';
        LEAVE ManejoErrores;
    END IF;

    SET Var_Consecutivo  := (SELECT IFNULL(Max(Consecutivo),Entero_Cero)+1
    FROM ESCRITURAPUB
    WHERE ClienteID=Par_ClienteID );
    SET Aud_FechaActual := CURRENT_TIMESTAMP();

INSERT INTO ESCRITURAPUB VALUES ( Par_ClienteID,    Var_Consecutivo ,   Par_EmpresaID,
                                  Par_Esc_Tipo,     Par_NomApoder,      Par_RFC_Apoder,
                                  Par_EscriPub,     Par_LibroEscr,      Par_VolumenEsc,
                                  Par_EstadoIDEsc,  Par_FechaEsc,       Par_LocalEsc,
                                  Par_Notaria,      Par_DirecNotar,     Par_NomNotario,
                                  Par_RegistroPub,  Par_FolioRegPub,    Par_VolRegPub,
                                  Par_LibroRegPub,  Par_AuxiRegPub,     Par_FechaRegPub,
                                  Par_EstadoIDReg,  Par_LocalRegPub,    Estatus_Vigente,
                                  Par_Observacion,  Aud_Usuario,        Aud_FechaActual,
                                  Aud_DireccionIP,  Aud_ProgramaID,     Aud_Sucursal,
                                  Aud_NumTransaccion);

    SET Par_NumErr      := '000';
    SET Par_ErrMen      := CONCAT('Escritura Publica Agregada Exitosamente: ',CAST(Var_Consecutivo AS CHAR) );
    SET VarControl      := 'consecutivoEsc';
    SET Var_Consecutivo := Var_Consecutivo;

    END ManejoErrores;

    IF (Par_Salida = Salida_SI) THEN
        SELECT
            Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            VarControl AS control,
            Var_Consecutivo AS consecutivo;
    END IF;

END TerminaStore$$