-- EDOCTAV2DATOSCTEPRO
DELIMITER ;
DROP PROCEDURE IF EXISTS `EDOCTAV2DATOSCTEPRO`;
DELIMITER $$

CREATE PROCEDURE `EDOCTAV2DATOSCTEPRO`(
	-- SP que genera informacion del Estado Cuenta
	Par_Salida			CHAR(1),			-- Parametro que indica si el procedimiento devuelve una salida
	INOUT Par_NumErr	INT(11),
	INOUT Par_ErrMen	VARCHAR(400),

    -- Parametros de Auditoria
	Par_EmpresaID		INT(11),
	Aud_Usuario			INT(11),
	Aud_FechaActual		DATETIME,
	Aud_DireccionIP		VARCHAR(15),
	Aud_ProgramaID		VARCHAR(50),
	Aud_Sucursal		INT(11),
	Aud_NumTransaccion	BIGINT(20)
	)
TerminaStore: BEGIN
	-- DECLARACION DE CONTANTES
	DECLARE Constante_Si		CHAR(1);
	DECLARE Constante_No		CHAR(1);
	DECLARE SinNum				CHAR(3);
	DECLARE PerFisica			CHAR(1);
	DECLARE PerFiscaAct			CHAR(1);
	DECLARE PerMoral			CHAR(1);
	DECLARE DescPerFisica		VARCHAR(50);
	DECLARE DescPerFiscaAct		VARCHAR(50);
	DECLARE DescPerMoral		VARCHAR(50);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Decimal_Cero		DECIMAL(12,2);
	DECLARE Entero_Cero			INT(11);
	DECLARE CliEstActivo		CHAR(1);
	DECLARE CliEstInactivo		CHAR(1);
	DECLARE NoEsMenorEdad		CHAR(1);
	DECLARE ClienteInstitu 		INT(11);
	DECLARE EsRegHacienda		CHAR(1);
	DECLARE EsFiscal			CHAR(1);
	DECLARE EsOficial	    	CHAR(1);

	-- DECLARACION DE VARIABLES
	DECLARE Var_FechaSis		DATE;
	DECLARE Var_FolioProceso	BIGINT(20);
	DECLARE Var_AnioMes			INT(11);
	DECLARE Var_Control			VARCHAR(50);
	DECLARE Var_FecIniMes		DATE;						-- Fecha inicial del Periodo a procesar
	DECLARE Var_FecFinMes		DATE;						-- Fecha final del Periodo a Procear

	-- SETEO DE CONSTANTES
	SET Constante_Si		:= 'S';
	SET Constante_No		:= 'N';
	SET SinNum				:= 'S/N';
	SET PerFisica			:= 'F';
	SET PerFiscaAct			:= 'A';
	SET PerMoral			:= 'M';
	SET DescPerFisica		:= 'Persona Fisica Sin Actividad Empresarial';
	SET DescPerFiscaAct		:= 'Persona Fisica Con Actividad Empresarial';
	SET DescPerMoral		:= 'Persona Moral';
	SET Cadena_Vacia		:= '';
	SET Decimal_Cero		:= 0.0;
	SET Entero_Cero			:= 0;
	SET CliEstActivo		:= 'A';
	SET CliEstInactivo		:= 'I';
	SET NoEsMenorEdad		:= 'N';
	SET ClienteInstitu 		:= 1;
	SET EsRegHacienda		:= 'S';
	SET EsFiscal		    := 'S';
	SET EsOficial	    	:= 'S';

	ManejoErrores: BEGIN
	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN
			SET Par_NumErr	= 999;
			SET Par_ErrMen	= CONCAT(	'El SAFI ha tenido un problema al concretar la operacion. ',
										'Disculpe las molestias que esto le ocasiona. Ref: SP-EDOCTAV2DATOSCTEPRO');
			SET Var_Control	= 'sqlException';
		END;

		SELECT	MesProceso,  FechaInicio, 	FechaFin,  		FolioProceso
		INTO	Var_AnioMes, Var_FecIniMes, Var_FecFinMes, 	Var_FolioProceso
		FROM	EDOCTAV2PARAMS
		LIMIT	1;

		SET Var_FolioProceso 	:= IFNULL(Var_FolioProceso, Entero_Cero);

		DROP TABLE IF EXISTS TMPDATOSCTE;
		CREATE TEMPORARY TABLE TMPDATOSCTE(
		`Tmp_Aniome` 		INT(11),
		`Tmp_SucursalID` 	INT(11),
		`Tmp_NombreSuc` 	VARCHAR(60),
		`Tmp_ClienteID` 	INT(11),
		`Tmp_NombreCli`	 	VARCHAR(170) ,
		`Tmp_TipPer`    	CHAR(1),
		`Tmp_TipoCli` 		VARCHAR(50) ,
		`Tmp_Calle`  		VARCHAR(50) ,
		`Tmp_NumeroInt` 	CHAR(10),
		`Tmp_NumeroExt` 	CHAR(10),
		`Tmp_Colonia` 		VARCHAR(200) ,
		`Tmp_MunicipioID`	INT(11),
		`Tmp_MunicipioDel` 	VARCHAR(50),
		`Tmp_Localidad` 	VARCHAR(50),
		`Tmp_EstadoID`	 	INT(11),
		`Tmp_Estado` 		VARCHAR(50),
		`Tmp_CodigoPostal` 	CHAR(5),
		`Tmp_RFC` 			VARCHAR(13),
		`Tmp_InstrucEnvio` 	CHAR(1),
		`Tmp_DireccionCompleta` VARCHAR(500),
		`Tmp_RegHacienda`  	CHAR(1),
		`Tmp_ParteSocial`  	DECIMAL(16,2)
		);
		CREATE INDEX IDX_TMPDATOSCTE_ANIOMES USING BTREE ON TMPDATOSCTE (Tmp_Aniome);
		CREATE INDEX IDX_TMPDATOSCTE_CLIENTE USING BTREE ON TMPDATOSCTE (Tmp_ClienteID);
		CREATE INDEX IDX_TMPDATOSCTE_SUCURSAL USING BTREE ON TMPDATOSCTE (Tmp_SucursalID);
		CREATE INDEX IDX_TMPDATOSCTE_REGHACIE USING BTREE ON TMPDATOSCTE (Tmp_RegHacienda);

		INSERT INTO TMPDATOSCTE
		SELECT Var_AnioMes,	  SucursalOrigen,	Cadena_Vacia,	ClienteID,	NombreCompleto,
			   TipoPersona,
			   CASE TipoPersona WHEN PerFisica THEN DescPerFisica
								WHEN PerMoral THEN DescPerMoral
								WHEN PerFiscaAct THEN DescPerFiscaAct
										 ELSE CONCAT("No Definido para: ", TipoPersona)
			   END,
			   Cadena_Vacia AS Calle,
			   Entero_Cero AS NumInt,
			   Entero_Cero AS NumExt,
			   Cadena_Vacia AS Colonia,
			   Entero_Cero AS MunicipioID,
			   Cadena_Vacia AS Municipio,
			   Cadena_Vacia AS Localidad,
			   Entero_Cero AS EstadoID,
			   Cadena_Vacia AS Estado,
			   Entero_Cero AS CodigoPostal,
			   RFCOficial AS RFC,
			   Cadena_Vacia AS InstrucEnvio,
			   Cadena_Vacia,
			   RegistroHacienda,
			   Entero_Cero AS ParteSocial
		FROM CLIENTES
		WHERE FechaAlta <= Var_FecFinMes
		AND	  ClienteID <> ClienteInstitu
		AND  IFNULL(EsMenorEdad, NoEsMenorEdad) = NoEsMenorEdad
		AND  (Estatus = CliEstActivo OR (Estatus = CliEstInactivo AND FechaBaja >= Var_FecIniMes))
		ORDER BY ClienteID;

		UPDATE TMPDATOSCTE
		INNER JOIN SUCURSALES Suc ON Suc.SucursalID = Tmp_SucursalID
		SET Tmp_NombreSuc = NombreSucurs ;

		UPDATE TMPDATOSCTE
			INNER JOIN DIRECCLIENTE Dir ON Tmp_ClienteID = Dir.ClienteID AND Dir.Fiscal = EsFiscal
			INNER JOIN COLONIASREPUB Col ON Col.ColoniaID = Dir.ColoniaID AND Col.EstadoID = Dir.EstadoID AND Col.MunicipioID = Dir.MunicipioID
		SET Tmp_Calle 		 = Dir.Calle,
			Tmp_NumeroInt 	 = Dir.NumeroCasa,
			Tmp_NumeroExt 	 = Dir.NumInterior,
			Tmp_Colonia 	 = Col.Asentamiento,
			Tmp_CodigoPostal = Dir.CP,
			Tmp_MunicipioID	 = Dir.MunicipioID,
			Tmp_EstadoID	 = Dir.EstadoID,
			Tmp_DireccionCompleta = Dir.DireccionCompleta
		WHERE	Tmp_RegHacienda = EsRegHacienda;

		-- Todos los clientes que no se actualizaron porque no tienen una direccion fiscal
		-- Mas todos los clientes que no estan marcados como registrados en hacienda se actualiza con la direccion Oficial
		UPDATE TMPDATOSCTE
			INNER JOIN DIRECCLIENTE Dir ON Tmp_ClienteID = Dir.ClienteID AND Dir.Oficial = EsOficial
			INNER JOIN COLONIASREPUB Col ON Col.ColoniaID = Dir.ColoniaID AND Col.EstadoID = Dir.EstadoID AND Col.MunicipioID = Dir.MunicipioID
		SET Tmp_Calle 		 = Dir.Calle,
			Tmp_NumeroInt 	 = Dir.NumeroCasa,
			Tmp_NumeroExt 	 = Dir.NumInterior,
			Tmp_Colonia 	 = Col.Asentamiento,
			Tmp_CodigoPostal = Dir.CP,
			Tmp_MunicipioID	 = Dir.MunicipioID,
			Tmp_EstadoID	 = Dir.EstadoID,
			Tmp_DireccionCompleta = Dir.DireccionCompleta
		WHERE	Tmp_DireccionCompleta = Cadena_Vacia
		   OR 	Tmp_Colonia = Cadena_Vacia ;

		UPDATE TMPDATOSCTE Cte
			INNER JOIN ESTADOSREPUB Est ON Cte.Tmp_EstadoID = Est.EstadoID
		SET Tmp_Estado = Est.Nombre ;

		UPDATE TMPDATOSCTE Cte
			INNER JOIN MUNICIPIOSREPUB Mun ON Cte.Tmp_EstadoID = Mun.EstadoID AND Cte.Tmp_MunicipioID = Mun.MunicipioID
		SET Tmp_MunicipioDel = Mun.Nombre;

		-- Este campo solo aplica para Cajas de Ahorro (SOCAPS)
		UPDATE  TMPDATOSCTE Cte
			INNER JOIN APORTACIONSOCIO Apo ON Apo.ClienteID = Cte.Tmp_ClienteID
		SET Cte.Tmp_ParteSocial = IFNULL(Apo.Saldo, Entero_Cero);

		INSERT INTO EDOCTAV2DATOSCTE
		SELECT 	IFNULL(Tmp_Aniome,Entero_Cero),
				IFNULL(Tmp_SucursalID,Entero_Cero),
				IFNULL(Tmp_ClienteID,Entero_Cero),
				Var_FolioProceso,
				IFNULL(Tmp_NombreCli,Cadena_Vacia),
				IFNULL(Tmp_NombreSuc,Cadena_Vacia),
				IFNULL(Tmp_TipPer,Cadena_Vacia),
				IFNULL(Tmp_TipoCli,Cadena_Vacia),
				IFNULL(Tmp_Calle,Cadena_Vacia),
				CASE WHEN IFNULL(Tmp_NumeroInt,Cadena_Vacia) = Cadena_Vacia OR Tmp_NumeroInt = 'SN'  THEN SinNum ELSE IFNULL(Tmp_NumeroInt,SinNum) END,
				CASE WHEN IFNULL(Tmp_NumeroExt,Cadena_Vacia) = Cadena_Vacia OR Tmp_NumeroExt = 'SN'  THEN SinNum ELSE IFNULL(Tmp_NumeroExt,SinNum) END ,
				IFNULL(Tmp_Colonia,Cadena_Vacia),
				IFNULL(Tmp_MunicipioDel,Cadena_Vacia),
				IFNULL(Tmp_Localidad,Cadena_Vacia),
				IFNULL(Tmp_Estado,Cadena_Vacia),
				IFNULL(Tmp_CodigoPostal,Cadena_Vacia),
				IFNULL(Tmp_RFC,Cadena_Vacia),
				IFNULL(Tmp_DireccionCompleta,Cadena_Vacia),
				Var_FecFinMes as FechaGeneracion,
				IFNULL(Tmp_RegHacienda,Cadena_Vacia),
				IFNULL(Tmp_ParteSocial, Entero_Cero),
				'N' AS PDFGenerado,
				Par_EmpresaID,
				Aud_Usuario,
				Aud_FechaActual,
				Aud_DireccionIP,
				Aud_ProgramaID,
				Aud_Sucursal,
				Aud_NumTransaccion
		FROM TMPDATOSCTE;

	    SET Par_NumErr	:= Entero_Cero;
		SET Par_ErrMen	:= CONCAT('Datos Generales del Cliente Terminado exitosamente con Folio: ', CAST(Var_FolioProceso AS CHAR));
		SET Var_Control	:= 'EDOCTAV2DATOSCTEPRO';
	END ManejoErrores;

	IF (Par_Salida = Constante_Si) THEN
		SELECT	Par_NumErr			AS NumErr,
				Par_ErrMen			AS ErrMen,
				Var_FolioProceso	AS control;
	END IF;

END TerminaStore$$
