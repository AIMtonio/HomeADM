-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- ACTACONSTIGRUPREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `ACTACONSTIGRUPREP`;DELIMITER $$

CREATE PROCEDURE `ACTACONSTIGRUPREP`(
# ========================================================
# ----- SP PARA GENERAR INFORMACION ACTA CONSTITUTIVA-----
# ========================================================
	Par_GrupoID			INT(11),
	Par_TipoConsulta	INT(1),

	Par_EmpresaID      	INT,
	Aud_Usuario         INT,
	Aud_FechaActual     DATETIME,
	Aud_DireccionIP     VARCHAR(15),
	Aud_ProgramaID      VARCHAR(50),
	Aud_Sucursal        INT,
	Aud_NumTransaccion  BIGINT
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_NumRECA     	VARCHAR(200);
	DECLARE Var_PresCliID   	BIGINT;
	DECLARE Var_PresProID   	BIGINT;
	DECLARE Var_NombrePres  	VARCHAR(200);
	DECLARE Var_GaranLiq		DECIMAL(12,4);
	DECLARE Var_GrupoID	  		INT(11);

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Oficial_SI			CHAR(1);
	DECLARE Hora				TIME;
	DECLARE Anio				INT(5);
	DECLARE Dia					INT(3);
	DECLARE Secretario			INT(1);
	DECLARE Tesorero			INT(1);
	DECLARE Presidente			INT(1);
	DECLARE Principal			INT(1);
	DECLARE TipoCargo			INT(1);
	DECLARE Var_NombreSecre		VARCHAR(100);
	DECLARE Var_NombreTeso		VARCHAR(100);
	DECLARE Mes					VARCHAR(20);
	DECLARE Var_DirecCompleta	VARCHAR(500);
	DECLARE Var_NombreGrupo		VARCHAR(100);
	DECLARE Decimal_Cero		DECIMAL(14,2);

	-- Asigancion de Constantes
	SET Cadena_Vacia    		:= '';			-- Cadena Vacia
	SET Fecha_Vacia     		:= '1900-01-01';-- Fecha Vacia
	SET Entero_Cero     		:= 0;			-- Entero Cero
	SET Estatus_Activo			:= 'A';			-- Estatus Activo de los integrantes del grupo
	SET	Decimal_Cero			:= 0.00;		-- DECIMAL Cero
	SET Oficial_SI				:= 'S';			-- Si la direccion del Cliente es oficial
	SET Secretario				:= 3;			-- Tipo de Cargo Secretario(a)
	SET Tesorero				:= 2;			-- Tipo Cargo Teseorero(a)
	SET Presidente				:= 1;			-- Tipo de Cargo Presidente
	SET Principal				:= 1;			-- Consulta de Datos para el ActaConstitutiva
	SET TipoCargo				:= 2;			-- Consulta de Datos para los Tipos de Cargos de los integrantes del grupo


	-- Inicializacion
	SET Hora					:= CURTIME();	-- Hora actual para el reporte
	SET Anio					:= YEAR(NOW());	-- Anio Actual
	SET Dia						:= DAY(NOW());	-- Dia Actual


	-- Inicio de Consulta para el reporte de Acta Constitutiva
	IF(Par_TipoConsulta = Principal) THEN
	-- Consulta Registro Reca, Garantia liquida, Nombre del Cliente y Mes
		SELECT  Inte.GrupoID,	Prod.RegistroRECA,	Sol.PorcGarLiq , 	Cli.ClienteID,	 Pro.ProspectoID,
				CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero THEN
						  CONCAT(Pro.PrimerNombre,
								(CASE WHEN IFNULL(Pro.SegundoNombre, '') != '' THEN CONCAT(' ', Pro.SegundoNombre)
									ELSE Cadena_Vacia END),
								(CASE WHEN IFNULL(Pro.TercerNombre, '') != '' THEN  CONCAT(' ', Pro.TercerNombre)
									  ELSE Cadena_Vacia END), ' ',
								Pro.ApellidoPaterno, ' ', Pro.ApellidoMaterno)
					  ELSE
						 CONCAT(Cli.PrimerNombre,
								(CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
									  ELSE Cadena_Vacia END),
								(CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
									  ELSE Cadena_Vacia END), ' ',
								Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
					 END,
				-- Mes para el Acta Constitutiva
				CASE	WHEN MONTH(NOW()) = 1 THEN 'ENERO'
						WHEN MONTH(NOW()) = 2 THEN 'FEBRERO'
						WHEN MONTH(NOW()) = 3 THEN 'MARZO'
						WHEN MONTH(NOW()) = 4 THEN 'ABRIL'
						WHEN MONTH(NOW()) = 5 THEN 'MAYO'
						WHEN MONTH(NOW()) = 6 THEN 'JUNIO'
						WHEN MONTH(NOW()) = 7 THEN 'JULIO'
						WHEN MONTH(NOW()) = 8 THEN 'AGOSTO'
						WHEN MONTH(NOW()) = 9 THEN 'SEPTIEMBRE'
						WHEN MONTH(NOW()) = 10 THEN 'OCTUBRE'
						WHEN MONTH(NOW()) = 11 THEN 'NOVIEMBRE'
						WHEN MONTH(NOW()) = 12 THEN 'DICIEMBRE'
				END
				INTO
				Var_GrupoID, 		Var_NumRECA, 	Var_GaranLiq, 	Var_PresCliID, 	Var_PresProID,
				Var_NombrePres,	Mes

			FROM INTEGRAGRUPOSCRE Inte,
				 PRODUCTOSCREDITO Prod,
				 SOLICITUDCREDITO Sol

			LEFT JOIN CLIENTES Cli    ON Sol.ClienteID  = Cli.ClienteID
			LEFT JOIN PROSPECTOS Pro ON Sol.ProspectoID = Pro.ProspectoID

			WHERE 	Inte.GrupoID  			= Par_GrupoID
			AND 	Inte.Cargo    			= Presidente
			AND 	Inte.SolicitudCreditoID	= Sol.SolicitudCreditoID
			AND 	Sol.ProductoCreditoID 	= Prod.ProducCreditoID
            AND 	Inte.Estatus			= Estatus_Activo;

			SET Var_PresCliID   := IFNULL(Var_PresCliID, Entero_Cero);
			SET Var_PresProID   := IFNULL(Var_PresProID, Entero_Cero);

			-- Consultamos la Direccion del Cliente o Prospecto
			IF(Var_PresCliID != Entero_Cero) THEN
				SELECT Dir.DireccionCompleta INTO Var_DirecCompleta
					FROM  	DIRECCLIENTE Dir
					WHERE	Dir.ClienteID	= Var_PresCliID
					AND 	Dir.Oficial 	= Oficial_SI;

			ELSE
				SELECT
					CONCAT(Pros.Calle,
							(CASE WHEN IFNULL(Pros.NumExterior, '') != '' THEN CONCAT(' ', Pros.NumExterior)
								ELSE Cadena_Vacia END),
							(CASE WHEN IFNULL(Pros.NumInterior, '') != '' THEN  CONCAT(' ', Pros.NumInterior)
								  ELSE Cadena_Vacia END),
							(CASE WHEN IFNULL(Pros.Manzana, '') != '' THEN  CONCAT(' ', Pros.Manzana)
								  ELSE Cadena_Vacia END),
							(CASE WHEN IFNULL(Pros.Lote, '') != '' THEN  CONCAT(' ', Pros.Lote)
								  ELSE Cadena_Vacia END),' ',
							   Colonia,' ', CP,' ',Mun.Nombre, ' ', Est.Nombre)

					INTO Var_DirecCompleta

				FROM PROSPECTOS Pros
				LEFT JOIN ESTADOSREPUB 		Est	ON	Est.EstadoID	= Pros.EstadoID
				LEFT JOIN MUNICIPIOSREPUB	Mun	ON	Mun.EstadoID	= Pros.EstadoID
											AND Mun.MunicipioID		= Pros.MunicipioID
				WHERE Pros.ProspectoID	= Var_PresProID;

			END IF;

		-- Consulta Nombre De grupo
		SELECT Gru.NombreGrupo INTO Var_NombreGrupo
			FROM 	GRUPOSCREDITO Gru
			WHERE 	Gru.GrupoID	= Var_GrupoID;

		-- Nombre del Secretario del Grupo
		SELECT
			CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero  THEN
				CONCAT(Pros.PrimerNombre,
						(CASE WHEN IFNULL(Pros.SegundoNombre, '') != '' THEN CONCAT(' ', Pros.SegundoNombre)
							ELSE Cadena_Vacia END),
						(CASE WHEN IFNULL(Pros.TercerNombre, '') != '' THEN  CONCAT(' ', Pros.TercerNombre)
							ELSE Cadena_Vacia END), ' ',
				Pros.ApellidoPaterno, ' ', Pros.ApellidoMaterno)
			ELSE
				CONCAT(Cli.PrimerNombre,
						(CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
							ELSE Cadena_Vacia END),
						(CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
							ELSE Cadena_Vacia END), ' ',
				Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
			END INTO Var_NombreSecre
		FROM INTEGRAGRUPOSCRE Inte
			LEFT JOIN CLIENTES Cli 	ON	Inte.ClienteID 		= Cli.ClienteID
			LEFT JOIN PROSPECTOS Pros	ON Cli.ClienteID	= Pros.ClienteID
		WHERE 	Inte.GrupoID 	= Par_GrupoID
		AND 	Inte.Estatus	= Estatus_Activo
		AND 	Inte.Cargo		= Secretario;

	-- Nombre del Tesorero del Grupo
		SELECT
			CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero  THEN
				CONCAT(Pros.PrimerNombre,
					(CASE WHEN IFNULL(Pros.SegundoNombre, '') != '' THEN CONCAT(' ', Pros.SegundoNombre)
						ELSE Cadena_Vacia END),
					(CASE WHEN IFNULL(Pros.TercerNombre, '') != '' THEN  CONCAT(' ', Pros.TercerNombre)
						ELSE Cadena_Vacia END), ' ',
				Pros.ApellidoPaterno, ' ', Pros.ApellidoMaterno)
			ELSE
				CONCAT(Cli.PrimerNombre,
					(CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
						ELSE Cadena_Vacia END),
					(CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
						 ELSE Cadena_Vacia END), ' ',
				Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
			END  INTO Var_NombreTeso
		FROM INTEGRAGRUPOSCRE Inte
			LEFT JOIN CLIENTES Cli		ON Inte.ClienteID 	= Cli.ClienteID
			LEFT JOIN PROSPECTOS Pros	ON Cli.ClienteID	= Pros.ClienteID
		WHERE 	Inte.GrupoID 	= Par_GrupoID
		AND 	Inte.Estatus	= Estatus_Activo
		AND 	Inte.Cargo		= Tesorero ;

	-- Seleccion de las variables para el ActaConstitutiva
		SET Var_NumRECA			:= IFNULL(Var_NumRECA,Cadena_Vacia);
		SET Var_GaranLiq		:= IFNULL(Var_GaranLiq,Decimal_Cero);
		SET Var_NombrePres		:= IFNULL(Var_NombrePres,Cadena_Vacia);
		SET Var_NombreSecre		:= IFNULL(Var_NombreSecre,Cadena_Vacia);
		SET Var_NombreTeso		:= IFNULL(Var_NombreTeso,Cadena_Vacia);
		SET Var_DirecCompleta	:= IFNULL(Var_DirecCompleta,Cadena_Vacia);
		SET Var_NombreGrupo		:= IFNULL(Var_NombreGrupo,Cadena_Vacia);

		SELECT 	Var_NumRECA,		ROUND(Var_GaranLiq,2),		Var_NombrePres,	Var_NombreSecre ,	Var_NombreTeso,
				Var_DirecCompleta,	Var_NombreGrupo, 			Mes,			Hora,      			Anio,
				Dia;
	END IF;



	-- Consulta de los Integrantes del Grupo
	IF(Par_TipoConsulta = TipoCargo) THEN
		SELECT
			CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero  THEN
				CONCAT(Pros.PrimerNombre,
						(CASE WHEN IFNULL(Pros.SegundoNombre, '') != '' THEN CONCAT(' ', Pros.SegundoNombre)
							ELSE Cadena_Vacia END),
						(CASE WHEN IFNULL(Pros.TercerNombre, '') != '' THEN  CONCAT(' ', Pros.TercerNombre)
							ELSE Cadena_Vacia	END), ' ',
				Pros.ApellidoPaterno, ' ', Pros.ApellidoMaterno)
			ELSE
				CONCAT(Cli.PrimerNombre,
						(CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
							ELSE Cadena_Vacia	END),
						(CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
							ELSE Cadena_Vacia	END), ' ',
				Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
			END INTO Var_NombrePres
		FROM INTEGRAGRUPOSCRE Inte
			LEFT JOIN CLIENTES Cli		ON Inte.ClienteID 	= Cli.ClienteID
			LEFT JOIN PROSPECTOS Pros	ON Cli.ClienteID	= Pros.ClienteID
		WHERE 	Inte.GrupoID 	= Par_GrupoID
		AND 	Inte.Estatus	= Estatus_Activo
		AND 	Inte.Cargo		= Presidente ;


		SELECT
			CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero  THEN
				CONCAT(Pros.PrimerNombre,
						(CASE WHEN IFNULL(Pros.SegundoNombre, '') != '' THEN CONCAT(' ', Pros.SegundoNombre)
							ELSE Cadena_Vacia END),
						(CASE WHEN IFNULL(Pros.TercerNombre, '') != '' THEN  CONCAT(' ', Pros.TercerNombre)
							ELSE Cadena_Vacia END), ' ',
				Pros.ApellidoPaterno, ' ', Pros.ApellidoMaterno)
			ELSE
				CONCAT(Cli.PrimerNombre,
						(CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
							ELSE Cadena_Vacia END),
						(CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
							ELSE Cadena_Vacia END), ' ',
				Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
			END INTO Var_NombreSecre
		FROM INTEGRAGRUPOSCRE Inte
			LEFT JOIN CLIENTES Cli 		ON	Inte.ClienteID 	= Cli.ClienteID
			LEFT JOIN PROSPECTOS Pros		ON Cli.ClienteID 		= Pros.ClienteID
		WHERE Inte.GrupoID = Par_GrupoID
			AND Inte.Estatus= Estatus_Activo
			AND Inte.Cargo= Secretario ;


		SELECT
			CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero  THEN
				CONCAT(Pros.PrimerNombre,
					(CASE WHEN IFNULL(Pros.SegundoNombre, '') != '' THEN CONCAT(' ', Pros.SegundoNombre)
						  ELSE Cadena_Vacia END),
					(CASE WHEN IFNULL(Pros.TercerNombre, '') != '' THEN  CONCAT(' ', Pros.TercerNombre)
						  ELSE Cadena_Vacia END), ' ',
				Pros.ApellidoPaterno, ' ', Pros.ApellidoMaterno)
			ELSE
				CONCAT(Cli.PrimerNombre,
					(CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
						  ELSE Cadena_Vacia END),
					(CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
						  ELSE Cadena_Vacia END), ' ',
				Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
			END  INTO Var_NombreTeso
		FROM INTEGRAGRUPOSCRE Inte
			LEFT JOIN CLIENTES Cli 		ON Inte.ClienteID = Cli.ClienteID
			LEFT JOIN PROSPECTOS Pros		ON Cli.ClienteID = Pros.ClienteID
		WHERE Inte.GrupoID = Par_GrupoID
			AND Inte.Estatus= Estatus_Activo
			AND Inte.Cargo= Tesorero ;

			SET Var_NombrePres	:= IFNULL(Var_NombrePres,Cadena_Vacia);
			SET Var_NombreSecre	:= IFNULL(Var_NombreSecre,Cadena_Vacia);
			SET Var_NombreTeso	:= IFNULL(Var_NombreTeso,Cadena_Vacia);

		SELECT
			CASE WHEN IFNULL(Cli.ClienteID, Entero_Cero) <= Entero_Cero  THEN
				CONCAT(Pros.PrimerNombre,
						(CASE WHEN IFNULL(Pros.SegundoNombre, '') != '' THEN CONCAT(' ', Pros.SegundoNombre)
							ELSE Cadena_Vacia END),
						(CASE WHEN IFNULL(Pros.TercerNombre, '') != '' THEN  CONCAT(' ', Pros.TercerNombre)
							ELSE Cadena_Vacia	END), ' ',
				Pros.ApellidoPaterno, ' ', Pros.ApellidoMaterno)
			ELSE
				CONCAT(Cli.PrimerNombre,
						(CASE WHEN IFNULL(Cli.SegundoNombre, '') != '' THEN CONCAT(' ', Cli.SegundoNombre)
							ELSE Cadena_Vacia	END),
						(CASE WHEN IFNULL(Cli.TercerNombre, '') != '' THEN  CONCAT(' ', Cli.TercerNombre)
							ELSE Cadena_Vacia	END), ' ',
				Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)
			END AS IntegrantesGrupo, 	Var_NombrePres,	Var_NombreSecre ,	Var_NombreTeso
		FROM INTEGRAGRUPOSCRE Inte
			LEFT JOIN CLIENTES Cli 		ON Inte.ClienteID = Cli.ClienteID
			LEFT JOIN PROSPECTOS Pros		ON Cli.ClienteID = Pros.ClienteID
		WHERE Inte.GrupoID = Par_GrupoID
			AND Inte.Estatus= Estatus_Activo;
	END  IF;

END TerminaStore$$