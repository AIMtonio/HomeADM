-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCEDESLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCEDESLIS`;
DELIMITER $$


CREATE PROCEDURE `BANCEDESLIS`(
# =================================================================
# ----------- SP PARA LISTAS DE CEDE PARA BANCA MOVIL -----------
# =================================================================
	Par_ClienteID			INT(11),				-- Numero de Cliente
	Par_TamanioLista		INT(11),				-- Parametro tamanio de la lista
	Par_PosicionInicial		INT(11),				-- Parametro posicion inicial de la lista
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
	DECLARE Lis_CedesCliente	INT(1);				-- Opcion para lista de cedes del Cliente
	DECLARE Est_Vigente			CHAR(1);			-- Estatus Vigente
	DECLARE Est_Alta			CHAR(1);			-- Estatus Alta --
	DECLARE Est_Cancelada		CHAR(1);			-- Estatus Cancelada --
	DECLARE Est_Pagada			CHAR(1);			-- Estatus Pagada --
	DECLARE Est_Vencida			CHAR(1);			-- Estatus Vencida --
	DECLARE Alta				VARCHAR(8);			-- Descripcion Estatus Inactivo
	DECLARE Vigente				VARCHAR(7);			-- Descripcion Estatus Vigente
	DECLARE Cancelada			VARCHAR(9);			-- Descripcion Estatus Cancelado
	DECLARE	Pagada				VARCHAR(6);			-- Descripcion Estatus Pagado
	DECLARE Vencida				VARCHAR(7);			-- Descripcion Estatus Vencido
	DECLARE Registrada      	VARCHAR(12);		-- Descripcion Estatus Registrado
	
	-- Asignacion de constantes
	SET	Cadena_Vacia			:= '';				-- Cadena VAcia
	SET	Fecha_Vacia				:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero				:= 0;				-- Entero Cero
	SET	Lis_CedesCliente		:= 1;				-- Opcion para lista de cedes del Cliente
	SET Est_Vigente				:= 'N';				-- Estatus Vigente
	SET Est_Alta				:= 'A';				-- Estatus Alta --
	SET Est_Cancelada			:= 'C';				-- Estatus Cancelada --
	SET Est_Pagada				:= 'P';				-- Estatus Pagada --
	SET Est_Vencida				:= 'V';				-- Estatus Vencida --
	SET Alta					:='INACTIVA';		-- Descripcion Estatus Inactivo
	SET Vigente					:='VIGENTE';		-- Descripcion Estatus Vigente
	SET Cancelada				:='CANCELADA';		-- Descripcion Estatus Cancelado
	SET Pagada					:='PAGADA';			-- Descripcion Estatus Pagado
	SET Vencida					:='VENCIDA';		-- Descripcion Estatus Vencido
	SET Registrada      		:= 'REGISTRADA';	-- Descripcion Estatus Registrado


	-- Opcion para lista de cedes del Cliente
	IF(Par_NumLis = Lis_CedesCliente) THEN
		SELECT 	cede.CedeID,	tipo.TipoCedeID,							tipo.Descripcion AS TipoCede,			cede.FechaInicio,
				cede.Monto, 	cede.SaldoProvision as InteresGenerado,		cede.Estatus,
				CASE cede.Estatus
					WHEN Est_Vencida THEN Vencida
					WHEN Est_Vigente THEN Vigente
					WHEN Est_Alta THEN Registrada
					WHEN Est_Cancelada THEN Cancelada
					WHEN Est_Pagada THEN Pagada
				END AS DescEstatus
			FROM CEDES cede
			INNER JOIN TIPOSCEDES tipo ON cede.TipoCedeID = tipo.TipoCedeID
			WHERE cede.ClienteID = Par_ClienteID
            AND cede.Estatus = Est_Vigente;
	END IF;

END TerminaStore$$ 
