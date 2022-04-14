-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- GRUPOSCREDITOLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `GRUPOSCREDITOLIS`;DELIMITER $$

CREATE PROCEDURE `GRUPOSCREDITOLIS`(
/*SP PARA EL LISTADO DE GRUPOS DE CREDITO */
	Par_NombreGrupo 	VARCHAR(200),
	Par_NumLis			TINYINT UNSIGNED,

	Aud_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN
	/* Declaracion de Variables */
	DECLARE Var_AtiendeSucursales   CHAR(1);
	DECLARE Var_SucursalUsuario     INT(11);
    DECLARE Var_FechaSistema		DATE;

	-- Declaracion de Constantes
	DECLARE	Cadena_Vacia			CHAR(1);
	DECLARE	Fecha_Vacia				DATE;
	DECLARE	Entero_Cero				INT;
	DECLARE	Lis_Principal			INT;
	DECLARE	Lis_RompGrupo			INT;
	DECLARE	Lis_GrupoSolLiberada	INT;
	DECLARE	Lis_CambioPuestos	    INT;
    DECLARE Lis_EsAgropecuario 		INT;
	DECLARE EstatLiberada      		CHAR(1);
	DECLARE AtiendeSucursal_SI	    CHAR(1);
	DECLARE	AtiendeSucursal_NO	    CHAR(1);
	DECLARE	EstatusActivo			CHAR(1);
    DECLARE Es_Agropecuario			CHAR(1);
    DECLARE No_Es_Agropecuario		CHAR(1);
    DECLARE Lis_GrupoCredDesem		INT(11);
    DECLARE Est_Vigente				CHAR(1);

	-- Asignacion de Constantes
	SET	Cadena_Vacia			:= '';
	SET	Fecha_Vacia				:= '1900-01-01';
	SET	Entero_Cero				:= 0;
	SET	Lis_Principal			:= 1;
	SET	Lis_RompGrupo	    	:= 2;				-- Lista de Grupos de Credito en Rompimiento
	SET	Lis_GrupoSolLiberada	:= 3;				-- Lista de Grupos con Solicitud Liberada
	SET	Lis_CambioPuestos	    := 4;				-- Lista de Grupos para Cambio de Puestos Integrantes
    SET Lis_EsAgropecuario		:= 5;
    SET Lis_GrupoCredDesem		:= 6;				-- Lista de Grupos que tienen creditos desembolsados durante el dia.
	SET EstatLiberada           := 'L';  			-- Estatus de Solicitud Liberada
	SET	AtiendeSucursal_SI		:= 'S';             -- Usuario atiende Sucursal: Si
	SET	AtiendeSucursal_NO		:= 'N';             -- Usuario atiende Sucursal: No
	SET EstatusActivo			:= 'A';
	SET Es_Agropecuario			:= 'S';				-- indica que el grupo  es agropecuario
    SET No_Es_Agropecuario		:= 'N';				-- indica que el grupo no es agropecuario
    SET Est_Vigente				:= 'V';				-- Estatus Vigente

    SET Var_FechaSistema := (SELECT FechaSistema FROM PARAMETROSSIS);

	IF(Par_NumLis = Lis_Principal) THEN
		SELECT Gru.GrupoID, Gru.NombreGrupo, Suc.NombreSucurs
			FROM GRUPOSCREDITO Gru,
				SUCURSALES Suc
			WHERE NombreGrupo	LIKE	CONCAT("%", Par_NombreGrupo, "%")
				AND Gru.SucursalID = Suc.SucursalID
					AND Gru.EsAgropecuario = No_Es_Agropecuario
						LIMIT 0, 15;
	END IF;

	/* Lista de Grupo de Credito en Rompimiento  */
	IF(Par_NumLis = Lis_RompGrupo) THEN
		SELECT  Rmp.GrupoID, Gpo.NombreGrupo, Suc.NombreSucurs
			FROM ROMPIMIENTOSGRUPO Rmp,
				 GRUPOSCREDITO Gpo,
				 SUCURSALES Suc
			WHERE Rmp.GrupoID = Gpo.GrupoID
				AND  Gpo.NombreGrupo	LIKE CONCAT("%", Par_NombreGrupo, "%")
				AND Gpo.SucursalID = Suc.SucursalID
			LIMIT 0, 15;
	END IF;

	/* Lista de Grupos con Solicitudes Liberadas */
	IF(Par_NumLis = Lis_GrupoSolLiberada) THEN
		SELECT Pue.AtiendeSuc,         Usu.SucursalUsuario
		 INTO  Var_AtiendeSucursales,  Var_SucursalUsuario
			FROM USUARIOS Usu
				INNER JOIN PUESTOS Pue
					ON Pue.ClavePuestoID = Usu.ClavePuestoID
				WHERE Usu.UsuarioID = Aud_Usuario;
		SELECT Grp.GrupoID, Grp.NombreGrupo, Suc.NombreSucurs
			FROM GRUPOSCREDITO Grp
				LEFT JOIN SOLICITUDCREDITO Sol	ON Sol.GrupoID = Grp.GrupoID
					AND Grp.CicloActual = Sol.CicloGrupo
				INNER JOIN SUCURSALES Suc	ON Grp.SucursalID = Suc.SucursalID
					WHERE Sol.Estatus = EstatLiberada
						AND ((Var_AtiendeSucursales = AtiendeSucursal_SI
						AND Var_SucursalUsuario = Sol.SucursalID)
						OR Var_AtiendeSucursales = AtiendeSucursal_NO)
						AND (Grp.NombreGrupo LIKE CONCAT("%",Par_NombreGrupo,"%"))
				GROUP BY Grp.GrupoID, Grp.NombreGrupo, Suc.NombreSucurs
			LIMIT 0, 15;
	END IF;

	/* Lista de Grupos para Cambios Puestos Integrantes */
	IF(Par_NumLis = Lis_CambioPuestos) THEN
		SELECT Grp.GrupoID, Grp.NombreGrupo, Suc.NombreSucurs
			FROM GRUPOSCREDITO Grp
				INNER JOIN SUCURSALES Suc
					ON Grp.SucursalID = Suc.SucursalID
				WHERE Grp.NombreGrupo LIKE CONCAT("%",Par_NombreGrupo,"%")
				GROUP BY Grp.GrupoID, Grp.NombreGrupo, Suc.NombreSucurs
		LIMIT 0, 15;
	END IF;

    /*Lista para mostrar grupos agropecuarios*/
    IF(Par_NumLis = Lis_EsAgropecuario) THEN
		SELECT Gru.GrupoID, Gru.NombreGrupo, Suc.NombreSucurs
			FROM GRUPOSCREDITO Gru,
				SUCURSALES Suc
			WHERE NombreGrupo	LIKE	CONCAT("%", Par_NombreGrupo, "%")
				AND Gru.SucursalID = Suc.SucursalID
					AND Gru.EsAgropecuario = Es_Agropecuario
						LIMIT 0, 15;
	END IF;

    # LISTA DE GRUPOS CON CREDITOS DESEMBOLSADOS
    IF(Par_NumLis = Lis_GrupoCredDesem) THEN
		SELECT Gru.GrupoID, Gru.NombreGrupo, Suc.NombreSucurs
			FROM GRUPOSCREDITO Gru
            INNER JOIN 	SUCURSALES Suc
            ON Gru.SucursalID = Suc.SucursalID
            INNER JOIN CREDITOS Cre
            ON Gru.GrupoID = Cre.GrupoID
			WHERE NombreGrupo	LIKE	CONCAT("%", Par_NombreGrupo , "%")
				AND Gru.SucursalID = Suc.SucursalID
					AND Gru.EsAgropecuario = No_Es_Agropecuario
                    AND Cre.FechaInicio = Var_FechaSistema
                    AND Cre.Estatus = Est_Vigente
					AND (Cre.FolioDispersion = Entero_Cero OR Cre.MontoDesemb = Cre.MontoCredito)
                    GROUP BY Gru.GrupoID, Gru.NombreGrupo, Suc.NombreSucurs
						LIMIT 0, 15;
	END IF;

END TerminaStore$$