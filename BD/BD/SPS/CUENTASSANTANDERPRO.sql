-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASSANTANDERPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASSANTANDERPRO`;
DELIMITER $$


CREATE PROCEDURE `CUENTASSANTANDERPRO`(
	/*SP PARA EL ALTA Y ACTUALIZACION DE LAS CUENTAS DE SANTANDER*/
	Par_FechaInicio			DATE,				-- FECHA INICIO
	Par_FechaFin			DATE,				-- FECHA FINAL    
    Par_TipoTran			TINYINT UNSIGNED, 	-- TIPO DE TRANSACCION     
    
	Par_Salida				CHAR(1), 			-- SALIDA
	INOUT Par_NumErr		INT(11),			-- NUM ERROR
	INOUT Par_ErrMen		VARCHAR(400),		-- MENSAJE DE ERROR
	Aud_EmpresaID			INT(11),			-- AUDITORIA    
	Aud_Usuario				INT(11),			-- AUDITORIA
    
	Aud_FechaActual			DATETIME,			-- AUDITORIA
	Aud_DireccionIP			VARCHAR(15),		-- AUDITORIA
	Aud_ProgramaID			VARCHAR(50),		-- AUDITORIA
	Aud_Sucursal			INT(11),			-- AUDITORIA
	Aud_NumTransaccion		BIGINT(20)			-- AUDITORIA
	)

TerminaStore: BEGIN
	-- DECLARACIO DE VARIABLES
    DECLARE Var_Control			VARCHAR(25);
    
    
	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia		CHAR(1);		-- CADENA VACIA
	DECLARE Fecha_Vacia			DATE;			-- FECHA VACIA
	DECLARE Entero_Cero			INT;			-- ENTERO CERO
	DECLARE SiOficial			CHAR(1);		-- SI OFICIAL
	DECLARE Salida_SI			CHAR(1);		-- SALIDA SI
	DECLARE Salida_No			CHAR(1);		-- SALIDA NO
	DECLARE EstatusReg			CHAR(1);		-- ESTATUS REGISTRADO
	DECLARE EstatusEnv			CHAR(1);		-- ESTATUS ENVIADA
	DECLARE NumPazaBanxico		INT(11);		-- NUMERO DE PLAZA ANTE BANXICO
	DECLARE Sucursal			INT(11);		-- NUMERO DE SUCURSAL
	DECLARE TipoCtaSantander	CHAR(1);		-- TIPO DE CUENTA SANTANDER 
	DECLARE TipoCtaOtros		CHAR(1);		-- TIPO DE CUENTA OTROS
	DECLARE DesTipoCtaSantan	VARCHAR(6);		-- DESCRIPCION TIPO DE CUENTA SANTANDER
	DECLARE DesTipoCtaOtros		VARCHAR(6);		-- DESCRIPCION TIPO DE CUENTA OTROS
	DECLARE TipoTranAlta		INT(11);		-- TIPO DE TRANSACCION DE ALTA

	

	-- ASIGNACION DE CONSTANTES
    SET TipoTranAlta		:= 1;
	SET Cadena_Vacia		:= '';
	SET Fecha_Vacia			:= '1900-01-01';
	SET Entero_Cero			:= 0;
	SET SiOficial			:= 'S';
	SET Salida_SI			:= 'S';
	SET Salida_NO			:= 'N';
	SET EstatusReg			:= 'R';
	SET EstatusEnv			:= 'E';
	SET NumPazaBanxico		:= 3954;
	SET Sucursal			:= '00001';
	SET TipoCtaSantander	:= 'A';
	SET TipoCtaOtros		:= 'O';
	SET DesTipoCtaSantan	:= 'SANTAN';
	SET DesTipoCtaOtros		:= 'EXTRNA';

ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION
	BEGIN
		SET Par_NumErr := 999;
		SET Par_ErrMen := CONCAT('El SAFI ha tenido un problema al concretar la operacion. ',
								'Disculpe las molestias que esto le ocasiona. Ref: SP-CUENTASSANTANDERPRO');
	END;

	IF(Par_TipoTran = TipoTranAlta)THEN                        
		-- ELIMINAMOS LA TABLA TEMPORAL
		DROP TEMPORARY TABLE IF EXISTS TMPCUENTASSANTANDER;
        
        -- CRAMOS LA TABLA TEMPORAL
       CREATE TEMPORARY TABLE `TMPCUENTASSANTANDER` (
		`SolicitudCreditoID`	BIGINT(20) COMMENT 'ID de la tabla',
		`ClienteID`				INT(11) COMMENT 'ID del cliente que le corresponde a la Solicitud de credito',
		`TipoCtaSAFIID`			CHAR(1) COMMENT 'Tipo de Cta.\n  A.-Santander\n O.-Otro',
		`TipoCuenta`			VARCHAR(6) COMMENT 'Descripcion del tipo de Cta. SANTAN.-Santander\n EXTRNA.-Otro',
		`NumeroCta`				VARCHAR(20) COMMENT 'Cuenta Clabe a la cual se hara el abono de la dispersión del credito',
		`PazaBanxico`			INT(11) COMMENT 'Numero de plaza ante banxico',
		`SucursalID`			INT(11) COMMENT 'Numero Sucursal titular',
		`Estatus`				CHAR(3) COMMENT 'Estatus en que se encuentra la Cuenta.\n E.-Enviado\n	A.-Autorizado por el banco\n 	C.-Cancelada por el banco\n J.-Ejecutada por el banco \n N.-En proceso por el banco \n P.-Pendiente por autorizar por el banco\n D.-Pendiente por Activar\n R.-Rechazada',
		`FechaRegistro`			DATE DEFAULT NULL COMMENT 'Fecha de registro de la solicitud de credito',
		`NombreBeneficiario`	VARCHAR(500) DEFAULT "" COMMENT "NOMBRE DEL BENEFICIARIO" ,
        `EmpresaID` 			INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
		`Usuario` 				INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
		`FechaActual` 			DATETIME DEFAULT NULL COMMENT 'AUDITORIA',
		`DireccionIP` 			VARCHAR(15) DEFAULT NULL COMMENT 'AUDITORIA',
		`ProgramaID` 			VARCHAR(50) DEFAULT NULL COMMENT 'AUDITORIA',
		`Sucursal` 				INT(11) DEFAULT NULL COMMENT 'AUDITORIA',
		`NumTransaccion` 		BIGINT(20) COMMENT 'AUDITORIA',
		INDEX (`SolicitudCreditoID`,`ClienteID`,`NumeroCta`, `NumTransaccion`));
        
		INSERT INTO TMPCUENTASSANTANDER
					(SolicitudCreditoID, 			ClienteID, 			Estatus,				PazaBanxico,			SucursalID,
					TipoCtaSAFIID,					FechaRegistro,		TipoCuenta,				NumeroCta,			
					EmpresaID,						Usuario,			FechaActual,    		DireccionIP,      		ProgramaID,    
					Sucursal,       				NumTransaccion)                                
			SELECT  SOL.SolicitudCreditoID, 		SOL.ClienteID, 		EstatusEnv,				NumPazaBanxico,			Sucursal,
					SOL.TipoCtaSantander,			SOL.FechaRegistro,
					CASE SOL.TipoCtaSantander WHEN TipoCtaSantander THEN DesTipoCtaSantan WHEN TipoCtaOtros THEN DesTipoCtaOtros ELSE Cadena_Vacia END AS TipoCuenta,
					CASE SOL.TipoCtaSantander WHEN TipoCtaSantander THEN SOL.CtaSantander WHEN TipoCtaOtros THEN SOL.CtaClabeDisp ELSE Entero_Cero END AS NumeroCta,
					Aud_EmpresaID,					Aud_Usuario,    	Aud_FechaActual,    	Aud_DireccionIP,      	Aud_ProgramaID,
					Aud_Sucursal,       			Aud_NumTransaccion
				FROM SOLICITUDCREDITO SOL
				LEFT JOIN CUENTASSANTANDER CUE ON CUE.SolicitudCreditoID= SOL.SolicitudCreditoID
				WHERE CUE.SolicitudCreditoID IS NULL
				AND SOL.FechaRegistro BETWEEN Par_FechaInicio AND Par_FechaFin
				AND IFNULL(SOL.TipoCtaSantander, Cadena_Vacia)!=Cadena_Vacia
				AND FIND_IN_SET(SOL.Estatus, "D,A")
				ORDER BY SOL.SolicitudCreditoID ASC;

        
		
		INSERT INTO CUENTASSANTANDER
					(SolicitudCreditoID, 			ClienteID, 			Estatus,				PazaBanxico,			SucursalID,
					TipoCtaSAFIID,					FechaRegistro,		TipoCuenta,				NumeroCta,				BenefNombre,
                    Titular,
					EmpresaID,						Usuario,			FechaActual,    		DireccionIP,      		ProgramaID,    
					Sucursal,       				NumTransaccion)
			SELECT MAX(BEN.SolicitudCreditoID), 			MAX(SOL.ClienteID), 		EstatusEnv,				NumPazaBanxico,			Sucursal,
					CASE LENGTH(MAX(BEN.Cuenta)) WHEN 18 THEN 'O' ELSE 'A' END AS TipoCtaSAFIID,		MAX(SOL.FechaRegistro),	
					CASE LENGTH(MAX(BEN.Cuenta)) WHEN 18 THEN DesTipoCtaOtros ELSE DesTipoCtaSantan END AS TipoCuenta,
					MAX(BEN.Cuenta),				MAX(FNLIMPIACARACTERESGEN(REPLACE(BEN.Beneficiario,'Ñ','N'),"OR")),	MAX(FNLIMPIACARACTERESGEN(REPLACE(BEN.Beneficiario,'Ñ','N'),"OR")),
                    Aud_EmpresaID,					Aud_Usuario,    	Aud_FechaActual,    	Aud_DireccionIP,      	Aud_ProgramaID,
					Aud_Sucursal,       			Aud_NumTransaccion
			FROM SOLICITUDCREDITO SOL
			INNER JOIN BENEFICDISPERSIONCRE BEN ON SOL.SolicitudCreditoID=BEN.SolicitudCreditoID
			LEFT JOIN CUENTASSANTANDER CUE ON CUE.SolicitudCreditoID= SOL.SolicitudCreditoID
		WHERE CUE.NumeroCta IS NULL
			 AND SOL.FechaRegistro BETWEEN Par_FechaInicio AND Par_FechaFin
			AND IFNULL(SOL.TipoCtaSantander, "")=""
			AND SOL.Estatus IN ('D','A')
			 AND BEN.TipoDispersionID IN ('T')
		GROUP BY BEN.Cuenta;
            
        INSERT INTO CUENTASSANTANDER
					(SolicitudCreditoID, 			ClienteID, 			Estatus,				PazaBanxico,			SucursalID,
					TipoCtaSAFIID,					FechaRegistro,		TipoCuenta,				NumeroCta,			
					EmpresaID,						Usuario,			FechaActual,    		DireccionIP,      		ProgramaID,    
					Sucursal,       				NumTransaccion)
        SELECT		TMP.SolicitudCreditoID, 		TMP.ClienteID, 		TMP.Estatus,			TMP.PazaBanxico,		TMP.SucursalID,
					TMP.TipoCtaSAFIID,				TMP.FechaRegistro,	TMP.TipoCuenta,			TMP.NumeroCta,			
					TMP.EmpresaID,					TMP.Usuario,		TMP.FechaActual,    	TMP.DireccionIP,      	TMP.ProgramaID,    
					TMP.Sucursal,       			TMP.NumTransaccion
			FROM TMPCUENTASSANTANDER TMP
			LEFT JOIN CUENTASSANTANDER CUE ON CUE.NumeroCta =TMP.NumeroCta
		WHERE CUE.NumeroCta IS NULL
		AND TMP.NumTransaccion=Aud_NumTransaccion;
        
        
        -- ELIMINAMOS LA TABLA TEMPORAL
        DROP TEMPORARY TABLE IF EXISTS TMPCUENTASSANTANDER;
        -- ACTUALIZAMOS LOS DATOS REGISTRADOS
		UPDATE CUENTASSANTANDER CUE
			INNER JOIN CLIENTES CLI ON CUE.ClienteID = CLI.ClienteID
			INNER JOIN DIRECCLIENTE DIR ON DIR.ClienteID = CLI.ClienteID AND DIR.Oficial=SiOficial
			INNER JOIN ESTADOSREPUB EST ON EST.EstadoID=DIR.EstadoID
		SET CUE.Titular = FNLIMPIACARACTERESGEN(REPLACE(CLI.NombreCompleto,'Ñ','N'),"OR"), 
			CUE.BenefAppPaterno = FNLIMPIACARACTERESGEN(REPLACE(CLI.ApellidoPaterno,'Ñ','N'),"OR"), 
			CUE.BenefAppMaterno = FNLIMPIACARACTERESGEN(REPLACE(CLI.ApellidoMaterno,'Ñ','N'),"OR"), 
			CUE.BenefNombre = FNLIMPIACARACTERESGEN(REPLACE(CLI.SoloNombres,'Ñ','N'),"OR"), 
			CUE.BenefDireccion = FNLIMPIACARACTERESGEN(REPLACE(DIR.DireccionCompleta,'Ñ','N'),"OR"), 
			CUE.BenefCiudad = FNLIMPIACARACTERESGEN(REPLACE(EST.Nombre,'Ñ','N'),"OR"),
            CUE.TipoCta = CASE LENGTH(CUE.NumeroCta) WHEN 18 THEN '40' ELSE '02' END
		WHERE CUE.Estatus=EstatusEnv
        AND CUE.FechaRegistro BETWEEN Par_FechaInicio AND Par_FechaFin
        AND IFNULL(CUE.BenefNombre, "")="";
        

         -- ACTUALIZAMOS DATOS DE LA INSTITUCION
        UPDATE CUENTASSANTANDER CUE
			INNER JOIN SOLICITUDCREDITO SOL ON  CUE.SolicitudCreditoID=SOL.SolicitudCreditoID
			INNER JOIN INSTITUCIONES INS ON IFNULL(INS.Folio,0) IN(SUBSTRING(SOL.CtaSantander, 1,3), SUBSTRING(SOL.CtaClabeDisp, 1,3))
			INNER JOIN CATBANCOSTRANFER CAT ON INS.ClaveParticipaSpei=CAT.BancoID
			SET CUE.ClaveBanco=CAT.ClaveTransfer,
				CUE.NumeroCta = CASE CUE.TipoCtaSAFIID WHEN "A" THEN SOL.CtaSantander WHEN "O" THEN SOL.CtaClabeDisp ELSE CUE.NumeroCta END
        WHERE IFNULL(SOL.CtaSantander,"")!="" OR IFNULL(SOL.CtaClabeDisp,"")!=""
        AND CUE.FechaRegistro BETWEEN Par_FechaInicio AND Par_FechaFin
        AND CUE.Estatus=EstatusEnv;

        UPDATE CUENTASSANTANDER CUE
			INNER JOIN INSTITUCIONES INS ON IFNULL(INS.Folio,0) IN(SUBSTRING(CUE.NumeroCta, 1,3))
			INNER JOIN CATBANCOSTRANFER CAT ON INS.ClaveParticipaSpei=CAT.BancoID
			SET CUE.ClaveBanco=CAT.ClaveTransfer
        WHERE CUE.TipoCtaSAFIID = TipoCtaOtros
        AND IFNULL(CUE.ClaveBanco,Cadena_Vacia) = Cadena_Vacia
        AND CUE.FechaRegistro BETWEEN Par_FechaInicio AND Par_FechaFin
        AND CUE.Estatus=EstatusEnv;
        
    END IF;
	
	SET Par_NumErr := Entero_Cero;
	SET Par_ErrMen := CONCAT('Operacion Realizada Exitosamente.');
	SET Var_Control := 'fechaInicio';

END ManejoErrores;

IF (Par_Salida = Salida_SI) THEN
	SELECT  Par_NumErr AS NumErr,
		Par_ErrMen AS ErrMen,
		Var_Control AS Control,
		Entero_Cero AS Consecutivo;
END IF;

END TerminaStore$$

