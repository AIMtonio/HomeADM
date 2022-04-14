-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- VERIFICAPREGUNTASSEGREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `VERIFICAPREGUNTASSEGREP`;DELIMITER $$

CREATE PROCEDURE `VERIFICAPREGUNTASSEGREP`(
	-- Reporte Verificacion de Preguntas de Seguridad
	Par_FechaInicio			DATE,				-- Fecha Inicio Disposicion
	Par_FechaFin 			DATE,				-- Fecha Fin Disposicion
	Par_ClienteID 			INT(11),			-- Numero Cliente

	Par_NumReporte			TINYINT UNSIGNED,	-- Numero de Reporte

	Par_EmpresaID 			INT(11),			-- Parametro de Auditoria
	Aud_Usuario 			INT(11),			-- Parametro de Auditoria
	Aud_FechaActual 		DATETIME,			-- Parametro de Auditoria
	Aud_DireccionIP 		VARCHAR(15),		-- Parametro de Auditoria
	Aud_ProgramaID 			VARCHAR(50),		-- Parametro de Auditoria
	Aud_Sucursal 			INT(11),			-- Parametro de Auditoria
	Aud_NumTransaccion 		BIGINT(20)

)
TerminaStore: BEGIN

    -- Declaracion de variables
	DECLARE Var_Sentencia 	VARCHAR(10000);

    -- Declaracion de constantes
	DECLARE Cadena_Vacia	CHAR(1);
	DECLARE Entero_Cero 	INT(11);
	DECLARE Rep_Excel 		INT(11);

    -- Asignacion de constantes
	SET Cadena_Vacia 		:= '';		-- Cadena Vacia
	SET	Entero_Cero 		:= 0;		-- Entero Cero
	SET Rep_Excel 			:= 1; 		-- Reporte Excel Verificacion Preguntas

    -- 1.- Reporte Excel Verificacion Preguntas
	IF(Par_NumReporte = Rep_Excel) THEN
		SET Var_Sentencia :=' SELECT Ver.ClienteID,Cli.NombreCompleto AS NombreCliente,Ver.Telefono AS TelefonoCelular,Pre.CuentaAhoID, ';
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'DATE(Ver.FechaVerifica) AS Fecha, TIME(Ver.FechaVerifica) AS Hora, Sop.Descripcion AS TipoSoporte, ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'Usu.NombreCompleto AS Usuario,Ver.ResultadoFinal AS Resultado ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'FROM VERIFICAPREGUNTASSEG Ver ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN PREGUNTASSEGURIDAD Pre ON  Pre.ClienteID = Ver.ClienteID AND Ver.PreguntaID = Pre.PreguntaID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN CUENTASBCAMOVIL Cta ON Pre.ClienteID = Cta.ClienteID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN CLIENTES Cli ON Cli.ClienteID = Cta.ClienteID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN USUARIOS Usu ON Usu.UsuarioID = Ver.UsuarioID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'INNER JOIN CATTIPOSOPORTE Sop ON Sop.TipoSoporteID = Ver.TipoSoporteID ');
		SET Var_Sentencia := CONCAT(Var_Sentencia, 'WHERE DATE(Ver.FechaVerifica) BETWEEN DATE( "',Par_FechaInicio,'") AND DATE( "',Par_FechaFin,'") ');

		IF(IFNULL(Par_ClienteID, Entero_Cero) != Entero_Cero) THEN
			SET Var_Sentencia := CONCAT(Var_Sentencia, ' AND Ver.ClienteID = ', Par_ClienteID);
		END IF;

        SET Var_Sentencia := CONCAT(Var_Sentencia, ' GROUP BY Ver.FechaVerifica, Ver.ClienteID, Cli.NombreCompleto, Ver.Telefono, Pre.CuentaAhoID, Sop.Descripcion, Usu.NombreCompleto, Ver.ResultadoFinal; ');

		SET @Sentencia	= (Var_Sentencia);

		PREPARE VERIFICAPREGUNTASSEGREP FROM @Sentencia;
		EXECUTE VERIFICAPREGUNTASSEGREP;
		DEALLOCATE PREPARE VERIFICAPREGUNTASSEGREP;

	END IF;


END TerminaStore$$