
-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- FNGETPLDSITITELS

DELIMITER ;
DROP FUNCTION IF EXISTS `FNGETPLDSITITELS`;

DELIMITER $$
CREATE FUNCTION `FNGETPLDSITITELS`(
	/* FUNCIÓN QUE OBTIENE LOS TELÉFONOS DEL CLIENTE PARA LOS REPORTES PLD. */
	Par_TipoConsulta		TINYINT,		-- TIPO DE CONSULTA
	Par_TipoPersSAFI		VARCHAR(3),		-- TIPO DE PERSONA SAFI.
	Par_PersonaID			INT(11),		-- NÚMERO DE CLIENTE
	Par_CuentaAhoID			BIGINT(12)		-- NÚMERO DE CUENTA PARA RELACIONADOS A LA CTA.
) RETURNS varchar(100) CHARSET latin1
    DETERMINISTIC
BEGIN
	-- Declaracion Variables
	DECLARE Var_TelefonoRes		VARCHAR(100);	-- RESULTADO.
	DECLARE Var_TelTrabajo		VARCHAR(20);	-- TELEFONO DEL TRABAJO.
	DECLARE Var_TelefonoCelular	VARCHAR(20);	-- TELEFONO CELULAR.
	DECLARE Var_Telefono		VARCHAR(20);	-- TELEFONO CASA.

	-- Declaracion de Constantes
	DECLARE Estatus_Activo		CHAR(1);
	DECLARE Cadena_Vacia		CHAR(1);
	DECLARE Fecha_Vacia			DATE;
	DECLARE Entero_Cero			INT;
	DECLARE Tipo_RepSITI		INT;
	DECLARE Tipo_Cliente		VARCHAR(3);
	DECLARE Tipo_UServ 			VARCHAR(3);
	DECLARE Tipo_UServ2			VARCHAR(3);
	DECLARE Tipo_Aval 			VARCHAR(3);
	DECLARE Tipo_Prospecto 		VARCHAR(3);
	DECLARE Tipo_Relacionado 	VARCHAR(3);
	DECLARE Tipo_Proveedor	 	VARCHAR(3);
	DECLARE Tipo_ObligSol	 	VARCHAR(3);

	-- Asignacion de Constantes
	SET Estatus_Activo			:= 'A';				-- ESTATUS ACTIVO.
	SET Cadena_Vacia			:= '';				-- CADENA VACIA.
	SET Fecha_Vacia				:= '1900-01-01';	-- FECHA VACIA.
	SET Entero_Cero				:= 0;				-- ENTERO CERO.
	SET Tipo_RepSITI			:= 01;				-- FORMATO TIPO COMO LO REQUIERE EL SITI.
	SET Tipo_Cliente			:='CTE';	-- Tipo Cliente
	SET Tipo_UServ				:='USU';	-- Tipo Usuario de Servicios
	SET Tipo_UServ2				:='USS';	-- Tipo Usuario de Servicios
	SET Tipo_Aval				:='AVA';	-- Tipo Aval
	SET Tipo_Prospecto			:='PRO';	-- Tipo Prospecto
	SET Tipo_Relacionado		:='REL';	-- Tipo Relacionado a la Cuenta
	SET Tipo_Proveedor 			:='PRV';	-- Tipo Proveedor
	SET Tipo_ObligSol 			:='OBS';	-- Tipo Obligado Solidario

	IF(Par_TipoPersSAFI = Tipo_Cliente)THEN
		SELECT
			TRIM(IFNULL(TelTrabajo,Cadena_Vacia)),
			TRIM(IFNULL(TelefonoCelular,Cadena_Vacia)),
			TRIM(IFNULL(Telefono,Cadena_Vacia))
		INTO
			Var_TelTrabajo,		Var_TelefonoCelular,	Var_Telefono
		FROM CLIENTES
		WHERE ClienteID = Par_PersonaID;
	END IF;

	IF(Par_TipoPersSAFI IN (Tipo_UServ,Tipo_UServ2))THEN
		SELECT
			Cadena_Vacia,
			TRIM(IFNULL(TelefonoCelular,Cadena_Vacia)),
			TRIM(IFNULL(Telefono,Cadena_Vacia))
		INTO
			Var_TelTrabajo,		Var_TelefonoCelular,	Var_Telefono
		FROM USUARIOSERVICIO
		WHERE UsuarioServicioID = Par_PersonaID;
	END IF;

	IF(Par_TipoPersSAFI = Tipo_Prospecto)THEN
		SELECT
			TRIM(IFNULL(TelTrabajo,Cadena_Vacia)),
			Cadena_Vacia,
			TRIM(IFNULL(Telefono,Cadena_Vacia))
		INTO
			Var_TelTrabajo,		Var_TelefonoCelular,	Var_Telefono
		FROM PROSPECTOS
		WHERE ProspectoID = Par_PersonaID;
	END IF;

	IF(Par_TipoPersSAFI = Tipo_Aval)THEN
		SELECT
			TRIM(IFNULL(TelefonoTrabajo,Cadena_Vacia)),
			TRIM(IFNULL(TelefonoCel,Cadena_Vacia)),
			TRIM(IFNULL(Telefono,Cadena_Vacia))
		INTO
			Var_TelTrabajo,		Var_TelefonoCelular,	Var_Telefono
		FROM AVALES
		WHERE AvalID = Par_PersonaID;
	END IF;

	IF(Par_TipoPersSAFI = Tipo_Relacionado)THEN
		SELECT
			Cadena_Vacia,
			TRIM(IFNULL(TelefonoCelular,Cadena_Vacia)),
			TRIM(IFNULL(TelefonoCasa,Cadena_Vacia))
		INTO
			Var_TelTrabajo,		Var_TelefonoCelular,	Var_Telefono
		FROM CUENTASPERSONA
		WHERE PersonaID = Par_PersonaID
			AND CuentaAhoID = Par_CuentaAhoID;
	END IF;

	IF(Par_TipoPersSAFI = Tipo_Proveedor)THEN
		SELECT
			Cadena_Vacia,
			TRIM(IFNULL(TelefonoCelular,Cadena_Vacia)),
			TRIM(IFNULL(Telefono,Cadena_Vacia))
		INTO
			Var_TelTrabajo,		Var_TelefonoCelular,	Var_Telefono
		FROM PROVEEDORES
		WHERE ProveedorID = Par_PersonaID;
	END IF;

	IF(Par_TipoPersSAFI = Tipo_ObligSol)THEN
		SELECT
			TRIM(IFNULL(TelefonoTrabajo,Cadena_Vacia)),
			TRIM(IFNULL(TelefonoCel,Cadena_Vacia)),
			TRIM(IFNULL(Telefono,Cadena_Vacia))
		INTO
			Var_TelTrabajo,		Var_TelefonoCelular,	Var_Telefono
		FROM OBLIGADOSSOLIDARIOS
		WHERE OblSolidID = Par_PersonaID;
	END IF;

	IF(IFNULL(Par_TipoConsulta, Entero_Cero) = Tipo_RepSITI)THEN
		SET Var_TelefonoRes :=
			CASE
				WHEN /*01 - SOLO TELÉFONO DE TRABAJO.*/
					CHAR_LENGTH(Var_TelTrabajo) > Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) = Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) = Entero_Cero
					THEN
					Var_TelTrabajo
				WHEN /*02 - SOLO TELÉFONO DE CASA.*/
					CHAR_LENGTH(Var_TelTrabajo) = Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) > Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) = Entero_Cero
					THEN
					Var_Telefono
				WHEN /*03 - SOLO TELÉFONO CELULAR.*/
					CHAR_LENGTH(Var_TelTrabajo) = Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) = Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) > Entero_Cero
					THEN
					Var_TelefonoCelular
				WHEN /*04*/
					CHAR_LENGTH(Var_TelTrabajo) > Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) > Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) = Entero_Cero
					THEN
					IF(Var_TelTrabajo != Var_Telefono,CONCAT(Var_TelTrabajo,'/',Var_Telefono),Var_TelTrabajo)
				WHEN /*05*/
					CHAR_LENGTH(Var_TelTrabajo) > Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) = Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) > Entero_Cero
					THEN
					IF(Var_TelTrabajo != Var_TelefonoCelular,CONCAT(Var_TelTrabajo,'/',Var_TelefonoCelular),Var_TelTrabajo)
				WHEN /*06*/
					CHAR_LENGTH(Var_TelTrabajo) = Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) > Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) > Entero_Cero
					THEN
					IF(Var_Telefono != Var_TelefonoCelular,CONCAT(Var_Telefono,'/',Var_TelefonoCelular),Var_Telefono)
				WHEN /*07*/
					CHAR_LENGTH(Var_TelTrabajo) > Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) > Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) > Entero_Cero AND
					(Var_TelTrabajo = Var_Telefono AND Var_TelTrabajo = Var_TelefonoCelular)
					THEN
					Var_TelTrabajo
				WHEN /*08*/
					CHAR_LENGTH(Var_TelTrabajo) > Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) > Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) > Entero_Cero AND
					(Var_TelTrabajo != Var_Telefono AND Var_Telefono = Var_TelefonoCelular)
					THEN
					CONCAT(Var_TelTrabajo,'/',Var_Telefono)
				WHEN /*09*/
					CHAR_LENGTH(Var_TelTrabajo) > Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) > Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) > Entero_Cero AND
					(Var_TelTrabajo != Var_Telefono AND Var_TelTrabajo = Var_TelefonoCelular)
					THEN
					CONCAT(Var_TelTrabajo,'/',Var_Telefono)
				WHEN /*10*/
					CHAR_LENGTH(Var_TelTrabajo) > Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) > Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) > Entero_Cero AND
					(Var_TelTrabajo != Var_Telefono AND Var_TelTrabajo != Var_TelefonoCelular)
					THEN
					CONCAT(Var_TelTrabajo,'/',Var_Telefono)
				WHEN /*11*/
					CHAR_LENGTH(Var_TelTrabajo) > Entero_Cero AND
					CHAR_LENGTH(Var_Telefono) > Entero_Cero AND
					CHAR_LENGTH(Var_TelefonoCelular) > Entero_Cero
					THEN
					IF(Var_TelTrabajo = Var_Telefono,CONCAT(Var_TelTrabajo,'/',Var_TelefonoCelular),Var_Telefono)
				ELSE Cadena_Vacia
			END;

		SET Var_TelefonoRes := IF(CHAR_LENGTH(Var_TelefonoRes)>Entero_Cero,Var_TelefonoRes,Cadena_Vacia);
	END IF;


RETURN LEFT(IFNULL(Var_TelefonoRes, Cadena_Vacia),100);
END$$


