-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASBCAMOVILLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASBCAMOVILLIS`;DELIMITER $$

CREATE PROCEDURE `CUENTASBCAMOVILLIS`(



    Par_Nombre        	VARCHAR(50),
    Par_CuentasBcaMovID	BIGINT(20),
    Par_ClienteID		INT(11),
    Par_FechaInicial	DATE,
	Par_FechaFinal		DATE,
	Par_NumLis			TINYINT UNSIGNED,

    Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(20),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

)
TerminaStore: BEGIN

	DECLARE Var_FechaActual     DATE;
	DECLARE Var_Sentencia		VARCHAR(9000);


	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
    DECLARE	Fecha_Cero			VARCHAR(10);
	DECLARE	Entero_Cero			INT;
	DECLARE Estatus_Pen         CHAR(1);
	DECLARE	Lis_Usuario	 		INT;
	DECLARE	Lis_Registro 		INT;
	DECLARE	Lis_UsuaGroup 		INT;
	DECLARE	Lis_UsuaTele 		INT;
	DECLARE	Lis_RegUsuario 		INT;


	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Fecha_Cero				:= '0000-00-00';
	SET	Entero_Cero				:= 0;
	SET	Estatus_Pen				:= 'P';
	SET	Lis_Usuario			    := 1;
	SET	Lis_Registro		    := 2;
	SET Lis_UsuaGroup			:= 3;
	SET Lis_UsuaTele			:= 4;
	SET Lis_RegUsuario			:= 5;


	IF(Par_NumLis = Lis_Usuario) THEN
		SELECT	CM.CuentasBcaMovID,	CI.ClienteID,	CM.Telefono,	CM.UsuarioPDMID,	CI.NombreCompleto,
				CM.Estatus
			FROM CUENTASBCAMOVIL CM
				INNER JOIN	CLIENTES CI ON CM.ClienteID = CI.ClienteID
			WHERE	CI.NombreCompleto LIKE	CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_Registro) THEN
		SELECT	CM.CuentasBcaMovID,	CO.CuentaAhoID,		CM.UsuarioPDMID, CM.Telefono,
				DATE_FORMAT(CM.FechaRegistro,"%Y-%m-%d %H:%i:%s") AS FechaRegistro,
				CI.ClienteID,		CI.NombreCompleto,	CM.Estatus
			FROM CUENTASBCAMOVIL CM
				INNER JOIN	CLIENTES CI ON CM.ClienteID = CI.ClienteID
				INNER JOIN	CUENTASAHO CO ON CO.ClienteID = CI.ClienteID
			WHERE	CM.CuentasBcaMovID 	= Par_CuentasBcaMovID
			  AND	CM.CuentaAhoID 		= CO.CuentaAhoID;
	END IF;

	IF(Par_NumLis = Lis_UsuaGroup) THEN
		SELECT	Entero_Cero AS CuentasBcaMovID,	CI.ClienteID,	Cadena_Vacia AS Telefono,	Entero_Cero AS UsuarioPDMID,	MAX(CI.NombreCompleto) AS NombreCompleto,
				Cadena_Vacia AS Estatus
			FROM CUENTASBCAMOVIL CM
				INNER JOIN	CLIENTES CI ON CM.ClienteID = CI.ClienteID
			WHERE	CI.NombreCompleto LIKE	CONCAT("%", Par_Nombre, "%")
			GROUP BY CI.ClienteID
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_UsuaTele) THEN
		SELECT	CM.CuentasBcaMovID,	CI.ClienteID,	CM.Telefono,	CM.UsuarioPDMID,	CI.NombreCompleto,
				CM.Estatus
			FROM CUENTASBCAMOVIL CM
				INNER JOIN CLIENTES CI ON CM.ClienteID = CI.ClienteID
			WHERE	CM.Telefono LIKE CONCAT("%", Par_Nombre, "%")
			LIMIT 0, 15;
	END IF;

	IF(Par_NumLis = Lis_RegUsuario) THEN
		SET Var_Sentencia := 'SELECT CM.CuentasBcaMovID, CO.CuentaAhoID,	CM.UsuarioPDMID,
									 CM.Telefono, 		 DATE_FORMAT(CM.FechaRegistro,"%Y-%m-%d %H:%i:%s") AS FechaRegistro,
									 CI.ClienteID,		 CI.NombreCompleto,	CM.Estatus';

		SET Var_Sentencia := CONCAT(Var_Sentencia,' FROM CUENTASBCAMOVIL CM
													 INNER JOIN CLIENTES CI ON CM.ClienteID = CI.ClienteID
													 INNER JOIN CUENTASAHO CO ON CO.ClienteID = CI.ClienteID');
		SET Var_Sentencia := CONCAT(Var_Sentencia,' WHERE	CM.ClienteID = ', Par_ClienteID);
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CM.CuentaAhoID = CO.CuentaAhoID');

		IF(IFNULL(Par_FechaInicial,Fecha_Vacia) != Fecha_Vacia AND Par_FechaInicial != Fecha_Cero ) THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND DATE(CM.FechaRegistro) >= "', Par_FechaInicial,'"');
		END IF;
		IF(IFNULL(Par_FechaFinal,Fecha_Vacia) != Fecha_Vacia AND Par_FechaFinal != Fecha_Cero ) THEN
			SET Var_Sentencia :=  CONCAT(Var_Sentencia,' AND DATE(CM.FechaRegistro) <= "', Par_FechaFinal,'"');
		END IF;

		SET @Sentencia	= (Var_Sentencia);

		PREPARE STREGISTROSUSU FROM @Sentencia;
		EXECUTE STREGISTROSUSU;

		DEALLOCATE PREPARE STREGISTROSUSU;

	END IF;

END TerminaStore$$