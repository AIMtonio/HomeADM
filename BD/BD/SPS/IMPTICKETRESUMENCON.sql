-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- IMPTICKETRESUMENCON
DELIMITER ;
DROP PROCEDURE IF EXISTS IMPTICKETRESUMENCON;

DELIMITER $$
CREATE PROCEDURE `IMPTICKETRESUMENCON`(
	-- Store Procedure: Que Consulta las Operaciones validas para la impresion del ticket de Resumen
	-- Modulo Ventanilla --> Ingreso de Operaciones / Envio Spei
	Par_OpcionCajaID			INT(11),			-- ID de Tabla
	Par_NumConsulta				TINYINT UNSIGNED,	-- Numero de Consulta

	Aud_EmpresaID				INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario					INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual				DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP				VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID				VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal				INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion			BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Constantes
	DECLARE Var_MostrarBtnResumen	CHAR(1);		-- Muestra Boton Imprimir Resumen

	-- Declaracion de Constantes
	DECLARE Entero_Cero				INT(11);		-- Constante de Entero Cero
	DECLARE Decimal_Cero			DECIMAL(14,2);	-- Constante de Decimal Cero
	DECLARE Fecha_Vacia				DATE;			-- Constante de Fecha Vacia
	DECLARE	Cadena_Vacia			CHAR(1);		-- Constante de Cadena Vacia

	-- Declaracion de Consultas
	DECLARE Con_Principal			TINYINT UNSIGNED;	-- Consulta Principal

	-- Asignacion de Constantes
	SET Entero_Cero 			:= 0;
	SET Decimal_Cero			:= 0.00;
	SET Fecha_Vacia 			:= '1900-01-01';
	SET Cadena_Vacia			:= '';

	-- Asignacion de Consultas
	SET Con_Principal			:= 1;

	-- Se realiza la consulta principal
	IF( Par_NumConsulta = Con_Principal ) THEN

		SELECT MostrarBtnResumen
		INTO Var_MostrarBtnResumen
		FROM PARAMETROSSIS LIMIT 1;

		SELECT	OpcionCajaID,		UPPER(Descripcion) AS Descripcion,			EsReversa,
				ImpTicketResumen,	Var_MostrarBtnResumen AS MostrarBtnResumen,	CampoPantalla
		FROM OPCIONESCAJA
		WHERE OpcionCajaID = Par_OpcionCajaID;
	END IF;

END TerminaStore$$