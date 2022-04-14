-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOCTAHEADERINVPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAHEADERINVPRO`;DELIMITER $$

CREATE PROCEDURE `EDOCTAHEADERINVPRO`(
-- SP PARA GENERAR INFORMACION DEL ENCABEZADO DE INVERSIONES PARA EL ESTADO DE CUENTA
	Par_AnioMes						INT(11),					-- Anio y Mes
	Par_IniMes						DATE,						-- Fecha Inicio Mes
	Par_FinMes						DATE						-- Fecha Fin Mes

	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CliProEspEdoCta		INT(11);				-- Almacena el Numero de Cliente para Procesos Especificos de estado de cuenta
	DECLARE Var_Llamada				VARCHAR(400);				-- Almacena la llamada a realizar el proceso
	DECLARE Var_ProcPersonalizado	VARCHAR(200);				-- Almacena el nombre del SP para generar el encabezado de inversiones

	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);					-- Entero Cero
	DECLARE Cadena_Vacia			CHAR(1);					-- Cadena Vacia
	DECLARE HeaderInvEdoCta			INT(11);					-- Identificador del encabezado de inversiones para el Estado de Cuenta
	DECLARE Con_EdoCtaGral			VARCHAR(20);				-- Numero de Cliente para Procesos Especificos de estado de cuenta
	DECLARE NumClienteNuevo			INT(11);					-- Numero para todos los clientes nuevos Procesos Especificos Estado Cuenta: 99

	-- Asignacion de constantes
	SET Entero_Cero 				:= 0;						-- Entero Cero
	SET Cadena_Vacia				:= '';						-- Cadena Vacia
	SET HeaderInvEdoCta				:= 18;						-- Identificador del encabezado de inversiones para el Estado de Cuenta
	SET Con_EdoCtaGral				:= 'EdoCtaGeneral';			-- Numero de Cliente para Procesos Especificos de estado de cuenta
	SET NumClienteNuevo				:= 99;						-- Numero para todos los clientes nuevos Procesos Especificos Estado Cuenta: 99

ManejoErrores:BEGIN

	-- Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEspEdoCta := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_EdoCtaGral);

	SET Var_CliProEspEdoCta := IFNULL(Var_CliProEspEdoCta,Entero_Cero);

	-- Se obtiene el nombre del SP a realizar el proceso
	IF(Var_CliProEspEdoCta = NumClienteNuevo) THEN
		SET Var_ProcPersonalizado := (SELECT NomProc FROM CATPROCEDIMIENTOS WHERE ProcedimientoID = HeaderInvEdoCta AND CliProEspID = Var_CliProEspEdoCta);
	ELSE
		LEAVE ManejoErrores;
	END IF;


	-- Se realiza la llamada al SP para realizar el proceso de los detalles de movimientos de creditos
	SET Var_Llamada := CONCAT(' CALL ', Var_ProcPersonalizado,' (',Par_AnioMes,",'",Par_IniMes,"','",Par_FinMes,"');");

	-- Se ejecuta la sentencia del proceso
	SET @Sentencia	=	(Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;

END ManejoErrores;


END TerminaStore$$