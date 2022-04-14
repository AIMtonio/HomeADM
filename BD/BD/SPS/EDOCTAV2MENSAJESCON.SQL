-- SP EDOCTAV2MENSAJESCON
DELIMITER ;
DROP PROCEDURE IF EXISTS EDOCTAV2MENSAJESCON;
DELIMITER $$

CREATE PROCEDURE EDOCTAV2MENSAJESCON (
	-- SP para la consulta de mensajes generales de estado de cuenta
	Par_ClienteID			INT(11),			-- Numero de cliente a consultar
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de consulta
	Par_EmpresaID			INT(11),			-- Parametro de auditoria
	Aud_Usuario				INT(11),			-- Parametro de auditoria
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria
	Aud_Sucursal			INT(11),			-- Parametro de auditoria
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_FechaFin		DATE;				-- Fecha final del periodo registrada en EDOCTAV2PARAMS
	DECLARE Var_TipoCambio		DECIMAL(14,6);		-- Tipo de cambio del historico de monedas
	DECLARE Var_Proteccion		DECIMAL(14,6);		-- Valor de fondo de proteccion

	-- Declaracion de constantes
	DECLARE Var_ConMenCliente	TINYINT UNSIGNED;	-- Consulta de mensajes por cliente
	DECLARE Var_ConMenUDIS		TINYINT UNSIGNED;	-- Consulta de mensajes tomando en cuenta el valor de la UDI al ultimo dia del periodo
	DECLARE Var_SimboloUDIS		VARCHAR(45);		-- Simbolo de la moneda UDI
	DECLARE Fecha_Vacia			DATE;				-- Fecha vacia
	DECLARE Decimal_Cero		DECIMAL(14,2);		-- Decimal cero
	DECLARE Var_ComodinPro		CHAR(5);			-- Comodin que se reemplazara con el valor de Var_Proteccion

	-- Asignacion de constantes
	SET Var_ConMenCliente		:= 1;				-- Consulta de mensajes por cliente
	SET Var_ConMenUDIS			:= 2;				-- Consulta de mensajes tomando en cuenta el valor de la UDI al ultimo dia del periodo
	SET Var_SimboloUDIS			:= 'UDIS';			-- Simbolo de la moneda UDI
	SET Fecha_Vacia				:= '1900-01-01';	-- Fecha vacia
	SET Decimal_Cero			:= 0.00;			-- Decimal cero
	SET Var_ComodinPro			:= "&PROT";			-- Comodin que se reemplazara con el valor de Var_Proteccion

	-- Consulta de mensajes por cliente
	IF Par_NumCon = Var_ConMenCliente THEN
		SELECT	msj.SucursalID,	msj.TipoPersona,	msj.Mensaje1,	msj.Mensaje2,	msj.Mensaje3,
				msj.Mensaje4,	msj.Mensaje5
			FROM EDOCTAV2MENSAJES AS msj
			INNER JOIN EDOCTAV2DATOSCTE AS cte ON msj.SucursalID = cte.SucursalID
			WHERE	cte.ClienteID	= Par_ClienteID
			  AND	msj.TipoPersona	= cte.TipoPer;
	END IF;

	-- Consulta de mensajes tomando en cuenta el valor de la UDI al ultimo dia del periodo
	IF Par_NumCon = Var_ConMenUDIS THEN
		SELECT		FechaFin
			INTO	Var_FechaFin
			FROM	EDOCTAV2PARAMS
			LIMIT 0, 1;

		SET Var_FechaFin	:= IFNULL(Var_FechaFin, Fecha_Vacia);

		SELECT		TipCamDof
			INTO	Var_TipoCambio
			FROM	`HIS-MONEDAS`
			WHERE	Simbolo				= Var_SimboloUDIS
			  AND	DATE(FechaActual)	<= Var_FechaFin
			ORDER BY MonedaId DESC
			LIMIT 0, 1;

		SET Var_TipoCambio	:= IFNULL(Var_TipoCambio, Decimal_Cero);
		SET Var_Proteccion	:= Var_TipoCambio * 25000;

		SELECT	msj.SucursalID,	msj.TipoPersona,	msj.Mensaje2,	msj.Mensaje3,	msj.Mensaje4,
				msj.Mensaje5,	REPLACE(msj.Mensaje1, Var_ComodinPro, CAST(FORMAT(Var_Proteccion, 2) AS CHAR)) AS Mensaje1
			FROM EDOCTAV2MENSAJES AS msj
			INNER JOIN EDOCTAV2DATOSCTE AS cte ON msj.SucursalID = cte.SucursalID
			WHERE	cte.ClienteID	= Par_ClienteID
			  AND	msj.TipoPersona	= cte.TipoPer;
	END IF;
END TerminaStore$$
