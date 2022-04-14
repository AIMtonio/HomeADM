-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HISDISPERSIONMOVALT
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISDISPERSIONMOVALT`;
DELIMITER $$

CREATE PROCEDURE `HISDISPERSIONMOVALT`(
# =========================================================================
# ----------SP PARA DAR DE ALTA EL HISTORICO DE LAS DISPERSIONES-----------
# =========================================================================
    Par_DispersionID			INT(11),		-- FOLIO DE DISPERSION
    Par_ClaveDispMov			INT(11),		-- CLEVE DEL MOVIMIENTO DISPERSION   
	Par_FechaCancela			DATE,			-- FECHA DE CANCELACION
    Par_NumeroTrans				BIGINT(20),		-- NUMERO DE OPERACION
    
    Par_Salida					CHAR(1),		-- SALIDA
    INOUT Par_NumErr	 		INT(11),		-- NUMERO DE ERROR
    INOUT Par_ErrMen	 		VARCHAR(400),	-- MENSAJE DE ERROR
    
	Aud_EmpresaID				INT(11),		-- AUDITORIA
	Aud_Usuario					INT(11),		-- AUDITORIA
	Aud_FechaActual				DATETIME,		-- AUDITORIA
	Aud_DireccionIP				VARCHAR(15),	-- AUDITORIA
	Aud_ProgramaID				VARCHAR(50),	-- AUDITORIA
	Aud_Sucursal				INT(11),		-- AUDITORIA
	Aud_NumTransaccion			BIGINT(20)		-- AUDITORIA
)
TerminaStore: BEGIN

	-- DECLARACION DE VARIABLES
	DECLARE Var_Control				VARCHAR(100);		-- CONTROL
	DECLARE Var_FechaSis			DATE;				-- FECHA DEL SISTEMA
    DECLARE	Var_Sentencia			VARCHAR(15000);		-- SENTENCIA
    DECLARE Var_Consecutivo			INT(11);			-- CONSECUTIVO
    
	-- DECLARACION DE CONSTANTES
	DECLARE Entero_Cero				INT(11);
	DECLARE SalidaSi  				CHAR(1);
	DECLARE SalidaNo  				CHAR(1);
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
    
    -- ASIGNACION DE CONSTANTES
	SET Entero_Cero					:= 0;
	SET SalidaSi					:= 'S';
	SET SalidaNo					:= 'N';
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	
    SET Par_DispersionID 			:= IFNULL(Par_DispersionID, Entero_Cero);
    SET Par_ClaveDispMov 			:= IFNULL(Par_ClaveDispMov, Entero_Cero);
    
	ManejoErrores:BEGIN

		DECLARE EXIT HANDLER FOR SQLEXCEPTION
			BEGIN
				SET Par_NumErr := 999;
				SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								  'Disculpe las molestias que esto le ocasiona. Ref: SP-HISDISPERSIONMOVALT');
				SET Var_Control := 'sqlexception';
			END;
		
        IF(Par_DispersionID = Entero_Cero) THEN
				SET Par_NumErr := 1;
				SET Par_ErrMen := 'El numero de dispersion esta vacio';
				SET Var_Control:= 'dispersionID';
                SET Var_Consecutivo	:= Entero_Cero;
				LEAVE ManejoErrores;
			END IF;
        
		SELECT FechaSistema INTO Var_FechaSis 
			FROM PARAMETROSSIS;
            
		IF(Par_FechaCancela= Fecha_Vacia )THEN
			SET Par_FechaCancela := Var_FechaSis;
        END IF;

		SET Var_Sentencia := CONCAT('
		INSERT INTO HISDISPERSIONMOV(
			ClaveDispMov,	DispersionID, 	CuentaCargo, 	CuentaContable, Descripcion,
			Referencia, 	TipoMovDIspID, 	FormaPago, 		Monto, 			CuentaDestino,
			Identificacion, Estatus, 		NombreBenefi, 	FechaEnvio, 	SucursalID,
			CreditoID, 		NombreArchivo, 	EstatusResSanta, NomArchivoGenerado, FechaGenArch, 
			ProveedorID, 	FacturaProvID, 	DetReqGasID, 	TipoGastoID, 	CatalogoServID,
			AnticipoFact, 	TipoChequera, 	ConceptoDispersion, FechaCancela, NumeroTrans,
			FechaLiquidacion,FechaRechazo,
            EmpresaID, 		Usuario, 		FechaActual, 	DireccionIP, 	ProgramaID,
			Sucursal, 		NumTransaccion)
		SELECT ClaveDispMov,	DispersionID, 	CuentaCargo, 	CuentaContable, Descripcion,
			Referencia, 	TipoMovDIspID, 	FormaPago, 		Monto, 			CuentaDestino,
			Identificacion, Estatus, 		NombreBenefi, 	FechaEnvio, 	SucursalID,
			CreditoID, 		NombreArchivo, 	EstatusResSanta, NomArchivoGenerado, FechaGenArch, 
			ProveedorID, 	FacturaProvID, 	DetReqGasID, 	TipoGastoID, 	CatalogoServID,
			AnticipoFact, 	TipoChequera, 	ConceptoDispersion,"', Par_FechaCancela,'",',Par_NumeroTrans,',
            FechaLiquidacion,FechaRechazo,
			EmpresaID, 		Usuario, 		FechaActual, 	DireccionIP, 	ProgramaID,
			Sucursal, 		NumTransaccion
		FROM DISPERSIONMOV
        WHERE DispersionID = ',Par_DispersionID);
        
        IF(Par_ClaveDispMov != Entero_Cero)THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND ClaveDispMov = ',Par_ClaveDispMov);
        END IF;        
		
        SET Var_Sentencia := CONCAT(Var_Sentencia,';');
        SET @Sentencia := (Var_Sentencia);
		PREPARE HISDISPERSIONMOV FROM @Sentencia;
		EXECUTE HISDISPERSIONMOV;
		DEALLOCATE PREPARE HISDISPERSIONMOV;
    
		SET Par_NumErr 			:= 0;
		SET Par_ErrMen 			:= 'Datos insertados correctamente.';
        SET Var_Control			:= '';

	END ManejoErrores;

		IF (Par_Salida = SalidaSi) THEN
			SELECT 	Par_NumErr AS NumErr,
			   		Par_ErrMen AS ErrMen,
			   		Var_Control AS control,
			   		Var_Consecutivo AS consecutivo;
		END IF;

END TerminaStore$$