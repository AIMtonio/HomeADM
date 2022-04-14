-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CEDESPAGAREREP
DELIMITER ;
DROP PROCEDURE IF EXISTS `CEDESPAGAREREP`;DELIMITER $$

CREATE PROCEDURE `CEDESPAGAREREP`(
# ===================================================
# ---------- SP PARA GENERAR PAGARE DE CEDES---------
# ===================================================
	Par_CedeID			INT(11),		   -- ID de la CEDE

	Par_EmpresaID	    INT(11),		   -- Parametro de Auditoria
	Aud_Usuario		    INT(11),	       -- Parametro de Auditoria
	Aud_FechaActual	    DATETIME,	       -- Parametro de Auditoria
	Aud_DireccionIP	    VARCHAR(15),       -- Parametro de Auditoria
	Aud_ProgramaID		VARCHAR(50),	   -- Parametro de Auditoria
	Aud_Sucursal		INT(11),		   -- Parametro de Auditoria
	Aud_NumTransaccion	BIGINT(20)		   -- Parametro de Auditoria

)
TerminaStore: BEGIN

	-- Declaracion de constantes
	DECLARE	Fecha_Vacia		    DATE;
	DECLARE	Entero_Cero		    INT(3);
	DECLARE	Cadena_Vacia	    CHAR(1);
	DECLARE	Decimal_Cero	    DECIMAL(18,2);
	DECLARE Auto_Cede           INT(11);
	DECLARE SalidaNO            CHAR(1);
	DECLARE Var_Si				CHAR(1);
	DECLARE Cte_PF				CHAR(1);
	DECLARE Cte_PFActividadEmp	CHAR(1);
	DECLARE Cte_PM				CHAR(1);
	DECLARE	Par_NumErr			INT(11);
	DECLARE	Par_ErrMen			VARCHAR(400);

	-- Declaracion de variables
	DECLARE Depositante1		VARCHAR(200);
	DECLARE Depositante2		VARCHAR(200);
	DECLARE Depositante3		VARCHAR(200);
	DECLARE Depositante4		VARCHAR(200);
	DECLARE Depositante5		VARCHAR(200);
	DECLARE Var_DepositaPMRS	VARCHAR(250);
	DECLARE Var_TipoPersona		CHAR(1);
	DECLARE Var_CuentaAhoID		BIGINT(12);
	DECLARE Var_DomicilioCte	VARCHAR(500);
	DECLARE Var_LugarExp		VARCHAR(150);
	DECLARE Var_PlazoLetras		VARCHAR(400);
	DECLARE Var_TasaFija		DECIMAL(12,4);
	DECLARE Var_TasaFijaLetras	VARCHAR(400);
	DECLARE Var_Reinversion		CHAR(2);
	DECLARE Var_MontoCede		VARCHAR(100);
	DECLARE TipoCede_RECA		VARCHAR(100);
	DECLARE Var_Dias			INT(11);
	DECLARE Var_ClienteID       INT(11);
	DECLARE Var_NumContrato     INT(11);


	-- Asignacion de constantes
	SET	Fecha_Vacia			 	:= '1900-01-01';     -- Fecha Vacia
	SET	Entero_Cero			 	:= 0;                -- Entero en Cero
	SET	Cadena_Vacia		 	:= '';               -- Cadena o String Vacio
	SET	Decimal_Cero		 	:= 0.00;             -- DECIMAL en Cero
	SET Auto_Cede            	:=  4;               -- Para Autorizar el Pagare de la Cede
	SET SalidaNO             	:= 'N';              -- Salida NO
	SET Var_Si				 	:= 'S';              -- Valor SI
	SET Cte_PF 				 	:= 'F';              -- Persona Fisica
	SET Cte_PFActividadEmp	 	:= 'A';              -- Persona Fisica con Actividad Empresarial
	SET Cte_PM				 	:= 'M';              -- Persona Moral


	-- TABLA TEMPORAL PARA ALMACENAR LOS BENEFICIARIOS
	CREATE TEMPORARY TABLE IF NOT EXISTS TMPRPTCUEPER (
	   ID INT AUTO_INCREMENT PRIMARY KEY,
	   NombreCompleto VARCHAR(200) DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=latin1;

	TRUNCATE TMPRPTCUEPER;

	-- OBTENIENDO EL LUGAR DE EXPEDICION
	SELECT MUN.Nombre	INTO Var_LugarExp
		FROM 	SUCURSALES SUC, MUNICIPIOSREPUB MUN
		WHERE 	SUC.SucursalID  = Aud_Sucursal
		AND   	SUC.EstadoID    = MUN.EstadoID
		AND   	SUC.MunicipioID = MUN.MunicipioID;

	-- OBTENIENDO DATOS DE LA CEDE
	SELECT
		CLI.TipoPersona,      CD.CuentaAhoID,     DIR.DireccionCompleta,   CD.Plazo,
		CD.TasaFija,          CD.Reinvertir,      CLI.ClienteID,	       CD.Monto,
		TC.NumRegistroRECA,	  CONCAT(TRIM(CONCAT(CLI.PrimerNombre,' ', CLI.SegundoNombre,' ', CLI.TercerNombre)),' ', TRIM(CONCAT(CLI.ApellidoPaterno,' ', CLI.ApellidoMaterno)))
	INTO
		Var_TipoPersona,	  Var_CuentaAhoID,    Var_DomicilioCte,		   Var_Dias,
		Var_TasaFija,         Var_Reinversion,	  Var_ClienteID,	       Var_MontoCede,
		TipoCede_RECA,		  Var_DepositaPMRS
		FROM  CEDES       AS CD
		LEFT OUTER JOIN
			  TIPOSCEDES  AS TC  ON TC.TipoCedeID = CD.TipoCedeID,
			  CLIENTES    AS CLI
		LEFT OUTER JOIN
			 DIRECCLIENTE AS DIR ON DIR.ClienteID = CLI.ClienteID
			 AND DIR.Oficial = Var_Si
		WHERE
			 CD.ClienteID    = CLI.ClienteID
			 AND CD.CedeID   = Par_CedeID;

	-- CONVIERTIENDO EL PLAZO Y LA TASA A LETRAS
	SET Var_PlazoLetras 	:= IFNULL((CONVPORCANT(ROUND(Var_Dias,0), 'I','','')), Cadena_Vacia);
	SET Var_TasaFijaLetras	:= IFNULL((CONVPORCANT(ROUND(Var_TasaFija,4), '%','4','')), Cadena_Vacia);

	IF(Var_TipoPersona = Cadena_Vacia) THEN
		SET Depositante1	:=Cadena_Vacia;
		SET Depositante2	:=Cadena_Vacia;
		SET Depositante3	:=Cadena_Vacia;
		SET Depositante4	:=Cadena_Vacia;
		SET Depositante5	:=Cadena_Vacia;
	END IF;


	-- DETERMINANDO SI ES PERSONA FISICA O PERSONA MORAL
	IF(Var_TipoPersona = Cte_PF OR Var_TipoPersona = Cte_PFActividadEmp) THEN

		INSERT INTO TMPRPTCUEPER
					(NombreCompleto)
			SELECT   	NombreCompleto
				FROM  	CUENTASPERSONA
				WHERE	(EsCotitular = Var_Si OR EsTitular   = Var_Si)
				AND	 	CuentaAhoID = Var_CuentaAhoID
				LIMIT 	5;
	END IF;

	IF(Var_TipoPersona = Cte_PM) THEN
		INSERT INTO TMPRPTCUEPER
					(NombreCompleto)
			SELECT   	RazonSocial AS NombreCompleto
				FROM  	CLIENTES
				WHERE 	ClienteID = Var_ClienteID
				LIMIT 	1;
		INSERT INTO TMPRPTCUEPER
					(NombreCompleto)
			SELECT   	NombreCompleto
				FROM  	CUENTASPERSONA
				WHERE 	EsApoderado = Var_Si
				AND	 	CuentaAhoID = Var_CuentaAhoID
				LIMIT 	4;
	END IF;

	-- OBTENIENDO LOS DATOS DE LA TABLA TEMPORAL
	SELECT
		MAX(CASE ID WHEN 1 THEN NombreCompleto ELSE Cadena_Vacia END) AS Depositante1,
		MAX(CASE ID WHEN 2 THEN NombreCompleto ELSE Cadena_Vacia END) AS Depositante2,
		MAX(CASE ID WHEN 3 THEN NombreCompleto ELSE Cadena_Vacia END) AS Depositante3,
		MAX(CASE ID WHEN 4 THEN NombreCompleto ELSE Cadena_Vacia END) AS Depositante4,
		MAX(CASE ID WHEN 5 THEN NombreCompleto ELSE Cadena_Vacia END) AS Depositante5
		INTO Depositante1,    Depositante2,    Depositante3,    Depositante4,    Depositante5
	FROM TMPRPTCUEPER;

	SET Depositante1	:=IFNULL(Depositante1,Cadena_Vacia);
	SET Depositante2	:=IFNULL(Depositante2,Cadena_Vacia);
	SET Depositante3	:=IFNULL(Depositante3,Cadena_Vacia);
	SET Depositante4	:=IFNULL(Depositante4,Cadena_Vacia);
	SET Depositante5	:=IFNULL(Depositante5,Cadena_Vacia);
	SET Var_Reinversion	:=IFNULL(Var_Reinversion,Cadena_Vacia);

	-- AUTORIZANDO EL PAGARE DE LA CEDE

	CALL CEDESACT(
		Par_CedeID, 		Entero_Cero,		Entero_Cero,		Auto_Cede,			SalidaNO,
        Par_NumErr,			Par_ErrMen,			Par_EmpresaID,      Aud_Usuario,		Aud_FechaActual,
        Aud_DireccionIP,	Aud_ProgramaID,		Aud_Sucursal, 	    Aud_NumTransaccion);

	SELECT  Depositante1,    Depositante2,       Depositante3,    		  Depositante4,      Depositante5,
			Var_LugarExp,    Var_DomicilioCte,   FORMAT(Var_MontoCede,2) AS Var_MontoCede,   	 Var_PlazoLetras,   Var_TasaFijaLetras,
			Var_Reinversion, CONVPORCANT(ROUND(Var_MontoCede, 2), '$P', '2', '') AS CapitalLetra,
			Var_NumContrato,Var_TipoPersona AS TipoPersona;

	TRUNCATE TMPRPTCUEPER;


END TerminaStore$$