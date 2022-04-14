-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- CUENTASFIRMALIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `CUENTASFIRMALIS`;
DELIMITER $$

CREATE PROCEDURE `CUENTASFIRMALIS`(

	Par_CuentaAhoID			BIGINT(12),				-- Parámetro Cuenta de ahorro.
	Par_NombreCompleto		VARCHAR(20),			-- Parámetro nombre completo.
	Par_NumLis				TINYINT UNSIGNED,		-- Parámetro número de lista.

	Aud_EmpresaID         	INT(11),				-- Parámetro de auditoría ID de la empresa.
	Aud_Usuario         	INT(11),				-- Parámetro de auditoría ID del usuario.
	Aud_FechaActual     	DATETIME,				-- Parámetro de auditoría fecha actual.
	Aud_DireccionIP     	VARCHAR(15),			-- Parámetro de auditoría direccion IP.
	Aud_ProgramaID      	VARCHAR(50),			-- Parámetro de auditoría programa.
	Aud_Sucursal        	INT(11),				-- Parámetro de auditoría ID de la sucursal.
	Aud_NumTransaccion  	BIGINT(20)				-- Parámetro de auditoría numero de transaccion.
)
TerminaStore: BEGIN

	-- Declaración de variables.
	DECLARE Var_NombreCliente 	VARCHAR(100);		-- Variable para almacenar el nombre del cliente.
	DECLARE Var_PersonaID		INT(12);			-- Variable para almacenar el ID de la persona.
	DECLARE Var_RolID			INT(11);			-- Variable para almacenar el número de rol.
	DECLARE Var_SocioID   		INT(11);			-- Variable para almacenar el ID del socio de la tabla CUENTASAHO.

	-- Declaración de constantes
	DECLARE Entero_Cero	  		INT(11);			-- Constante número cero (0).
	DECLARE Cadena_Vacia  		CHAR(1);			-- Constante cadena vacía ''.
	DECLARE	Lis_Principal		INT(11);			-- Constante lista principal.
	DECLARE Lis_Firmantes		INT(11);			-- Constante lista para el grid de la pantalla de Registro Huellas Firmantes.
	DECLARE Lis_FirmaHuella		INT(11);			-- Constante lista de las Huellas de los Firmantes de una Cuenta de Ahorro.

	DECLARE Tipo_Firmante      	CHAR(1);			-- Constante persona tipo firmante 'F'.
	DECLARE Tipo_Cliente		CHAR(1);			-- Constante persona tipo cliente 'C'.
	DECLARE Tipo_Usuario  		CHAR(1);			-- Constante persona tipo usuario 'U'.
	DECLARE Cons_Si				CHAR(1);			-- Constante SI 'S'.
	DECLARE Cons_No				CHAR(1);			-- Constante NO 'N'.

	DECLARE Est_Autorizada		CHAR(1);			-- Constante estatus autorizada 'A'.
	DECLARE Est_Vigente			CHAR(1);			-- Constante estatus vigente 'V'.

	-- Asignación de constantes.
	SET Entero_Cero		:= 0;
	SET Cadena_Vacia	:= '';
	SET	Lis_Principal	:= 1;
	SET Lis_Firmantes	:= 2;
	SET Lis_FirmaHuella	:= 3;

	SET Tipo_Firmante	:= 'F';
	SET Tipo_Cliente	:= 'C';
	SET Tipo_Usuario	:= 'U';
	SET Cons_Si			:= 'S';
	SET Cons_No			:= 'N';

	SET Est_Vigente		:= 'V';
	SET Est_Autorizada 	:= 'A';

	IF (Par_NumLis = Lis_Principal) THEN
		SELECT	CF.CuentaFirmaID, 	CF.CuentaAhoID,	CF.PersonaID,	CF.NombreCompleto,	CF.Tipo,
				CF.InstrucEspecial,	CP.RFC
		FROM CUENTASFIRMA CF
		INNER JOIN CUENTASPERSONA CP ON CP.CuentaAhoID = CF.CuentaAhoID
			AND CP.PersonaID = CF.PersonaID
		WHERE CF.CuentaAhoID = Par_CuentaAhoID
		AND CP.EstatusRelacion = Est_Vigente;
	END IF;

	IF(Par_NumLis = Lis_Firmantes) THEN
		SELECT	CF.CuentaFirmaID, CF.NombreCompleto,
				CASE IFNULL(CP.ClienteID, Entero_Cero) WHEN Entero_Cero THEN Tipo_Firmante ELSE
					Tipo_Cliente END AS TipoFirmante,
				IFNULL(Hue.DedoHuellaUno,Cadena_Vacia) AS DedoHuellaUno,
				IFNULL(Hue.DedoHuellaDos,Cadena_Vacia) AS DedoHuellaDos,
				Hue.HuellaUno, Hue.HuellaDos,
				CASE WHEN IFNULL(CP.ClienteID, Entero_Cero) = Entero_Cero THEN CF.CuentaFirmaID ELSE
					CP.ClienteID END AS PersonaID,
				CA.CuentaAhoID, IFNULL(Hue.Estatus,Cadena_Vacia) AS Estatus
		FROM  CUENTASAHO CA
		INNER JOIN	CUENTASFIRMA CF ON CF.CuentaAhoID = CA.CuentaAhoID
		INNER JOIN  CUENTASPERSONA CP ON CP.CuentaAhoID = CF.CuentaAhoID AND CP.PersonaID = CF.PersonaID
			AND  CP.EstatusRelacion = Est_Vigente
		LEFT OUTER JOIN HUELLADIGITAL Hue
			ON (CASE WHEN IFNULL(CP.ClienteID, Entero_Cero) = Entero_Cero THEN CF.CuentaFirmaID ELSE
				CP.ClienteID END = Hue.PersonaID)
			AND (CASE WHEN IFNULL(CP.ClienteID, Entero_Cero) = Entero_Cero THEN Tipo_Firmante ELSE
				Tipo_Cliente END = Hue.TipoPersona)
		WHERE CA.CuentaAhoID = Par_CuentaAhoID
		AND CP.EsFirmante = Cons_Si;
	END IF;

	IF (Par_NumLis = Lis_FirmaHuella) THEN

		SET Var_RolID := (SELECT HuellaMaestra FROM HUELLADIGITALPARAM WHERE ParametroID = 1);

		SELECT 	Aho.ClienteID,	Cli.NombreCompleto
		INTO 	Var_SocioID, 	Var_NombreCliente
		FROM CUENTASAHO Aho
		INNER JOIN CLIENTES Cli ON Cli.ClienteID = Aho.ClienteID
		WHERE Aho.CuentaAhoID = Par_CuentaAhoID;

		SET Var_SocioID := IFNULL(Var_SocioID,Entero_Cero);

		DROP TABLE IF EXISTS HUELLAMAESTRA;

		CREATE TEMPORARY TABLE HUELLAMAESTRA (
			CuentaAhoID		        BIGINT(12),
			NombreFirmante	        VARCHAR(200),
			TipoFirmante	        CHAR(1),
			PersonaID	            BIGINT(11),
			HuellaUno	            VARBINARY(4000),
			DedoHuellaUno	        CHAR(1),
			HuellaDos	            VARBINARY(4000),
			DedoHuellaDos	        CHAR(1),
			Estitular				CHAR(1)
		);

		INSERT INTO HUELLAMAESTRA
		SELECT	Per.CuentaAhoID,  Fir.NombreCompleto AS NombreFirmante,
				CASE WHEN IFNULL(Per.ClienteID, Entero_Cero) = Entero_Cero THEN Tipo_Firmante ELSE
					Tipo_Cliente END AS TipoFirmante,
				CASE WHEN IFNULL(Per.ClienteID, Entero_Cero) = Entero_Cero THEN Fir.CuentaFirmaID ELSE
					Per.ClienteID END AS PersonaID,
				Hue.HuellaUno, Hue.DedoHuellaUno, Hue.HuellaDos, Hue.DedoHuellaDos, IFNULL(Per.EsTitular, Cons_No)
		FROM CUENTASAHO CA,
			 CUENTASFIRMA Fir
		INNER JOIN CUENTASPERSONA Per ON Per.CuentaAhoID = Fir.CuentaAhoID AND Per.PersonaID = Fir.PersonaID
			AND Per.EstatusRelacion = Est_Vigente
		INNER JOIN HUELLADIGITAL Hue ON Hue.PersonaID = Fir.CuentaFirmaID AND Hue.TipoPersona = Tipo_Firmante
			AND Hue.Estatus = Est_Autorizada
		WHERE CA.CuentaAhoID = Par_CuentaAhoID
		AND CA.CuentaAhoID = Fir.CuentaAhoID AND Per.EsFirmante = Cons_Si;

		INSERT INTO HUELLAMAESTRA
		SELECT	Per.CuentaAhoID,  Fir.NombreCompleto AS NombreFirmante,
				CASE WHEN IFNULL(Per.ClienteID, Entero_Cero) = Entero_Cero THEN Tipo_Firmante ELSE
					Tipo_Cliente END AS TipoFirmante,
				CASE WHEN IFNULL(Per.ClienteID, Entero_Cero) = Entero_Cero THEN Fir.CuentaFirmaID ELSE
					Per.ClienteID END AS PersonaID,
				Hue.HuellaUno, Hue.DedoHuellaUno, Hue.HuellaDos, Hue.DedoHuellaDos,
				IFNULL(Per.EsTitular, 'N')
		FROM CUENTASAHO CA
		INNER JOIN CUENTASFIRMA Fir ON Fir.CuentaAhoID = CA.CuentaAhoID
		INNER JOIN CUENTASPERSONA Per ON Per.CuentaAhoID = Fir.CuentaAhoID AND Per.PersonaID = Fir.PersonaID
			AND Per.EstatusRelacion = Est_Vigente
		INNER JOIN HUELLADIGITAL Hue ON Hue.PersonaID = Per.ClienteID AND Hue.TipoPersona = Tipo_Cliente
			AND Hue.Estatus = Est_Autorizada
		WHERE CA.CuentaAhoID = Par_CuentaAhoID AND Per.EsFirmante = Cons_Si;

		INSERT INTO HUELLAMAESTRA
		SELECT 	Entero_Cero,		Usu.NombreCompleto, Hue.TipoPersona, 	Hue.PersonaID, Hue.HuellaUno,
				Hue.DedoHuellaUno, 	Hue.HuellaDos, 		Hue.DedoHuellaDos,	Cadena_Vacia
		FROM USUARIOS Usu
		INNER JOIN HUELLADIGITAL Hue ON Usu.UsuarioID = Hue.PersonaID
		WHERE Usu.RolID = Var_RolID
		AND Usu.AccedeHuella = Cons_Si
		AND Usu.SucursalUsuario = Aud_Sucursal
		AND Hue.TipoPersona = Tipo_Usuario
		AND Hue.Estatus = Est_Autorizada;

		SELECT IFNULL(PersonaID, Entero_Cero) INTO Var_PersonaID
		FROM HUELLAMAESTRA
		WHERE PersonaID = Var_SocioID;

		SET Var_PersonaID :=IFNULL(Var_PersonaID, Entero_Cero);

		IF (Var_PersonaID = Entero_Cero) THEN
			INSERT INTO HUELLAMAESTRA
			SELECT  Par_CuentaAhoID,	Var_NombreCliente,	Tipo_Cliente,		Var_SocioID,	Hue.HuellaUno,
					Hue.DedoHuellaUno,	Hue.HuellaDos, 		Hue.DedoHuellaDos,	Cons_Si
			FROM HUELLADIGITAL Hue
			WHERE Hue.PersonaID = Var_SocioID
			AND Hue.TipoPersona = Tipo_Cliente
			AND Hue.Estatus = Est_Autorizada;
		END IF;

		SELECT  CuentaAhoID,	NombreFirmante,	TipoFirmante,	PersonaID,	HuellaUno,
				DedoHuellaUno, 	HuellaDos, 		DedoHuellaDos,	Estitular
		FROM HUELLAMAESTRA ORDER BY Estitular DESC;

	END IF;

END TerminaStore$$
