-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CONTRATOGRUPALREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CONTRATOGRUPALREP`;DELIMITER $$

CREATE PROCEDURE `CONTRATOGRUPALREP`(
	Par_GrupoID				INT,
	Par_TipoConsulta		INT,

	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),
	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN

	DECLARE Var_Llamada				VARCHAR(500);     -- Variable Llamada
	DECLARE Var_ClienteEspecifico	CHAR(3);          -- Variable Cliente Especifico
	DECLARE Con_CliEspecificoPar	CHAR(17);

	SET Var_Llamada 			= 'CALL CONTRATOGRUPAL';
	SET Con_CliEspecificoPar	= 'CliProcEspecifico';

	-- SE BUSCA EL CLIENTE ESPECIFICO PARA LLAMAR EL SP ADECUADO
	SELECT LPAD(ValorParametro, 3, '0') INTO Var_ClienteEspecifico
	  FROM PARAMGENERALES
	 WHERE LlaveParametro = Con_CliEspecificoPar;

	-- SE ARMA LA LLAMADA AL SP DE ACUERDO A LO ENCONTRADO EN LA CONSULTA ANTERIOR
	SET Var_Llamada = CONCAT(	Var_Llamada, Var_ClienteEspecifico,
								'REP(',	Par_GrupoID, ',', Par_TipoConsulta, ',',
								Aud_EmpresaID, ',',
								Aud_Usuario, ',',
								"'", Aud_FechaActual, "',",
								"'", Aud_DireccionIP, "',",
								"'", Aud_ProgramaID, "',",
								Aud_Sucursal, ',',
								Aud_NumTransaccion,
								');'
							);

	-- SE REALIZA LA LLAMADA ARMADA ANTERIORMENTE
	SET @Sentencia = Var_Llamada;
	PREPARE EjecutaProc FROM @Sentencia;
	EXECUTE EjecutaProc;
	DEALLOCATE PREPARE EjecutaProc;

END TerminaStore$$