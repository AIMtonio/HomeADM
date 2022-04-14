-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- PLDDOCUMENTOSEXPIRACON
DELIMITER ;
DROP PROCEDURE IF EXISTS `PLDDOCUMENTOSEXPIRACON`;DELIMITER $$

CREATE PROCEDURE `PLDDOCUMENTOSEXPIRACON`(
/* SP para la consulta de Documentos por Expirar*/
	Par_ClienteID			INT(11),			-- Numero de Cliente
	Par_UsuarioID			INT(11),			-- Usuario ID
	Par_SucursalID			INT(11),			-- Numero de Sucursal
	Par_NumCon				INT(11),			-- 1- Notificacion de Numero de Clientes que van a expirar sus comp domicilio.

	/* Parametros de Auditoria */
	Aud_EmpresaID			INT(11),
	Aud_Usuario				INT(11),
	Aud_FechaActual			DATETIME,
	Aud_DireccionIP			VARCHAR(15),
	Aud_ProgramaID			VARCHAR(50),

	Aud_Sucursal			INT(11),
	Aud_NumTransaccion		BIGINT(20)
)
TerminaStore: BEGIN
	-- Declaracion de Variables
	DECLARE Var_FechaSiste				DATE;
	DECLARE Var_FechaExpira				DATE;
	DECLARE Var_ValidarVigDomi			CHAR(1);
	DECLARE Var_NumClientes				INT(11);
	DECLARE Var_TipoDocumento			INT(11);
	DECLARE Var_InstitucionID			INT(11);
	DECLARE Var_SafiLocale				VARCHAR(20);
	DECLARE Var_NombreCorto				VARCHAR(45);
	DECLARE Var_NumNotifica				INT(11);
	DECLARE Var_Mensaje					VARCHAR(200);
	DECLARE Var_MostrarUsuario			CHAR(1);
	DECLARE Var_NivelRiesgo				CHAR(1);
	DECLARE Var_ClienteIDConCuest		INT(11);

	-- Declaracion de Constantes
	DECLARE ConsultaPrincipal			INT(11);
	DECLARE ConsultaXCliente			INT(11);
	DECLARE Cons_Si						CHAR(1);
	DECLARE Cadena_Vacia				CHAR(1);
	DECLARE Entero_Cero					INT(11);
	DECLARE SCAP_Cliente				VARCHAR(20);
	DECLARE SOFIPO_Cliente				VARCHAR(20);
	DECLARE SOFOM_Cliente				VARCHAR(20);
	DECLARE sofipo						VARCHAR(20);
	DECLARE sofom						VARCHAR(20);
	DECLARE scap						VARCHAR(20);
	DECLARE Fecha_Vacia					DATE;

	SET Cons_Si						:= 'S';
	SET Cadena_Vacia				:= '';
	SET Fecha_Vacia					:= '1900-01-01';
	SET ConsultaPrincipal			:= 1;
	SET ConsultaXCliente			:= 2;
	SET Entero_Cero					:= 0;
	SET sofipo						:= 'sofipo';
	SET sofom						:= 'sofom';
	SET scap						:= 'scap';
	SET SCAP_Cliente				:= 'Socio';
	SET SOFIPO_Cliente				:= 'Cliente';
	SET SOFOM_Cliente				:= 'Cliente';
	SET Var_NumNotifica				:= 0000;
	SET Var_Mensaje					:= Cadena_Vacia;
	SET Var_NumClientes 			:= Entero_Cero;
	SET Var_SafiLocale	:= FNSAFILOCALECTE();
    SET Var_NumNotifica	:= 0000;
	SET Var_Mensaje := '';
	IF(Par_NumCon = ConsultaPrincipal) THEN
		SELECT
			FechaSistema,			ValidarVigDomi,			TipoDocDomID,		Var_InstitucionID
			INTO Var_FechaSiste,	Var_ValidarVigDomi,		Var_TipoDocumento,	Var_InstitucionID
			FROM PARAMETROSSIS LIMIT 1;



		SET Var_MostrarUsuario := (SELECT Notificacion FROM USUARIOS WHERE UsuarioID = Par_UsuarioID);


		IF(Var_ValidarVigDomi = Cons_Si) THEN
			IF(Var_MostrarUsuario = Cons_Si) THEN
				IF(Par_SucursalID>0) THEN
					SET Var_NumClientes := (SELECT COUNT(*) FROM (SELECT MAX(FechaExpira)
												FROM CLIENTEARCHIVOS AS CTE
													INNER JOIN CLIENTES AS CLI ON CTE. ClienteID = CLI.ClienteID
													WHERE  DATE_SUB(FechaExpira, INTERVAL 1 MONTH)  <= Var_FechaSiste
													AND TipoDocumento = Var_TipoDocumento
													AND CLI.SucursalOrigen = Par_SucursalID
													GROUP BY CTE.ClienteID) AS BB);
				ELSE
					SET Var_NumClientes := (SELECT COUNT(*) FROM (SELECT MAX(FechaExpira)
											FROM CLIENTEARCHIVOS AS CTE
												WHERE  DATE_SUB(FechaExpira, INTERVAL 1 MONTH)  <= Var_FechaSiste
												AND TipoDocumento = Var_TipoDocumento
												GROUP BY CTE.ClienteID) AS BB);
				END IF;
				SET Var_NumClientes := IFNULL(Var_NumClientes, Entero_Cero);
				IF(Var_NumClientes > Entero_Cero) THEN
					SET Var_NumNotifica	:= 0001;
					SET Var_Mensaje		:= CONCAT('Existen ',Var_NumClientes,' ',Var_SafiLocale,'s  que tiene Documentos (Comprobante de Domicilio) por Terminar su Vigencia.<br>Revisar el reporte Prevencion LD > Reportes > Documentos Vigencia');
				  ELSE
					SET Var_NumNotifica	:= 0000;
					SET Var_Mensaje	:= CONCAT('No Hay ',Var_SafiLocale, ' Con Documentos (Comprobante de Domicilio) Pendientes a Expirar.');
				END IF;
			  ELSE
				SET Var_NumNotifica	:= 0000;
				SET Var_Mensaje	:= CONCAT('No Hay ',Var_SafiLocale, ' Con Documentos (Comprobante de Domicilio) Pendientes a Expirar.');
			END IF;
		 ELSE
			SET Var_NumNotifica	:= 0000;
            SET Var_Mensaje	:= CONCAT('No Hay ',Var_SafiLocale, ' Con Documentos (Comprobante de Domicilio) Pendientes a Expirar.');
		END IF;


	END IF;

	IF(Par_NumCon = ConsultaXCliente) THEN
		SELECT
			FechaSistema,			ValidarVigDomi,			TipoDocDomID
			INTO Var_FechaSiste,	Var_ValidarVigDomi,		Var_TipoDocumento
				FROM PARAMETROSSIS LIMIT 1;

		SELECT
			PLD.ClienteID,				CTE.NivelRiesgo
			INTO
			Var_ClienteIDConCuest,		Var_NivelRiesgo
			FROM
				CLIENTES AS CTE LEFT JOIN PLDIDENTIDADCTE AS PLD ON CTE.ClienteID = PLD.ClienteID
				WHERE
				CTE.ClienteID = Par_ClienteID;

		SET Var_ClienteIDConCuest		:= IFNULL(Var_ClienteIDConCuest, Entero_Cero);
		SET Var_NivelRiesgo				:= IFNULL(Var_NivelRiesgo, Cadena_Vacia);

		IF(Var_ValidarVigDomi = Cons_Si) THEN
			SELECT MAX(FechaExpira)
				INTO
				Var_FechaExpira
				FROM CLIENTEARCHIVOS AS CTE
					WHERE TipoDocumento = Var_TipoDocumento
					AND CTE.ClienteID = Par_ClienteID
					GROUP BY CTE.ClienteID;

			SET Var_FechaExpira		:= IFNULL(Var_FechaExpira,Fecha_Vacia);
			SET Var_SafiLocale		:= FNSAFILOCALECTE();

			IF(Var_FechaExpira = Fecha_Vacia) THEN
				SET Var_NumNotifica	:= 001;
				SET Var_Mensaje		:= CONCAT('El ',Var_SafiLocale,' No tiene Registrado su Comprobante de Domicilio, favor de registrarlo.');
				IF(Var_NivelRiesgo = 'A') THEN
					SET Var_NumNotifica	:= 999;
					SET Var_Mensaje		:= CONCAT(Var_Mensaje,'<br>No puede continuar con la operaci&oacute;n.');
				END IF;
			  ELSEIF(Var_FechaExpira < DATE_SUB(Var_FechaExpira, INTERVAL 1 MONTH) AND Var_FechaExpira>Var_FechaSiste) THEN
				SET Var_NumNotifica	:= 0001;
				SET Var_Mensaje		:= CONCAT('El Comprobante de Domicilio del ',Var_SafiLocale,' esta por Vencer,<br>favor de actualizar este documento antes del:<b>Var_FechaExpira</b>');
			  ELSEIF( Var_FechaExpira<Var_FechaSiste) THEN
				SET Var_NumNotifica	:= 999;
				SET Var_Mensaje		:= CONCAT('El Comprobante de Domicilio del ',Var_SafiLocale,' esta Vencido, favor de Actualizarlo.');
				IF(Var_NivelRiesgo = 'A') THEN
					SET Var_NumNotifica	:= 999;
					SET Var_Mensaje		:= CONCAT(Var_Mensaje,'<br>No puede continuar con la operaci&oacute;n.');
				END IF;
			END IF;
		END IF;

		IF(Var_NumNotifica = Entero_Cero AND Var_NivelRiesgo = 'A' AND Var_ClienteIDConCuest = Entero_Cero) THEN
			SET Var_NumNotifica	:= 0001;
			SET Var_Mensaje	:= CONCAT('Es necesario que el ',Var_SafiLocale,' llene el siguiente cuestionario <b><a href="javascript: " onclick="cargarCuestionarioPLD(',Par_ClienteID,')">Identidad del Cliente</a></b>');
		END IF;
	END IF;

	SELECT Var_NumNotifica AS NumNotificacion,
			Var_Mensaje AS Mensaje,
			Var_NumClientes AS Consecutivo,
			Cadena_Vacia	AS ConsecutivoString;
END TerminaStore$$