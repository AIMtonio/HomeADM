-- SP CONVENIOSNOMINALIS

DELIMITER ;

DROP PROCEDURE IF EXISTS HISCONVENIOSNOMINALIS;

DELIMITER $$

CREATE PROCEDURE HISCONVENIOSNOMINALIS (
	-- Stored procedure para listas de la tabla HISCONVENIOSNOMINA
	Par_InstitNominaID			INT(11),			-- Empresa de nomina a la cual pertenece el convenio
	Par_ConvenioNominaID		BIGINT UNSIGNED,	-- Identificador del convenio
	Par_FechaInicio				DATE,				-- Fecha de inicio del intervalo
	Par_FechaFin				DATE,				-- Fecha final del intervalo

	Par_NumLis					TINYINT,			-- Numero de lista

	Par_EmpresaID 				INT(11), 			-- Parametros de auditoria
	Aud_Usuario					INT(11),			-- Parametros de auditoria
	Aud_FechaActual				DATETIME,			-- Parametros de auditoria
	Aud_DireccionIP				VARCHAR(15),		-- Parametros de auditoria
	Aud_ProgramaID				VARCHAR(50),		-- Parametros de auditoria
	Aud_Sucursal				INT(11),			-- Parametros de auditoria
	Aud_NumTransaccion			BIGINT(20)			-- Parametros de auditoria
)
TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero			INT(1);				-- Entero Cero
	DECLARE Var_LisPrincipal	TINYINT UNSIGNED;	-- Lista principal para la pantalla de bitacora de cambios en convenios de nomina
	DECLARE Var_ConstanteN		CHAR(1);			-- Constante N
	DECLARE Var_ConstanteS		CHAR(1);

	-- Asignacion de constantes
	SET Entero_Cero				:= 0;				-- Entero Cero
	SET Var_LisPrincipal		:= 1;				-- Lista principal para la pantalla de bitacora de cambios en convenios de nomina
	SET Var_ConstanteN			:= 'N';				-- Constante N
	SET Var_ConstanteS			:= 'S';				-- Constante S

	-- Lista principal para la pantalla de bitacora de cambios en convenios de nomina
	IF (Par_NumLis = Var_LisPrincipal) THEN
		DROP TEMPORARY TABLE IF EXISTS `TMPHIS`;
		CREATE TEMPORARY TABLE `TMPHIS` (
			FechaCambio				DATETIME,
			NombreInstitNomina		VARCHAR(200),
			ConvenioNominaID		BIGINT UNSIGNED,
			NumActualizaciones		INT(11),
			NombreCompleto			VARCHAR(150),
			NombreSucurs			VARCHAR(50),
			HisConvenioNomID		BIGINT(20),
			InstitNominaID			INT(11)
		);

		INSERT INTO TMPHIS	(	FechaCambio,			NombreInstitNomina,		ConvenioNominaID,		NumActualizaciones,		NombreCompleto,
								NombreSucurs,			HisConvenioNomID,		InstitNominaID			)
			SELECT	His.FechaSistema,					Ins.NombreInstit AS NombreInstitNomina,			His.ConvenioNominaID,	His.NumActualizaciones,
					Usu.NombreCompleto,					Suc.NombreSucurs,		His.HisConvenioNomID,	His.InstitNominaID
				FROM HISCONVENIOSNOMINA His
				INNER JOIN INSTITNOMINA Ins ON His.InstitNominaID = Ins.InstitNominaID
				INNER JOIN USUARIOS Usu ON Usu.UsuarioID = His.Usuario
				INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Usu.SucursalUsuario
				WHERE His.InstitNominaID = CASE WHEN Par_InstitNominaID <> Entero_Cero THEN Par_InstitNominaID ELSE His.InstitNominaID END
				  AND (His.ConvenioNominaID = CASE WHEN Par_ConvenioNominaID <> Entero_Cero THEN Par_ConvenioNominaID ELSE His.ConvenioNominaID END)
				  AND (CAST(His.FechaSistema AS DATE) BETWEEN Par_FechaInicio AND Par_FechaFin);

			SELECT	FechaCambio,		NombreInstitNomina,		ConvenioNominaID,		NumActualizaciones,		NombreCompleto,
					NombreSucurs,		HisConvenioNomID,		InstitNominaID
				FROM TMPHIS
				ORDER BY FechaCambio ASC;
	END IF;
END TerminaStore$$
