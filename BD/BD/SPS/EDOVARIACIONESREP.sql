-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- EDOVARIACIONESREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOVARIACIONESREP`;DELIMITER $$

CREATE PROCEDURE `EDOVARIACIONESREP`(
	# ==============================================================
	# ---- SP PARA GENERAR EL REPORTE DE VARIACIONES DE CAPITAL ----
	# ==============================================================
	Par_Ejercicio       INT(11),
	Par_Periodo         INT(11),
	Par_Fecha           DATE,
	Par_TipoConsulta    CHAR(1),
	Par_SaldosCero      CHAR(1),

	Par_Cifras          CHAR(1),
	Par_CCInicial		INT(11),
	Par_CCFinal			INT(11),
	Par_EmpresaID       INT(11),
	Aud_Usuario         INT(11),

	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT(11),
	Aud_NumTransaccion  BIGINT(20)
	)
TerminaStore: BEGIN

	-- Declaracion de variables
	DECLARE Var_CliProEsp   		INT(11);
	DECLARE Var_Llamada 			VARCHAR(400);
	DECLARE Var_ProcPersonalizado 	VARCHAR(200);

	-- Declaracion de constantes
	DECLARE Entero_Cero    			INT(11);
	DECLARE Con_VariaCapital 		INT(11);
	DECLARE Con_CliProcEspe     	VARCHAR(20);
	DECLARE Edo_VariacionGeneral 	VARCHAR(30);

	-- Asignacion de constantes
	SET Entero_Cero 			:= 0;					-- Entero Cero
	SET Con_VariaCapital		:= 5;					-- Identificador Estado de Variacion de Capital
	SET Con_CliProcEspe     	:= 'CliProcEspecifico'; -- Numero de Cliente para Procesos Especificos
	SET Edo_VariacionGeneral 	:= 'EDOVARIACIONES000REP';	-- SP General

	ManejoErrores:BEGIN

		SELECT IFNULL(ValorParametro, Entero_Cero)   into Var_CliProEsp
		    FROM PARAMGENERALES
		    WHERE LlaveParametro = Con_CliProcEspe;


		SET Var_ProcPersonalizado:=(SELECT NomProc
		FROM CATPROCEDIMIENTOS
		WHERE ProcedimientoID = Con_VariaCapital
		  and CliProEspID = Var_CliProEsp);

		SET Edo_VariacionGeneral := IFNULL(Var_ProcPersonalizado, Edo_VariacionGeneral);

		SET Var_Llamada := concat(' CALL ', Var_ProcPersonalizado,' (',Par_Ejercicio,',',Par_Periodo,',',"'",Par_Fecha,"'",",","'",Par_TipoConsulta,"'",",","'",Par_SaldosCero,"'",",","'",Par_Cifras,"'",",",Par_CCInicial,",",Par_CCFinal,",",Par_EmpresaID,",",Aud_Usuario,",","'",Aud_FechaActual,"'",",","'",Aud_DireccionIP,"'",",","'",Aud_ProgramaID,"'",",","'",Aud_Sucursal,"'",",","'",Aud_NumTransaccion,"'",");");

		SET @Sentencia    = (Var_Llamada);
		PREPARE EjecutaProc FROM @Sentencia;
		EXECUTE  EjecutaProc;
		DEALLOCATE PREPARE EjecutaProc;

	END ManejoErrores;


END TerminaStore$$