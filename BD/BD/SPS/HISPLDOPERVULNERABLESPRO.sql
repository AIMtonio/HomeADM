-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPERVULNERABLESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `HISPLDOPERVULNERABLESPRO`;
DELIMITER $$


CREATE PROCEDURE `HISPLDOPERVULNERABLESPRO`(
-- SP PARA CONSULTAR LAS OPERACIONES VULNERABLES
	Par_anio			INT(11),
	Par_Mes				INT(11),
    Par_FechaReporte	DATE,
    Par_InstitucionID	INT(11),
	Par_TipoReporte		TINYINT UNSIGNED,

    Aud_EmpresaID       INT(11),
    Aud_Usuario         INT(11),
    Aud_FechaActual     DATETIME,
    Aud_DireccionIP     VARCHAR(15),
    Aud_ProgramaID      VARCHAR(50),
    Aud_Sucursal        INT(11),
    Aud_NumTransaccion  BIGINT
		)
TerminaStore: BEGIN
	-- DECLARACION DE VARIABLES
	DECLARE Var_Sentencia   				VARCHAR(3000); 
    DECLARE Var_FechaTran					DATE;
    DECLARE Var_FechaNULL					DATE;
    DECLARE Var_MesRep						INT(11);
    DECLARE Var_OperMax						DECIMAL(20,2);
    DECLARE Var_InstitucionID 				INT(11);
	DECLARE Var_ClaveEntidadColegiada		VARCHAR(20);
	DECLARE Var_ClaveSujetoObligado			VARCHAR(20);
	DECLARE Var_ClaveActividad				CHAR(10);
	DECLARE Var_Exento						INT(11);
	DECLARE Var_DominioPlataforma			VARCHAR(100);
	DECLARE Var_ReferenciaAviso				INT(11);
	DECLARE Var_Prioridad					INT(11);
	DECLARE Var_FolioModificacion			BIGINT(12);
	DECLARE Var_DescripcionModificacion		VARCHAR(3000);
	DECLARE Var_TipoAlerta					INT(11);
	DECLARE Var_DescripcionAlerta			VARCHAR(3000);
	DECLARE Var_RutaArchivo					VARCHAR(1000);
    DECLARE Var_NuemRegEval					INT(11);
    
	-- DECLARACION DE CONSTANTES
	DECLARE	Cadena_Vacia	CHAR(1);
	DECLARE	Fecha_Vacia		DATE;
	DECLARE	Entero_Cero		INT(11);
	DECLARE	ContanteSI		CHAR(1);
	
    -- ASIGNACION DE CONSTANTES 
	SET	Cadena_Vacia	:= '';
	SET	Fecha_Vacia		:= '1900-01-01';
	SET	Entero_Cero		:= 0;
	SET	ContanteSI		:='S';
    SET Var_FechaTran 	:= DATE_SUB(Par_FechaReporte,INTERVAL '0-6' YEAR_MONTH);
    SET Var_MesRep		:= (SELECT MAX(IFNULL(Mes, Entero_Cero)) FROM HISPLDOPERVULNERABLES WHERE Anio=Par_anio);
    SET Var_MesRep 		:= IFNULL(Var_MesRep, '-1');
	
    SELECT (IFNULL(SalMinDFReal, 0)* IFNULL(VecesSalMinVig,0)) INTO Var_OperMax 
		FROM PARAMETROSSIS
        WHERE EmpresaID=1;
    
    SET Var_OperMax := IFNULL(Var_OperMax,0);
    
    
    SELECT 	InstitucionID,					ClaveEntidadColegiada,			ClaveSujetoObligado,
			ClaveActividad,					Exento,							DominioPlataforma,
			ReferenciaAviso,				Prioridad,						FolioModificacion,
			DescripcionModificacion,		TipoAlerta,						DescripcionAlerta,
			RutaArchivo
	INTO	Var_InstitucionID,				Var_ClaveEntidadColegiada,		Var_ClaveSujetoObligado,
			Var_ClaveActividad,				Var_Exento,						Var_DominioPlataforma,
			Var_ReferenciaAviso,			Var_Prioridad,					Var_FolioModificacion,
			Var_DescripcionModificacion,	Var_TipoAlerta,					Var_DescripcionAlerta,
			Var_RutaArchivo
    FROM CATPLDOPERVULNERABLES
    WHERE InstitucionID = Par_InstitucionID;
    
    
    DROP TABLE IF EXISTS TMP_CUENTASAHOMOV;
    CREATE TEMPORARY TABLE TMP_CUENTASAHOMOV(
        ClienteID     		INT(11),
        CuentaAhoID     	BIGINT(11),
        CantidadMovC     	DECIMAL(16,2),
        CantidadMovA     	DECIMAL(16,2),
        TipoMovAhoID    	CHAR(4),
        MonedaID			INT(11),
        FechaOper			DATE,
        Anio 				INT(11),
        Mes					INT(11),
        PRIMARY KEY(ClienteID,CuentaAhoID)
    );
    
 	INSERT INTO TMP_CUENTASAHOMOV
		SELECT 	MAX(CTA.ClienteID),
				MAX(CTA.CuentaAhoID), 
				SUM(CASE MOV.NatMovimiento WHEN "C" THEN MOV.CantidadMov ELSE Entero_Cero END) , 
				SUM(CASE MOV.NatMovimiento WHEN "A" THEN MOV.CantidadMov ELSE Entero_Cero END) , 
                MAX(MOV.TipoMovAhoID), 
                MAX(MOV.MonedaID),
                MAX(MOV.Fecha),
                MAX(Par_anio),
                MAX(Par_Mes)
		FROM CUENTASAHO CTA
		INNER JOIN CUENTASAHOMOV MOV ON MOV.CuentaAhoID = CTA.CuentaAhoID 
		WHERE CTA.EsPrincipal = "S" AND CTA.Estatus = 'A'
		GROUP BY MOV.CuentaAhoID;
  
	SELECT COUNT(TMP.FechaOper) 
		INTO Var_NuemRegEval
		FROM TMP_CUENTASAHOMOV TMP
		LEFT JOIN HISPLDOPERVULNERABLES HIS ON TMP.CuentaAhoID = HIS.CuentaRelacionada 
		AND HIS.ClienteID=TMP.ClienteID OR HIS.ClienteID IS NULL OR HIS.CuentaRelacionada IS NULL
	WHERE Par_Mes > Var_MesRep AND Var_MesRep > IFNULL(HIS.Mes, '-2') 
	AND (Var_FechaTran < IFNULL(HIS.FechaReporto, Par_FechaReporte))
	AND TMP.CantidadMovC >=Var_OperMax
	AND TMP.Anio = Par_anio  
	AND TMP.Mes=Par_Mes;
    
    IF(Var_NuemRegEval > 0)THEN    
		-- VALIDACION  QUE CUMPLA CON EL MONTO Y QUE NO SE REPITA EL CLIENTE SI YA FUE REPORTADO
		 INSERT INTO HISPLDOPERVULNERABLES 
					(Anio,						Mes,						FechaReporto,					ClienteID,					CuentaRelacionada, 	
					FechaHoraOperacionFR,		MonedaOperacionFR,			MontoOperacionFR,				ClaveEntidadColegiada,		ClaveSujetoObligado,
					ClaveActividad,				Exento,						DominioPlataforma,				ReferenciaAviso,			Prioridad,
					FolioModificacion,			DescripcionModificacion,	TipoAlerta,						DescripcionAlerta)
			
            SELECT 	Par_anio, 					Par_Mes,					Par_FechaReporte, 				TMP.ClienteID, 				TMP.CuentaAhoID,	
					TMP.FechaOper,				TMP.MonedaID,				TMP.CantidadMovC,				Var_ClaveEntidadColegiada,	Var_ClaveSujetoObligado,
                    Var_ClaveActividad,			Var_Exento,					Var_DominioPlataforma,			Var_ReferenciaAviso,		Var_Prioridad,
                    Var_FolioModificacion,		Var_DescripcionModificacion,Var_TipoAlerta,					Var_DescripcionAlerta
				FROM TMP_CUENTASAHOMOV TMP
				LEFT JOIN HISPLDOPERVULNERABLES HIS ON TMP.CuentaAhoID = HIS.CuentaRelacionada 
				AND HIS.ClienteID=TMP.ClienteID OR HIS.ClienteID IS NULL OR HIS.CuentaRelacionada IS NULL
			WHERE Par_Mes > Var_MesRep AND Var_MesRep > IFNULL(HIS.Mes, '-2') 
			AND (Var_FechaTran < IFNULL(HIS.FechaReporto, Par_FechaReporte))
			AND TMP.CantidadMovC >=Var_OperMax
			AND TMP.Anio = Par_anio  
			AND TMP.Mes=Par_Mes;

		-- ACTUALIZACION DE DATOS DEL CLIENTE
		UPDATE HISPLDOPERVULNERABLES HIS
		INNER JOIN CLIENTES CLI ON HIS.ClienteID=CLI.ClienteID
		LEFT JOIN DIRECCLIENTE DIR ON DIR.ClienteID=CLI.ClienteID AND DIR.Oficial="S"
		LEFT JOIN CUENTASAHO CUE ON CUE.ClienteID = CLI.ClienteID AND HIS.CuentaRelacionada=CUE.CuentaAhoID
		LEFT JOIN PAISES PAI ON PAI.PaisID= CLI.PaisNacionalidad
			SET HIS.ClaveEntidadColegiada   =   Cadena_Vacia,
				HIS.ClaveSujetoObligado     =   Cadena_Vacia,
				HIS.ClaveActividad          =   Cadena_Vacia,
				HIS.Exento                  =   Entero_Cero,
				HIS.DominioPlataforma       =   Cadena_Vacia,
				HIS.ReferenciaAviso         =   Entero_Cero,
				HIS.Prioridad               =   Entero_Cero,
				HIS.FolioModificacion       =   Entero_Cero,
				HIS.DescripcionModificacion =   Cadena_Vacia,
				HIS.TipoAlerta              =   Entero_Cero,
				HIS.DescripcionAlerta       =   Cadena_Vacia,
				-- FIN PENDIETE DE VALIDAR
				HIS.CuentaRelacionada       =   CUE.CuentaAhoID,
				HIS.ClabeInterbancaria      =   CUE.Clabe,
				HIS.MonedaCuenta            =   CUE.MonedaID,
				HIS.NombrePF                =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.SoloNombres ELSE Cadena_Vacia END,
				HIS.ApellidoPaternoPF       =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.ApellidoPaterno ELSE Cadena_Vacia END,
				HIS.ApellidoMaternoPF       =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.ApellidoMaterno ELSE Cadena_Vacia END,
				HIS.FechaNacimientoPF       =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.FechaNacimiento ELSE Fecha_Vacia END,
				HIS.RFCPF                   =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.RFCOficial ELSE Cadena_Vacia END,
				HIS.CURPPF                  =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.RFC ELSE Cadena_Vacia END,
				HIS.PaisNacionalidadPF      =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN PAI.ClaveCNBV ELSE Cadena_Vacia END,
				HIS.DenominacionRazonPM     =   CASE WHEN IFNULL(CLI.TipoPersona, "F") != "F" THEN CLI.NombreCompleto ELSE Cadena_Vacia END,
				HIS.FechaConstitucionPM     =   CASE WHEN IFNULL(CLI.TipoPersona, "F") != "F" THEN CLI.FechaConstitucion ELSE Fecha_Vacia END,
				HIS.RFCPM                   =   CASE WHEN IFNULL(CLI.TipoPersona, "F") != "F" THEN CLI.RFCpm ELSE Cadena_Vacia END,
				HIS.PaisNacionalidadPM      =   CASE WHEN IFNULL(CLI.TipoPersona, "F") != "F" THEN PAI.ClaveCNBV ELSE Cadena_Vacia END,
				HIS.ColoniaN                =   CASE CLI.Nacion WHEN "N" THEN DIR.Colonia ELSE Cadena_Vacia END,
				HIS.CalleN                  =   CASE CLI.Nacion WHEN "N" THEN DIR.Calle ELSE Cadena_Vacia END,
				HIS.NumeroExteriorN         =   CASE CLI.Nacion WHEN "N" THEN IFNULL(DIR.NumeroCasa, Cadena_Vacia) ELSE Cadena_Vacia END,
				HIS.NumeroInteriorN         =   CASE CLI.Nacion WHEN "N" THEN IFNULL(DIR.NumInterior, Cadena_Vacia) ELSE Cadena_Vacia END,
				HIS.CodigoPostalN           =   CASE CLI.Nacion WHEN "N" THEN DIR.CP ELSE Cadena_Vacia END,
				HIS.PaisE                   =   CASE CLI.Nacion WHEN "E" THEN IFNULL(PAI.Nombre, Cadena_Vacia) ELSE Cadena_Vacia END,
				HIS.ClavePaisPer            =   IFNULL(PAI.ClaveCNBV,Cadena_Vacia),
				HIS.NumeroTelefonoPer       =   CASE WHEN IFNULL(CLI.TelefonoCelular, Cadena_Vacia) !=Cadena_Vacia THEN CLI.TelefonoCelular 
													 WHEN IFNULL(CLI.TelTrabajo, Cadena_Vacia) !=Cadena_Vacia THEN CLI.TelTrabajo 
													 WHEN IFNULL(CLI.Telefono, Cadena_Vacia) !=Cadena_Vacia THEN CLI.Telefono 
												ELSE Cadena_Vacia END,
				HIS.CorreoElectronicoPer    =   IFNULL(CLI.Correo, Cadena_Vacia),
				HIS.Nacionalidad            =   IFNULL(CLI.Nacion,Cadena_Vacia),
				-- PENDIENTES DE VALIDAR
				HIS.NombreFRPF              =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.SoloNombres ELSE Cadena_Vacia END,
				HIS.ApellidoPaternoFRPF     =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.ApellidoPaterno ELSE Cadena_Vacia END,
				HIS.ApellidoMaternoFRPF     =   CASE WHEN CLI.TipoPersona="F" OR CLI.TipoPersona="A" THEN CLI.ApellidoMaterno ELSE Cadena_Vacia END,
				HIS.DenominacionRazonFRPF   =   CASE WHEN CLI.TipoPersona="M" THEN CLI.RazonSocial ELSE Cadena_Vacia END,
				HIS.ClabeDestinoFRN     	=	IFNULL(CUE.Clabe, Cadena_Vacia)
			WHERE HIS.Anio = Par_anio  
			AND HIS.Mes=Par_Mes;
		   

		-- ACTUALIZAMOS LOS DATOS DE LA IDENTIFICACION
		UPDATE HISPLDOPERVULNERABLES HIS
		INNER JOIN IDENTIFICLIENTE IDE ON IDE.ClienteID=HIS.ClienteID AND IDE.Oficial=ContanteSI
		INNER JOIN CLIENTES CLI ON CLI.ClienteID = HIS.ClienteID
		SET HIS.TipoIdentificacionPF = IDE.TipoIdentiID,
			HIS.NumeroIdentificacionPF = IDE.NumIdentific
		WHERE CLI.TipoPersona = "F"
		AND HIS.Anio = Par_anio  
		AND HIS.Mes=Par_Mes;
        
		-- ACTUALIZAMOS LOS DATOS DEL REPRESENTANTE LEGAL
		UPDATE HISPLDOPERVULNERABLES HIS
		INNER JOIN CUENTASPERSONA CTA ON CTA.CuentaAhoID = HIS.CuentaRelacionada
		LEFT JOIN PAISES PAI ON PAI.PaisID = CTA.PaisRFC
		SET HIS.NombreRL 			  = TRIM(CONCAT(IFNULL(CTA.PrimerNombre,''), " ", IFNULL(CTA.SegundoNombre,'')," ", IFNULL(CTA.TercerNombre,''))),
			HIS.ApellidoPaternoRL     = IFNULL(CTA.ApellidoPaterno,Cadena_Vacia),
			HIS.ApellidoMaternoRL 	  =	IFNULL(CTA.ApellidoMaterno,Cadena_Vacia),
			HIS.FechaNacimientoRL     = IFNULL(CTA.FechaNac,Cadena_Vacia),
			HIS.RFCRL 			 	  = IFNULL(CTA.RFC,Cadena_Vacia),
			HIS.CURPRL	 		 	  = IFNULL(CTA.CURP,Cadena_Vacia),
			HIS.PaisNacionalidadDuePF = IFNULL(PAI.ClaveCNBV,Cadena_Vacia)
		WHERE IFNULL(CTA.EsApoderado, 'N') = 'S'
        AND HIS.Anio = Par_anio  
		AND HIS.Mes=Par_Mes;
        
        -- ACTUALIZAMOS LOS BENEFICIARIOS DE LA CUENTA
		UPDATE HISPLDOPERVULNERABLES HIS
		INNER JOIN CUENTASPERSONA CTA ON CTA.CuentaAhoID = HIS.CuentaRelacionada
		LEFT JOIN PAISES PAI ON PAI.PaisID = CTA.PaisRFC
		SET HIS.NombreDuePF = TRIM(CONCAT(IFNULL(CTA.PrimerNombre,''), " ", IFNULL(CTA.SegundoNombre,'')," ", IFNULL(CTA.TercerNombre,''))),
			HIS.ApellidoPaternoDuePF = 	IFNULL(CTA.ApellidoPaterno,Cadena_Vacia),
			HIS.ApellidoMaternoDuePF =	IFNULL(CTA.ApellidoMaterno,Cadena_Vacia),
			HIS.FechaNacimientoDuePF = 	IFNULL(CTA.FechaNac,Cadena_Vacia),
			HIS.RFCDuePF 			 = 	IFNULL(CTA.RFC,Cadena_Vacia),
			HIS.CURPDuePF	 		 = 	IFNULL(CTA.CURP,Cadena_Vacia),
			HIS.PaisNacionalidadDuePF = IFNULL(PAI.ClaveCNBV,Cadena_Vacia)
		WHERE IFNULL(CTA.EsBeneficiario, 'N') = 'S'
        AND HIS.Anio = Par_anio  
		AND HIS.Mes=Par_Mes;
		

		-- ACTUALIZAMOS LOS DATOS DE PERSONA EXTRANJERA
		UPDATE HISPLDOPERVULNERABLES HIS
		INNER JOIN CLIEXTRANJERO EXT ON EXT.ClienteID = HIS.ClienteID
		LEFT JOIN PAISES PAI ON PAI.PaisID = EXT.PaisRFC
		SET HIS.EstadoProvinciaE = EXT.Entidad,
			HIS.CiudadPoblacionE = EXT.Localidad,
			HIS.ColoniaE = EXT.Colonia,
			HIS.CalleE = EXT.Calle,
			HIS.NumeroExteriorE = EXT.NumeroCasa,
			HIS.NumeroInteriorE = EXT.NumeroIntCasa,
			HIS.CodigoPostalE = EXT.Adi_CoPoEx,
			HIS.ClavePaisPer = EXT.PaisRFC,
			HIS.ClavePaisPer = PAI.ClaveCNBV
		WHERE HIS.Nacionalidad = 'E'
		AND HIS.Anio = Par_anio  
		AND HIS.Mes=Par_Mes;
        
        
		SELECT 	IFNULL(Anio,Cadena_Vacia) AS Anio,
				CONCAT(IFNULL(Anio,0), CASE  WHEN  IFNULL(Mes,0)<10 THEN CONCAT("0",Mes) ELSE Mes END ) AS Mes,
				CASE WHEN IFNULL(FechaReporto,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaReporto,Cadena_Vacia) ELSE Cadena_Vacia END  AS FechaReporto,
				IFNULL(ClaveEntidadColegiada,Cadena_Vacia) AS ClaveEntidadColegiada,
				IFNULL(ClaveSujetoObligado,Cadena_Vacia) AS ClaveSujetoObligado,
				IFNULL(ClaveActividad,Cadena_Vacia) AS ClaveActividad,
				IFNULL(Exento,Cadena_Vacia) AS  Exento,
				IFNULL(DominioPlataforma,Cadena_Vacia) AS DominioPlataforma,
				IFNULL(ReferenciaAviso,Cadena_Vacia) AS ReferenciaAviso,
				IFNULL(Prioridad,Cadena_Vacia) AS Prioridad,
				IFNULL(FolioModificacion,Cadena_Vacia) AS FolioModificacion,
				IFNULL(DescripcionModificacion,Cadena_Vacia) AS DescripcionModificacion,
				IFNULL(TipoAlerta,Cadena_Vacia) AS  TipoAlerta,
				IFNULL(DescripcionAlerta,Cadena_Vacia) AS DescripcionAlerta,
				IFNULL(ClienteID,Cadena_Vacia) AS ClienteID,
				IFNULL(CuentaRelacionada,Cadena_Vacia) AS CuentaRelacionada,
				IFNULL(ClabeInterbancaria,Cadena_Vacia) AS ClabeInterbancaria,
				IFNULL(MonedaCuenta,Cadena_Vacia) AS MonedaCuenta,
				IFNULL(NombrePF,Cadena_Vacia) AS  NombrePF,
				IFNULL(ApellidoPaternoPF,Cadena_Vacia) AS ApellidoPaternoPF,
				IFNULL(ApellidoMaternoPF,Cadena_Vacia) AS ApellidoMaternoPF,
				CASE WHEN IFNULL(FechaNacimientoPF,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaNacimientoPF,Cadena_Vacia) ELSE Cadena_Vacia END AS FechaNacimientoPF,
				IFNULL(RFCPF,Cadena_Vacia) AS RFCPF,
				IFNULL(CURPPF,Cadena_Vacia) AS  CURPPF,
				IFNULL(PaisNacionalidadPF,Cadena_Vacia) AS  PaisNacionalidadPF,
				IFNULL(ActividadEconomicaPF,Cadena_Vacia) AS ActividadEconomicaPF,
				IFNULL(TipoIdentificacionPF,Cadena_Vacia) AS TipoIdentificacionPF,
				IFNULL(NumeroIdentificacionPF,Cadena_Vacia) AS NumeroIdentificacionPF,
				IFNULL(DenominacionRazonPM,Cadena_Vacia) AS DenominacionRazonPM,
				CASE WHEN IFNULL(FechaConstitucionPM,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaConstitucionPM,Cadena_Vacia) ELSE Cadena_Vacia END AS FechaConstitucionPM,
				IFNULL(RFCPM,Cadena_Vacia) AS RFCPM,
				IFNULL(PaisNacionalidadPM,Cadena_Vacia) AS  PaisNacionalidadPM,
				IFNULL(GiroMercantilPM,Cadena_Vacia) AS GiroMercantilPM,
				IFNULL(NombreRL,Cadena_Vacia) AS  NombreRL,
				IFNULL(ApellidoPaternoRL,Cadena_Vacia) AS ApellidoPaternoRL,
				IFNULL(ApellidoMaternoRL,Cadena_Vacia) AS ApellidoMaternoRL,
				CASE WHEN IFNULL(FechaNacimientoRL,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaNacimientoRL,Cadena_Vacia) ELSE Cadena_Vacia END AS FechaNacimientoRL,
				IFNULL(RFCRL,Cadena_Vacia) AS RFCRL,
				IFNULL(CURPRL,Cadena_Vacia) AS  CURPRL,
				IFNULL(TipoIdentificacionRL,Cadena_Vacia) AS  TipoIdentificacionRL,
				IFNULL(NumeroIdentificacionRL,Cadena_Vacia) AS NumeroIdentificacionRL,
				IFNULL(DenominacionRazonFedi,Cadena_Vacia) AS DenominacionRazonFedi,
				IFNULL(RFCFedi,Cadena_Vacia) AS RFCFedi,
				IFNULL(FideicomisoIDFedi,Cadena_Vacia) AS FideicomisoIDFedi,
				IFNULL(NombreApo,Cadena_Vacia) AS NombreApo,
				IFNULL(ApellidoPaternoApo,Cadena_Vacia) AS  ApellidoPaternoApo,
				IFNULL(ApellidoMaternoApo,Cadena_Vacia) AS  ApellidoMaternoApo,
				CASE WHEN IFNULL(FechaNacimientoApo,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaNacimientoApo,Cadena_Vacia) ELSE Cadena_Vacia END AS  FechaNacimientoApo,
				IFNULL(RFCApo,Cadena_Vacia) AS  RFCApo,
				IFNULL(CURPApo,Cadena_Vacia) AS CURPApo,
				IFNULL(TipoIdentificacionApo,Cadena_Vacia) AS TipoIdentificacionApo,
				IFNULL(NumeroIdentificacionApo,Cadena_Vacia) AS NumeroIdentificacionApo,
				IFNULL(ColoniaN,Cadena_Vacia) AS  ColoniaN,
				IFNULL(CalleN,Cadena_Vacia) AS  CalleN,
				IFNULL(NumeroExteriorN,Cadena_Vacia) AS NumeroExteriorN,
				IFNULL(NumeroInteriorN,Cadena_Vacia) AS NumeroInteriorN,
				IFNULL(CodigoPostalN,Cadena_Vacia) AS CodigoPostalN,
				IFNULL(PaisE,Cadena_Vacia) AS PaisE,
				IFNULL(EstadoProvinciaE,Cadena_Vacia) AS  EstadoProvinciaE,
				IFNULL(CiudadPoblacionE,Cadena_Vacia) AS  CiudadPoblacionE,
				IFNULL(ColoniaE,Cadena_Vacia) AS  ColoniaE,
				IFNULL(CalleE,Cadena_Vacia) AS  CalleE,
				IFNULL(NumeroExteriorE,Cadena_Vacia) AS NumeroExteriorE,
				IFNULL(NumeroInteriorE,Cadena_Vacia) AS NumeroInteriorE,
				IFNULL(CodigoPostalE,Cadena_Vacia) AS CodigoPostalE,
				IFNULL(ClavePaisPer,Cadena_Vacia) AS  ClavePaisPer,
				IFNULL(NumeroTelefonoPer,Cadena_Vacia) AS NumeroTelefonoPer,
				IFNULL(CorreoElectronicoPer,Cadena_Vacia) AS  CorreoElectronicoPer,
				IFNULL(NombreDuePF,Cadena_Vacia) AS NombreDuePF,
				IFNULL(ApellidoPaternoDuePF,Cadena_Vacia) AS  ApellidoPaternoDuePF,
				IFNULL(ApellidoMaternoDuePF,Cadena_Vacia) AS ApellidoMaternoDuePF,
				CASE WHEN IFNULL(FechaNacimientoDuePF,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaNacimientoDuePF,Cadena_Vacia) ELSE Cadena_Vacia END  AS FechaNacimientoDuePF,
				IFNULL(RFCDuePF,Cadena_Vacia) AS  RFCDuePF,
				IFNULL(CURPDuePF,Cadena_Vacia) AS CURPDuePF,
				IFNULL(PaisNacionalidadDuePF,Cadena_Vacia) AS PaisNacionalidadDuePF,
				IFNULL(DenominacionRazonDuePM,Cadena_Vacia) AS  DenominacionRazonDuePM,
				CASE WHEN IFNULL(FechaConstitucionDuePM,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaConstitucionDuePM,Cadena_Vacia) ELSE Cadena_Vacia END AS FechaConstitucionDuePM,
				IFNULL(RFCDuePM,Cadena_Vacia) AS  RFCDuePM,
				IFNULL(PaisNacionalidadDuePM,Cadena_Vacia) AS PaisNacionalidadDuePM,
				IFNULL(DenominacionRazonDueFid,Cadena_Vacia) AS DenominacionRazonDueFid,
				IFNULL(RFCDueFid,Cadena_Vacia) AS RFCDueFid,
				IFNULL(FideicomisoIDDueFid,Cadena_Vacia) AS FideicomisoIDDueFid,
				CASE WHEN IFNULL(FechaHoraOperacionCom,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaHoraOperacionCom,Cadena_Vacia) ELSE Cadena_Vacia END  AS FechaHoraOperacionCom,
				IFNULL(MonedaOperacionCom,Cadena_Vacia) AS  MonedaOperacionCom,
				IFNULL(MontoOperacionCom,Cadena_Vacia) AS MontoOperacionCom,
				IFNULL(ActivoVirtualOperadoAV,Cadena_Vacia) AS  ActivoVirtualOperadoAV,
				IFNULL(DescripcionActivoVirtualAV,Cadena_Vacia) AS DescripcionActivoVirtualAV,
				IFNULL(TipoCambioMnAV,Cadena_Vacia) AS  TipoCambioMnAV,
				IFNULL(CantidadActivoVirtualAV,Cadena_Vacia) AS CantidadActivoVirtualAV,
				IFNULL(HashOperacionAV,Cadena_Vacia) AS HashOperacionAV,
				CASE WHEN IFNULL(FechaHoraOperacionV,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaHoraOperacionV,Cadena_Vacia) ELSE Cadena_Vacia END AS FechaHoraOperacionV,
				IFNULL(MonedaOperacionV,Cadena_Vacia) AS  MonedaOperacionV,
				IFNULL(MontoOperacionV,Cadena_Vacia) AS MontoOperacionV,
				IFNULL(ActivoVirtualOperadoVAV,Cadena_Vacia) AS ActivoVirtualOperadoVAV,
				IFNULL(DescripcionActivoVirtualVAV,Cadena_Vacia) AS DescripcionActivoVirtualVAV,
				IFNULL(TipoCambioMnVAV,Cadena_Vacia) AS TipoCambioMnVAV,
				IFNULL(CantidadActivoVirtualVAV,Cadena_Vacia) AS CantidadActivoVirtualVAV,
				IFNULL(HashOperacionVAV,Cadena_Vacia) AS  HashOperacionVAV,
				CASE WHEN IFNULL(FechaHoraOperacionOI,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaHoraOperacionOI,Cadena_Vacia) ELSE Cadena_Vacia END  AS FechaHoraOperacionOI,
				IFNULL(ActivoVirtualOperadoOIAV,Cadena_Vacia) AS  ActivoVirtualOperadoOIAV,
				IFNULL(DescripcionActivoVirtualOIAV,Cadena_Vacia) AS DescripcionActivoVirtualOIAV,
				IFNULL(TipoCambioMnOIAV,Cadena_Vacia) AS  TipoCambioMnOIAV,
				IFNULL(CantidadActivoVirtualOIAV,Cadena_Vacia) AS CantidadActivoVirtualOIAV,
				IFNULL(MontoOperacionMnOIAV,Cadena_Vacia) AS  MontoOperacionMnOIAV,
				IFNULL(ActivoVirtualOperadoOIAR,Cadena_Vacia) AS  ActivoVirtualOperadoOIAR,
				IFNULL(DescripcionActivoVirtualOIAR,Cadena_Vacia) AS  DescripcionActivoVirtualOIAR,
				IFNULL(TipoCambioMnOIAR,Cadena_Vacia) AS  TipoCambioMnOIAR,
				IFNULL(CantidadActivoVirtualOIAR,Cadena_Vacia) AS CantidadActivoVirtualOIAR,
				IFNULL(MontoOperacionMnOIAR,Cadena_Vacia) AS MontoOperacionMnOIAR,
				IFNULL(HashOperacionOIAR,Cadena_Vacia) AS HashOperacionOIAR,
				CASE WHEN IFNULL(FechaHoraOperacionOTE,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaHoraOperacionOTE,Cadena_Vacia) ELSE Cadena_Vacia END  AS FechaHoraOperacionOTE,
				IFNULL(MontoOperacionMnOTE,Cadena_Vacia) AS MontoOperacionMnOTE,
				IFNULL(ActivoVirtualOperadoOTAV,Cadena_Vacia) AS ActivoVirtualOperadoOTAV,
				IFNULL(DescripcionActivoVirtualOTAV,Cadena_Vacia) AS  DescripcionActivoVirtualOTAV,
				IFNULL(TipoCambioMnOTAV,Cadena_Vacia) AS TipoCambioMnOTAV,
				IFNULL(CantidadActivoVirtualOTAV,Cadena_Vacia) AS CantidadActivoVirtualOTAV,
				IFNULL(HashOperacionOTAV,Cadena_Vacia) AS HashOperacionOTAV,
				CASE WHEN IFNULL(FechaHoraOperacionTR,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaHoraOperacionTR,Cadena_Vacia) ELSE Cadena_Vacia END AS  FechaHoraOperacionTR,
				IFNULL(MontoOperacionMnTR,Cadena_Vacia) AS MontoOperacionMnTR,
				IFNULL(ActivoVirtualOperadoTRA,Cadena_Vacia) AS ActivoVirtualOperadoTRA,
				IFNULL(DescripcionActivoVirtualTRA,Cadena_Vacia) AS DescripcionActivoVirtualTRA,
				IFNULL(TipoCambioMnTRA,Cadena_Vacia) AS TipoCambioMnTRA,
				IFNULL(CantidadActivoVirtualTRA,Cadena_Vacia) AS CantidadActivoVirtualTRA,
				IFNULL(HashOperacionTRA,Cadena_Vacia) AS  HashOperacionTRA,
				CASE WHEN IFNULL(FechaHoraOperacionFR,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaHoraOperacionFR,Cadena_Vacia) ELSE Cadena_Vacia END  AS FechaHoraOperacionFR,
				IFNULL(InstrumentoMonetarioFR,Cadena_Vacia) AS  InstrumentoMonetarioFR,
				IFNULL(MonedaOperacionFR,Cadena_Vacia) AS MonedaOperacionFR,
				IFNULL(MontoOperacionFR,Cadena_Vacia) AS  MontoOperacionFR,
				IFNULL(NombreFRPF,Cadena_Vacia) AS  NombreFRPF,
				IFNULL(ApellidoPaternoFRPF,Cadena_Vacia) AS ApellidoPaternoFRPF,
				IFNULL(ApellidoMaternoFRPF,Cadena_Vacia) AS ApellidoMaternoFRPF,
				IFNULL(DenominacionRazonFRPF,Cadena_Vacia) AS DenominacionRazonFRPF,
				IFNULL(ClabeDestinoFRN,Cadena_Vacia) AS ClabeDestinoFRN,
				IFNULL(ClaveInstitucionFinancieraFRN,Cadena_Vacia) AS ClaveInstitucionFinancieraFRN,
				IFNULL(NumeroCuentaFRE,Cadena_Vacia) AS NumeroCuentaFRE,
				IFNULL(NombreBancoFRE,Cadena_Vacia) AS  NombreBancoFRE,
				CASE WHEN IFNULL(FechaHoraOperacionFD,Cadena_Vacia)!=Fecha_Vacia THEN IFNULL(FechaHoraOperacionFD,Cadena_Vacia) ELSE Cadena_Vacia END AS FechaHoraOperacionFD,
				IFNULL(InstrumentoMonetarioFD,Cadena_Vacia) AS  InstrumentoMonetarioFD,
				IFNULL(MonedaOperacionFD,Cadena_Vacia) AS  MonedaOperacionFD,
				IFNULL(MontoOperacionFD,Cadena_Vacia) AS MontoOperacionFD,
				IFNULL(NombreFDPF,Cadena_Vacia) AS  NombreFDPF,
				IFNULL(ApellidoPaternoFDPF,Cadena_Vacia) AS ApellidoPaternoFDPF,
				IFNULL(ApellidoMaternoFDPF,Cadena_Vacia) AS ApellidoMaternoFDPF,
				IFNULL(DenominacionRazonFDPM,Cadena_Vacia) AS DenominacionRazonFDPM,
				IFNULL(ClabeDestinoFDN,Cadena_Vacia) AS ClabeDestinoFDN,
				IFNULL(ClaveInstitucionFinancieraFDN,Cadena_Vacia) AS ClaveInstitucionFinancieraFDN,
				IFNULL(NumeroCuentaFDE,Cadena_Vacia) AS NumeroCuentaFDE,
				IFNULL(NombreBancoFDE,Cadena_Vacia) AS  NombreBancoFDE,
				IFNULL(Nacionalidad,Cadena_Vacia) AS  Nacionalidad
		FROM HISPLDOPERVULNERABLES
		WHERE Mes = Par_Mes
		AND Anio = Par_anio
		AND FechaReporto = Par_FechaReporte
		ORDER BY ClienteID;
    
    END IF;
        


    
    
END TerminaStore$$
