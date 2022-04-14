
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDOPEINTERPREOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDOPEINTERPREOLIS`;

DELIMITER $$
CREATE PROCEDURE `PLDOPEINTERPREOLIS`(
	Par_PeriodoInicio		DATE,			-- Fecha de Inicio del Periodo a Reportar.
	Par_PeriodoFin			DATE,			-- Fecha Final del Periodo a Reportar.
	Par_CategoriaID			INT(11),
	Par_SucursalID			INT(11),
	Par_Nombre				VARCHAR(40),

	Par_NumLis				TINYINT UNSIGNED,
	/* Parametros de Auditoria */
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
DECLARE	Var_RegBitID				BIGINT(20);


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
	SET Var_RegBitID		:= (SELECT MAX(RegistroID) FROM BITPLDOPEINTPREO);
	SET Var_RegBitID		:= IFNULL(Var_RegBitID, Entero_Cero);
	SET Par_PeriodoInicio	:= (SELECT FechaGeneracion FROM BITPLDOPEINTPREO WHERE RegistroID = Var_RegBitID);
	SET Par_PeriodoInicio	:= IFNULL(Par_PeriodoInicio, Fecha_Vacia);

	SELECT
		TipoReporte AS TipoDeReporte,					PeriodoReporte AS Periodo,
		Folio AS Folio,									ClaveOrgSupervisor AS OrganoSup,
		ClaveEntCasFim AS ClaveCasfim,					LocalidadSuc AS LocalidadSuc,
		SucursalID AS SucursalCP,						TipoOperacionID AS TipoOperacion,
		InstrumentMonID AS InstrumentoMon,				CuentaAhoID AS NumCuenta,
		Monto AS MontoOperacion,						ClaveMoneda AS Moneda,
		FechaOpe AS FechaOperacion,						FechaDeteccion AS FechaDeteccion,
		Nacionalidad AS Nacionalidad,					TipoPersona AS TipoDePersona,
		RazonSocial AS RazonSocioal,					Nombre AS Nombre,
		ApellidoPat AS ApellidoPaterno,					ApellidoMat AS ApellidoMaterno,
		RFC AS RFC,										CURP AS CURP,
		FechaNac AS FechaNacimiento,					Domicilio AS Domicilio,
		Colonia AS Colonia,								Localidad AS Localidad,
		Telefono AS Telefonos,							ActEconomica AS ActividadEconomica,
		NomApoderado AS NombreApoSeguros,				ApPatApoderado AS ApellidoPaternoApoSeguros,
		ApMatApoderado AS ApellidoMaternoApoSeguros,	RFCApoderado AS RFCApoSeguros,
		CURPApoderado AS CURPApoSeguros,				CtaRelacionadoID AS ConsecutivoCuenta,
		CuenAhoRelacionado AS NumCuentaRelacionado,		ClaveSujeto AS ClaveCasfimRelacionado,
		NomTitular AS NombreRelacionado,				ApPatTitular AS ApellidoPaternoRelacionado,
		ApMatTitular AS ApellidoMaternoRelacionado,		DesOperacion AS DescriOperacion,
		Razones AS DescriMotivo
	FROM PLDCNBVOPEINTPREOC
	WHERE Fecha BETWEEN Par_PeriodoInicio AND Par_PeriodoFin
	ORDER BY Folio;

END IF;


IF(Par_NumLis = Lis_OpePreocupan)THEN
	SELECT OpeInterPreoID, NomPersonaInv, FechaDeteccion
		FROM PLDOPEINTERPREO
			WHERE NomPersonaInv LIKE CONCAT("%", Par_Nombre, "%")
		ORDER BY Fecha DESC
		LIMIT 0,15;
END IF;

END TerminaStore$$

