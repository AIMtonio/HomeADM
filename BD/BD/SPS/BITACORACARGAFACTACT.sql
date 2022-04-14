-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BITACORACARGAFACTACT
DELIMITER ;
DROP PROCEDURE IF EXISTS `BITACORACARGAFACTACT`;

DELIMITER $$
CREATE PROCEDURE `BITACORACARGAFACTACT`(
	# =====================================================================================
	# SP PARA ACTUALIZAR LA FACTURA DE LA CARGA MASIVA
	# =====================================================================================
    Par_FolioCargaID        	INT(11),			-- FOLIO DE CARGA
    Par_FolioFacturaID         	INT(11),			-- FOLIO DE LA FACTURA
	Par_TipoActualizacion		TINYINT UNSIGNED,	-- NUMERO DE

    Par_Salida              	CHAR(1),			-- SALIDA
    INOUT Par_NumErr        	INT(11),			-- NUMERO DE ERROR
    INOUT Par_ErrMen        	VARCHAR(400),		-- MENSAJE DE ERROR

    Aud_EmpresaID           	INT(11),			-- AUDITORIA
    Aud_Usuario             	INT(11),			-- AUDITORIA
    Aud_FechaActual         	DATETIME,			-- AUDITORIA
    Aud_DireccionIP         	VARCHAR(15),		-- AUDITORIA
    Aud_ProgramaID          	VARCHAR(50),		-- AUDITORIA
    Aud_Sucursal            	INT(11),			-- AUDITORIA
    Aud_NumTransaccion      	BIGINT(20)			-- AUDITORIA
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_Control         VARCHAR(100);
    DECLARE Var_FacturaID		BIGINT(20);
	DECLARE Var_FolioFacturaID	INT(11);

	-- Declaracion de constantes
	DECLARE Entero_Cero         INT(11);
	DECLARE Decimal_Cero        DECIMAL(12,2);
	DECLARE Cadena_Vacia        CHAR(1);
	DECLARE Fecha_Vacia         DATE;
	DECLARE SalidaNO            CHAR(1);
	DECLARE SalidaSI            CHAR(1);
    DECLARE Cons_EstatusB		CHAR(1);
    DECLARE Cons_EstatusP		CHAR(1);

    DECLARE Act_BajaFac			INT(11);
    DECLARE Act_ProcesaFac		INT(11);

	-- Asignacion de constantes
	SET Entero_Cero         := 0;
	SET Decimal_Cero        := 0.0;
	SET Cadena_Vacia        := '';
	SET Fecha_Vacia         := '1900-01-01';
	SET SalidaNO            := 'N';
	SET SalidaSI            := 'S';
    SET Cons_EstatusB		:= 'B';
    SET Cons_EstatusP		:= 'P';

    SET Act_BajaFac			:= 1;
    SET Act_ProcesaFac		:= 2;


ManejoErrores: BEGIN

	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr = 999;
		SET Par_ErrMen = CONCAT('El SAFI ha tenido un problema al concretar la operacion. Disculpe las molestias que ',
								'esto le ocasiona. Ref: SP-BITACORACARGAFACTBAJ');
				SET Var_Control = 'SQLEXCEPTION' ;

	END;


    IF(IFNULL(Par_FolioCargaID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 001;
		SET Par_ErrMen := 'El Folio de la Carga Esta Vacio.';
		SET Var_Control := 'folioCargaID';
		LEAVE ManejoErrores;
	END IF;

    IF(IFNULL(Par_FolioFacturaID, Entero_Cero) = Entero_Cero) THEN
		SET Par_NumErr := 002;
		SET Par_ErrMen := 'El Folio de Factura Esta Vacio.';
		SET Var_Control := 'folioCargaID';
		LEAVE ManejoErrores;
	END IF;

    SELECT FolioFacturaID INTO Var_FolioFacturaID
		FROM BITACORACARGAFACT
        WHERE FolioFacturaID = Par_FolioFacturaID;

	SET Var_FolioFacturaID := IFNULL(Var_FolioFacturaID, Entero_Cero);

    IF(Var_FolioFacturaID != Par_FolioFacturaID) THEN
		SET Par_NumErr := 003;
		SET Par_ErrMen := 'El Folio de Factura No Existe.';
		SET Var_Control := 'folioCargaID';
		LEAVE ManejoErrores;
	END IF;

	SELECT Folio INTO Var_FacturaID
			FROM BITACORACARGAFACT
		WHERE FolioCargaID = Par_FolioCargaID
        AND FolioFacturaID = Par_FolioFacturaID;

        SET Var_FacturaID := IFNULL(Var_FacturaID, Entero_Cero);

    -- BAJA DE FACTURA
	IF(Par_TipoActualizacion = Act_BajaFac)THEN
		UPDATE BITACORACARGAFACT
			SET EstatusPro = Cons_EstatusB
		WHERE FolioCargaID = Par_FolioCargaID
        AND FolioFacturaID = Par_FolioFacturaID;

        SET Par_ErrMen := CONCAT("La(s) factura(s) ", Var_FacturaID, " fue(ron) dada(s) de baja con exito.");
    END IF;

    -- FACTURA PROCESADA
	IF(Par_TipoActualizacion = Act_ProcesaFac)THEN
		UPDATE BITACORACARGAFACT
			SET EstatusPro = Cons_EstatusP
		WHERE FolioCargaID = Par_FolioCargaID
        AND FolioFacturaID = Par_FolioFacturaID;

        SET Par_ErrMen := CONCAT("La factura ", Var_FacturaID, " fue procesada con exito.");
    END IF;

	SET Par_NumErr := 000;
	SET Par_ErrMen := Par_ErrMen;

END ManejoErrores;

IF(Par_Salida = SalidaSI) THEN
    SELECT Par_NumErr AS NumErr,
           Par_ErrMen AS ErrMen,
           "folioCargaID" AS control,
		   Par_FolioCargaID AS consecutivo;
END IF;
END TerminaStore$$