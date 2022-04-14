-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDOCUMENTOSEXPIRAREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDOCUMENTOSEXPIRAREP`;DELIMITER $$

CREATE PROCEDURE `PLDDOCUMENTOSEXPIRAREP`(
/* STORE QUE GENERA EL REPORTE DE OPERACIONES PLD SEGUN EL LAYOUT OFICIAL */
	Par_FechaInicio			DATE,				-- Fecha Final del Periodo
	Par_FechaFinal			DATE,				-- Fecha Final del Periodo
	Par_Sucursal			INT(11),			-- Sucursal
	Par_NivelRiesgo			CHAR(1),			-- Nivel Riesgo Cliente
	Par_Estatus				CHAR(1),			-- Estatus del documento
	Par_NumCon				INT(11),			-- No. de Lista

	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_Sentencia				VARCHAR(6000);			# Sentencia SQL
	DECLARE Var_Filtro					VARCHAR(6000);			# Sentencia SQL
	DECLARE Var_TipoDocumento			INT(11);
	DECLARE Var_FechaSiste				DATE;

	-- Declaracion de Constantes
	DECLARE Rep_DocumentosExpira		INT(11);				# Tipo de Reporte Inusuales
	DECLARE Cadena_Vacia				CHAR(1);				# Constante cadena vacia ''
	DECLARE Fecha_Vacia					DATE;					# Constante Fecha vacia 1900-01-01
	DECLARE Entero_Cero					INT(1);					# Constante Entero cero 0
	DECLARE Decimal_Cero				DECIMAL(14,2);			# DECIMAL cero
	DECLARE Est_Expirado				CHAR(1);
	DECLARE Est_Vigente					CHAR(1);
	DECLARE Estatus_Todas				CHAR(1);

	-- Asignacion de constantes
	SET Rep_DocumentosExpira			:= 1;
	SET Cadena_Vacia					:= '';
	SET Fecha_Vacia						:= '1900-01-01';
	SET Entero_Cero						:= 0;
	SET Decimal_Cero					:= 0;
	SET Est_Expirado					:= 'E';
	SET Est_Vigente						:= 'V';
	SET Estatus_Todas					:= 'T';

	IF(Par_NumCon = Rep_DocumentosExpira) THEN
		SET Par_Sucursal			:= IFNULL(Par_Sucursal,Entero_Cero);
		SET Par_NivelRiesgo			:= IFNULL(Par_NivelRiesgo, Cadena_Vacia);
		SET Par_Estatus				:= IFNULL(Par_Estatus, Cadena_Vacia);
		SET Var_Filtro				:= IFNULL(Var_Filtro, Cadena_Vacia);

		SELECT
			FechaSistema,			TipoDocDomID
			INTO Var_FechaSiste,	Var_TipoDocumento
			FROM PARAMETROSSIS LIMIT 1;

		DROP TABLE IF EXISTS TMPARCHIVOSPLDEXPIRA;
		CREATE TEMPORARY TABLE TMPARCHIVOSPLDEXPIRA(
			ClienteID				INT(11),
			ClienteArchivosID		INT(11),
			FechaExpira				DATE,
			Estatus 				CHAR(1),
			INDEX (ClienteID, ClienteArchivosID)
			);

		INSERT INTO TMPARCHIVOSPLDEXPIRA(
			ClienteID,				ClienteArchivosID, 			FechaExpira,			Estatus)
		SELECT
			DISTINCT
			ClienteID,			ClienteArchivosID,					MAX(FechaExpira),		IF(MAX(FechaExpira)<Var_FechaSiste,'E','V')
			FROM CLIENTEARCHIVOS AS ARC
				WHERE ARC.TipoDocumento = Var_TipoDocumento
					AND FechaExpira BETWEEN Par_FechaInicio AND Par_FechaFinal
					GROUP BY ARC.ClienteID,ClienteArchivosID;


		IF(Par_Sucursal != Entero_Cero) THEN
			SET Var_Filtro	:= CONCAT(Var_Filtro,' WHERE CLI.SucursalOrigen = ',Par_Sucursal);
		END IF;

		IF(Par_NivelRiesgo != Cadena_Vacia AND Par_NivelRiesgo != Estatus_Todas) THEN
			SET Var_Filtro	:= CONCAT(IF(Var_Filtro = Cadena_Vacia," WHERE ",CONCAT(Var_Filtro," AND "))," CLI.NivelRiesgo = '",Par_NivelRiesgo,"'");
		END IF;

		IF(Par_Estatus != Cadena_Vacia AND Par_Estatus != Estatus_Todas) THEN
			SET Var_Filtro	:= CONCAT(IF(Var_Filtro = Cadena_Vacia," WHERE ",CONCAT(Var_Filtro," AND "))," TMP.Estatus = '",Par_Estatus,"'");
		END IF;

		SET Var_Sentencia := CONCAT("SELECT CLI.SucursalOrigen, SUC.NombreSucurs,CLI.ClienteID,CLI.NombreCompleto,  CTE.FechaRegistro,CTE.FechaExpira,
				IF(CLI.NivelRiesgo='B','BAJO',IF(CLI.NivelRiesgo = 'M','MEDIO', 'ALTO')) AS NivelRiesgo,
				IF(TMP.Estatus ='E','VENCIDO','VIGENTE') AS Estatus
					FROM
						TMPARCHIVOSPLDEXPIRA AS TMP INNER JOIN
						CLIENTEARCHIVOS AS CTE ON TMP.ClienteID = CTE.ClienteID AND TMP.ClienteArchivosID = CTE.ClienteArchivosID
						INNER JOIN CLIENTES AS CLI ON CTE. ClienteID = CLI.ClienteID
						INNER JOIN SUCURSALES AS SUC ON CLI.SucursalOrigen = SUC.SucursalID ",Var_Filtro,"
				ORDER BY CLI.SucursalOrigen,CLI.ClienteID,CTE.ClienteArchivosID;");
		SET @Sentencia := (Var_Sentencia);

		PREPARE DOCSEXPIRAPLD FROM @Sentencia;
		EXECUTE DOCSEXPIRAPLD;
		DEALLOCATE PREPARE DOCSEXPIRAPLD;

		DROP TABLE IF EXISTS TMPARCHIVOSPLDEXPIRA;
	END IF;
END TerminaStore$$