-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- SOLBUROCREDITOCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `SOLBUROCREDITOCON`;DELIMITER $$

CREATE PROCEDURE `SOLBUROCREDITOCON`(
	/*SP de Consulta de las solicitudes de Buro de credito*/
	Par_FolioConsul		VARCHAR(30),				# Folio de la Consulta
	Par_RFC				VARCHAR(13),				# RFC del cliente
	Par_NumCon			TINYINT UNSIGNED, 			# Numero de Consulta
	/* Parametros de Auditoria */
	Par_EmpresaID		INT(11),					# Auditoria
	Aud_Usuario			INT(11),					# Auditoria

	Aud_FechaActual		DATETIME,					# Auditoria
	Aud_DireccionIP		VARCHAR(15),				# Auditoria
	Aud_ProgramaID		VARCHAR(50),				# Auditoria
	Aud_Sucursal		INT(11),					# Auditoria
	Aud_NumTransaccion	BIGINT(20)					# Auditoria
)
TerminaStore: BEGIN

/* Declaracion de variables */
DECLARE Par_DiasVigBC		INT;
DECLARE Var_FolioConsulta	VARCHAR(30);
DECLARE Var_FolioConsec		VARCHAR(30);
DECLARE Var_FechaConsulta	DATETIME;
DECLARE Var_DiasVigencia	INT(11);
DECLARE Var_DeudaTotBuro	DECIMAL(14,2);
DECLARE Var_CalificaBuro	VARCHAR(11);

-- Declaracion de constantes
DECLARE  Entero_Cero		INT;
DECLARE  Cadena_Vacia		CHAR(1);
DECLARE  Con_Principal		INT;
DECLARE  Con_Circulo		INT;
DECLARE  Con_FolFecha		INT;
DECLARE  Con_FolFechaC		INT;
DECLARE  Con_Ratios			INT;
DECLARE  Decimal_Cero		DECIMAL(14,2);
DECLARE  Seg23				INT;
DECLARE  Seg38				INT;
DECLARE  Fecha_Vacia		DATE;

	-- Asignacion de constantes
	SET	Entero_Cero		:= 0;
	SET Cadena_Vacia	:='';
	SET	Con_Principal	:= 1;
	SET	Con_Circulo		:= 2;
	SET Con_FolFecha	:= 3;
	SET Con_FolFechaC	:= 4;
	SET Con_Ratios		:= 5;
	SET Decimal_Cero	:= 0.0;
	SET Seg23			:= 23;
	SET Seg38			:= 38;
	SET Fecha_Vacia		:= '1900-01-01';

	SET Aud_FechaActual := CURRENT_TIMESTAMP();
	SET Par_DiasVigBC	:= (SELECT DiasVigenciaBC FROM PARAMETROSSIS);

	IF(Par_NumCon = Con_Principal)THEN
		SELECT  	Sol.RFC, 				Sol.FechaConsulta,		PrimerNombre,		SegundoNombre,	 TercerNombre,
					ApellidoPaterno,	ApellidoMaterno,	EstadoID,			LocalidadID,	 MunicipioID,
					Calle,				NumeroExterior,		NumeroInterior,		Piso,			 Colonia,
					CP,					Lote,				Manzana,			FechaNacimiento, FolioConsulta,
					IFNULL(Par_DiasVigBC-DATEDIFF(NOW(),FechaConsulta),0) AS DiasVigencia,usu.Clave
			FROM SOLBUROCREDITO Sol,USUARIOS usu
			WHERE FolioConsulta = Par_FolioConsul
			AND usu.UsuarioID = Sol.Usuario;
	END IF;

	IF(Par_NumCon = Con_Circulo)THEN
		SELECT  	sol.RFC, 				sol.FechaConsulta,		sol.PrimerNombre,		sol.SegundoNombre,	sol.TercerNombre,
					sol.ApellidoPaterno,	sol.ApellidoMaterno,	sol.EstadoID,			sol.LocalidadID,	sol.MunicipioID,
					sol.Calle,				NumeroExterior,		NumeroInterior,		Piso,				Colonia,
					CP,					Lote,				Manzana,			FechaNacimiento,	FolioConsultaC,
					IFNULL(Par_DiasVigBC-DATEDIFF(NOW(),FechaConsulta),0) AS DiasVigencia, usu.UsuarioCirculo AS UsuarioCirculo,usu.Clave AS Clave
			FROM SOLBUROCREDITO sol,
				 USUARIOS usu
			WHERE sol.FolioConsultaC = Par_FolioConsul
				AND usu.UsuarioID = sol.Usuario;
	END IF;

	IF(Par_NumCon = Con_FolFecha)THEN
		SELECT CONCAT(Bur.BUR_SOLNUM, '&',Bur.FOL_BUR), Sol.FechaConsulta,
			  IFNULL(Par_DiasVigBC-DATEDIFF(NOW(),FechaConsulta),0) AS DiasVigencia
			FROM  SOLBUROCREDITO Sol, bur_fol Bur
			WHERE Sol.RFC=Par_RFC AND !(ISNULL(FolioConsulta))
			AND Sol.FolioConsulta = Bur.BUR_SOLNUM
			ORDER BY FechaConsulta DESC LIMIT 1;
	END IF;

	IF(Par_NumCon = Con_FolFechaC)THEN
		SELECT	Sol.FolioConsultaC,		Sol.FechaConsulta,
				IFNULL(DiasVigenciaBC-DATEDIFF(NOW(),FechaConsulta),0) AS DiasVigencia
		INTO 	Var_FolioConsulta,	Var_FechaConsulta,	Var_DiasVigencia
			FROM  SOLBUROCREDITO Sol,
					PARAMETROSSIS Par,
					USUARIOS Usu
			WHERE Sol.RFC=Par_RFC AND !(ISNULL(FolioConsultaC))
			AND FolioConsultaC != ''
			AND Par.Usuario = Usu.UsuarioID
			ORDER BY FechaConsulta DESC LIMIT 1;
		SET Var_FolioConsulta := CONVERT(IFNULL(CAST(IF(Var_FolioConsulta='Error_al_consultar' OR Var_FolioConsulta='Procesando Respuesta','0',Var_FolioConsulta) AS UNSIGNED),0),CHAR);
		SET Var_FolioConsec := CONVERT(LPAD(Var_FolioConsulta, 10, 0),CHAR);
		SELECT	IFNULL(Var_FolioConsulta,'') AS FolioConsultaC,	Var_FechaConsulta AS FechaConsulta,
				IFNULL(Var_DiasVigencia,0) AS DiasVigencia, Var_FolioConsec AS ConsecutivoFol;
	END IF;


	IF(Par_NumCon = Con_Ratios)THEN
		SELECT	FolioConsulta, FechaConsulta,
			IFNULL(Par_DiasVigBC-DATEDIFF(NOW(),FechaConsulta),0) AS DiasVigencia
			INTO Var_FolioConsulta, Var_FechaConsulta, Var_DiasVigencia
			FROM  SOLBUROCREDITO
				WHERE RFC=Par_RFC AND !(ISNULL(FolioConsulta))
					AND FolioConsulta != ''
						ORDER BY FechaConsulta DESC LIMIT 1;

		SET Var_FolioConsulta	:=IFNULL(Var_FolioConsulta,Cadena_Vacia);
		SET Var_FechaConsulta	:=IFNULL(Var_FechaConsulta, Fecha_Vacia);
		SET Var_DiasVigencia	:=IFNULL(Var_DiasVigencia,Entero_Cero);

		IF(Var_DiasVigencia > 0)THEN
			SELECT SUM(IFNULL(RS_VALOR,Decimal_Cero)) INTO Var_DeudaTotBuro
			FROM 	bur_segrs
			WHERE 	BUR_SOLNUM = Var_FolioConsulta
			AND  	RS_SEGMEN = Seg23;
			SELECT  MAX(CONVERT(IFNULL(TL_VALOR,Cadena_Vacia),UNSIGNED))  INTO Var_CalificaBuro
			FROM 	bur_segtl
			WHERE 	BUR_SOLNUM = Var_FolioConsulta
			AND  	TL_SEGMEN = 26;
		END IF;

		IF (Var_FechaConsulta = '0000-00-00')THEN
			SET Var_FechaConsulta	:= Fecha_Vacia;
		END IF;
		SELECT	IFNULL(Var_FolioConsulta,'') AS FolioConsulta,		Var_FechaConsulta AS FechaConsulta,
				IFNULL(Var_DiasVigencia,0) AS DiasVigencia, 		Var_DeudaTotBuro AS DeudaTotBuro,
				Var_CalificaBuro AS CalificaBuro;
	END IF;-- Consulta Ratios


END TerminaStore$$