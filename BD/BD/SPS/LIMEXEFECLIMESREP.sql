-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- LIMEXEFECLIMESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `LIMEXEFECLIMESREP`;
DELIMITER $$


CREATE PROCEDURE `LIMEXEFECLIMESREP`(
	Par_FechaInicio			DATE,
	Par_FechaFin			DATE,
	Par_Monto				DECIMAL(18,4),
	Par_TipoPersona			VARCHAR(2),

	Par_NumRep				TINYINT UNSIGNED,
	Par_EmpresaID			INT,
	Aud_Usuario				INT,
	Aud_FechaActual			DATE,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT,
	Aud_NumTransaccion		BIGINT

	)

TerminaStore: BEGIN
	-- Declaracion de Variables
    DECLARE NumClienteSofi		INT(11);				-- Numero de Cliente para Sofi Express Procesos Especificos: 15
    DECLARE Var_ProcPersonalizado	VARCHAR(200);		-- Almacena el nombre del SP para generar los detalles de los creditos
    DECLARE Var_CliProEsp   	INT(11);				-- Almacena el Numero de Cliente para Procesos Especificos

    DECLARE Var_Llamada			VARCHAR(1000);			-- Almacena la llamada a realizar el proceso
	-- Declaracion de constantes
	DECLARE Cadena_Vacia		CHAR(1);				-- Cadena o String Vacio
	DECLARE Decimal_Cero		DECIMAL(12,2);			-- Decimal en Cero
	DECLARE Entero_Cero			INT;					-- Entero en Cero
	DECLARE Fecha_Vacia			DATE;					-- Fecha Vacia
	DECLARE SalidaSi			CHAR(1);				-- Salida Si

    DECLARE Con_CliProcEspe     VARCHAR(20);			-- Numero de Cliente para Procesos Especificos
    DECLARE Rep_LimExcep		INT(11);				-- Reporte de Operaciones con Limites Excedidos


	-- Asignacion de Constantes
	SET Cadena_Vacia			:= '';				-- Cadena o String Vacio
	SET Decimal_Cero			:= 0.0;				-- Decimal en Cero
	SET Entero_Cero				:= 0;				-- Entero en Cero
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET SalidaSi				:= 'S';				-- Salida Si

    SET NumClienteSofi			:= 15;
    SET Con_CliProcEspe     	:= 'CliProcEspecifico'; -- Numero de Cliente para Procesos Especificos
	SET Rep_LimExcep			:= 1;				-- Reporte de Operaciones con Limites Excedidos

	IF(Par_NumRep = Rep_LimExcep) THEN
		-- Se obtiene el Numero de Cliente para Procesos Especificos
	SET Var_CliProEsp := 	(SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = Con_CliProcEspe);
    SET Var_CliProEsp := IFNULL(Var_CliProEsp,Entero_Cero);
    SET Aud_ProgramaID := IFNULL(Aud_ProgramaID,Cadena_Vacia);

    IF(Var_CliProEsp = NumClienteSofi) THEN
		SET Var_ProcPersonalizado := (' LIMEXEFECLIMES015REP ');
	ELSEIF(Var_CliProEsp > Entero_Cero) THEN
		SET Var_ProcPersonalizado := (' LIMEXEFECLIMES000REP ');
	END IF;

    	-- Se realiza la llamada al SP para realizar el proceso del timbrado CFDI
	SET Var_Llamada := CONCAT(' CALL ', Var_ProcPersonalizado," ('",Par_FechaInicio,
			"','",Par_FechaFin,			"','",	Par_Monto,				"','",	Par_TipoPersona,		"','",	Par_NumRep,
            "','",Par_EmpresaID,		"','",	Aud_Usuario,			"','",	Aud_FechaActual,		"','",	Aud_DireccionIP,
            "','",Aud_ProgramaID,		"','",	Aud_Sucursal,			"','",	Aud_NumTransaccion,"');");
	-- Se ejecuta la sentencia del proceso
	SET @Sentencia    := (Var_Llamada);
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE  EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;

END IF;

END TerminaStore$$
