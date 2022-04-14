-- ---------------------------------------------------------------------------------
-- Routine DDL
-- Note: comments before and after the routine body will not be stored by the server
-- ---------------------------------------------------------------------------------
-- TIPOSLINEASAGROCON
DELIMITER ;
DROP PROCEDURE IF EXISTS `TIPOSLINEASAGROCON`;

DELIMITER $$
CREATE PROCEDURE `TIPOSLINEASAGROCON`(
	-- Store procedure para la Consulta de Tipos de lineas de credito Agro
	-- Modulo Cartera y Solicitud de Credito Agro
	Par_TipoLineaAgroID		INT(11),			-- Numero de Tipo de Linea de Credito Agro
	Par_NumCon				TINYINT UNSIGNED,	-- Numero de Consulta

	Par_EmpresaID			INT(11),			-- Parametro de auditoria ID de la empresa
	Aud_Usuario				INT(11),			-- Parametro de auditoria ID del usuario
	Aud_FechaActual			DATETIME,			-- Parametro de auditoria Feha actual
	Aud_DireccionIP			VARCHAR(15),		-- Parametro de auditoria Direccion IP
	Aud_ProgramaID			VARCHAR(50),		-- Parametro de auditoria Programa
	Aud_Sucursal			INT(11),			-- Parametro de auditoria ID de la sucursal
	Aud_NumTransaccion		BIGINT(20)			-- Parametro de auditoria Numero de la transaccion
)
TerminaStore: BEGIN

	-- Declaracion de Varaibles
	DECLARE Var_ProductoCreditoID	INT(11);-- Numero de Producto de Credito

	-- Declaracion de Constantes
	DECLARE Cadena_Vacia		CHAR(1);	-- Constantes Cadena Vacia
	DECLARE Fecha_Vacia			DATE;		-- Constantes Fecha Vacia
	DECLARE Entero_Cero			INT(11);	-- Constantes Entero Cero
	DECLARE Con_SI				CHAR(1);	-- Constantes SI
	DECLARE Est_Activa			CHAR(1);	-- Constantes Estatus Activa

	-- Declaracion de Consultas
	DECLARE Con_Principal		INT(11);	-- Consulta Principal
	DECLARE Con_ManejaLinea		INT(11);	-- Consulta Si el Prodcuto Credito Maneja Linea de Credito

	-- Asignacion de Constantes
	SET	Cadena_Vacia		:= '';
	SET	Fecha_Vacia			:= '1900-01-01';
	SET	Entero_Cero			:= 0;
	SET Con_SI				:= 'S';
	SET Est_Activa			:= 'A';

	-- Asignacion de Consultas
	SET	Con_Principal		:= 1;
	SET Con_ManejaLinea		:= 2;

	IF( Par_NumCon = Con_Principal ) THEN
		SELECT	TipoLineaAgroID,	Nombre,				FechaRegistro,		Estatus,		EsRevolvente,
				MontoLimite,		PlazoLimite,		ManejaComAdmon,		ManejaComGaran,	ProductosCredito,
				FechaBaja,			FechaReactivacion,	UsuarioRegistro,	UsuarioBaja
		FROM TIPOSLINEASAGRO
		WHERE TipoLineaAgroID = Par_TipoLineaAgroID;
	END IF;

	IF( Par_NumCon = Con_ManejaLinea ) THEN

		SET Var_ProductoCreditoID := Par_TipoLineaAgroID;

		SELECT COUNT(IFNULL(TipoLineaAgroID, Entero_Cero)) AS TipoLineaAgroID
		FROM TIPOSLINEASAGRO
		WHERE FIND_IN_SET(Var_ProductoCreditoID, ProductosCredito)
		  AND Estatus = Est_Activa;
	END IF;

END TerminaStore$$