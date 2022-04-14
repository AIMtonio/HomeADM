-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BEDETALLEPAGNOMINWSALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BEDETALLEPAGNOMINWSALT`;
DELIMITER $$

CREATE PROCEDURE `BEDETALLEPAGNOMINWSALT`(
    Par_FolioCargaID            INT(11),            -- ID de Folio de Carga
    Par_EmpresaNominaID         INT(11),            -- Institucion de Nomina ID
    Par_CreditoID               BIGINT(12),         -- Credito ID
    Par_Cliente                 VARCHAR(20),        -- ID del Cliente de Nomina
    Par_Monto                   DECIMAL(12,2),      -- Monto a Aplicar

    Par_Salida                  CHAR(1),            -- Parametro de Salida
    INOUT Par_NumErr            INT(11),            -- Parametro de Numero de Error
    INOUT Par_ErrMen            VARCHAR(400),       -- Parametro de Mensaje de Error

    Par_EmpresaID               INT(11),            -- Parametros de Auditoria
    Aud_Usuario                 INT(11),            -- Parametros de Auditoria
    Aud_FechaActual             DATETIME,           -- Parametros de Auditoria
    Aud_DireccionIP             VARCHAR(15),        -- Parametros de Auditoria
    Aud_ProgramaID              VARCHAR(50),        -- Parametros de Auditoria
    Aud_Sucursal                INT(11),            -- Parametros de Auditoria
    Aud_NumTransaccion          BIGINT(20)          -- Parametros de Auditoria
        )
TerminaStore:BEGIN

    -- Declaracion de Variables
    DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_Institucion     INT(11);            -- Variable de ID de Institucion de Nomina
    DECLARE Var_Solicitud       BIGINT(20);         -- Variable para la Solicitud de Credito
    DECLARE Var_FolioCtrl       VARCHAR(20);        -- Numero de control que la institucion de nomina tiene para el control de sus empleados
    DECLARE Var_FolioCarga      INT(11);            -- Folio Carga ID
    DECLARE Var_FolioNomina     INT(11);            -- Variable de Folio de Nomina de  BEPAGOSNOMINA
    DECLARE Var_InstitNominaID  INT(11);            -- Institucion de Nomina

    -- Declaracion de Constantes
    DECLARE Cadena_Vacia        CHAR(1);            -- Constante Cadena Vacia
    DECLARE Fecha_Vacia         DATE;               -- Constante Fecha Vacia
    DECLARE FechaSist           DATE;               -- Constante Fecha del Sistema
    DECLARE Entero_Cero         INT(11);            -- Constante Entero Cero
    DECLARE Decimal_Cero        DECIMAL(12,2);      -- Constante Decimal Cero
    DECLARE SalidaSI            CHAR(1);            -- Constante Salida SI 'S'
    DECLARE Con_NO              CHAR(1);

    -- Seteo de Constantes
    SET Cadena_Vacia        := '';
    SET Fecha_Vacia         := '1900-01-01';
    SET Entero_Cero         := 0;
    SET Decimal_Cero        := 0.0;
    SET SalidaSI            := 'S';
    SET Con_NO              := 'N';


    SET FechaSist := (SELECT FechaSistema FROM PARAMETROSSIS);
    SET Aud_FechaActual := NOW();
    SET Var_FolioNomina     := 0;
    ManejoErrores: BEGIN

        DECLARE EXIT HANDLER FOR SQLEXCEPTION
            BEGIN
            SET Par_NumErr := 999;
            SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
                        'Disculpe las molestias que esto le ocasiona. Ref: SP-BEDETALLEPAGNOMINWSALT');
            END;

        SET Var_FolioCarga :=  (SELECT FolioCargaID FROM BECARGAPAGNOMINA WHERE FolioCargaID = Par_FolioCargaID);
        SET Var_FolioCarga := IFNULL(Var_FolioCarga, Entero_Cero);

        IF(Var_FolioCarga = Entero_Cero )THEN
			SET	Par_NumErr 		:= 1;
			SET	Par_ErrMen		:= 'La Folio de Carga no Existe';
            SET Var_Control		:= 'folioCargaID';
			LEAVE ManejoErrores;
		END IF;

        SET Var_Institucion := (SELECT InstitNominaID
                                    FROM INSTITNOMINA
                                    WHERE InstitNominaID = Par_EmpresaNominaID);
        SET Var_Institucion := IFNULL(Var_Institucion,Entero_Cero);

        IF(Var_Institucion = Entero_Cero )THEN
			SET	Par_NumErr 		:= 2;
			SET	Par_ErrMen		:= 'La Institucion especificada no Existe';
            SET Var_Control		:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

        IF NOT EXISTS(SELECT CreditoID FROM CREDITOS WHERE CreditoID =  Par_CreditoID) THEN
			SET	Par_NumErr 		:= 3;
			SET	Par_ErrMen		:= 'El Credito No Existe';
            SET Var_Control		:= 'creditoID';
			LEAVE ManejoErrores;
		END IF;


        SET Var_Solicitud := (SELECT SolicitudCreditoID FROM CREDITOS WHERE CreditoID = Par_CreditoID );
        SET Var_Solicitud := IFNULL(Var_Solicitud , Entero_Cero);

        SET Var_FolioCtrl := (SELECT FolioCtrl FROM SOLICITUDCREDITO WHERE SolicitudCreditoID =  Var_Solicitud);
        SET Var_FolioCtrl := IFNULL( Var_FolioCtrl, Entero_Cero);

        IF(Var_FolioCtrl = Cadena_Vacia) THEN
            SET	Par_NumErr 		:= 4;
			SET	Par_ErrMen		:= 'El Numero de Empleado No Coincide con la Solicitud ';
            SET Var_Control		:= 'clienteID';
			LEAVE ManejoErrores;
		END IF;

        IF((Par_Cliente LIKE Var_FolioCtrl) = Entero_Cero )THEN
            SET	Par_NumErr 		:= 5;
			SET	Par_ErrMen		:= 'El Empleado no Corresponde al Credito';
            SET Var_Control		:= 'monto';
			LEAVE ManejoErrores;
        END IF;

        IF(Par_Monto <= Entero_Cero)THEN
            SET	Par_NumErr 		:= 6;
			SET	Par_ErrMen		:= 'El Monto a Aplicar es Menor o Igual a Cero';
            SET Var_Control		:= 'monto';
			LEAVE ManejoErrores;
		END IF;

        SET Var_InstitNominaID := (SELECT InstitNominaID FROM CREDITOS WHERE CreditoID = Par_CreditoID);
        SET Var_InstitNominaID := IFNULL(Var_InstitNominaID, Entero_Cero);

         IF(Par_EmpresaNominaID != Var_InstitNominaID)THEN
            SET	Par_NumErr 		:= 7;
			SET	Par_ErrMen		:= 'La Institucion de Nomina no Corresponde al Credito';
            SET Var_Control		:= 'institucionID';
			LEAVE ManejoErrores;
		END IF;

       CALL BEPAGOSNOMINALT(    Par_FolioCargaID,   Entero_Cero,        Par_EmpresaNominaID,       Par_CreditoID,      Par_Cliente,
                                Par_Monto,          Var_FolioNomina,    Con_NO,             Par_NumErr,                Par_ErrMen,         Par_EmpresaID,
                                Aud_Usuario,        Aud_FechaActual,    Aud_DireccionIP,           Aud_ProgramaID,     Aud_Sucursal,
                                Aud_NumTransaccion);

         IF(Par_NumErr != Entero_Cero)THEN
            LEAVE ManejoErrores;
        END IF;

        SET Var_FolioNomina := IFNULL(Var_FolioNomina, Entero_Cero);

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := 'Folio Carga de Archivo Cargado Exitosamente';
    SET Var_Control := 'institNominaID';

    END ManejoErrores;

IF (Par_Salida = SalidaSI) THEN
    SELECT  Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Var_FolioNomina AS consecutivo;
END IF;

END TerminaStore$$