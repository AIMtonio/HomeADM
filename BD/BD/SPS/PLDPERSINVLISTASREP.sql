-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDPERSINVLISTASREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDPERSINVLISTASREP`;
DELIMITER $$

CREATE PROCEDURE `PLDPERSINVLISTASREP`(
	/*SP PARA EL REPORTE DE CLIENTES EN LISTAS PLD*/
	Par_TipoRep					TINYINT UNSIGNED,	# Tipo de Reporte 1:Listas Negras 2:Listas P.Bloq. 3:Ambas listas
	Par_Sucursal				INT(11),			# ID de la Sucursal al filtrar
	/* Parametros de Auditoria */
	Aud_EmpresaID				INT(11),			# Auditoria
	Aud_Usuario					INT(11),			# Auditoria
	Aud_FechaActual				DATETIME,			# Auditoria

	Aud_DireccionIP				VARCHAR(15),		# Auditoria
	Aud_ProgramaID				VARCHAR(50),		# Auditoria
	Aud_Sucursal				INT(11),			# Auditoria
	Aud_NumTransaccion			BIGINT(20)			# Auditoria
)
TerminaStore: BEGIN

	DECLARE Var_Sentencia 		TEXT;
	DECLARE Var_FechaCargaLB	DATE;
	DECLARE Var_FechaCargaLN	DATE;

	-- Declaracion de constantes
	DECLARE Cadena_Vacia			CHAR(1);
	DECLARE Fecha_Vacia				DATE;
	DECLARE Entero_Cero				INT;
	DECLARE Reporte_ListasNegras	INT(1);
	DECLARE Reporte_ListasPersBloq	INT(11);
	DECLARE Reporte_ListasAmbas		INT(11);
	DECLARE Lista_Negra				CHAR(1);
	DECLARE Lista_Bloq				CHAR(1);

	-- Asignacion de Constantes
	SET Cadena_Vacia				:= '';				-- Cadena Vacia
	SET Fecha_Vacia					:= '1900-01-01';	-- Fecha Vacia
	SET Entero_Cero					:= 0;				-- Entero Cero
	SET Reporte_ListasNegras		:= 1;				-- Listas Negras
	SET Reporte_ListasPersBloq		:= 2;				-- Listas Personas Bloqueadas
	SET Reporte_ListasAmbas			:= 3;				-- Listas Ambas
	SET Lista_Negra					:='N';				-- Lista Negra
	SET Lista_Bloq					:='B';				-- Lista Personas Bloqueadas
	SET Var_Sentencia				:= '';

	DROP TABLE IF EXISTS TMPREPPERSINVOLUCRADAS;

	CREATE TABLE IF NOT EXISTS TMPREPPERSINVOLUCRADAS(
		ClavePersonaInv 	INT(11),
		NombreCompleto 		VARCHAR(300),
		TipoLista 			VARCHAR(50),
		FechaDeteccion 		DATE,
		FechaAlta	 		DATE,
		FechaDepInicial		DATE,
		NumeroOficio 		VARCHAR(50),
		OrigenDeteccion		VARCHAR(50),
		INDEX(ClavePersonaInv)
	);

	/* DETECCIONES POR PANTALLA */
	SET Var_Sentencia := CONCAT(
		' INSERT INTO TMPREPPERSINVOLUCRADAS (ClavePersonaInv,NombreCompleto,FechaAlta,FechaDepInicial,TipoLista,NumeroOficio,OrigenDeteccion, FechaDeteccion)',
		' SELECT ClavePersonaInv, CLI.NombreCompleto,	CLI.FechaAlta,	CTA.FechaDepInicial AS FechaIniTran,',
        ' CASE "',Par_TipoRep,'" WHEN "',Reporte_ListasNegras,'" THEN TipoListaID',
		' WHEN "',Reporte_ListasPersBloq,'" THEN ',
		' CASE TipoLista WHEN "',Lista_Bloq,'" THEN "LISTA DE PERSONAS BLOQUEADAS" END END AS TipoLista, NumeroOficio,',
		' CONCAT(IF(OrigenDeteccion=\'P\',\'PANTALLA\',\'CARGA MASIVA\'),\' - \',FechaDeteccion), FechaDeteccion',
		' FROM PLDDETECPERS AS Pers INNER JOIN',
		' CLIENTES AS CLI ON Pers.ClavePersonaInv=CLI.ClienteID LEFT JOIN ',
		' CUENTASAHO AS CTA ON CLI.ClienteID = CTA.ClienteID AND FechaDepInicial != "1900-01-01"',
						' WHERE TipoPersonaSAFI = "CTE" ',
						' AND OrigenDeteccion=\'P\' ');
	IF(Par_TipoRep = Reporte_ListasNegras) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Pers.TipoLista = "',Lista_Negra,'"');
	END IF;

	IF(Par_TipoRep = Reporte_ListasPersBloq) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Pers.TipoLista = "',Lista_Bloq,'"');
	END IF;

	IF(Par_Sucursal != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.SucursalOrigen = "',Par_Sucursal,'"');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,' ;');
	SET @Sentencia	:= CONCAT(Var_Sentencia);

	PREPARE PLDPERSINVLISTASREPSENT FROM @Sentencia;
	EXECUTE PLDPERSINVLISTASREPSENT;
	DEALLOCATE PREPARE PLDPERSINVLISTASREPSENT;

	SET Var_Sentencia := CONCAT(
		' INSERT INTO TMPREPPERSINVOLUCRADAS (ClavePersonaInv,NombreCompleto,FechaAlta,FechaDepInicial,TipoLista,NumeroOficio,OrigenDeteccion, FechaDeteccion)',
		' SELECT ClavePersonaInv, CLI.NombreCompleto,	CLI.FechaAlta,	CTA.FechaDepInicial AS FechaIniTran,',
		' CASE "',Par_TipoRep,'" WHEN "',Reporte_ListasNegras,'" THEN TipoListaID',
		' WHEN "',Reporte_ListasPersBloq,'" THEN ',
		' CASE TipoLista WHEN "',Lista_Bloq,'" THEN "LISTA DE PERSONAS BLOQUEADAS" END END AS  TipoLista, NumeroOficio,',
		' CONCAT(IF(OrigenDeteccion=\'P\',\'PANTALLA\',\'CARGA MASIVA\'),\' - \',FechaDeteccion), FechaDeteccion',
		' FROM HISPLDDETECPERS AS Pers INNER JOIN',
		' CLIENTES AS CLI ON Pers.ClavePersonaInv=CLI.ClienteID LEFT JOIN ',
		' CUENTASAHO AS CTA ON CLI.ClienteID = CTA.ClienteID AND FechaDepInicial != "1900-01-01"',
						' WHERE TipoPersonaSAFI = "CTE" ',
						' AND OrigenDeteccion=\'P\' ');

	IF(Par_TipoRep = Reporte_ListasNegras) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Pers.TipoLista = "',Lista_Negra,'"');
	END IF;

	IF(Par_TipoRep = Reporte_ListasPersBloq) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Pers.TipoLista = "',Lista_Bloq,'"');
	END IF;

	IF(Par_Sucursal != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.SucursalOrigen = "',Par_Sucursal,'"');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,' ;');
	SET @Sentencia	:= CONCAT(Var_Sentencia);

	PREPARE PLDPERSINVLISTASREPSENT FROM @Sentencia;
	EXECUTE PLDPERSINVLISTASREPSENT;
	DEALLOCATE PREPARE PLDPERSINVLISTASREPSENT;

	/* DETECCIONES POR CARGA DE LISTAS */
	-- FECHAS DE LA CARGA MAS RECIENTE.
	SET Var_FechaCargaLB := (SELECT FechaAlta FROM PLDLISTAPERSBLOQ
								WHERE ProgramaID != '/microfin/listasPersBVista.htm'
									ORDER by FechaActual DESC LIMIT 1);
	SET Var_FechaCargaLN := (SELECT FechaAlta FROM PLDLISTANEGRAS
								WHERE ProgramaID != '/microfin/listaNegrasVista.htm'
									ORDER by FechaActual DESC LIMIT 1);
	SET Var_FechaCargaLB := IFNULL(Var_FechaCargaLB, Fecha_Vacia);
	SET Var_FechaCargaLN := IFNULL(Var_FechaCargaLN, Fecha_Vacia);

	SET Var_Sentencia := CONCAT(
		' INSERT INTO TMPREPPERSINVOLUCRADAS (ClavePersonaInv,NombreCompleto,FechaAlta,FechaDepInicial,TipoLista,NumeroOficio,OrigenDeteccion, FechaDeteccion)',
		' SELECT ClavePersonaInv, CLI.NombreCompleto,	CLI.FechaAlta,	CTA.FechaDepInicial AS FechaIniTran,',
		' CASE "',Par_TipoRep,'" WHEN "',Reporte_ListasNegras,'" THEN TipoListaID',
		' WHEN "',Reporte_ListasPersBloq,'" THEN ',
		' CASE TipoLista WHEN "',Lista_Bloq,'" THEN "LISTA DE PERSONAS BLOQUEADAS" END END AS  TipoLista, NumeroOficio,',
		' CONCAT(IF(OrigenDeteccion=\'P\',\'PANTALLA\',\'CARGA MASIVA\'),\' - \',FechaDeteccion), FechaDeteccion',
		' FROM PLDDETECPERS AS Pers INNER JOIN',
		' CLIENTES AS CLI ON Pers.ClavePersonaInv=CLI.ClienteID LEFT JOIN ',
		' CUENTASAHO AS CTA ON CLI.ClienteID = CTA.ClienteID AND FechaDepInicial != "1900-01-01"',
						' WHERE TipoPersonaSAFI = "CTE" ',
						' AND OrigenDeteccion=\'C\' ');

	IF(Par_TipoRep = Reporte_ListasNegras) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Pers.TipoLista = "',Lista_Negra,'"');
		SET Var_Sentencia := CONCAT(Var_Sentencia,IF(Var_FechaCargaLN != Fecha_Vacia,CONCAT('AND Pers.FechaAlta = \'',Var_FechaCargaLN,'\' '),'  '));
	END IF;

	IF(Par_TipoRep = Reporte_ListasPersBloq) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Pers.TipoLista = "',Lista_Bloq,'"');
		SET Var_Sentencia := CONCAT(Var_Sentencia,IF(Var_FechaCargaLB != Fecha_Vacia,CONCAT('AND Pers.FechaAlta = \'',Var_FechaCargaLB,'\' '),'  '));
	END IF;

	IF(Par_Sucursal != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.SucursalOrigen = "',Par_Sucursal,'"');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,' ;');
	SET @Sentencia	:= CONCAT(Var_Sentencia);

	PREPARE PLDPERSINVLISTASREPSENT FROM @Sentencia;
	EXECUTE PLDPERSINVLISTASREPSENT;
	DEALLOCATE PREPARE PLDPERSINVLISTASREPSENT;

	SET Var_Sentencia := CONCAT(
		' INSERT INTO TMPREPPERSINVOLUCRADAS (ClavePersonaInv,NombreCompleto,FechaAlta,FechaDepInicial,TipoLista,NumeroOficio,OrigenDeteccion, FechaDeteccion)',
		' SELECT ClavePersonaInv, CLI.NombreCompleto,	CLI.FechaAlta,	CTA.FechaDepInicial AS FechaIniTran,',
		' CASE "',Par_TipoRep,'" WHEN "',Reporte_ListasNegras,'" THEN TipoListaID',
		' WHEN "',Reporte_ListasPersBloq,'" THEN ',
		' CASE TipoLista WHEN "',Lista_Bloq,'" THEN "LISTA DE PERSONAS BLOQUEADAS" END END AS  TipoLista, NumeroOficio,',
		' CONCAT(IF(OrigenDeteccion=\'P\',\'PANTALLA\',\'CARGA MASIVA\'),\' - \',FechaDeteccion), FechaDeteccion',
		' FROM HISPLDDETECPERS AS Pers INNER JOIN',
		' CLIENTES AS CLI ON Pers.ClavePersonaInv=CLI.ClienteID LEFT JOIN ',
		' CUENTASAHO AS CTA ON CLI.ClienteID = CTA.ClienteID AND FechaDepInicial != "1900-01-01"',
						' WHERE TipoPersonaSAFI = "CTE" ',
						' AND OrigenDeteccion=\'C\' ');

	IF(Par_TipoRep = Reporte_ListasNegras) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Pers.TipoLista = "',Lista_Negra,'"');
		SET Var_Sentencia := CONCAT(Var_Sentencia,IF(Var_FechaCargaLN != Fecha_Vacia,CONCAT('AND Pers.FechaAlta = \'',Var_FechaCargaLN,'\' '),'  '));
	END IF;

	IF(Par_TipoRep = Reporte_ListasPersBloq) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND Pers.TipoLista = "',Lista_Bloq,'"');
		SET Var_Sentencia := CONCAT(Var_Sentencia,IF(Var_FechaCargaLB != Fecha_Vacia,CONCAT('AND Pers.FechaAlta = \'',Var_FechaCargaLB,'\' '),'  '));
	END IF;

	IF(Par_Sucursal != Entero_Cero) THEN
		SET Var_Sentencia := CONCAT(Var_Sentencia,' AND CLI.SucursalOrigen = "',Par_Sucursal,'"');
	END IF;

	SET Var_Sentencia := CONCAT(Var_Sentencia,' ;');

	SET @Sentencia	:= CONCAT(Var_Sentencia);

	PREPARE PLDPERSINVLISTASREPSENT FROM @Sentencia;
	EXECUTE PLDPERSINVLISTASREPSENT;
	DEALLOCATE PREPARE PLDPERSINVLISTASREPSENT;

	-- RESULTADO DEL REPORTE
	SELECT
		ClavePersonaInv,	NombreCompleto,		FechaAlta, FechaDepInicial AS FechaIniTran,		TipoLista,
		NumeroOficio, 		OrigenDeteccion
	FROM TMPREPPERSINVOLUCRADAS ORDER BY FechaDeteccion DESC, NombreCompleto ASC;

	TRUNCATE TMPREPPERSINVOLUCRADAS;

END TerminaStore$$