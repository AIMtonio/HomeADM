-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATDCDATOSCTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATDCDATOSCTEPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTATDCDATOSCTEPRO`(
	Par_DiaCorte 		INT,			-- Dia del corte del un tarjeta
	Par_Periodo         INT,			-- Periodo de inicio a fecha de corte de una tarjeta
	Par_EmpresaID		INT,			-- Parametro de Auditoria
	Aud_Usuario			INT,			-- Parametro de Auditoria
	Aud_FechaActual		DATETIME,		-- Parametro de Auditoria
	Aud_DireccionIP		VARCHAR(15),	-- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	-- Parametro de Auditoria
	Aud_Sucursal		INT,			-- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT			-- Parametro de Auditoria
)
TerminaStore: BEGIN

    -- Declaraciones de Constantes
	DECLARE	Entero_Cero				INT;
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE PersonaFisica			CHAR(1);
	DECLARE PersonaMoral			CHAR(1);
	DECLARE PerActivEmp				CHAR(1);
	DECLARE EsRegHacienda			CHAR(1);
	DECLARE EsFiscal				CHAR(1);
	DECLARE EsOficial	    		CHAR(1);

    -- Declaraciones de Variables
	DECLARE	Var_NombreInstit		VARCHAR(150);
	DECLARE	Var_DireccionInstit		VARCHAR(200);
	DECLARE	Var_NumInstitucion		INT(11);

    -- Asignacion de Constantes
	SET	Entero_Cero					:= 0;
	SET Cadena_Vacia				:= '';
	SET	Fecha_Vacia					:= '1900-01-01';
	SET PersonaFisica				:= 'F';
	SET PersonaMoral				:= 'M';
	SET PerActivEmp					:= 'A';
	SET EsRegHacienda				:= 'S';
	SET EsFiscal		    		:= 'S';
	SET EsOficial	    			:= 'S';

    -- Asignacion de Variables



	 INSERT INTO EDOCTATDCDATOSCTE
	 SELECT Par_Periodo,		Par_DiaCorte,			Cli.ClienteID,		Cli.NombreCompleto,		Cli.SucursalOrigen,
			Cadena_Vacia AS NombreSucurs,
			Cli.TipoPersona,
			CASE Cli.TipoPersona WHEN PersonaFisica THEN 'FISICA'
													 WHEN PersonaMoral	THEN 'MORAL'
													 WHEN PerActivEmp	THEN 'FISICA CON ACTIVIDAD EMPRESARIAL'
													 ELSE CONCAT("No Definido para: ", TipoPersona)
		   END,
		   Cli.RFCOficial,
		   Cadena_Vacia AS Calle 			,
		   Cadena_Vacia AS NumInt 		,
		   Cadena_Vacia AS NumExt 		,
		   Cadena_Vacia AS Colonia 		,
		   Cadena_Vacia AS Municip_Deleg ,
		   Cadena_Vacia AS Estado 		,
		   Cadena_Vacia AS CodigoPostal 	,
		   Cadena_Vacia AS NombreInstit 	,
		   Cadena_Vacia AS DireccionInstit,
		   Cli.RegistroHacienda, Par_EmpresaID,   Aud_Usuario,    Aud_FechaActual,     Aud_DireccionIP,    Aud_ProgramaID,     Aud_Sucursal,   Aud_NumTransaccion
	 FROM CLIENTES Cli
	 INNER JOIN EDOCTATDCLINEACRED Edc ON Edc.ClienteID = Cli.ClienteID;


	UPDATE EDOCTATDCDATOSCTE Dat
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Dat.SucursalID
	SET Dat.NombreSucurs = TRIM(Suc.NombreSucurs);


	UPDATE EDOCTATDCDATOSCTE Dat
		INNER JOIN DIRECCLIENTE Dir ON Dat.ClienteID = Dir.ClienteID AND CASE WHEN Dat.RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END
	 	INNER JOIN COLONIASREPUB Col ON Col.ColoniaID	= Dir.ColoniaID AND Col.EstadoID	= Dir.EstadoID AND Col.MunicipioID = Dir.MunicipioID
	SET Dat.Calle 	= TRIM(Dir.Calle),
		Dat.NumExt	= Dir.NumeroCasa,
		Dat.NumInt	= Dir.NumInterior,
		Dat.Colonia	= TRIM(Col.Asentamiento),
		Dat.CodigoPostal = Dir.CP;


	UPDATE EDOCTATDCDATOSCTE Dat
		INNER JOIN DIRECCLIENTE Dir ON Dat.ClienteID = Dir.ClienteID AND CASE WHEN Dat.RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END
		INNER JOIN ESTADOSREPUB Est ON Dir.EstadoID = Est.EstadoID
	SET Dat.Estado = Est.Nombre;


	UPDATE EDOCTATDCDATOSCTE Dat
		INNER JOIN DIRECCLIENTE Dir ON Dat.ClienteID = Dir.ClienteID AND CASE WHEN Dat.RegHacienda = EsRegHacienda THEN Dir.Fiscal = EsFiscal ELSE Dir.Oficial = EsOficial END
		INNER JOIN MUNICIPIOSREPUB Mun ON Dir.EstadoID = Mun.EstadoID AND Dir.MunicipioID = Mun.MunicipioID
	SET Dat.Municip_Deleg = Mun.Nombre;



	SET	Var_NumInstitucion	:= (SELECT InstitucionID FROM EDOCTAPARAMS);
	SET	Var_NumInstitucion	:= IFNULL(Var_NumInstitucion, Entero_Cero);

	SET Var_NombreInstit	:= (SELECT Nombre FROM INSTITUCIONES WHERE InstitucionID = Var_NumInstitucion);
	SET Var_DireccionInstit := (SELECT DirFiscal FROM INSTITUCIONES WHERE InstitucionID = Var_NumInstitucion);

	UPDATE EDOCTATDCDATOSCTE Dat
	SET Dat.NombreInstit	= Var_NombreInstit,
		Dat.DireccionInstit	= Var_DireccionInstit;


END TerminaStore$$