-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINTERPREOXMLREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINTERPREOXMLREP`;
DELIMITER $$

CREATE PROCEDURE `PLDOPEINTERPREOXMLREP`(

	Par_CategoriaID			INT(11),
	Par_SucursalID			INT(11),
	Par_Nombre				VARCHAR(40),
	Par_NumLis				TINYINT UNSIGNED,

	Par_EmpresaID			INT(11),

	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),

	Aud_NumTransaccion		BIGINT(20)
		)
TerminaStore: BEGIN


DECLARE	Var_FechaSistema			DATE;
DECLARE	Var_PeriodoReporte			INT(11);
DECLARE	Var_OrganoSupervisor		VARCHAR(6);
DECLARE	Var_ClaveCasFim				VARCHAR(7);
DECLARE Var_TipoInstitID   			INT(11);
DECLARE Var_NombreCorto   			VARCHAR(45);


DECLARE	Cadena_Vacia				CHAR(1);
DECLARE	Fecha_Vacia					DATE;
DECLARE	Entero_Cero					INT;
DECLARE	Dato_Desconocido			INT;
DECLARE NacMexicana             	CHAR(2);
DECLARE EstatusVigente             	CHAR(1);

DECLARE TipoRepPREOCUPANTES 	    CHAR(1);
DECLARE InstrumEfectivo 			CHAR(2);
DECLARE RegistroTitularCta 		    CHAR(2);
DECLARE EstatusReportarOperacion    INT(11);
DECLARE ActEconom                   VARCHAR(11);
DECLARE Localid                     VARCHAR(8);
DECLARE MontoCero                   DECIMAL(18,2);
DECLARE LongFolio					INT(11);
DECLARE LongRazonSocial				INT(11);
DECLARE LongNombre					INT(11);
DECLARE LongApMaterno				INT(11);
DECLARE LongDomicilio				INT(11);
DECLARE LongColonia					INT(11);
DECLARE LongLocalidad				INT(11);
DECLARE LongSucursal				INT(11);
DECLARE LongTelefono				INT(11);
DECLARE LongActEconomica6			INT(11);
DECLARE LongActEconomica7			INT(11);
DECLARE LongCuenta					INT(11);
DECLARE LongMoneda					INT(11);
DECLARE Mayusculas					CHAR(2);
DECLARE TipoSocap					INT(11);
DECLARE TipoSofipo					INT(11);
DECLARE TipoSofom					INT(11);


DECLARE	Lis_Principal 		INT;
DECLARE	Lis_Completa 		INT;
DECLARE	Lis_FiltroA	 		INT;
DECLARE	Lis_FiltroB	 		INT;
DECLARE	Lis_EviaArchivo		INT;
DECLARE Lis_OpePreocupan	INT;

DECLARE Var_TipoITF					CHAR(6);
DECLARE Var_PrioridadReporte		CHAR(6);


SET	Cadena_Vacia			:= '';
SET	Fecha_Vacia				:= '1900-01-01';
SET	Entero_Cero				:= 0;
SET Dato_Desconocido		:= 7;
SET NacMexicana        	 	:= '1';
SET ActEconom               := '8949903160';
SET MontoCero               := '00000000000000.00';
SET Localid               	:= '01001002';
SET EstatusVigente         	:= 'V';


SET	Lis_Principal			:= 1;
SET	Lis_Completa			:= 2;
SET	Lis_FiltroA				:= 3;
SET	Lis_FiltroB				:= 4;
SET	Lis_EviaArchivo			:= 5;
SET Lis_OpePreocupan		:= 6;

SET LongFolio					:= 6;
SET LongRazonSocial				:= 125;
SET LongNombre					:= 60;
SET LongApMaterno				:= 30;
SET LongDomicilio				:= 60;
SET LongColonia					:= 30;
SET LongLocalidad				:= 8;
SET LongSucursal				:= 8;
SET LongTelefono				:= 40;
SET LongActEconomica6			:= 6;
SET LongActEconomica7			:= 7;
SET LongCuenta					:= 16;
SET LongMoneda					:= 3;
SET Mayusculas					:= 'MA';
SET TipoSocap     				:= 6;
SET TipoSofipo     				:= 3;
SET TipoSofom     				:= 4;

SET	Var_TipoITF				:= (SELECT TipoITF FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
SET	Var_PrioridadReporte	:= (SELECT PrioridadReporte FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

IF(Par_NumLis = Lis_Principal) THEN
	IF(Par_CategoriaID=Dato_Desconocido)THEN
		SELECT 	E.EmpleadoID, E.NombreCompleto
			FROM EMPLEADOS E
				WHERE E.SucursalID=Par_SucursalID
					AND E.NombreCompleto	LIKE	CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	ELSE
		SELECT 	E.EmpleadoID, E.NombreCompleto
			FROM PUESTOS P
				INNER JOIN EMPLEADOS E ON P.ClavePuestoID=E.ClavePuestoID
				WHERE E.SucursalID=Par_SucursalID
					AND P.CategoriaID=Par_CategoriaID
					AND E.NombreCompleto	LIKE	CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;
	END IF;
END IF;


IF(Par_NumLis = Lis_Completa) THEN
	SELECT 	E.EmpleadoID, E.NombreCompleto
		FROM EMPLEADOS E
			WHERE E.NombreCompleto	LIKE	CONCAT("%", Par_Nombre, "%")
				AND E.Estatus='A'
		LIMIT 0, 15;
END IF;


IF(Par_NumLis = Lis_FiltroA) THEN
	IF(Par_CategoriaID=Dato_Desconocido) THEN
		SELECT 	E.EmpleadoID, E.NombreCompleto
			FROM EMPLEADOS E
				WHERE E.NombreCompleto	LIKE	CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	ELSE
		SELECT 	E.EmpleadoID, E.NombreCompleto
			FROM EMPLEADOS E
				INNER JOIN PUESTOS P ON E.ClavePuestoID=P.ClavePuestoID
				WHERE P.CategoriaID=Par_CategoriaID
					AND E.NombreCompleto	LIKE	CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;
	END IF;
END IF;


IF(Par_NumLis = Lis_FiltroB) THEN
	SELECT 	E.EmpleadoID, E.NombreCompleto
		FROM EMPLEADOS E
		WHERE E.SucursalID=Par_SucursalID
			AND E.NombreCompleto	LIKE	CONCAT("%", Par_Nombre, "%")
		LIMIT 0, 15;
END IF;
 

IF(Par_NumLis = Lis_EviaArchivo) THEN
	SET Var_FechaSistema      	:=  (SELECT FechaSistema FROM PARAMETROSSIS);
	SET Var_PeriodoReporte    	:= 	DATE_FORMAT(Var_FechaSistema,'%Y%m%d');
	SET Var_OrganoSupervisor   	:= 	(SELECT ClaveOrgSupervisor FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);
	SET Var_ClaveCasFim        	:= 	(SELECT ClaveEntCasfim FROM PARAMETROSPLD WHERE Estatus = EstatusVigente);

	SET TipoRepPREOCUPANTES            	:= '3';
	SET InstrumEfectivo                	:= '01';
	SET RegistroTitularCta            	:= '00';
	SET EstatusReportarOperacion    	:= 3;


	SELECT IFNULL(Ins.TipoInstitID,Entero_Cero), 	Tip.NombreCorto
      INTO Var_TipoInstitID, 						Var_NombreCorto
		FROM PARAMETROSSIS Par
			INNER JOIN INSTITUCIONES Ins ON Par.InstitucionID = Ins.InstitucionID
			INNER JOIN TIPOSINSTITUCION Tip ON Ins.TipoInstitID = Tip.TipoInstitID;

	DROP TABLE IF EXISTS TMPENVIOALERTASPREOCUPANTES;
	CREATE TEMPORARY TABLE TMPENVIOALERTASPREOCUPANTES (
        TipoDeReporte 				CHAR(1),
		Periodo						INT(11),
		Folio 						INTEGER AUTO_INCREMENT PRIMARY KEY,
		OrganoSup					VARCHAR(6),
		ClaveCasfim					VARCHAR(6),
		LocalidadSuc				VARCHAR(8),
		SucursalCP					VARCHAR(8),
		TipoOperacion				VARCHAR(2),
		InstrumentoMon				VARCHAR(2),
		NumCuenta					VARCHAR(16),
		MontoOperacion				DECIMAL(18,2),
		Moneda						VARCHAR(3),
		FechaOperacion				INT(11),
		FechaDeteccion				INT(11),
		Nacionalidad				CHAR(2),
		TipoDePersona				VARCHAR(1),
		RazonSocioal				VARCHAR(60),
		Nombre						VARCHAR(100),
		ApellidoPaterno				VARCHAR(60),
		ApellidoMaterno				VARCHAR(60),
		RFC							VARCHAR(13),
		CURP						VARCHAR(18),
		FechaNacimiento				INT(11),
		Domicilio					VARCHAR(60),
		Colonia						VARCHAR(30),
		Localidad					VARCHAR(8),
		Telefonos					VARCHAR(40),
		ActividadEconomica			VARCHAR(15),
		NombreApoSeguros			VARCHAR(60),
		ApellidoPaternoApoSeguros	VARCHAR(60),
		ApellidoMaternoApoSeguros	VARCHAR(30),
		RFCApoSeguros			    VARCHAR(13),
		CURPApoSeguros			    VARCHAR(18),
		ConsecutivoCuenta			VARCHAR(2),
		NumCuentaRelacionado		VARCHAR(16),
		ClaveCasfimRelacionado		VARCHAR(6),
		NombreRelacionado			VARCHAR(100),
		ApellidoPaternoRelacionado	VARCHAR(60),
		ApellidoMaternoRelacionado	VARCHAR(60),
		DescriOperacion			    VARCHAR(2000),
		DescriMotivo				VARCHAR(500),
		OpeInterPreoID				BIGINT(11),
	
		TipoPersona 				INT(11), 
		RazonSocial 				VARCHAR(100), 
		NombreCliente 				VARCHAR(100), 
		ApellidoPatCliente			VARCHAR(100),
		ApellidoMatCliente 			VARCHAR(100), 
	
		RFCOficial 					VARCHAR(100), 
		CURPCliente					VARCHAR(100), 
		FechaNacCliente				INT(11),
		CuentaAhoID 				INT(11),
		EqCNBV 						VARCHAR(200),
	
		CP 							CHAR(5),
		ClaveRegistra 				CHAR(29)
		);


	INSERT INTO TMPENVIOALERTASPREOCUPANTES (
		TipoDeReporte,		Periodo,					OrganoSup,					ClaveCasfim,				LocalidadSuc,
		SucursalCP,			TipoOperacion,				InstrumentoMon,				NumCuenta,					MontoOperacion,
		Moneda,				FechaOperacion,				FechaDeteccion,				Nacionalidad,				TipoDePersona,
		RazonSocioal,		Nombre,						ApellidoPaterno,			ApellidoMaterno,			RFC,
		CURP,				FechaNacimiento,			Domicilio,					Colonia,					Localidad,
		Telefonos,			ActividadEconomica,			NombreApoSeguros,			ApellidoPaternoApoSeguros,	ApellidoMaternoApoSeguros,
		RFCApoSeguros,		CURPApoSeguros,				ConsecutivoCuenta,			NumCuentaRelacionado,		ClaveCasfimRelacionado,
		NombreRelacionado,	ApellidoPaternoRelacionado,	ApellidoMaternoRelacionado,	DescriOperacion,			DescriMotivo,
		OpeInterPreoID,		TipoPersona, 				RazonSocial, 				NombreCliente, 				ApellidoPatCliente,
		ApellidoMatCliente, RFCOficial, 				CURPCliente, 				FechaNacCliente,			CuentaAhoID,
		EqCNBV,				CP,							ClaveRegistra)
	  SELECT
		TipoRepPREOCUPANTES,Var_PeriodoReporte,			Var_OrganoSupervisor,		Var_ClaveCasFim,			RIGHT(IFNULL(Localid, Cadena_Vacia),8) AS LocalidadSuc,
		IF(Var_TipoInstitID=TipoSofom,IFNULL(Suc.CP, Cadena_Vacia),IFNULL(Suc.ClaveSucCNBV, Cadena_Vacia)) AS SucursalCP,
		IFNULL('08', Cadena_Vacia) AS TipoOperacion,
		InstrumEfectivo AS InstrumentoMon,
		'0' AS NumCuenta,
		MontoCero AS MontoOperacion,
		'1' AS Moneda,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaOperacion,
		DATE_FORMAT(IFNULL(Inu.FechaDeteccion, Fecha_Vacia),'%Y%m%d') AS FechaDeteccion,
		NacMexicana AS Nacionalidad,
		'1'  AS TipoDePersona,
		Cadena_Vacia AS RazonSocioal,
		IFNULL(TRIM(CONCAT(IFNULL(Emp.PrimerNombre,Cadena_Vacia),' ',IFNULL(Emp.SegundoNombre,Cadena_Vacia))), 'XXXX') AS Nombre,
		IFNULL(Emp.ApellidoPat, 'XXXX') AS ApellidoPaterno,
		IFNULL(Emp.ApellidoMat, 'XXXX') AS ApellidoMaterno,
		IFNULL(Emp.RFC, Cadena_Vacia) AS RFC,
		Cadena_Vacia AS CURP,
		DATE_FORMAT(IFNULL(Emp.FechaNac, Fecha_Vacia),'%Y%m%d')   AS FechaNacimiento,
		Cadena_Vacia AS Domicilio,
		Cadena_Vacia AS Colonia,
		Cadena_Vacia AS Localidad,
		Cadena_Vacia AS Telefonos,
		ActEconom AS ActividadEconomica,
		Cadena_Vacia AS NombreApoSeguros,
		Cadena_Vacia AS ApellidoPaternoApoSeguros,
		Cadena_Vacia AS ApellidoMaternoApoSeguros,
		Cadena_Vacia AS RFCApoSeguros,
		Cadena_Vacia AS CURPApoSeguros,
		RegistroTitularCta AS ConsecutivoCuenta,
		Cadena_Vacia AS NumCuentaRelacionado    ,
		Cadena_Vacia AS ClaveCasfimRelacionado,
		TRIM(CONCAT(IFNULL(Emp.PrimerNombre,Cadena_Vacia)," ",IFNULL(Emp.SegundoNombre,Cadena_Vacia))) AS NombreRelacionado,
		IFNULL(Emp.ApellidoPat,Cadena_Vacia) AS ApellidoPaternoRelacionado,
		IFNULL(Emp.ApellidoMat,Cadena_Vacia) AS ApellidoMaternoRelacionado,
		TRIM(CONCAT(IFNULL(Inu.DesOperacion, Cadena_Vacia), " ", IFNULL(REPLACE(Inu.ComentarioOC,char(10 using utf8),'*'), Cadena_Vacia))) AS DescriOperacion,
		TRIM(IFNULL(Mot.DesCorta, Cadena_Vacia)) AS DescriMotivo,
		Inu.OpeInterPreoID,
		#AGREGADO PARA XML 
		CASE WHEN Cli.TipoPersona = 'F' THEN 1 ELSE 2 END, Cli.RazonSocial, 
				CONCAT(Cli.PrimerNombre," ",Cli.SegundoNombre," ",Cli.TercerNombre), 
				Cli.ApellidoPaterno, Cli.ApellidoMaterno, Cli.RFCOficial, Cli.CURP, 
				DATE_FORMAT(IFNULL(Cli.FechaNacimiento, Fecha_Vacia),'%Y%m%d'),CTA.CuentaAhoID, MunSuc.EqCNBV, D.CP, Inu.ClaveRegistra

		FROM PLDOPEINTERPREO Inu
			LEFT JOIN SUCURSALES Suc ON Suc.SucursalID = Inu.SucursalID
			LEFT JOIN CLIENTES Cli ON Inu.CteInvolucrado = Cli.ClienteID
			LEFT JOIN DIRECCLIENTE D ON Cli.ClienteID = D.ClienteID AND D.Oficial = 'S'
			LEFT JOIN CUENTASAHO CTA ON Cli.ClienteID = CTA.ClienteID AND CTA.EsPrincipal = 'S'
			LEFT JOIN MUNICIPIOSREPUB MunSuc ON MunSuc.EstadoID = Suc.EstadoID AND MunSuc.MunicipioID = Suc.MunicipioID
			LEFT JOIN EMPLEADOS Emp ON Inu.ClavePersonaInv=Emp.EmpleadoID
			LEFT JOIN PLDCATMOTIVPREO Mot ON Mot.CatMotivPreoID = Inu.CatMotivPreoID
			WHERE Inu.Estatus = EstatusReportarOperacion;


	SELECT 	
			Cadena_Vacia AS sujeto_obligado,
				OrganoSup AS organo_supervisor,
				Var_TipoITF AS tipo_itf,
				ClaveCasfim AS clave_sujeto,
			Cadena_Vacia AS reportes,
			Cadena_Vacia AS reporte,
				TipoDeReporte AS tipo_reporte,
				FechaOperacion AS fecha_reporte,
				LPAD(Folio,LongFolio, 0) AS folio_consecutivo,
			Cadena_Vacia AS empleado,
				Nacionalidad AS pais_nacionalidad,
				LEFT(Nombre, LongNombre) AS nombre,
				LEFT(ApellidoPaterno,LongNombre) AS apellido_paterno,
				LEFT(ApellidoMaterno,LongApMaterno)	AS apellido_materno,
				TipoDePersona AS genero,
				RFC AS rfc,
				CURP AS curp,
				FechaNacimiento AS fecha_nacimiento,
				LEFT(Localidad,LongLocalidad) AS entidad_nacimiento,
			Cadena_Vacia AS domicilio_empleado,
				Localidad AS entidad_federativa_domicilio,
				FNLIMPIACARACTERESGEN(LEFT(Domicilio,LongDomicilio),Mayusculas) AS calle_domicilio ,
				FNLIMPIACARACTERESGEN(LEFT(Colonia,LongColonia),Mayusculas) AS colonia,
				EqCNBV AS ciudad_poblacion,
				CP AS codigo_postal,
				LEFT(Telefonos,LongTelefono) AS telefono,
				'P' AS puesto_entidad,
			Cadena_Vacia AS operacion,
				TipoOperacion AS tipo_operacion_itf,
				InstrumentoMon AS instrumento_monetario,
				MontoOperacion AS monto,
				LPAD(Moneda,LongMoneda,0) AS moneda,
				FechaOperacion AS fecha,
			Cadena_Vacia AS analisis,
				FechaDeteccion AS fecha_deteccion,
				ClaveRegistra AS descripcion_perfil_empleado,
				FNLIMPIACARACTERESGEN(DescriMotivo,Mayusculas) AS razones_vulnera_pld,
				Var_PrioridadReporte AS prioridad_reporte,
			Cadena_Vacia AS clientes_relacionados,
			Cadena_Vacia AS cliente_relacionado,
				TipoPersona AS tipo_persona_cliente,
				RazonSocial AS razon_denominacion_cliente,
				NombreCliente AS nombre_cliente,
				ApellidoPatCliente AS apellido_paterno_cliente,
				ApellidoMatCliente AS apellido_materno_cliente,
				RFCOficial AS  rfc_cliente,
				CURPCliente AS curp_cliente,
				FechaNacCliente AS fecha_nacimiento_cliente,
				CuentaAhoID AS numero_cuenta_cliente
	FROM TMPENVIOALERTASPREOCUPANTES;
END IF;


IF(Par_NumLis = Lis_OpePreocupan)THEN
	SELECT OpeInterPreoID, NomPersonaInv, FechaDeteccion
		FROM PLDOPEINTERPREO
			WHERE NomPersonaInv LIKE CONCAT("%", Par_Nombre, "%")
		ORDER BY Fecha DESC
		LIMIT 0,15;
END IF;

END TerminaStore$$