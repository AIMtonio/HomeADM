-- APPWCUENTASDESTINOLIS

DELIMITER ;

DROP PROCEDURE IF EXISTS APPWCUENTASDESTINOLIS;

DELIMITER $$

CREATE PROCEDURE `APPWCUENTASDESTINOLIS`(
	-- Store para actualizar un dato de un cliente usuario de la app wallet

	Par_ClienteID 				INT(11),				-- ID del Usuario de Banca Movil
	Par_NumLis 					TINYINT UNSIGNED,		-- Indica Tipo de Lista

	Aud_EmpresaID 				INT(11), 				-- Parametro de Auditoria
	Aud_UsuarioID 				INT(11),				-- Parametro de Auditoria
	Aud_Fecha 					DATE, 					-- Parametro de Auditoria
	Aud_DireccionIP 			VARCHAR(15), 			-- Parametro de Auditoria
	Aud_ProgramaID 				VARCHAR(50), 			-- Parametro de Auditoria
	Aud_Sucursal 				INT(11), 				-- Parametro de Auditoria
	Aud_NumeroTransaccion 		BIGINT(20) 				-- Parametro de Auditoria
)
TerminaStore: BEGIN

	-- DECLARACION DE CONSTANTES
	DECLARE Cadena_Vacia 		CHAR(1);				-- Cadena vacia
	DECLARE Entero_Cero 		INT; 					-- Entero 0
	DECLARE Lis_Principal 		INT(11); 				-- Lista Principal
	DECLARE Lis_Web				INT(11);
	DECLARE Est_Activo 			CHAR(1); 				-- Estado Activo
	DECLARE TipoInterna 		CHAR(1); 				-- Tipo Interna
	DECLARE TipoExterna 		CHAR(1); 				-- Tipo Externa

	-- DECLARACION DE VARIABLES
	DECLARE Var_Nombres 		VARCHAR(100); 			-- Nombres del cliente
	DECLARE Var_Apellidos 		VARCHAR(100); 			-- Apellidos del cliente
	DECLARE Var_Institucion		INT(11);				-- Numero de la institucion

	-- ASIGNACION DE CONSTANTES
	SET Cadena_Vacia 	:= '' ; 		-- Cadena o string vacio
	SET Entero_Cero 	:= 0;			-- Entero Cero
	SET Lis_Principal 	:= 1;			-- Lista Principal
	SET Lis_Web			:= 2;
	SET Est_Activo 		:= 'A'; 		-- Estatus Activa.
	SET TipoInterna 	:= 'I'; 		-- Tipo de cuentas internas.
	SET TipoExterna 	:= 'E'; 		-- Tipo de cuentas externas.


	SET Par_ClienteID		:= IFNULL(Par_ClienteID, Entero_Cero);

	SET Var_Institucion		:= (SELECT IFNULL(InstitucionID,Entero_Cero)
									FROM PARAMETROSSIS LIMIT 1);


	IF (Par_NumLis = Lis_Principal) THEN


		SELECT 	IF(Cue.Alias = Cadena_Vacia, Cli.PrimerNombre, Cue.Alias) AS Alias,	Cue.TipoCuenta,
				Cue.MontoLimite,
				Cue.CuentaTranID,
				IF(Cue.Beneficiario = Cadena_Vacia, Cli.PrimerNombre, Cue.Beneficiario) AS Beneficiario,
				IFNULL(Cue.CuentaDestino,Cadena_Vacia) AS CuentaInterna,
				IFNULL(Cue.Clabe,Cadena_Vacia) AS CuentaCLABE
				FROM CUENTASTRANSFER Cue
				INNER JOIN INSTITUCIONES Ins ON IF(Cue.InstitucionID = Entero_Cero, Var_Institucion, Cue.InstitucionID) = Ins.InstitucionID
				INNER JOIN CLIENTES Cli ON Cli.ClienteID = Cue.ClienteDestino
				WHERE Cue.ClienteID = IF (Par_ClienteID > Entero_Cero, Par_ClienteID,Cue.ClienteID)
				AND Cue.Estatus = Est_Activo
				ORDER BY Cue.CuentaTranID;

	END IF;


	IF (Par_NumLis = Lis_Web) THEN

		SELECT TRIM(CONCAT(Cli.PrimerNombre, ' ', Cli.SegundoNombre, ' ', Cli.TercerNombre))
		INTO Var_Nombres
		FROM CLIENTES Cli
		WHERE Cli.ClienteID = Par_ClienteID;

		SELECT TRIM(CONCAT(Cli.ApellidoPaterno, ' ', Cli.ApellidoMaterno)) INTO Var_Apellidos
		FROM CLIENTES Cli
		WHERE Cli.ClienteID = Par_ClienteID;

		SET Var_Nombres := IFNULL(Var_Nombres, Cadena_Vacia);
		SET Var_Apellidos := IFNULL(Var_Apellidos, Cadena_Vacia);


		SELECT 	IF(Cue.Alias = Cadena_Vacia, Cli.PrimerNombre, Cue.Alias) AS Alias,               Cue.TipoCuenta,        Cue.MontoLimite,        Cue.CuentaTranID,        Ins.ClaveParticipaSpei,
				IF(Cue.Beneficiario = Cadena_Vacia, Cli.PrimerNombre, Cue.Beneficiario) AS Beneficiario,        Ins.InstitucionID,	                             Cue.Estatus AS Estatus, UPPER(Ins.NombreCorto) AS NombreBanco,	IFNULL(Cue.CuentaDestino,Cadena_Vacia) AS CuentaInterna, IFNULL(Cue.TipoCuentaSpei,Cadena_Vacia) AS TipoSPEI,	IFNULL(Cue.Clabe,Cadena_Vacia) AS CuentaCLABE,		IFNULL(Cue.Clabe,Cadena_Vacia) AS TarjetaDebID,   IFNULL(Cue.Clabe,Cadena_Vacia) AS EmailBenefi,		IFNULL(Cue.Clabe,Cadena_Vacia) AS TelefonoBenefi,   IFNULL(Var_Nombres,Cadena_Vacia) AS Nombres,    IFNULL(Var_Apellidos,Cadena_Vacia) AS Apellidos
				FROM CUENTASTRANSFER Cue
				INNER JOIN INSTITUCIONES Ins ON IF(Cue.InstitucionID = Entero_Cero, Var_Institucion, Cue.InstitucionID) = Ins.InstitucionID
				INNER JOIN CLIENTES Cli ON Cli.ClienteID = Cue.ClienteDestino
				WHERE Cue.ClienteID = IF (Par_ClienteID > Entero_Cero, Par_ClienteID,Cue.ClienteID)
				AND Cue.Estatus = Est_Activo
				ORDER BY Cue.CuentaTranID;

	END IF;

END TerminaStore$$
