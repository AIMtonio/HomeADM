-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- OPCIONESMENUCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `OPCIONESMENUCON`;DELIMITER $$

CREATE PROCEDURE `OPCIONESMENUCON`(
-- --------------------------------------------------------------------
-- SP DE CONSULTA DE OPCIONES MENU
-- --------------------------------------------------------------------
	Par_OpcionMenuID	INT,
	Par_ClaveUsuario	VARCHAR(45),
	Par_RolID			INT,
	Par_NumCon			TINYINT UNSIGNED,

	Par_EmpresaID		INT,
	Aud_Usuario			INT,
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT,
	Aud_NumTransaccion	BIGINT

	)
TerminaStore:BEGIN

	/*DECLARACION DE CONSTANTES */
	DECLARE	Cadena_Vacia		CHAR(1);
	DECLARE	Fecha_Vacia			DATE;
	DECLARE	Entero_Cero			INT;
	DECLARE	Con_Principal		INT;
	DECLARE	Con_PorPerfil		INT;
	DECLARE Con_RecursosPerf	INT;
	DECLARE TipoMatriz			INT(11);
	DECLARE CancelaCreditos		VARCHAR(200);

	/*DECLARACION DE VARIABLES */
	DECLARE Var_Rol             INT;
    DECLARE Var_ManejaCarteraAgro	CHAR(1);

	/*ASIGNACION DE CONSTANTES */
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET	Con_Principal		:= 1;
	SET	Con_PorPerfil		:= 2;
	SET Con_RecursosPerf	:= 4;

	SET TipoMatriz := (SELECT TipoMatrizPLD FROM PARAMETROSSIS LIMIT 1);
	SET CancelaCreditos := (SELECT ValorParametro FROM PARAMGENERALES WHERE LlaveParametro = 'CancelacionCred');

	/*CONSULTA PRINCIPAL */
	IF(Par_NumCon = Con_Principal) THEN
		SELECT	OpcionMenuID,	GrupoMenuID,	Descripcion,	Desplegado,
				Recurso,		Orden
		FROM OPCIONESMENU
		WHERE  OpcionMenuID = Par_OpcionMenuID;
	END IF;


	/* Consulta para armar el menu dimanico al entrar
	al sistema*/
	IF(Par_NumCon = Con_PorPerfil) THEN
		-- Consulta del rol del usuario
			SELECT RolID INTO Var_Rol
				FROM USUARIOS
				WHERE Clave = Par_ClaveUsuario;
		IF(CancelaCreditos = 'S') THEN
			IF(TipoMatriz = 1) THEN
				-- Filtro por rol y pantalla
				SELECT 	Me.MenuID,		Me.Desplegado,	Gr.GrupoMenuID,		Gr.Desplegado,	Op.OpcionMenuID,
						Op.Desplegado,	Op.Recurso,		Op.RequiereCajero
					FROM	OPCIONESMENU 	Op,
							GRUPOSMENU	  	Gr,
							MENUSAPLICACION	Me,
							OPCIONESROL     opRol
					WHERE opRol.RolID		= Var_Rol
					  AND Op.OpcionMenuID	= opRol.OpcionMenuID
					  AND Op.GrupoMenuID	= Gr.GrupoMenuID
					  AND Gr.MenuID 		= Me.MenuID
					  AND Op.OpcionMenuID NOT IN(886/*MatrizPuntos*/ ,896/*RepHisNivel*/ )
					ORDER BY Me.Orden, Gr.Orden, Op.Orden;
			ELSE
				SELECT 	Me.MenuID,		Me.Desplegado,	Gr.GrupoMenuID,		Gr.Desplegado,	Op.OpcionMenuID,
							Op.Desplegado,	Op.Recurso,		Op.RequiereCajero
						FROM	OPCIONESMENU 	Op,
								GRUPOSMENU	  	Gr,
								MENUSAPLICACION	Me,
								OPCIONESROL     opRol
						WHERE opRol.RolID		= Var_Rol
						  AND Op.OpcionMenuID	= opRol.OpcionMenuID
						  AND Op.GrupoMenuID	= Gr.GrupoMenuID
						  AND Gr.MenuID 		= Me.MenuID
						  AND Op.OpcionMenuID NOT IN(700/*Consulta NivelRe*/ ,703/*RepHistoricoNivelRies*/ ,
						  	699/*ParametrosMatriz*/ ,845/*RepoEvaluacionMasiva*/ )
						ORDER BY Me.Orden, Gr.Orden, Op.Orden;
			END IF;
		  ELSE
			IF(TipoMatriz = 1) THEN
				-- Filtro por rol y pantalla
				SELECT 	Me.MenuID,		Me.Desplegado,	Gr.GrupoMenuID,		Gr.Desplegado,	Op.OpcionMenuID,
						Op.Desplegado,	Op.Recurso,		Op.RequiereCajero
					FROM	OPCIONESMENU 	Op,
							GRUPOSMENU	  	Gr,
							MENUSAPLICACION	Me,
							OPCIONESROL     opRol
					WHERE opRol.RolID		= Var_Rol
					  AND Op.OpcionMenuID	= opRol.OpcionMenuID
					  AND Op.GrupoMenuID	= Gr.GrupoMenuID
					  AND Gr.MenuID 		= Me.MenuID
					  AND Op.OpcionMenuID NOT IN(886/*MatrizPuntos*/ ,896/*RepHisNivel*/ ,902/*Cancelacion cred*/ , 903/*Reporte Cancelacion*/ )
					ORDER BY Me.Orden, Gr.Orden, Op.Orden;
			ELSE
				SELECT 	Me.MenuID,		Me.Desplegado,	Gr.GrupoMenuID,		Gr.Desplegado,	Op.OpcionMenuID,
							Op.Desplegado,	Op.Recurso,		Op.RequiereCajero
						FROM	OPCIONESMENU 	Op,
								GRUPOSMENU	  	Gr,
								MENUSAPLICACION	Me,
								OPCIONESROL     opRol
						WHERE opRol.RolID		= Var_Rol
						  AND Op.OpcionMenuID	= opRol.OpcionMenuID
						  AND Op.GrupoMenuID	= Gr.GrupoMenuID
						  AND Gr.MenuID 		= Me.MenuID
						  AND Op.OpcionMenuID NOT IN(700/*Consulta NivelRe*/ ,703/*RepHistoricoNivelRies*/ ,
						  	699/*ParametrosMatriz*/ ,845/*RepoEvaluacionMasiva*/ ,902/*Cancelacion cred*/ , 903/*Reporte Cancelacion*/ )
						ORDER BY Me.Orden, Gr.Orden, Op.Orden;
			END IF;
		END IF;-- END CANCELA
	END IF;

	/* SE UTILIZA PARA SER MOSTRADA EN PANTALLA  Ocpiones por Rol*/
	IF(Par_NumCon = Con_RecursosPerf) THEN
		-- OBTIENE PARAMEROS SI MANEJA CARTERA AGRO
		SET Var_ManejaCarteraAgro := (SELECT ManejaCarteraAgro FROM PARAMETROSSIS WHERE EmpresaID=1);
		IF(CancelaCreditos = 'S') THEN
        -- SI NO MANEJA CARTERA AGRO NO SE MOSTRARAN LAS PANTALLAS DE ESTE MODULO CON ID 31,32
        IF(Var_ManejaCarteraAgro = 'N')THEN
			-- Filtro por rol y pantalla
			SELECT DISTINCT Me.MenuID, 		Me.Desplegado, 	Gr.GrupoMenuID, 	Gr.Desplegado, 	Op.OpcionMenuID,
							Op.Desplegado, 	Op.Recurso, 	Op.RequiereCajero, 	Me.Orden, 		Gr.Orden, 			Op.Orden
			FROM  OPCIONESMENU Op
				INNER JOIN GRUPOSMENU   Gr
					ON Op.GrupoMenuID = Gr.GrupoMenuID
				INNER JOIN MENUSAPLICACION Me
					ON	Gr.MenuID = Me.MenuID
				LEFT OUTER JOIN   OPCIONESROL     opRol
					ON Op.OpcionMenuID = opRol.OpcionMenuID
			WHERE Me.MenuID NOT IN(31,32)
			ORDER BY Me.Orden, Gr.Orden, Op.Orden;
        ELSE
			-- Filtro por rol y pantalla
			SELECT DISTINCT Me.MenuID, 		Me.Desplegado, 	Gr.GrupoMenuID, 	Gr.Desplegado, 	Op.OpcionMenuID,
							Op.Desplegado, 	Op.Recurso, 	Op.RequiereCajero, 	Me.Orden, 		Gr.Orden, 			Op.Orden
			FROM  OPCIONESMENU Op
			INNER JOIN GRUPOSMENU   Gr
				ON Op.GrupoMenuID = Gr.GrupoMenuID
			INNER JOIN MENUSAPLICACION Me
				ON	Gr.MenuID = Me.MenuID
			LEFT OUTER JOIN   OPCIONESROL     opRol
				ON Op.OpcionMenuID = opRol.OpcionMenuID
			ORDER BY Me.Orden, Gr.Orden, Op.Orden;

        END IF;
       	ELSE
       		IF(Var_ManejaCarteraAgro = 'N')THEN
				-- Filtro por rol y pantalla
				SELECT DISTINCT Me.MenuID, 		Me.Desplegado, 	Gr.GrupoMenuID, 	Gr.Desplegado, 	Op.OpcionMenuID,
								Op.Desplegado, 	Op.Recurso, 	Op.RequiereCajero, 	Me.Orden, 		Gr.Orden, 			Op.Orden
				FROM  OPCIONESMENU Op
					INNER JOIN GRUPOSMENU   Gr
						ON Op.GrupoMenuID = Gr.GrupoMenuID
					INNER JOIN MENUSAPLICACION Me
						ON	Gr.MenuID = Me.MenuID
					LEFT OUTER JOIN   OPCIONESROL     opRol
						ON Op.OpcionMenuID = opRol.OpcionMenuID
				WHERE Me.MenuID NOT IN(31,32,902/*Cancelacion cred*/ , 903/*Reporte Cancelacion*/ )
				ORDER BY Me.Orden, Gr.Orden, Op.Orden;
			  ELSE
				-- Filtro por rol y pantalla
				SELECT DISTINCT Me.MenuID, 		Me.Desplegado, 	Gr.GrupoMenuID, 	Gr.Desplegado, 	Op.OpcionMenuID,
								Op.Desplegado, 	Op.Recurso, 	Op.RequiereCajero, 	Me.Orden, 		Gr.Orden, 			Op.Orden
				FROM  OPCIONESMENU Op
				INNER JOIN GRUPOSMENU   Gr
					ON Op.GrupoMenuID = Gr.GrupoMenuID
				INNER JOIN MENUSAPLICACION Me
					ON	Gr.MenuID = Me.MenuID
				LEFT OUTER JOIN   OPCIONESROL     opRol
					ON Op.OpcionMenuID = opRol.OpcionMenuID
					WHERE Me.MenuID NOT IN(902/*Cancelacion cred*/ , 903/*Reporte Cancelacion*/ )
				ORDER BY Me.Orden, Gr.Orden, Op.Orden;
	        END IF;
       END IF;
	END IF;

END TerminaStore$$