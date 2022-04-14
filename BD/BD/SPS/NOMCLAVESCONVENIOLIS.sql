-- SP NOMCLAVESCONVENIOLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS NOMCLAVESCONVENIOLIS;

DELIMITER $$

CREATE  PROCEDURE NOMCLAVESCONVENIOLIS(
	-- SP para  listar los Claves Presupuestales Por institucion de nomina
	Par_NomClaveConvenioID		INT(11),			-- Id de la Tabla del Claves Presupuestales por Convenios de Nomina.
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
	DECLARE Cadena_Vacia				CHAR(1);		-- Cadena vacia
	DECLARE Entero_Cero					INT(11);		-- Entero vacio
	DECLARE Var_ContCadena				INT(11);		-- Variable del contador del cliclo while
	DECLARE Var_CantCadena				INT(11);		-- Variable que tiene la cantidad de caracteres en al cadena
	DECLARE Var_NomClavePresupID		VARCHAR(3000);	--  Variable para GUardar el id de la clave presupuestal
	DECLARE Var_Longitud				INT(11);		-- Variable para guardar la longitud de la cadena obtenida
	DECLARE Var_ClavesPresupuestales	VARCHAR(3000);	-- Cadema de los numero o ID de la Tabla del Claves Presupuestales
	DECLARE Var_ClavePresupID			INT(11);		--  Variable para GUardar el id de la clave presupuestal

	DECLARE Lis_ClavPresupConv			INT(11);		-- Variable para la lista de los claves presupuestales registrado por convenio de nomina
	DECLARE Lis_ClavPresup				INT(11);		-- Variable para la lista de los claves presupuestales registrado para el convenio
	DECLARE Lis_ClasiClavPresupConv		INT(11);		-- Lista de los Clasificion de claves presupuestales registrado para el convenio de nomina por sus claves
	DECLARE EstatusActivo				CHAR(1);		-- Indica el Estatus de la Clasificacion de clave presupuestal  Nace A=Activo

	DECLARE Var_Sentencia       		VARCHAR(3100);

	-- Asignacion de constantes
	SET	Cadena_Vacia					:= '';			-- Asignacion de Cadena Vacia
	SET Entero_Cero						:= 0;			-- Asignacion de Entero Vacio
	SET	Lis_ClavPresupConv				:= 1;			-- Variable para la lista de los claves presupuestales registrado por convenio de nomina
	SET	Lis_ClavPresup					:= 2;			-- Variable para la lista de los claves presupuestales registrado para el convenio
	SET Lis_ClasiClavPresupConv			:= 3;			-- Lista de los Clasificion de claves presupuestales registrado para el convenio de nomina por sus claves
	SET EstatusActivo					:= 'A';			-- Indica el Estatus de la Clasificacion de clave presupuestal  Nace A=Activo

	-- 1.-Variable para la lista de los claves presupuestales registrado por convenio de nomina
	IF(Par_NumLis = Lis_ClavPresupConv) THEN
		SELECT CLAV.NomClaveConvenioID,		IF(CONV.ConvenioNominaID > 0, CONV.Descripcion, 'TODOS LOS CONVENIOS') AS Descripcion,		CLAV.NomClavePresupID
			FROM NOMCLAVESCONVENIO CLAV
			LEFT JOIN CONVENIOSNOMINA CONV ON CLAV.ConvenioNominaID = CONV.ConvenioNominaID
			WHERE CLAV.InstitNominaID = IF(Par_InstitNominaID > 0,Par_InstitNominaID, CLAV.InstitNominaID);
	END IF;

	--  2.- -- Variable para la lista de los claves presupuestales registrado para el convenio
	IF(Par_NumLis = Lis_ClavPresup) THEN
		SELECT NomClavePresupID
			INTO Var_NomClavePresupID
			FROM NOMCLAVESCONVENIO
			WHERE NomClaveConvenioID = Par_NomClaveConvenioID;

		SET Var_Sentencia := CONCAT("SELECT NomClavePresupID, Descripcion 
									FROM NOMCLAVEPRESUP WHERE NomClavePresupID in (",Var_NomClavePresupID,");");


		SET @Sentencia  = (Var_Sentencia);

    	PREPARE CLAVEPRESUP FROM @Sentencia;
	    EXECUTE CLAVEPRESUP ;
	    DEALLOCATE PREPARE CLAVEPRESUP;
	END IF;

	--  3.Lista de los Clasificion de claves presupuestales registrado para el convenio de nomina por sus claves
	IF(Par_NumLis = Lis_ClasiClavPresupConv) THEN

		SELECT NomClavePresupID
		INTO Var_NomClavePresupID
			FROM NOMCLAVESCONVENIO
			WHERE InstitNominaID = Par_InstitNominaID
			AND ConvenioNominaID = IF(ConvenioNominaID <> 0, Par_ConvenioNominaID, ConvenioNominaID);

		DROP TABLE IF EXISTS TMPNOMCLAVESPRESUP;
		CREATE TEMPORARY TABLE TMPNOMCLAVESPRESUP (
			NomClavePresupID		BIGINT(12),
			Clave					CHAR(8),
			Descripcion				VARCHAR(80),
			PRIMARY KEY(NomClavePresupID)
		);

		SET Var_ClavesPresupuestales	:= CONCAT(Var_NomClavePresupID,",");

		-- Descomponemos la cadenas de claves presupuestales
		SET Var_ContCadena = 1;
		SELECT POSITION(','IN Var_ClavesPresupuestales) INTO Var_CantCadena;

		WHILE Var_CantCadena > Var_ContCadena DO
			-- Obtenemos el Primer valor de la cadena ante del delimitador coma
			SELECT LEFT(Var_ClavesPresupuestales,Var_CantCadena - 1) INTO Var_ClavePresupID;

			INSERT INTO TMPNOMCLAVESPRESUP(NomClavePresupID)
				VALUE(Var_ClavePresupID);

			SELECT SUBSTRING(Var_ClavesPresupuestales, Var_CantCadena + 1, LENGTH(Var_ClavesPresupuestales)) INTO Var_ClavesPresupuestales ;
			SELECT POSITION(',' IN Var_ClavesPresupuestales) INTO Var_CantCadena;
		END WHILE;

		UPDATE TMPNOMCLAVESPRESUP TMP
			INNER JOIN NOMCLAVEPRESUP NOM ON NOM.NomClavePresupID = TMP.NomClavePresupID
				SET TMP.Clave		= NOM.Clave,
					TMP.Descripcion	= NOM.Descripcion;

		DELETE TMP 
			FROM TMPNOMCLAVESPRESUP TMP
			LEFT JOIN NOMCLAVEPRESUP NOM ON NOM.NomClavePresupID = TMP.NomClavePresupID
			WHERE NOM.NomClavePresupID IS NULL;

		SELECT DISTINCT(CLASIF.NomClasifClavPresupID),		CLASIF.Descripcion,		CLASIF.Prioridad
			FROM NOMCLASIFCLAVEPRESUP CLASIF
			INNER JOIN TMPNOMCLAVESPRESUP  TMP
			WHERE FIND_IN_SET(TMP.NomClavePresupID, CLASIF.NomClavePresupID) > Entero_Cero
			AND CLASIF.Estatus = EstatusActivo
			ORDER BY CLASIF.Prioridad;

		DROP TABLE IF EXISTS TMPNOMCLAVESPRESUP;
	END IF;

END TerminaStore$$

