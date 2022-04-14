-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEPAGOSNOMINALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEPAGOSNOMINALT`;
DELIMITER $$


CREATE PROCEDURE `BEPAGOSNOMINALT`(

    Par_FolioCargaID        INT(11),
    Par_FolioCargaIDBE      INT(11),
    Par_EmpresaNominaID     INT(11),
    Par_CreditoID           BIGINT(12),
    Par_ClienteID           VARCHAR(20),
    Par_MontoPagos          DECIMAL(12,2),

    INOUT Var_Folio		    INT(11),

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


DECLARE Var_Control         VARCHAR(50);
DECLARE Var_FolioNominaID   INT(11);


DECLARE Cadena_Vacia        CHAR(1);
DECLARE Fecha_Vacia         DATE;
DECLARE FechaSist           DATE;
DECLARE Entero_Cero         INT;
DECLARE Decimal_Cero        DECIMAL(12,2);
DECLARE Est_Cargado         CHAR(1);
DECLARE SalidaSI            CHAR(1);
DECLARE ExisteCredito       INT;



SET Cadena_Vacia        := '';
SET Fecha_Vacia         := '1900-01-01';
SET Entero_Cero         :=  0;
SET Decimal_Cero        := 0.0;
SET Est_Cargado         := 'P';
SET SalidaSI            := 'S';



SET Par_FolioCargaIDBE  := IFNULL(Par_FolioCargaIDBE, Entero_Cero);

SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
SET Aud_FechaActual := NOW();
SET Var_Folio := Entero_Cero;

ManejoErrores: BEGIN
 DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
                SET Par_NumErr := 999;
                SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion.Disculpe las molestias que', 'esto le ocasiona. Ref: SP-BEPAGOSNOMINALT');
                SET Var_Control := 'sqlException' ;
            END;


 CALL FOLIOSAPLICAACT('BEPAGOSNOMINA', Var_FolioNominaID);
    INSERT INTO BEPAGOSNOMINA (
        FolioNominaID,      FolioCargaID,       FolioCargaIDBE,         EmpresaNominaID,
        FechaCarga,         CreditoID,          ClienteID,              MontoPagos,
        Estatus,            MotivoCancela,      EmpresaID,              Usuario,
        FechaActual,        DireccionIP,        ProgramaID,             Sucursal,
        NumTransaccion)
    VALUES (
        Var_FolioNominaID,  Par_FolioCargaID,   Par_FolioCargaIDBE,     Par_EmpresaNominaID,
        FechaSist,          Par_CreditoID,      Par_ClienteID,          Par_MontoPagos,
        Est_Cargado,        Cadena_Vacia,       Par_EmpresaID,          Aud_Usuario,
        Aud_FechaActual,    Aud_DireccionIP,    Aud_ProgramaID,         Aud_Sucursal,
        Aud_NumTransaccion);

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := 'Folio Carga de Archivo Cargado Exitosamente';
    SET Var_Control := 'folioNominaID';
    SET Var_Folio   := Var_FolioNominaID;

    END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_Folio AS consecutivo;
END IF;

END TerminaStore$$