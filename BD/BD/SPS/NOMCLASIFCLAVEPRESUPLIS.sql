-- SP NOMCLASIFCLAVEPRESUPLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLASIFCLAVEPRESUPLIS;

DELIMITER $$

CREATE  PROCEDURE NOMCLASIFCLAVEPRESUPLIS(
	-- SP para  listar las Clasificacion de Claves Presupuestales
	Par_NomClasifClavPresupID	INT(11),			-- Numero o Id de la Tabla del Clasificacion de Claves Presupuestales
	Par_Descripcion				VARCHAR(100),		-- Indica el tipo de clasificacion de clave presupuestal
	Par_InstitNominaID			INT(11),			-- ID o Numero de Institucion de Nomina
	Par_ConvenioNominaID		BIGINT(20),			-- ID o Numero de COnvenio de Nomina
	Par_NumLis					TINYINT UNSIGNED,	-- Numero de consulta de la lista

	-- Parametros de Auditoria
	Aud_EmpresaID				INT(11),			-- ID de la Empresa
	Aud_Usuario					INT(11),			-- ID del Usuario que creo el Registro
	Aud_FechaActual				DATETIME,			-- Fecha Actual de la creacion del Registro
	Aud_DireccionIP				VARCHAR(15),		-- Direccion IP de la computadora
	Aud_ProgramaID				VARCHAR(50),		-- Identificador del Programa
	Aud_Sucursal				INT(11),			-- Identificador de la Sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Numero de Transaccion
)TerminaStore: BEGIN
	-- Declaracion de constantes
	DECLARE Entero_Cero				INT(11);		-- Entero vacio
	DECLARE Lis_Principal			INT(11);		-- Variable para la lista de ayuda de las clasificaicion de claves presupuestales registrado
	DECLARE Lis_ClasiClavPresup		INT(11);		-- Variable para la lista de ayuda de las clasificaicion de claves presupuestales registrado
	DECLARE Lis_ClavPresup			INT(11);		-- Variable para la lista de los claves presupuestales registrado por su clasificacion
	DECLARE Lis_ClavPresupConv		INT(11);		-- Variable para la lista de los claves presupuestales registrado por su clasificacion y por convenio de nomina

	-- Declaracion de Variable
	DECLARE Var_NomClavePresupID		VARCHAR(3001);	--  Variable para GUardar el id de la clave presupuestal
	DECLARE Var_ContCadena				INT(11);		-- Variable del contador del cliclo while
	DECLARE Var_CantCadena				INT(11);		-- Variable que tiene la cantidad de caracteres en al cadena
	DECLARE Var_ClavesPresupuestales	VARCHAR(3001);	-- Cadema de los numero o ID de la Tabla del Claves Presupuestales
	DECLARE Var_ClavePresupID			INT(11);		--  Variable para GUardar el id de la clave presupuestal
	DECLARE Var_Descripcion				VARCHAR(80);	-- Descripcion de la clasif clave Presupuestal

	-- Asignacion de constantes
	SET Entero_Cero					:= 0;			-- Asignacion de Entero Vacio
	SET	Lis_Principal				:= 1;			-- Variable para la lista de ayuda de las clasificaicion de claves presupuestales registrado
	SET	Lis_ClasiClavPresup			:= 2;			-- Variable para la lista  de las clasificaicion de claves presupuestales registrado
	SET	Lis_ClavPresup				:= 3;			-- Variable para la lista de los claves presupuestales registrado por su clasificacion
	SET Lis_ClavPresupConv			:= 4;			-- Variable para la lista de los claves presupuestales registrado por su clasificacion y por convenio de nomina

	-- 1.-Variable para la lista de ayuda de las clasificaicion de claves presupuestales registrado
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT NomClasifClavPresupID,		Descripcion
			FROM NOMCLASIFCLAVEPRESUP
			WHERE Descripcion LIKE CONCAT("%", Par_Descripcion, "%")
			LIMIT 0,15;
	END IF;

	-- 2.-Variable para la lista  de las clasificaicion de claves presupuestales registrado
	IF(Par_NumLis = Lis_ClasiClavPresup) THEN
		SELECT NomClasifClavPresupID,		Descripcion,	Estatus,			Prioridad,		NomClavePresupID
			FROM NOMCLASIFCLAVEPRESUP;
	END IF;

	--  3.- Variable para la lista de los claves presupuestales registrado por su clasificacion
	IF(Par_NumLis = Lis_ClavPresup) THEN

		DROP TABLE IF EXISTS TMPNOMCLAVES;
		CREATE TEMPORARY TABLE TMPNOMCLAVES (
			NomClavePresupID		BIGINT(12),
			Clave					CHAR(8),
			Descripcion				VARCHAR(80),
			PRIMARY KEY(NomClavePresupID)
		);

		SELECT NomClavePresupID
			INTO Var_NomClavePresupID
			FROM NOMCLASIFCLAVEPRESUP
			WHERE NomClasifClavPresupID = Par_NomClasifClavPresupID;

		SET Var_ClavesPresupuestales	:= CONCAT(Var_NomClavePresupID,",");

		-- si por alguna razón se intenta asignar a otra clasificación el sistema deberá de mostrar una alerta indicando que ya la clase ya se tienen asignado a otra clasificación. 
		SET Var_ContCadena = 1;
		SELECT POSITION(','IN Var_ClavesPresupuestales) INTO Var_CantCadena;

		WHILE Var_CantCadena > Var_ContCadena DO
			-- Obtenemos el Primer valor de la cadena ante del delimitador coma
			SELECT LEFT(Var_ClavesPresupuestales,Var_CantCadena - 1) INTO Var_ClavePresupID;

			INSERT INTO TMPNOMCLAVES(NomClavePresupID)
				VALUE(Var_ClavePresupID);

			SELECT SUBSTRING(Var_ClavesPresupuestales, Var_CantCadena + 1, LENGTH(Var_ClavesPresupuestales)) INTO Var_ClavesPresupuestales ;
			SELECT POSITION(',' IN Var_ClavesPresupuestales) INTO Var_CantCadena;
		END WHILE;

		UPDATE TMPNOMCLAVES TMP
		INNER JOIN NOMCLAVEPRESUP NOM ON NOM.NomClavePresupID = TMP.NomClavePresupID
			SET TMP.Clave		= NOM.Clave,
				TMP.Descripcion	= NOM.Descripcion;

		SELECT NomClavePresupID,	CONCAT(IFNULL(Clave, ""), "-",Descripcion) AS Descripcion
			FROM TMPNOMCLAVES;

		DROP TABLE IF EXISTS TMPNOMCLAVES;
	END IF;

	--  4.- Variable para la lista de los claves presupuestales registrado por su clasificacion y por convenio de nomina
	IF(Par_NumLis = Lis_ClavPresupConv) THEN

		DROP TABLE IF EXISTS TMPNOMCLAVESCONV;
		CREATE TEMPORARY TABLE TMPNOMCLAVESCONV (
			NomClavePresupID		BIGINT(12),
			Clave					CHAR(8),
			Descripcion				VARCHAR(80),
			PRIMARY KEY(NomClavePresupID)
		);

		SELECT NomClavePresupID
			INTO Var_NomClavePresupID
			FROM NOMCLASIFCLAVEPRESUP
			WHERE NomClasifClavPresupID = Par_NomClasifClavPresupID;

		SET Var_ClavesPresupuestales	:= CONCAT(Var_NomClavePresupID,",");

		-- Se descompone la cadena de Clasificacion de claves presupuestales 
		SET Var_ContCadena = 1;
		SELECT POSITION(','IN Var_ClavesPresupuestales) INTO Var_CantCadena;

		WHILE Var_CantCadena > Var_ContCadena DO
			-- Obtenemos el Primer valor de la cadena ante del delimitador coma
			SELECT LEFT(Var_ClavesPresupuestales,Var_CantCadena - 1) INTO Var_ClavePresupID;

			INSERT INTO TMPNOMCLAVESCONV(NomClavePresupID)
				VALUE(Var_ClavePresupID);

			SELECT SUBSTRING(Var_ClavesPresupuestales, Var_CantCadena + 1, LENGTH(Var_ClavesPresupuestales)) INTO Var_ClavesPresupuestales ;
			SELECT POSITION(',' IN Var_ClavesPresupuestales) INTO Var_CantCadena;
		END WHILE;

		UPDATE TMPNOMCLAVESCONV TMP
		INNER JOIN NOMCLAVEPRESUP NOM ON NOM.NomClavePresupID = TMP.NomClavePresupID
			SET TMP.Clave		= NOM.Clave,
				TMP.Descripcion	= NOM.Descripcion;

		SELECT Descripcion
			INTO Var_Descripcion
			FROM NOMCLASIFCLAVEPRESUP
			WHERE NomClasifClavPresupID = Par_NomClasifClavPresupID;

		SELECT TMP.NomClavePresupID,		TMP.Clave,			TMP.Descripcion,		Par_NomClasifClavPresupID AS NomClasifClavPresupID,		Var_Descripcion AS DescClasifClavPresup
			FROM TMPNOMCLAVESCONV TMP
			INNER JOIN NOMCLAVESCONVENIO CLA
			WHERE FIND_IN_SET(TMP.NomClavePresupID, CLA.NomClavePresupID) > Entero_Cero
				AND CLA.InstitNominaID = Par_InstitNominaID
				AND CLA.ConvenioNominaID = IF(CLA.ConvenioNominaID <> 0, Par_ConvenioNominaID, CLA.ConvenioNominaID)
			ORDER BY TMP.NomClavePresupID;

		DROP TABLE IF EXISTS TMPNOMCLAVESCONV;
	END IF;

END TerminaStore$$
