-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- USUARIOSERARCHIVOALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `USUARIOSERARCHIVOALT`;
DELIMITER $$

CREATE PROCEDURE `USUARIOSERARCHIVOALT`(

    Par_UsuarioID           INT,
    Par_TipoDocumen         INT,
    Par_Observacion         VARCHAR(200),
    Par_Recurso             VARCHAR(500),
    Par_Extension           VARCHAR(50),

    Par_Salida              CHAR(1),
    inout   Par_NumErr      INT,
    inout   Par_ErrMen      VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
)
TerminaStore: BEGIN


DECLARE Var_UsuarioSerID    INT(11);
DECLARE NumUsuarioArc       INT;
DECLARE noConsecutivo       INT;
DECLARE varTipoDocID        INT;
DECLARE varRecurso          VARCHAR(500);
DECLARE varDesTipDoc        VARCHAR(45);
DECLARE Var_Fechasistema    DATE;
DECLARE Var_Control         VARCHAR(20);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE Entero_Cero         INT;
DECLARE Salida_SI           CHAR(1);
DECLARE Salida_NO           CHAR(1);


SET Cadena_Vacia        := '';
Set Fecha_Vacia         := '1900-01-01';
Set Entero_Cero         := 0;
SET Salida_SI           := 'S';
SET Salida_NO           := 'N';


Set noConsecutivo       := 0;

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        set Par_NumErr = 999;
        set Par_ErrMen = concat("Estimado Usuario(a), Ha ocurrido una falla en el sistema, " ,
                                 "estamos trabajando para resolverla. Disculpe las molestias que ",
                                 "esto le ocasiona. Ref: SP-USUARIOSERARCHIVOALT");
    END;

SELECT UsuarioServicioID INTO Var_UsuarioSerID
    FROM USUARIOSERVICIO
        WHERE UsuarioServicioID = Par_UsuarioID;

SET Var_UsuarioSerID:= IFNULL(Var_UsuarioSerID, Entero_Cero);

IF(Var_UsuarioSerID = Entero_Cero) THEN
    SET Par_NumErr := 001;
    SET Par_ErrMen := 'El Numero de Usuario No Existe.';
    SET Var_Control := 'usuarioID';
    LEAVE ManejoErrores;
END IF;


SELECT Tic.TipoDocumentoID
    INTO varTipoDocID
        FROM TIPOSDOCUMENTOS Tic
            WHERE Tic.TipoDocumentoID = Par_TipoDocumen;



IF(IFNULL(varTipoDocID, Entero_Cero))= Entero_Cero THEN
        SET Par_NumErr := 002;
        SET Par_ErrMen := 'El Tipo de documento no Existe.';
        SET Var_Control := 'usuarioID';
        LEAVE ManejoErrores;
END IF;

    SET noConsecutivo := (SELECT Max(Consecutivo)
                                FROM USUARIOSERARCHIVO
                                    WHERE UsuarioServicioID = Par_UsuarioID
                                    AND TipoDocumento = Par_TipoDocumen);

    SET noConsecutivo := IFNULL(noConsecutivo,Entero_Cero)+1;


SET varDesTipDoc :=  (SELECT Descripcion
                            FROM TIPOSDOCUMENTOS
                            WHERE TipoDocumentoID = Par_TipoDocumen);



SET NumUsuarioArc := (SELECT IFNULL(MAX(UsuarioSerArchiID),Entero_Cero) + 1 FROM USUARIOSERARCHIVO);


SET Aud_FechaActual := CURRENT_TIMESTAMP();

SELECT FechaSistema
    INTO Var_Fechasistema
        FROM PARAMETROSSIS;

SET Var_Fechasistema:= IFNULL(Var_Fechasistema,Fecha_Vacia);


SET Par_Extension := IFNULL(Par_Extension,Cadena_Vacia);
SET varRecurso := CONCAT(Par_Recurso,varDesTipDoc,"/Archivo", RIGHT(CONCAT("00000",CONVERT(noConsecutivo, char)), 5),Par_Extension);

INSERT INTO USUARIOSERARCHIVO(
            UsuarioSerArchiID,  UsuarioServicioID,  TipoDocumento,  Consecutivo,    Observacion,
            Recurso,            FechaRegistro,      EmpresaID,      Usuario,        FechaActual,
            DireccionIP,        ProgramaID,         Sucursal,       NumTransaccion)
VALUES (
        NumUsuarioArc,      Par_UsuarioID,      Par_TipoDocumen,    noConsecutivo,      Par_Observacion,
        varRecurso,         Var_Fechasistema,   Par_EmpresaID,      Aud_Usuario,        Aud_FechaActual,
        Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

SET Par_NumErr  := 000;
SET Par_ErrMen  := CONCAT("El archivo se ha Digitalizado Exitosamente; ", convert(NumUsuarioArc, CHAR));
SET Var_Control := 'usuarioID';
SET noConsecutivo := noConsecutivo;
SET varRecurso := varRecurso;

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  CONVERT(Par_NumErr, CHAR(10)) AS NumErr,
        Par_ErrMen AS ErrMen,
        Var_Control AS control,
        CONVERT(noConsecutivo, CHAR) AS consecutivo,
        varRecurso AS recurso;
END IF;

IF(Par_Salida = Salida_NO) THEN
    SET Par_NumErr := CONVERT(Par_NumErr, CHAR(10));
    SET Par_ErrMen := Par_ErrMen;
    SET Par_UsuarioID := Par_UsuarioID;
END IF;

END TerminaStore$$