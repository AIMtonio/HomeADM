-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ASIGNAGARANTIASACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `ASIGNAGARANTIASACT`;DELIMITER $$

CREATE PROCEDURE `ASIGNAGARANTIASACT`(
-- ---------------------------------------------------------------------------
-- SP PARA ACTUALIZAR LAS GARANTIAS EN LA TABLA ASIGNAGARANTIAS
-- ---------------------------------------------------------------------------
    Par_SolCredID       	INT(11),			-- Solicitud de credito
    Par_GarantiaID      	INT(11),			-- Numero de la garantia
    Par_NumActualizacion	TINYINT,			-- Numero de Actualizacion


    Par_Salida				CHAR(1),
    INOUT Par_NumErr		INT(11),
    INOUT Par_ErrMen		VARCHAR(150),

    Par_EmpresaID       	INT(11),			-- Parametro de Auditoria
    Aud_Usuario         	INT(11),			-- Parametro de Auditoria
    Aud_FechaActual     	DATETIME,			-- Parametro de Auditoria
    Aud_DireccionIP     	VARCHAR(15),		-- Parametro de Auditoria
    Aud_ProgramaID      	VARCHAR(50),		-- Parametro de Auditoria
    Aud_Sucursal        	INT(11),			-- Parametro de Auditoria
    Aud_NumTransaccion  	BIGINT(20)			-- Parametro de Auditoria
    	)
TerminaStore: BEGIN


-- DECLARACION DE VARIABLES
DECLARE Var_Control             VARCHAR(50);
DECLARE Var_ProductoCreditoID   INT(11);
DECLARE Var_ReqGarantias        CHAR(1);

-- DECLARACION DE CONSTANTES
DECLARE Entero_Cero             TINYINT;
DECLARE Cadena_Vacia            CHAR(1);
DECLARE Str_SI                  CHAR(1);
DECLARE Str_NO                  CHAR(1);
DECLARE Estatus_Autorizada      CHAR(1);
DECLARE Estatus_Asignada        CHAR(1);
DECLARE Actualizar_Estatus      TINYINT;

-- ASIGNACION DE CONSTANTES
SET Entero_Cero                 := 0;
SET Cadena_Vacia                := '';
SET Str_SI                      := 'S';
SET Str_NO                      := 'N';
SET Estatus_Autorizada          := 'U';
SET Estatus_Asignada            := 'A';
SET Actualizar_Estatus          := 1;


ManejoErrores:BEGIN

 DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        SET Par_NumErr := 999;
        SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar ',
                                'la operacion. Disculpe las molestias que ',
                                'esto le ocasiona. Ref: ASIGNAGARANTIASACT');
        SET Var_Control = 'SQLEXCEPTION';
    END;

    SELECT PROD.ProducCreditoID,    PROD.RequiereGarantia
    INTO   Var_ProductoCreditoID,   Var_ReqGarantias
    FROM SOLICITUDCREDITO SOL
    INNER JOIN PRODUCTOSCREDITO PROD ON PROD.ProducCreditoID = SOL.ProductoCreditoID
    WHERE SolicitudCreditoID = Par_SolCredID LIMIT 1;

    IF(Var_ReqGarantias = Str_NO) THEN
        SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT('No requiere garantias');
        LEAVE ManejoErrores;
    END IF;

    IF NOT EXISTS (SELECT SolicitudCreditoID FROM ASIGNAGARANTIAS WHERE SolicitudCreditoID = Par_SolCredID) THEN
        SET Par_NumErr := 0;
        SET Par_ErrMen := CONCAT('No Existe la Solicitud de Credito');
        LEAVE ManejoErrores;
    END IF;

    -- ACTUALIZACION DEL ESTATUS DE LA GARANTIA ASIGNADA
    IF (Par_NumActualizacion = Actualizar_Estatus) THEN
        UPDATE ASIGNAGARANTIAS SET Estatus = Estatus_Asignada
        WHERE SolicitudCreditoID = Par_SolCredID;
    END IF;

    SET Par_NumErr  := 000;
    SET Par_ErrMen  := 'Datos actualizados correctamente';
    SET Var_Control := 'SolicitudCreditoID';


END ManejoErrores;

IF(Par_Salida = Str_SI)THEN
    SELECT Par_NumErr AS NumErr,
            Par_ErrMen AS ErrMen,
            Var_Control AS control,
            Entero_Cero AS consecutivo;
END IF;

END TerminaStore$$