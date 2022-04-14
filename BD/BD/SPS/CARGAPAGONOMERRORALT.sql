-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CARGAPAGONOMERRORALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `CARGAPAGONOMERRORALT`;DELIMITER $$

CREATE PROCEDURE `CARGAPAGONOMERRORALT`(
    Par_FolioCargaID        INT(11),
    Par_EmpresaNominaID     INT(11),
    Par_DescripcionError    VARCHAR(200),
    Par_CreditoID           BIGINT(12),

    Par_Salida              CHAR(1),
    INOUT Par_NumErr        INT(11),
    INOUT Par_ErrMen        VARCHAR(400),

    Par_EmpresaID           INT(11),
    Aud_Usuario             INT(11),
    Aud_FechaActual         DATETIME,
    Aud_DireccionIP         VARCHAR(15),
    Aud_ProgramaID          VARCHAR(50),
    Aud_Sucursal            INT(11),
    Aud_NumTransaccion      BIGINT(20)
    )
TerminaStore: BEGIN


    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_FolioErrorID    INT(11);


    DECLARE SalidaNO        CHAR(1);
    DECLARE SalidaSI        CHAR(1);
    DECLARE Entero_Cero     INT;


    SET SalidaSI        := 'S';
    SET SalidaNO        := 'N';
    SET Entero_Cero     :=  0;



    SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-CARGAPAGONOMERRORALT');
                SET Var_Control = 'sqlException' ;
            END;


    CALL FOLIOSAPLICAACT('CARGAPAGONOMERROR', Var_FolioErrorID);


    INSERT INTO CARGAPAGONOMERROR (
        FolioErrorID,       FolioCargaID,   CreditoID,      EmpresaNominaID,        DescripcionError,
        EmpresaID,        Usuario,        FechaActual,  DireccionIP,              ProgramaID,
        Sucursal,         NumTransaccion)
        VALUES(
        Var_FolioErrorID,   Par_FolioCargaID,    Par_CreditoID,   Par_EmpresaNominaID,  Par_DescripcionError,
        Par_EmpresaID,       Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,       Aud_ProgramaID,
        Aud_Sucursal,      Aud_NumTransaccion);

      SET Par_NumErr  := 000;
      SET Par_ErrMen  := 'Folio Agregado';
      SET Var_Control := 'institNominaID';
      SET Entero_Cero :=  Var_FolioErrorID;

END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;

END IF;

END TerminaStore$$