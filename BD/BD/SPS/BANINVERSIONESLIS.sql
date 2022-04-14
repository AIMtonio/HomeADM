-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANINVERSIONESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANINVERSIONESLIS`;
DELIMITER $$


CREATE PROCEDURE `BANINVERSIONESLIS`(
# =======================================================================
# ----------- SP PARA LISTAS DE INVERSIONES PARA BANCA MOVIL -----------
# =======================================================================
	Par_ClienteID			INT(11),				-- Numero de Cliente
	Par_Estatus				CHAR(1),				-- Estatus de la inversion
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de Lista

	Par_Empresa				INT(11),				-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),				-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,				-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),			-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),			-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),				-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)				-- Parametro de auditoria Numero de la transaccion
)

TerminaStore: BEGIN
	-- Declaracion de variables
	DECLARE Var_EstatusISR	CHAR(1);

	-- Declaracion de constantes
	DECLARE	Cadena_Vacia		CHAR(1);			-- Cadena VAcia
	DECLARE	Fecha_Vacia			DATE;				-- Fecha Vacia
	DECLARE	Entero_Cero			INT(11);			-- Entero Cero
	DECLARE Lis_InvCliente		INT(1);				-- Opcion para la lista de Inversiones del Cliente
	DECLARE Est_Vigente			CHAR(1);			-- Estatus de Inversion Vigente

	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena VAcia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET	Lis_InvCliente			:= 1;				-- Opcion para la lista de Inversiones del Cliente
	SET Est_Vigente				:= 'N';				-- Estatus de Inversion Vigente

	-- Lista 1 - Lista de Inversiones por ClienteID
	IF(Par_NumLis = Lis_InvCliente) THEN

		SELECT 	INV.InversionID,		INV.CuentaAhoID,			INV.TipoInversionID,					TINV.Descripcion AS TipoInversion,			INV.FechaInicio,
				INV.Monto,				INV.Plazo,					INV.Etiqueta AS Etiqueta,				INV.SaldoProvision AS InteresGenerado,		INV.TasaISR,
				INV.Tasa,				INV.FechaVencimiento,		CASE INV.Estatus	WHEN "N" THEN "VIGENTE"
																						WHEN "P" THEN "PAGADA"
																						WHEN "C" THEN "CANCELADA"
																						WHEN "A" THEN "REGISTRADA"
																	END AS DescripcionEstatus,
				INV.Estatus
			FROM INVERSIONES INV
			INNER JOIN CATINVERSION TINV ON INV.TipoInversionID = TINV.TipoInversionID
			WHERE INV.ClienteID = Par_ClienteID
			AND IF(Par_Estatus != Cadena_Vacia, FIND_IN_SET(INV.Estatus, Par_Estatus), TRUE);
	END IF;

END TerminaStore$$
