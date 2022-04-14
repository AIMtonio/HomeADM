-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTATIMBRADOCFDI
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTATIMBRADOCFDI`;
DELIMITER $$


CREATE PROCEDURE `EDOCTATIMBRADOCFDI`(
	-- SP para generar informacion del timbrado CFDI para el estado de cuenta
	Par_RFCEmisor 				VARCHAR(25),		-- RFC del Emisor
	Par_RazonSocial 			VARCHAR(100),		-- Razon Social del Emisor
	Par_ExpCalle 				VARCHAR(100),		-- Calle de la Sucursal de Expedicion
	Par_ExpNumero 				VARCHAR(10),		-- Numero Sucursal de Expedicion
	Par_ExpColonia 				VARCHAR(50),		-- Colonia Sucursal Expedicion

	Par_ExpMunicipio			VARCHAR(50),		-- Municipio Sucursal Expedicion
	Par_ExpEstado 				VARCHAR(50),		-- Estado Sucursal Expedicion
	Par_ExpCP 					VARCHAR(10),		-- Codigo Postal Sucursal Expedicion
	Par_Tasa 					DECIMAL(12,2),		-- Valor Tasa
	Par_NumIntEmisor 			VARCHAR(20),		-- Numero Interior Emisor

	Par_NumExtEmisor 			VARCHAR(20),		-- Numero Exterior Emisor
	Par_NumReg  				INT(11),			-- Numero de Registro
	Par_CPEmisor 				VARCHAR(12),		-- Codigo Postal Emisor
	Par_TimbraEdoCta			CHAR(1),			-- Timbrado de Estado de Cuenta: SI NO
	Par_EstadoEmisor			VARCHAR(50),		-- Estado Emisor

	Par_MuniEmisor				VARCHAR(50),		-- Municipio Emisor
	Par_LocalEmisor				VARCHAR(100),		-- Localidad Emisor
	Par_ColEmisor				VARCHAR(100),		-- Colonia Emisor
	Par_CalleEmisor				VARCHAR(100),		-- Calle Emisor
	Par_GeneraCFDI				CHAR(1),			-- Genera CFDI: SI NO

	Par_AnioMes					CHAR(10),			-- Anio y mes que se genera el Estado de Cuenta
	Par_SucursalID     			INT(11),			-- Sucursal del Cliente
	Par_NombreSucursalCte 		VARCHAR(150),		-- Nombre del Sucursal del Cliente
	Par_ClienteID 				INT(11),			-- Numero del Cliente
	Par_NombreComple 			VARCHAR(250),		-- Nombre Completo del Cliente

	Par_TipPer   				CHAR(2),			-- Tipo de Persona
	Par_TipoPersona 			VARCHAR(50),		-- Descripcion Tipo de Persona
	Par_Calle     				VARCHAR(250),		-- Calle del Cliente
	Par_NumInt					VARCHAR(10),		-- Numero Interior Domicilio del Cliente
	Par_NumExt					VARCHAR(10),		-- Numero Exterior Domicilio del Cliente

	Par_Colonia 				VARCHAR(200),		-- Colonia del Domicilio del Cliente
	Par_Estado   				VARCHAR(50),		-- Estado del Cliente
	Par_CodigoPostal 			VARCHAR(10),		-- Codigo Postal del Cliente
	Par_RFC 					VARCHAR(20),		-- RFC del Cliente
	Par_ComisionInver 			DECIMAL(12,2),		-- Comision Inversion

	Par_FechaGeneracion 		VARCHAR(15),		-- Fecha en que se genera Informacion del Cliente
	Par_RegHacienda 			CHAR(1),			-- Registro en Hacienda: SI NO
	Par_ComisionAhorro 			DECIMAL(12,2),		-- Comision por Ahorro
	Par_ComisionCredito 		DECIMAL(12,2),		-- Comision de Credito
	Par_NombreInstitucion		VARCHAR(100),		-- Nombre Institucion

	Par_DireccionInstitucion	VARCHAR(150),		-- Direccion Institucion
	Par_MunicipioDelegacion		VARCHAR(50)			-- Municipio y Delegacion

	)

TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CliProEsp   		INT(11);		-- Almacena el Numero de Cliente para Procesos Especificos
	DECLARE Var_Llamada 			VARCHAR(1000);	-- Almacena la llamada a realizar el proceso
	DECLARE Var_ProcPersonalizado 	VARCHAR(200);   -- Almacena el nombre del SP para generar los detalles de los creditos
	DECLARE Var_CliProEspEdoCta		INT(11);		-- Almacena el Numero de Cliente para Procesos Especificos de estado de cuenta

	-- Declaracion de constantes
	DECLARE Entero_Cero    		INT(11);			-- Entero Cero
	DECLARE Cadena_Vacia		CHAR(1);			-- Cadena Vacia
	DECLARE EdoCtaTimbradoCFDI 	INT(11);			-- Identificador de timbrado para el Estado de Cuenta
	DECLARE Con_CliProcEspe     VARCHAR(20);		-- Numero de Cliente para Procesos Especificos
	DECLARE NumClienteSofi		INT(11);			-- Numero de Cliente para Sofi Express Procesos Especificos: 15

	DECLARE NumClienteCred		INT;				-- Numero de Cliente para Crediclub Proceso Especifico:24
	DECLARE	NumClienteNuevo		INT(11);			-- Numero para todos los clientes nuevos Procesos Especificos Estado Cuenta: 99
	DECLARE Con_EdoCtaGral		VARCHAR(20);		-- Numero de Cliente para Procesos Especificos de estado de cuenta

	-- Asignacion de constantes
	SET Entero_Cero 		:= 0;					-- Entero Cero
	SET Cadena_Vacia		:= '';					-- Cadena Vacia
	SET EdoCtaTimbradoCFDI	:= 8;					-- Identificador de timbrado para el Estado de Cuenta
	SET Con_CliProcEspe     := 'CliProcEspecifico'; -- Numero de Cliente para Procesos Especificos
	SET NumClienteSofi		:= 15;					-- Numero de Cliente para Sofi Express Procesos Especificos: 15
	SET Par_NumExt			:= IFNULL(Par_NumExt, Cadena_Vacia);

	SET NumClienteCred		:= 24;					-- Numero de Cliente para Crediclub Proceso Especifico:24
	SET	NumClienteNuevo		:= 99;					-- Numero para todos los clientes nuevos Procesos Especificos Estado Cuenta: 99
	SET Con_EdoCtaGral		:= 'EdoCtaGeneral';		-- Numero de Cliente para Procesos Especificos de estado de cuenta

ManejoErrores:BEGIN

	-- Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);

	SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

	-- Se obtiene el Numero de Cliente para Procesos Especificos de Estado de Cuenta
	SET Var_CliProEspEdoCta := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_EdoCtaGral);

	SET Var_CliProEspEdoCta := IFNULL(Var_CliProEspEdoCta,Entero_Cero);

    -- Se obtiene el nombre del SP a realizar el proceso
	IF(Var_CliProEsp = NumClienteSofi) THEN
		SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = EdoCtaTimbradoCFDI AND CliProEspID = Var_CliProEsp);
	ELSEIF (Var_CliProEsp = NumClienteCred) THEN
			SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = EdoCtaTimbradoCFDI AND CliProEspID = Var_CliProEsp);
	ELSEIF (Var_CliProEspEdoCta = NumClienteNuevo) THEN
			SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = EdoCtaTimbradoCFDI AND CliProEspID = Var_CliProEspEdoCta);
		ELSE
			SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = EdoCtaTimbradoCFDI AND CliProEspID = Entero_Cero);
	END IF;

	-- Se realiza la llamada al SP para realizar el proceso del timbrado CFDI
	SET Var_Llamada := CONCAT(' CALL ', Var_ProcPersonalizado," ('",Par_RFCEmisor,
			"','",Par_RazonSocial,		"','",	Par_ExpCalle,			"','",	Par_ExpNumero,			"','",	Par_ExpColonia,
            "','",Par_ExpMunicipio,		"','",	Par_ExpEstado,			"','",	Par_ExpCP,				"','",	Par_Tasa,
            "','",Par_NumIntEmisor,		"','",	Par_NumExtEmisor,		"','",	Par_NumReg,				"','",	Par_CPEmisor,
			"','",Par_TimbraEdoCta,		"','",	Par_EstadoEmisor,		"','",	Par_MuniEmisor,			"','",	Par_LocalEmisor,
			"','",Par_ColEmisor,		"','",	Par_CalleEmisor,		"','",	Par_GeneraCFDI,			"','",	Par_AnioMes,
            "','",Par_SucursalID,		"','",	Par_NombreSucursalCte,	"','",	Par_ClienteID,			"','",	Par_NombreComple,
            "','",Par_TipPer,			"','",	Par_TipoPersona,		"','",	Par_Calle,				"','",	Par_NumInt,
            "','",Par_NumExt,			"','",	Par_Colonia,			"','",	Par_Estado,				"','",	Par_CodigoPostal,
            "','",Par_RFC,				"','",	Par_ComisionInver,		"','",	Par_FechaGeneracion,	"','",	Par_RegHacienda,
            "','",Par_ComisionAhorro,	"','",	Par_ComisionCredito,	"','",	Par_NombreInstitucion,	"','",	Par_DireccionInstitucion,
            "','",Par_MunicipioDelegacion,"');");

	-- Se ejecuta la sentencia del proceso
	SET @Sentencia    := (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;

END ManejoErrores;


END TerminaStore$$
