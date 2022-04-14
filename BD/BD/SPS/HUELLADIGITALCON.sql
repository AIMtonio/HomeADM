-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- HUELLADIGITALCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `HUELLADIGITALCON`;

DELIMITER $$
CREATE PROCEDURE `HUELLADIGITALCON`(
	-- Store Procedure para consultas las Huellas del cliente / Firmantes / Usuarios de Sistema
	-- Modulo Huella Digital

	Par_PersonaID		INT(11),			-- Numero de Persona.
	Par_CuentaAhoID		BIGINT(12),			-- Numero de Cuenta de Ahorro.
	Par_NumCon			TINYINT UNSIGNED,	-- Numero de Consulta.

	Aud_EmpresaID		INT(11),			-- Parametro de auditoria ID de la empresa.
	Aud_Usuario			INT(11),			-- Parametro de auditoria ID del usuario.
	Aud_FechaActual		DATETIME,			-- Parametro de auditoria Feha actual.
	Aud_DireccionIP		VARCHAR(15),		-- Parametro de auditoria Direccion IP.
	Aud_ProgramaID		VARCHAR(50),		-- Parametro de auditoria ID del Programa.
	Aud_Sucursal		INT(11),			-- Parametro de auditoria ID de la sucursal.
	Aud_NumTransaccion	BIGINT(20)			-- Parametro de auditoria Numero de la transaccion.
)
TerminaStore: BEGIN

	-- Declaracion de Variables
	DECLARE Var_NoHuellaCliente		INT(11);	-- Variable No. Huella por Cliente
	DECLARE Var_NoHuellaFirmante	INT(11);	-- Variable No. Huella por Fimante

	-- Declaracion de Consultas
	DECLARE Con_Cliente			INT(11);	-- Consulta por Cliente
	DECLARE Con_Usuario			INT(11);	-- Consulta por Usuario
	DECLARE Con_Firmante		INT(11);	-- Consulta por Firmante
	DECLARE Con_NoHuella		INT(11);	-- Consulta Numero Huella Digitales por Cliente y Firmantes
	DECLARE Con_EstFirmante		INT(11);	-- Consulta huella digital de persona tipo firmante.

	DECLARE Con_UsuarioServicio INT(11);	-- Consulta para los usuarios de servicio (Funcionalidad 15) de la carta SFP_CC_0090_Deteccion_PLD_en_Remesas

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);	-- Constante Cadena Vacia
	DECLARE Tipo_Cliente		CHAR(1);	-- Constante Tipo Cliente
	DECLARE Tipo_Usuario		CHAR(1);	-- Constante Tipo Usuario
	DECLARE Tipo_UsuarioServ	CHAR(1);	-- Constante Tipo Usuario de Servicios.
	DECLARE Tipo_Firmante		CHAR(1);	-- Constante Tipo Firmante
	DECLARE Est_Vigente			CHAR(1);	-- Constante Estatus Vigente

	DECLARE EsFirmante			CHAR(1);	-- Constante Es Firmante
	DECLARE Entero_Cero			INT(11);	-- Constante Entero Cero


	-- Asignacion de Consultas
	SET Con_Cliente			:= 1;
	SET Con_Usuario			:= 2;
	SET Con_Firmante		:= 3;
	SET Con_NoHuella		:= 4;
	SET Con_EstFirmante		:= 5;

	SET Con_UsuarioServicio := 6;

	-- Asignacion de Constantes
	SET Cadena_Vacia		:= '';
	SET Tipo_Cliente		:= 'C';
	SET Tipo_Usuario		:= 'U';
	SET Tipo_Firmante		:= 'F';
	SET Tipo_UsuarioServ	:= 'S';

	SET Est_Vigente			:= 'V';
	SET EsFirmante			:= 'S';
	SET Entero_Cero			:= 0;

	-- Consulta por Cliente
	IF(Par_NumCon = Con_Cliente) THEN
		SELECT	TipoPersona,	PersonaID,	HuellaUno,	DedoHuellaUno,	HuellaDos,
				DedoHuellaDos, Estatus
		FROM HUELLADIGITAL
		WHERE TipoPersona = Tipo_Cliente
		  AND PersonaID = Par_PersonaID;
	END IF;

	-- Consulta por Usuario
	IF(Par_NumCon = Con_Usuario) THEN
		SELECT	TipoPersona,	PersonaID,	HuellaUno,	DedoHuellaUno,	HuellaDos,
				DedoHuellaDos,	Estatus
		FROM HUELLADIGITAL
		WHERE TipoPersona = Tipo_Usuario
		  AND PersonaID = Par_PersonaID;
	END IF;

	-- Consulta por Firmante
	IF(Par_NumCon = Con_Firmante) THEN
		SELECT	TipoPersona,	PersonaID,	HuellaUno,	DedoHuellaUno,	HuellaDos,
				DedoHuellaDos,	Estatus
		FROM HUELLADIGITAL
		WHERE TipoPersona = Tipo_Firmante
		  AND PersonaID = Par_PersonaID;
	END IF;

	-- Consulta Numero Huella Digitales por Cliente y Firmantes
	IF(Par_NumCon = Con_NoHuella) THEN
		SELECT	COUNT(PersonaID)
		INTO Var_NoHuellaCliente
		FROM HUELLADIGITAL
		WHERE TipoPersona = Tipo_Cliente
		  AND PersonaID = Par_PersonaID;

		SELECT	COUNT(CF.CuentaFirmaID)
		INTO Var_NoHuellaFirmante
		FROM CUENTASAHO CA
		INNER JOIN CUENTASFIRMA CF ON CA.CuentaAhoID = CF.CuentaAhoID
		INNER JOIN CUENTASPERSONA CP ON CP.CuentaAhoID = CF.CuentaAhoID AND CP.PersonaID = CF.PersonaID AND CP.EstatusRelacion = Est_Vigente
		LEFT OUTER JOIN HUELLADIGITAL Hue ON (CASE WHEN IFNULL(CP.ClienteID, Entero_Cero) = Entero_Cero THEN CF.CuentaFirmaID
												   ELSE CP.ClienteID
											  END = Hue.PersonaID)
										 AND (CASE IFNULL(CP.ClienteID,Entero_Cero) WHEN Entero_Cero THEN Tipo_Firmante
												   ELSE Tipo_Cliente
											  END = Hue.TipoPersona)
		WHERE CA.CuentaAhoID = Par_CuentaAhoID
		  AND CP.EsFirmante = EsFirmante
          AND Hue.TipoPersona IS NOT NULL;

		SELECT (IFNULL(Var_NoHuellaCliente, Entero_Cero) + IFNULL(Var_NoHuellaFirmante, Entero_Cero)) AS NoHuellas;
	END IF;

	-- 5. Consulta huella digital de persona tipo firmante.
	IF (Par_NumCon = Con_EstFirmante) THEN

		SELECT	hue.TipoPersona,	hue.PersonaID,	hue.HuellaUno,	hue.DedoHuellaUno,	hue.HuellaDos,
			 	hue.DedoHuellaDos,	hue.Estatus
		FROM HUELLADIGITAL hue
		INNER JOIN CUENTASFIRMA cf ON hue.PersonaID = cf.CuentaFirmaID AND hue.TipoPersona = Tipo_Firmante
		INNER JOIN CUENTASAHO aho ON cf.CuentaAhoID = aho.CuentaAhoID
		WHERE aho.ClienteID = Par_PersonaID LIMIT 1;
	END IF;

	-- 6.- Consulta huella de Usuarios de Servicios.
	-- Pantalla: Ventanilla > Registro > Huella Usuario Servicio.
	IF(Par_NumCon = Con_UsuarioServicio) THEN
		SELECT	TipoPersona,	PersonaID,	HuellaUno,	DedoHuellaUno,	HuellaDos,
				DedoHuellaDos,	Estatus
		FROM HUELLADIGITAL
		WHERE TipoPersona = Tipo_UsuarioServ
		  AND PersonaID = Par_PersonaID;
	END IF;


END TerminaStore$$