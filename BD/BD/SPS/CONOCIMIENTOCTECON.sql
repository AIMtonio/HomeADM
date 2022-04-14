-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONOCIMIENTOCTECON
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONOCIMIENTOCTECON`;
DELIMITER $$

CREATE PROCEDURE `CONOCIMIENTOCTECON`(
	Par_ClienteID		INT,
	Par_NumCon			TINYINT UNSIGNED,
	Par_EmpresaID		INT,

	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT
		)
TerminaStore: BEGIN

-- Declaracion de constantes
DECLARE	Cadena_Vacia	CHAR(1);
DECLARE	Fecha_Vacia		DATE;
DECLARE	Entero_Cero		INT;
DECLARE	Con_Principal	INT;
DECLARE	Con_Foranea		INT;
DECLARE	Con_Report		INT;
DECLARE Con_Existe		INT;

DECLARE	nombCte			VARCHAR(200);
DECLARE	funcion			INT;
DECLARE	descripFun		VARCHAR(150);

-- AsignaciÃ³n de constantes
SET	Cadena_Vacia	:= '';				-- Cadena Vacia
SET	Fecha_Vacia		:= '1900-01-01';	-- Fecha Vacia
SET	Entero_Cero		:= 0;				-- Entero Cero
SET	Con_Principal	:= 1;				-- Consulta principal
SET	Con_Foranea		:= 2;				-- consulta foranea
SET	Con_Report		:= 3;				-- Consulta para el reporte
SET	Con_Existe		:= 4;				-- Consulta existencia

SET nombCte			:= '';
SET descripFun		:= '';
SET funcion			:= 0;

-- 1.- Consulta principal
IF(Par_NumCon = Con_Principal) THEN
	SELECT	CON.ClienteID,					CON.NomGrupo, 			CON.RFC,							CON.Participacion,   				CON.Nacionalidad,
			CON.RazonSocial, 				CON.Giro,				CON.PEPs,							CON.FuncionID,						CON.ParentescoPEP,
			CON.NombFamiliar,				CON.APaternoFam,		CON.AMaternoFam,					CON.NoEmpleados,					CON.Serv_Produc,
			CON.Cober_Geograf,				CON.Estados_Presen,		FORMAT(CON.ImporteVta,2)ImporteVta,	FORMAT(CON.Activos,2)Activos,		FORMAT(CON.Pasivos,2)Pasivos,
			FORMAT(CON.Capital,2)Capital,	CON.Importa,			CON.DolaresImport,					CON.PaisesImport,					CON.PaisesImport2,
			CON.PaisesImport3,				CON.Exporta,			CON.DolaresExport,					CON.PaisesExport,					CON.PaisesExport2,
			CON.PaisesExport3,				CON.NombRefCom,			CON.NombRefCom2,					CON.TelRefCom,						CON.TelRefCom2,
			CON.BancoRef,					CON.BancoRef2,			CON.NoCuentaRef,					CON.NoCuentaRef2,					CON.NombreRef,
			CON.NombreRef2,					CON.DomicilioRef,		CON.DomicilioRef2,					CON.TelefonoRef,					CON.TelefonoRef2,
			CON.PFuenteIng,					CON.IngAproxMes,		CON.ExtTelefonoRefuno, 				CON.ExtTelefonoRefDos,				CON.ExtTelRefCom,
			CON.ExtTelRefCom2, 				CON.TipoRelacion1, 		CON.TipoRelacion2,					CON.PreguntaCte1, 					CON.RespuestaCte1,
			CON.PreguntaCte2, 				CON.RespuestaCte2, 		CON.PreguntaCte3, 					CON.RespuestaCte3, 					CON.PreguntaCte4,
			CON.RespuestaCte4,				CON.CapitalContable,	CTE.NivelRiesgo,					CON.EvaluaXMatriz,					CON.ComentarioNivel,
			CON.NoCuentaRefCom,				CON.NoCuentaRefCom2,	CON.DireccionRefCom,				CON.DireccionRefCom2,				CON.BanTipoCuentaRef,
			CON.BanTipoCuentaRef2,			CON.BanSucursalRef,		CON.BanSucursalRef2,				CON.BanNoTarjetaRef,				CON.BanNoTarjetaRef2,				
			CON.BanTarjetaInsRef,			CON.BanTarjetaInsRef2,	CON.BanCredOtraEnt,					CON.BanCredOtraEnt2,				CON.BanInsOtraEnt,					
			CON.BanInsOtraEnt2,				CON.OperacionAnios, 	CON.GiroAnios,
			IF(CON.FechaNombramiento = Fecha_Vacia, Cadena_Vacia, CON.FechaNombramiento) AS FechaNombramiento,
			CON.PeriodoCargo,				CON.PorcentajeAcciones,	CON.MontoAcciones,					CON.TiposClientes,					CON.InstrumentosMonetarios
		FROM	CONOCIMIENTOCTE AS CON INNER JOIN CLIENTES AS CTE ON CON.ClienteID = CTE.ClienteID
		WHERE	CON.ClienteID = Par_ClienteID;
END IF;

-- 2.- consulta foranea
IF(Par_NumCon = Con_Foranea) THEN
	SELECT	`ConocimientoID`
	FROM 		CONOCIMIENTOCTE
	WHERE		ClienteID = Par_ClienteID;
END IF;


SET nombCte := (SELECT NombreCompleto FROM CLIENTES WHERE Par_ClienteID = ClienteID);
SET funcion := (SELECT FuncionID FROM CONOCIMIENTOCTE WHERE Par_ClienteID= ClienteID);
SET descripFun := (SELECT Descripcion FROM FUNCIONESPUB WHERE funcion =FuncionID);
-- 3.- Consulta para el reporte
IF(Par_NumCon = Con_Report) THEN
	SELECT	ClienteID,			NomGrupo, 		RFC, 				Participacion,   	Nacionalidad,
			RazonSocial, 		Giro,			PEPs,				FuncionID,			ParentescoPEP,
			NombFamiliar,		APaternoFam,	AMaternoFam,		NoEmpleados,		Serv_Produc,
			Cober_Geograf,		Estados_Presen,	ImporteVta,			Activos,			Pasivos,
			Capital,			Importa,		DolaresImport,		PaisesImport,		PaisesImport2,
			PaisesImport3,		Exporta,		DolaresExport,		PaisesExport,		PaisesExport2,
			PaisesExport3,		NombRefCom,		NombRefCom2,		TelRefCom,			TelRefCom2,
			BancoRef,			BancoRef2,		NoCuentaRef,		NoCuentaRef2,		NombreRef,
			NombreRef2,			DomicilioRef,	DomicilioRef2,		TelefonoRef,		TelefonoRef2,
			PFuenteIng,			IngAproxMes, 	CURDATE() AS fecha,	nombCte,   			descripFun,
			CapitalContable
		FROM		CONOCIMIENTOCTE
		WHERE		ClienteID = Par_ClienteID;
END IF;

-- 4.- Consulta existencia
IF(Par_NumCon = Con_Existe) THEN
	SELECT	ClienteID
		FROM CONOCIMIENTOCTE
		WHERE  ClienteID 	= Par_ClienteID;

END IF;

END TerminaStore$$