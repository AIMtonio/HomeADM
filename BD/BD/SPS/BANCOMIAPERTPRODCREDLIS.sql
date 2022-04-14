-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- BANCOMIAPERTPRODCREDLIS
DELIMITER ;
DROP PROCEDURE IF EXISTS `BANCOMIAPERTPRODCREDLIS`;
DELIMITER $$

CREATE PROCEDURE `BANCOMIAPERTPRODCREDLIS`(
# =============================================================
# ------- STORE DE CONSULTA PARA EL LISTADO DE COMISION POR APERTURA DEL CREDTO --------
# =============================================================
	Par_ProducCreditoID		INT(11),				-- Numero de producto de credito
	Par_NumLis				TINYINT UNSIGNED,		-- Numero de consulta

	Aud_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)TerminaStore: BEGIN


-- Declaracion  de constantes
	DECLARE	Cadena_Vacia		CHAR(1);		-- Constante Cadena vacia
	DECLARE	Fecha_Vacia			DATE;			-- Constante Fecha Vacia
	DECLARE	Entero_Cero			INT(11);		-- Constante Entero cero
	DECLARE	Con_Cien			INT(11);		-- Constante Cien
	DECLARE Con_Monto			CHAR(1);		-- Constante Monto para Comision por Apertura

	DECLARE	Lis_Principal		INT(11);		-- Lista de las comisiones por apertura por producto de credito

	-- Asignacion de constantes
	SET	Cadena_Vacia		:= '';				-- Cadena Vacia
	SET	Fecha_Vacia			:= '1900-01-01';	-- Fecha Vacia
	SET	Entero_Cero			:=  0 ;				-- Enero cero
	SET	Con_Cien			:= 100;				-- Constante Cien
	SET Con_Monto			:= 'M';				-- Constante Monto para Comision por Apertura

	SET	Lis_Principal		:=  1 ;				-- Lista de las comisiones por apertura por producto de credito

	-- 1.-  Lista de las comisiones por apertura por producto de credito
	IF(Par_NumLis = Lis_Principal) THEN
		SELECT	ForCobroComAper,		TipoComXapert,			MontoComXapert
			FROM PRODUCTOSCREDITO
		WHERE  ProducCreditoID = Par_ProducCreditoID;
	END IF;


END TerminaStore$$