-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SPEITRANSFERENCIASALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `SPEITRANSFERENCIASALT`;DELIMITER $$

CREATE PROCEDURE `SPEITRANSFERENCIASALT`(
    Par_CorresponsalID    INT,
    Par_NombreCli         VARCHAR(150),
    Par_ClabeCli          VARCHAR(18),
    Par_Monto             DECIMAL(16,2),
    Par_Referencia        VARCHAR(40),

    Par_Salida             CHAR(1),
    INOUT Par_NumErr       INT,
    INOUT Par_ErrMen       VARCHAR(350),

    Par_EmpresaID          INT(11),
    Aud_Usuario            INT(11),
    Aud_FechaActual        DATETIME,
    Aud_DireccionIP        VARCHAR(20),
    Aud_ProgramaID         VARCHAR(50),
    Aud_Sucursal           INT(11),
    Aud_NumTransaccion     BIGINT(20)
        )
TerminaStore: BEGIN


DECLARE Cadena_Vacia      CHAR(1);
DECLARE Entero_Cero       INT;
DECLARE Decimal_Cero      DECIMAL(18,2);
DECLARE Fecha_Vacia       DATE;
DECLARE Salida_SI         CHAR(1);
DECLARE Salida_NO         CHAR(1);
DECLARE Estatus_Reg       CHAR(1);
DECLARE Estatus_Activa    CHAR(1);
DECLARE NumUno            INT;
DECLARE IncorporateEx     VARCHAR(60);
DECLARE NoDispon          VARCHAR(60);


DECLARE Var_Control       VARCHAR(200);
DECLARE Var_Consecutivo   BIGINT(20);
DECLARE Var_SpeiTransID   BIGINT(20);
DECLARE Var_Estatus       CHAR(1);
DECLARE Var_FechaAlta     DATETIME;
DECLARE Var_CausaDevol    INT(2);
DECLARE Var_FechaAuto     DATETIME;
DECLARE Var_UsuarioAuto   INT(11);
DECLARE Var_FechaProc     DATE;
DECLARE Var_Transaccion   BIGINT(20);
DECLARE Var_EstatusCta    CHAR(1);
DECLARE Var_EstatusCli    CHAR(1);
DECLARE Var_CuentaAho     BIGINT(12);
DECLARE Var_Corresponsal  VARCHAR(60);


SET Cadena_Vacia    := '';
SET Fecha_Vacia     := '1900-01-01 00:00:00';
SET Entero_Cero     := 0;
SET Decimal_Cero    := 0.0;
SET Salida_SI       := 'S';
SET Salida_NO       := 'N';
SET Par_NumErr      := 0;
SET Par_ErrMen      := '';
SET Estatus_Reg     := 'P';
SET Estatus_Activa  := 'A';
SET NumUno          := 1;
SET IncorporateEx   := 'Incorporated Express';
SET NoDispon        := 'No Disponible';

ManejoErrores:BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
                BEGIN
                    SET Par_NumErr = '999';
                    SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
                        'esto le ocasiona. Ref: SP-SPEITRANSFERENCIASALT');
                    SET Var_Control = 'sqlException' ;
                END;

IF (IFNULL(Par_ClabeCli,Cadena_Vacia))=Cadena_Vacia THEN
    SET Par_NumErr := 001;
    SET Par_ErrMen :='La clabe no puede ser vacia.';
    SET Var_Control :=  'clabeCli' ;
    LEAVE ManejoErrores;
END IF;

IF (IFNULL(Par_Monto,Entero_Cero))=Entero_Cero THEN
    SET Par_NumErr := 002;
    SET Par_ErrMen :='El monto no puede ser vacio.';
    SET Var_Control :=  'monto' ;
    LEAVE ManejoErrores;
END IF;


IF (Par_Monto < Entero_Cero) THEN
    SET Par_NumErr := 003;
    SET Par_ErrMen :='El Monto no puede ser negativo.';
    SET Var_Control :=  'monto' ;
    LEAVE ManejoErrores;
END IF;



IF EXISTS(SELECT CuentaAhoID
    FROM CUENTASAHO
    WHERE Clabe = Par_ClabeCli) THEN
    SELECT CA.CuentaAhoID,CA.Estatus,CTE.Estatus
    INTO Var_CuentaAho,Var_EstatusCta,Var_EstatusCli
    FROM CUENTASAHO CA INNER JOIN CLIENTES CTE ON CA.ClienteID = CTE.ClienteID
    WHERE Clabe = Par_ClabeCli;
ELSE
    SET Par_NumErr := 004;
    SET Par_ErrMen :=CONCAT('Cuenta inexistente: ',Par_ClabeCli );
    SET Var_Control:= 'clabeCli';
    LEAVE ManejoErrores;
END IF;


IF(Var_EstatusCta != Estatus_Activa)THEN
    SET Par_NumErr := 005;
    SET Par_ErrMen := 'La cuenta no esta activa.';
    SET Var_Control:= 'estatusCta';
    LEAVE ManejoErrores;
END IF;

IF(Var_EstatusCli != Estatus_Activa)THEN
    SET Par_NumErr := 006;
    SET Par_ErrMen := 'El cliente no esta activo.';
    SET Var_Control:= 'estatusCli';
    LEAVE ManejoErrores;
END IF;


IF(Par_CorresponsalID = NumUno)THEN

    SET Var_Corresponsal := IncorporateEx;
ELSE
    SET Var_Corresponsal := NoDispon;
END IF;



SET Var_SpeiTransID := (SELECT IFNULL(MAX(SpeiTransID),Entero_Cero) + 1
FROM SPEITRANSFERENCIAS);



SET Var_Estatus := Estatus_Reg;
SET Var_FechaAlta := CURRENT_TIMESTAMP();
SET Var_CausaDevol := Entero_Cero;
SET Var_FechaAuto := Fecha_Vacia;
SET Var_UsuarioAuto := Entero_Cero;
SET Var_FechaProc := Fecha_Vacia;
SET Var_Transaccion := Entero_Cero;


SET Aud_FechaActual := CURRENT_TIMESTAMP();

INSERT INTO SPEITRANSFERENCIAS (
    SpeiTransID,            Corresponsal,           NombreCli,          ClabeCli,           Monto,
    Estatus,                Referencia,             FechaAlta,          CausaDevol,         FechaAutoriza,
    UsuarioAutoriza,        FechaProceso,           Transaccion,        EmpresaID,          Usuario,
    FechaActual,            DireccionIP,            ProgramaID,         Sucursal,           NumTransaccion)

VALUES(
    Var_SpeiTransID,        Var_Corresponsal,       Par_NombreCli,      Par_ClabeCli,       Par_Monto,
    Var_Estatus,            Par_Referencia,         Var_FechaAlta,      Var_CausaDevol,     Var_FechaAuto,
    Var_UsuarioAuto,        Var_FechaProc,          Var_Transaccion,    Par_EmpresaID,      Aud_Usuario,
    Aud_FechaActual,        Aud_DireccionIP,        Aud_ProgramaID,     Aud_Sucursal,       Aud_NumTransaccion);

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := CONCAT('Transferencia SPEI Agregada Exitosamente: ', CONVERT(Var_SpeiTransID, CHAR));
    SET Var_Control := 'speiTransID' ;
    SET Var_Consecutivo := Var_SpeiTransID;


END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
    SELECT  Par_NumErr AS NumErr,
    Par_ErrMen AS ErrMen,
    Var_Control AS control,
    Var_Consecutivo AS consecutivo;
END IF;

END TerminaStore$$