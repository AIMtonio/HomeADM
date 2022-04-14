-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSCTE024PRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADATOSCTE024PRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTADATOSCTE024PRO`(
	-- SP para obtener los Datos del Cliente
    Par_AnioMes    		 	INT(11),		-- Anio y Mes Estado Cuenta
	Par_IniMes				DATE,			-- Fecha Inicio Mes
	Par_FinMes				DATE,			-- Fecha Fin Mes
	Par_ClienteInstitu		INT(11)			-- Cliente Institucion
	)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE	Var_NombreInstit		VARCHAR(150);		-- Almacena el nombre de la institucion
	DECLARE	Var_DireccionInstit		VARCHAR(200);		-- Almacena la direccion de la institucion
	DECLARE	Var_NumInstitucion		INT(11);			-- Almacena el numero de la institucion

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia	VARCHAR(1);			-- Cadena Vacia
	DECLARE	Fecha_Vacia		DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero		INT(11);			-- Entero Cero
	DECLARE	Moneda_Cero		INT(11);			-- Decimal Cero
	DECLARE NoProcesado		INT(11);			-- Numero Proceso: 1


	DECLARE NoEsMenorEdad   CHAR(1);			-- Cliente Menor Edad: NO
	DECLARE EstatusActivo	CHAR(1);			-- Estatus Cliente: ACTIVO
	DECLARE EstatusInactivo CHAR(1);			-- Estatus Cliente: INACTIVO
	DECLARE PersonaFisica	CHAR(1);			-- Tipo Persona: FISICA
	DECLARE PersonaMoral	CHAR(1);			-- Tipo Persona: MORAL

	DECLARE PerActivEmp		CHAR(1);			-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL
	DECLARE EsRegHacienda	CHAR(1);			-- Registro Hacienda: SI
	DECLARE EsFiscal		CHAR(1);			-- Direccion Fiscal: SI
	DECLARE EsOficial	    CHAR(1);			-- Direccion Oficial: SI
	DECLARE NoEsSuperTasas	CHAR(1);			-- Cliente de SuperTasas: NO
	DECLARE ConstanteNO		CHAR(1);			-- Constante NO

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';				-- Cadena Vacia
	SET Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero			:= 0;				-- Entero Cero
	SET Moneda_Cero			:= 0.00;			-- Decimal Cero
	SET NoProcesado			:= 1; 				-- Numero Proceso: 1

	SET NoEsMenorEdad		:='N';				-- Cliente Menor Edad: NO
	SET EstatusActivo		:='A';				-- Estatus Cliente: ACTIVO
	SET EstatusInactivo		:='I';				-- Estatus Cliente: INACTIVO
	SET PersonaFisica		:= 'F';				-- Tipo Persona: FISICA
	SET PersonaMoral		:= 'M';				-- Tipo Persona: MORAL
	SET PerActivEmp			:= 'A';				-- Tipo Persona: FISICA CON ACTIVIDAD EMPRESARIAL

	SET EsRegHacienda		:= 'S';				-- Registro Hacienda: SI
	SET EsFiscal		    := 'S';				-- Direccion Fiscal: SI
	SET EsOficial	    	:= 'S';				-- Direccion Oficial: SI
	SET NoEsSuperTasas		:= 'N';				-- Cliente de SuperTasas: NO
	SET ConstanteNO			:= 'N';				-- Constante NO

	-- Se crea tabla temporal para obtener los datos del cliente
	DROP TABLE IF EXISTS TMPDATOSCTE;
	CREATE TEMPORARY TABLE TMPDATOSCTE(
	`Tmp_Aniome` 		INT(11),
	`Tmp_SucursalID` 	INT(11),
	`Tmp_NombreSuc` 	VARCHAR(60),
	`Tmp_ClienteID` 	INT(11),
	`Tmp_NombreCli`	 	VARCHAR(170) ,
	`Tmp_TipPer`    	CHAR(1),
	`Tmp_TipoCli` 		VARCHAR(50) ,
	`Tmp_Calle`  		VARCHAR(50) ,
	`Tmp_NumeroInt` 	CHAR(15),
	`Tmp_NumeroExt` 	CHAR(15),
	`Tmp_Colonia` 		VARCHAR(200) ,
	`Tmp_MunicipioDel` 	VARCHAR(50),
	`Tmp_Localidad` 	VARCHAR(50),
	`Tmp_Estado` 		VARCHAR(50),
	`Tmp_CodigoPostal` 	CHAR(5),
	`Tmp_RFC` 			VARCHAR(13),
	`Tmp_InstrucEnvio` 	CHAR(1),
	`Tmp_DireccionCompleta` VARCHAR(500),
	`Tmp_RegHacienda`  	CHAR(1),
    `Tmp_CreditoID`  	BIGINT(1),
    `Tmp_ProductoID`  	INT(4)
	);
	CREATE INDEX IDX_TMPDATOSCTE_ANIOMES USING BTREE ON TMPDATOSCTE (Tmp_Aniome);
	CREATE INDEX IDX_TMPDATOSCTE_CLIENTE USING BTREE ON TMPDATOSCTE (Tmp_ClienteID);
	CREATE INDEX IDX_TMPDATOSCTE_SUCURSAL USING BTREE ON TMPDATOSCTE (Tmp_SucursalID);

	-- Se inserta los datos del cliente
	INSERT INTO TMPDATOSCTE
    SELECT Par_AnioMes,
		   CLI.SucursalOrigen,
		   Cadena_Vacia,
		   CLI.ClienteID,
		   CLI.NombreCompleto,
		   CLI.TipoPersona,
		   CASE TipoPersona WHEN PersonaFisica THEN 'FISICA'
							WHEN PersonaMoral THEN 'MORAL'
							WHEN PerActivEmp THEN 'FISICA CON ACTIVIDAD EMPRESARIAL'
									 ELSE CONCAT("No Definido para: ", TipoPersona)
		   END,
		   Cadena_Vacia,
		   Entero_Cero,
		   Entero_Cero,
		   Cadena_Vacia,
		   Cadena_Vacia,
		   Cadena_Vacia,
		   Cadena_Vacia,
		   Entero_Cero,
		   TRIM(CLI.RFCOficial),
		   Cadena_Vacia,
		   Cadena_Vacia,
		   CLI.RegistroHacienda,
           MAX(CRE.CreditoID),
           MAX(CRE.ProductoCreditoID)
	FROM CLIENTES CLI
	LEFT OUTER JOIN CREDITOS CRE ON CRE.ClienteID=CLI.ClienteID
	INNER JOIN EDOCTAFRECTIMXPROD EDO ON EDO.ProducCreditoID = CRE.ProductoCreditoID
	WHERE CLI.FechaAlta <=Par_FinMes
	AND	  CLI.ClienteID <> Par_ClienteInstitu
	AND   CLI.EsMenorEdad= NoEsMenorEdad
	AND  (CLI.Estatus = EstatusActivo OR (CLI.Estatus = EstatusInactivo AND CLI.FechaBaja >= Par_IniMes))
	group by CLI.SucursalOrigen, CLI.ClienteID,  CLI.NombreCompleto, CLI.TipoPersona, CLI.RFCOficial,
			 CLI.RegistroHacienda
	ORDER BY CLI.ClienteID;

	-- Se actualiza el Nombre de la Sucursal del Cliente
	UPDATE TMPDATOSCTE, SUCURSALES
	SET Tmp_NombreSuc = NombreSucurs
	WHERE SucursalID = Tmp_SucursalID;

	-- Se actualiza Direccion del Cliente
	UPDATE TMPDATOSCTE, DIRECCLIENTE Dir, COLONIASREPUB Col
	SET Tmp_Calle = Dir.Calle,
		Tmp_NumeroInt = Dir.NumeroCasa,
		Tmp_NumeroExt = Dir.NumInterior,
		Tmp_Colonia = Col.Asentamiento,
		Tmp_CodigoPostal = Dir.CP,
		Tmp_DireccionCompleta = Dir.DireccionCompleta
	WHERE	Tmp_ClienteID	= Dir.ClienteID
	  AND	CASE WHEN Tmp_RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END
	  AND	Col.ColoniaID	= Dir.ColoniaID
	  AND	Col.EstadoID	= Dir.EstadoID
	  AND	Col.MunicipioID = Dir.MunicipioID;

    -- Se actualiza la direccion oficial del cliente en caso de no tener una direccion fiscal
	UPDATE TMPDATOSCTE, DIRECCLIENTE Dir, COLONIASREPUB Col
	SET Tmp_Calle = Dir.Calle,
		Tmp_NumeroInt = Dir.NumeroCasa,
		Tmp_NumeroExt = Dir.NumInterior,
		Tmp_Colonia = Col.Asentamiento,
		Tmp_CodigoPostal = Dir.CP,
		Tmp_DireccionCompleta = Dir.DireccionCompleta
	WHERE	Tmp_ClienteID	= Dir.ClienteID
	  AND	Tmp_DireccionCompleta = Cadena_Vacia
	  AND   Dir.Oficial = EsOficial
	  AND	Col.ColoniaID	= Dir.ColoniaID
	  AND	Col.EstadoID	= Dir.EstadoID
	  AND	Col.MunicipioID = Dir.MunicipioID;

     -- Se actualiza el Nombre del Estado de la Republica del Cliente
	UPDATE TMPDATOSCTE, DIRECCLIENTE dir, ESTADOSREPUB est
	SET Tmp_Estado = est.Nombre
	WHERE Tmp_ClienteID = dir.ClienteID
	AND  dir.EstadoID = est.EstadoID
	AND	CASE WHEN Tmp_RegHacienda = EsRegHacienda THEN dir.Fiscal = EsFiscal ELSE dir.Oficial = EsOficial END;

    -- Se actualiza el Nombre del Municipio del Cliente
	UPDATE TMPDATOSCTE, DIRECCLIENTE dir, MUNICIPIOSREPUB mun
	SET Tmp_MunicipioDel = mun.Nombre
	WHERE Tmp_ClienteID = dir.ClienteID
	AND  dir.EstadoID = mun.EstadoID
	AND  dir.MunicipioID = mun.MunicipioID
	AND	CASE WHEN Tmp_RegHacienda = EsRegHacienda THEN dir.Fiscal = EsFiscal ELSE dir.Oficial = EsOficial END;

	-- Se obtiene el Numero de INstitucion
	SET	Var_NumInstitucion	:= (SELECT InstitucionID FROM EDOCTAPARAMS);
	SET	Var_NumInstitucion	:= IFNULL(Var_NumInstitucion, Entero_Cero);

	-- Se obtiene el Nombre de la Institucion
	SET Var_NombreInstit := (SELECT Nombre FROM INSTITUCIONES WHERE InstitucionID = Var_NumInstitucion);

     -- Se obtiene la Direccion Fiscal de la Institucion
	SET Var_DireccionInstit := (SELECT DirFiscal FROM INSTITUCIONES WHERE InstitucionID = Var_NumInstitucion);

	-- Se registran los datos del cliente para el estado de cuenta
	INSERT INTO EDOCTADATOSCTE
				(AnioMes, 						SucursalID, 							NombreSucursalCte, 							ClienteID, 								NombreComple,
                 TipPer, 						TipoPersona, 							Calle, 										NumInt, 								NumExt,
                 Colonia, 						MunicipioDelegacion, 					Localidad, 									Estado, 								CodigoPostal,
                 RFC, 							InstrucEnvio, 							DireccionCompleta, 							NombreInstitucion, 						DireccionInstitucion,
                 FechaGeneracion, 				RegHacienda, 							CadenaCFDI, 								ComisionAhorro, 						ComisionCredito,
                 ISR, 							CFDIFechaEmision, 						CFDIVersion, 								CFDINoCertSAT, 							CFDIUUID,
                 CFDIFechaTimbrado, 			CFDISelloCFD, 							CFDISelloSAT, 								CFDICadenaOrig, 						DiasPeriodo,
                 CFDIFechaCertifica, 			CFDINoCertEmisor, 						CFDILugExpedicion, 							Estatus, 								TotalInteres,
                 IvaComisiones, 				Comisiones, 							CadenaCFDIRet, 								CFDINoCertSATRet, 						CFDIUUIDRet,
                 CFDIFechaTimRet, 				CFDISelloCFDRet, 						CFDISelloSATRet, 							CFDICadenaOrigRet, 						CFDIFechaCertRet,
                 CFDINoCertEmiRet, 				CFDILugExpediRet, 						CFDISubTotal,								CFDITotalXML,							EstatusRet,
				 Intereses, 					ProductoCredID,							CFDITotal, 									CreditoID, 								EstatusCadenaProd,
				 PDFGenerado)
	SELECT IFNULL(Tmp_Aniome,Entero_Cero),       IFNULL(Tmp_SucursalID,Entero_Cero),    IFNULL(Tmp_NombreSuc,Cadena_Vacia),      	IFNULL(Tmp_ClienteID,Entero_Cero),      IFNULL(Tmp_NombreCli,Cadena_Vacia),
		   IFNULL(Tmp_TipPer,Cadena_Vacia),      IFNULL(Tmp_TipoCli,Cadena_Vacia),      IFNULL(Tmp_Calle,Cadena_Vacia),          	IFNULL(Tmp_NumeroInt,Entero_Cero),      IFNULL(Tmp_NumeroExt,Entero_Cero),
		   IFNULL(Tmp_Colonia,Cadena_Vacia),     IFNULL(Tmp_MunicipioDel,Cadena_Vacia), IFNULL(Tmp_Localidad,Cadena_Vacia),      	IFNULL(Tmp_Estado,Cadena_Vacia),        IFNULL(Tmp_CodigoPostal,Cadena_Vacia),
		   IFNULL(Tmp_RFC,Cadena_Vacia),         IFNULL(Tmp_InstrucEnvio,Cadena_Vacia), IFNULL(Tmp_DireccionCompleta,Cadena_Vacia), Var_NombreInstit,  			 			Var_DireccionInstit,
		   CURDATE(),	   	 					 IFNULL(Tmp_RegHacienda,Cadena_Vacia),  Cadena_Vacia,       						Moneda_Cero,        					Moneda_Cero,
		   Moneda_Cero,     					 Fecha_Vacia, 	    					Cadena_Vacia, 								Cadena_Vacia, 		 					Cadena_Vacia,
		   Cadena_Vacia,     					 Cadena_Vacia, 	    					Cadena_Vacia, 								Cadena_Vacia, 							Cadena_Vacia,
		   Cadena_Vacia,    					 Cadena_Vacia, 	    					Cadena_Vacia,								NoProcesado,							Moneda_Cero,
		   Moneda_Cero,		 					 Moneda_Cero,							Cadena_Vacia,								Cadena_Vacia,							Cadena_Vacia,
           Cadena_Vacia,						 Cadena_Vacia,							Cadena_Vacia,								Cadena_Vacia,							Cadena_Vacia,
           Cadena_Vacia,						 Cadena_Vacia,							Entero_Cero,								Entero_Cero,							NoProcesado,
		   Moneda_Cero,							 Entero_Cero,							Moneda_Cero,							 	Entero_Cero,							ConstanteNO,
		   ConstanteNO
	FROM TMPDATOSCTE;

	INSERT INTO EDOCTADATOSCTECOM
	SELECT 	IFNULL(Tmp_Aniome,Entero_Cero),		IFNULL(Tmp_SucursalID,Entero_Cero),       IFNULL(Tmp_ClienteID,Entero_Cero),     Cadena_Vacia,   Entero_Cero,
            Cadena_Vacia,			            Entero_Cero,					          Cadena_Vacia,					         NoEsSuperTasas, Entero_Cero,
            IFNULL(Tmp_ProductoID,Entero_Cero),	IFNULL(Tmp_CreditoID,Entero_Cero),
            Entero_Cero,					    Entero_Cero,							  Fecha_Vacia,				             Cadena_Vacia,   Cadena_Vacia,
            Entero_Cero,						Entero_Cero
	FROM TMPDATOSCTE;

	UPDATE EDOCTADATOSCTECOM COM,CUENTASAHO CUE
	SET COM.EsPrincipal = CUE.EsPrincipal,
		COM.CuentaAhoID = CUE.CuentaAhoID,
		COM.Clabe = CUE.Clabe,
		COM.MonedaID = CUE.MonedaID
	WHERE COM.ClienteID = CUE.ClienteID
	  AND CUE.Estatus = EstatusActivo;

	DROP TABLE IF EXISTS TMPDATOSCTE;

END TerminaStore$$
