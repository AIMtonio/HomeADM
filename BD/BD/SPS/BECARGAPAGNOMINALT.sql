-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BECARGAPAGNOMINALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BECARGAPAGNOMINALT`;DELIMITER $$

CREATE PROCEDURE `BECARGAPAGNOMINALT`(
    Par_FolioCargaIDBE          INT(11),
    Par_EmpresaNominaID         INT(11),
    Par_ClaveUsuario            VARCHAR(20),
    Par_NumTotalPagos           INT(11),
    Par_NumPagosExito           INT(11),
    Par_NumPagosError           INT(11),
    Par_MontoPagos              DECIMAL(12,2),
    Par_RutaArchivoPagoNom      VARCHAR(250),

    Par_Salida                  CHAR(1),
    INOUT Par_NumErr            INT(11),
    INOUT Par_ErrMen            VARCHAR(400),

    Par_EmpresaID               INT(11),
    Aud_Usuario                 INT(11),
    Aud_FechaActual             DATETIME,
    Aud_DireccionIP             VARCHAR(15),
    Aud_ProgramaID              VARCHAR(50),
    Aud_Sucursal                INT(11),
    Aud_NumTransaccion          BIGINT(20)
        )
TerminaStore:BEGIN


DECLARE Var_Control         VARCHAR(100);
DECLARE Var_FolioCarga      INT(11);




DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE FechaSist           DATE;
DECLARE Entero_Cero         INT(11);
DECLARE Est_SinProcesar     CHAR(1);
DECLARE SalidaSI            CHAR(1);


SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         := 0;
SET Est_SinProcesar     := 'N';
SET SalidaSI            := 'S';





SET Par_ClaveUsuario    := IFNULL(Par_ClaveUsuario, Cadena_Vacia);
SET Par_FolioCargaIDBE  := IFNULL(Par_FolioCargaIDBE, Entero_Cero);

SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
SET Aud_FechaActual := NOW();

ManejoErrores: BEGIN

DECLARE EXIT HANDLER FOR SQLEXCEPTION

            BEGIN
                SET Par_NumErr = 999;
                SET Par_ErrMen  = CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                                    'Disculpe las molestias que esto le ocasiona. Ref: SP-BECARGAPAGNOMINALT ');
                SET Var_Control = 'sqlException' ;
            END;


 CALL FOLIOSAPLICAACT('BECARGAPAGNOMINA', Var_FolioCarga);


    INSERT INTO BECARGAPAGNOMINA (
        FolioCargaID,           FolioCargaIDBE,         EmpresaNominaID,    ClaveUsuario,
        ClienteID,              FechaCarga,             NumTotalPagos,      NumPagosExito,
        NumPagosError,          MontoPagos,             RutaArchivoPagoNom, Estatus,
        EmpresaID,              Usuario,                FechaActual,        DireccionIP,
        ProgramaID,             Sucursal,               NumTransaccion)
    VALUES (
        Var_FolioCarga,         Par_FolioCargaIDBE,     Par_EmpresaNominaID,        Par_ClaveUsuario,
        Entero_Cero,            FechaSist,              Par_NumTotalPagos,          Par_NumPagosExito,
        Par_NumPagosError,      Par_MontoPagos,         Par_RutaArchivoPagoNom,     Est_SinProcesar,
        Par_EmpresaID,          Aud_Usuario,            Aud_FechaActual,            Aud_DireccionIP,
        Aud_ProgramaID,         Aud_Sucursal,           Aud_NumTransaccion);

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := 'Folio Carga de Archivo Cargado Exitosamente';
    SET Var_Control := 'institNominaID';
    SET Entero_Cero := Var_FolioCarga;

    END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_FolioCarga AS consecutivo;
END IF;

END TerminaStore$$