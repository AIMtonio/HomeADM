-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTADATOSCTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTADATOSCTEPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTADATOSCTEPRO`(
	-- SP para obtener los Datos del Cliente para el Estado de Cuenta
    Par_AnioMes    		 	INT(11),		-- Anio y Mes Estado Cuenta
	Par_IniMes				DATE,			-- Fecha Inicio Mes
	Par_FinMes				DATE,			-- Fecha Fin Mes
	Par_ClienteInstitu		INT(11)			-- Cliente Institucion
)
TerminaStore: BEGIN

-- Declaracion de variables
DECLARE Var_CliProEsp   		INT;			-- Almacena el Numero de Cliente para Procesos Especificos
DECLARE Var_Llamada 			VARCHAR(400);	-- Almacena la llamada a realizar el proceso
DECLARE Var_ProcPersonalizado 	VARCHAR(200);   -- Almacena el nombre del SP para obtener los datos de los clientes

-- Declaracion de constantes
DECLARE Entero_Cero    		INT;				-- Entero Cero
DECLARE Cadena_Vacia		CHAR(1);			-- Cadena Vacia
DECLARE DatosCteEdoCta 		INT;				-- Identificador Datos del Cliente para el Estado de Cuenta
DECLARE Con_CliProcEspe     VARCHAR(20);		-- Numero de Cliente para Procesos Especificos
DECLARE NumClienteSofi		INT;				-- Numero de Cliente para Sofi Express Procesos Especificos: 15
DECLARE NumClienteCred		INT;				-- Numero de Cliente para Crediclub Proceso Especifico:24

-- Asignacion de constantes
SET Entero_Cero 		:= 0;					-- Entero Cero
SET Cadena_Vacia		:= '';					-- Cadena Vacia
SET DatosCteEdoCta		:= 10;					-- Identificador Datos del Cliente para el Estado de Cuenta
SET Con_CliProcEspe     := 'CliProcEspecifico'; -- Numero de Cliente para Procesos Especificos
SET NumClienteSofi		:= 15;					-- Numero de Cliente para Sofi Express Procesos Especificos: 15
SET NumClienteCred		:= 24;					-- Numero de Cliente para Crediclub Procesos Especifico:24

ManejoErrores:BEGIN

	-- Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);

	SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);

    -- Se obtiene el nombre del SP a realizar el proceso
	IF(Var_CliProEsp = NumClienteSofi) THEN
		SET Var_ProcPersonalizado = (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = DatosCteEdoCta AND CliProEspID = Var_CliProEsp);
	ELSEIF (Var_CliProEsp = NumClienteCred) THEN
			SET Var_ProcPersonalizado = (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = DatosCteEdoCta AND CliProEspID = Var_CliProEsp);
		ELSE
			SET Var_ProcPersonalizado = (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = DatosCteEdoCta AND CliProEspID = Entero_Cero);
	END IF;

	-- Se realiza la llamada al SP para realizar el proceso para obtener los datos del cliente
	 SET Var_Llamada := CONCAT(' CALL ', Var_ProcPersonalizado,"('",Par_AnioMes,"','",Par_IniMes,"','",Par_FinMes,"','",Par_ClienteInstitu,"');");

	-- Se ejecuta la sentencia del proceso
	SET @Sentencia    = (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;

END ManejoErrores;


END TerminaStore$$